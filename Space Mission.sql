select * from space_missions
--========Retrieve the names of all rockets used in space missions
select distinct(Rocket) as name_of_roket from space_missions)

--========  Display the details of space missions launched by a specific company
select * from space_missions
where Company = 'RVSN USSR'

--=========Retrieve the top 5 most expensive rockets based on their cost
select  distinct(Rocket),Price  from space_missions
order by Price desc 

--=========Calculate the average cost of all rockets
select avg(price) as average_cost  from space_missions

--=========Group the missions by launch location and display the total count of missions for each location
select Location,COUNT(mission) as total_mission from space_missions
group by location 
order by total_mission desc

--========= Create a new table for rocket details and join it with the main table to display mission names and their corresponding rocket names.
create table rocket_details (
roke_id int primary key ,
rocket_name varchar(255),
manufact varchar(255),
cost real )

insert into rocket_details(
roke_id ,rocket_name ,manufact ,cost)
values
(9,'Sputnik 8K71PS1','Sputnik-1',23456.56),
(8,'Explorer 1','nasa',23456.56),
(12,'Juno I','nasa',23456.56)

select * from  space_missions 
right join rocket_details 
on rocket_details.rocket_name = space_missions.Rocket

--===========Find the company that conducted the most expensive mission
select top 1 Company,sum(Price) as total_price from space_missions
group by Company
order by total_price desc

--==========Calculate the total cost of successful missions
select round(sum(price),3) as total_cost_successful_missions  from space_missions
where MissionStatus = 'Success'

--========== Change the status of rockets to 'Inactive' for those whose mission status is'Prelaunch Failure'
select MissionStatus from space_missions
update space_missions 
set RocketStatus = 'inactive'
where MissionStatus = 'Prelaunch Failure'

--=========== Add a new record for a space mission with necessary details
insert into rocket_details(
roke_id ,rocket_name ,manufact ,cost)
values
(9,'Sputnik 8K71PS1','Sputnik-1',23456.56),
(8,'Explorer 1','nasa',23456.56),
(12,'Juno I','nasa',23456.56)

--=========== Remove all records where the mission status is 'Failure'
delete from space_missions 
where MissionStatus = 'Failure'

--===========Create a new column 'Mission_Result' that categorizes missions as 'Successful','Partial Success', or 'Failed' based on their mission status.
alter table space_missions add Mission_Result varchar(255)
update space_missions 
set Mission_Result = case 
when MissionStatus = 'Success' 
then  'Successful'
when MissionStatus = 'Partial Failure' 
then 'Partial Success'
else 'unknown'
end;

--========== Rank the missions based on their launch date within each company
select Company,Mission,Date, count(*) over(partition by company 
order by Date rows between unbounded preceding and current row) as running_total
from space_missions

--========

--=========== Create a Common Table Expression (CTE) that lists companies along with the count of their successful missions
with SuccessfulMissions as (select Company, count(*) as SuccessfulCount from space_missions
where MissionStatus = 'Success'
group by Company )
select  Company , SuccessfulCount from SuccessfulMissions

--========= Pivot the data to show the total count of missions for each company and their mission statuses
select * from (select company , MissionStatus from space_missions) as sourseTable
pivot(count(MissionStatus)for  MissionStatus in ([Success],[Partial Success],[Failure])) as pivotTable

--========== Unpivot the table to transform the 'Mission_Result' column into a single column named 'Result'

--=========Create a stored procedure that accepts a location as input and returns the total count of missions launched from that location
create procedure getMissionSCountByLocation4 @location nvarchar(255)
as begin
select count(*) as totalMissions from space_missions
where location = @location
end;

exec getMissionSCountByLocation4 location = 'LC-18A, Cape Canaveral AFS, Florida, USA'
