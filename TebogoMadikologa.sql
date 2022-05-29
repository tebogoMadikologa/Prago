USE [AdventureWorks2014]

/***

- First i created all my tables  Staging for loading the files then i load them in my DB.
- Then i created an SSIS package to actuaally import this data in the DB.
- Then i did My sanity checks on the data.

***/


----- Parcels Table
CREATE TABLE [Prago].[Parcles](
	[Waybill] [varchar](50) NOT NULL,
	[Customer ID] [varchar](50) NOT NULL,
	[Order Date] [varchar](50) NOT NULL,
	[Parcel KG] [varchar](50) NOT NULL,
	[Courier Charge] [varchar](50) NOT NULL,
	[Sales amount] [varchar](50) NOT NULL,
	[Pickup Point ID] [varchar](50) NOT NULL
) ON [PRIMARY]

----- Customer Tble



CREATE TABLE [Prago].[Customers](
	[Customer_ID] [varchar](50)  NULL,
	[Customer_Name] [varchar](50)  NULL,
	[Customer_Cell] [nvarchar](50)   NULL
) ON [PRIMARY]


---- Pickup Points Table


CREATE TABLE [Prago].[PickupPoints](
	[Pickup_Point_ID] [nvarchar](50) NOT NULL,
	[Suburb] [nvarchar](50) NOT NULL,
	[Province] [nvarchar](50) NOT NULL,
	[Regional] [nvarchar](50) NOT NULL
) ON [PRIMARY]


 /***
 
 Now that the data has been successfully loaded into the Db i will analyze the data see if needs any cleansing.
 Fist we check for any duplicaes in the ID columns 
 ***/

  ---  Thus tells me there are no duplcates in the data 
SELECT  COUNT([Customer_ID]) , [Customer_Name]
FROM [AdventureWorks2014].[Prago].[Customers_Staging]
GROUP BY [Customer_ID],[Customer_Name]
HAVING COUNT([Customer_ID]) > 1

  SELECT *
  FROM [AdventureWorks2014].[Prago].[Customers_Staging]
  WHERE [Customer ID] NOT LIKE 'CUS%'


------------- CHecks on the [PickupPoints_Staging] table

SELECT  COUNT([Pickup_Point_ID]) 
FROM [AdventureWorks2014].[Prago].[PickupPoints_Staging]
GROUP BY [Pickup_Point_ID]
HAVING COUNT([Pickup_Point_ID]) > 1


-------- Checks on the  [Parcles_Staging] table
SELECT COUNT([Waybill])
FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
GROUP BY [Waybill]
HAVING COUNT([Waybill]) > 1


  SELECT *
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE [Courier Charge] = ''

  
  SELECT ISNUMERIC([Parcel KG]), [Customer ID] , [Order Date]
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE ISNUMERIC([Parcel KG]) = 0
    
  SELECT *
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE ISNUMERIC([Parcel KG]) = 0


  SELECT ISNUMERIC([Sales amount]), [Customer ID] , [Order Date]
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE ISNUMERIC([Sales amount]) = 0
   

   SELECT *
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE ISNUMERIC([Sales amount]) = 0


    SELECT *
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]
  WHERE [Customer ID] NOT LIKE 'CUS%'

/******  staging into DB  ******/

    ---------- Customers table

INSERT INTO [AdventureWorks2014].[Prago].[Customers]
 (
    [Customer_ID]
   ,[Customer_Name]
   ,[Customer_Cell]
 )
SELECT  [Customer_ID]
      ,[Customer_Name]
      ,[Customer_Cell]
  FROM [AdventureWorks2014].[Prago].[Customers_Staging]

    ---------- Parcles table

  INSERT INTO [AdventureWorks2014].[Prago].[Parcles]
(
       [Waybill]
      ,[Customer ID]
      ,[Order Date]
      ,[Parcel KG]
      ,[Courier Charge]
      ,[Sales amount]
      ,[Pickup Point ID]
)
SELECT [Waybill]
      ,[Customer ID]
      ,[Order Date]
      ,[Parcel KG]
      ,[Courier Charge]
      ,[Sales amount]
      ,[Pickup Point ID]
  FROM [AdventureWorks2014].[Prago].[Parcles_Staging]

  ---------- Pick up points

  INSERT INTO [AdventureWorks2014].[Prago].[PickupPoints]
(
       [Pickup_Point_ID]
      ,[Suburb]
      ,[Province]
      ,[Regional]
)
SELECT [Pickup_Point_ID]
      ,[Suburb]
      ,[Province]
      ,[Regional]
  FROM [AdventureWorks2014].[Prago].[PickupPoints_Staging]

----  Then truncate stg and prepare for new load

TRUNCATE TABLE [AdventureWorks2014].[Prago].[PickupPoints_Staging]
TRUNCATE TABLE [AdventureWorks2014].[Prago].[Parcles_Staging]
TRUNCATE TABLE [AdventureWorks2014].[Prago].[Customers_Staging]
