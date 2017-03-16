Sys.setlocale(category = "LC_ALL", locale = "cht")

url <- "https://steamdb.info/graph/"

xpathSteamDB <-paste(paste("//td[", c(2:6), sep = ""), "]", sep = "")
steamdbData<-data.frame()
# get data from Steamdb
dataurl <-read_html(url)
data_forSteamdb <- dataurl %>%
  html_nodes(., xpath = xpathSteamDB[1])%>%
  html_text
steamdbData <- cbind(data_forSteamdb)

for(i in 1:length(xpathSteamDB) ){
  data_forSteamdb <- dataurl %>%
  html_nodes(., xpath = xpathSteamDB[i+1])%>%
  html_text
  steamdbData <- cbind(steamdbData, data_forSteamdb)
}
steamdbData <- as.data.frame(steamdbData)
names(steamdbData) <- c("id", "Name", "currentPlayer", "24Hpeak","allTimepeak")

# get developer data 
url_SingleGame <-paste(
  paste("https://steamdb.info/app/", steamdbData$id, sep = ""),
  "/",
  sep = ""
  )
# every Game Developer Xpath
xpath_GAme_developer <- "//table[@class='table table-bordered table-hover table-dark']/tbody/tr[4]/td[2]"
data_forGameDeveloper <- c()
for(i in 1:length(url_SingleGame)){
  Game_singlePage <-read_html(url_SingleGame[i])
  data_forGameDeveloper <-c(data_forGameDeveloper, Game_singlePage %>%
    html_nodes(., xpath = xpath_GAme_developer)%>%
    html_text)
  
}



# every Game data for current price
urlSingleGame <- "https://steamdb.info/app/"
xpath_price_line <-  "//tr/td[@class='price-line']"
