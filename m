Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45405 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbbIRJNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/34] staging: wilc1000: remove typedef from the struct tstrWILC_AddStaParam
Date: Fri, 18 Sep 2015 18:11:19 +0900
Message-ID: <1442567496-29331-17-git-send-email-tony.cho@atmel.com> (sfid-20150918_111354_456079_C56318EB)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrWILC_AddStaParam and
renames it to add_sta_param in oder to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 37 +++++++++++++----------
 drivers/staging/wilc1000/host_interface.h         | 16 ++++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 +--
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8733c1b..0308421 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -427,9 +427,9 @@ union message_body {
 	struct get_channel strHostIFGetChan;
 	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
 	struct del_beacon strHostIFDelBeacon;                 /*!< Del beacon message body */
-	tstrWILC_AddStaParam strAddStaParam;                    /*!< Add station message body */
+	struct add_sta_param strAddStaParam;                    /*!< Add station message body */
 	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
-	tstrWILC_AddStaParam strEditStaParam;                           /*!< Edit station message body */
+	struct add_sta_param strEditStaParam;                           /*!< Edit station message body */
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
 	tstrTimerCb strTimerCb;                                                 /*!< Timer callback message body */
 	tstrHostIfPowerMgmtParam strPowerMgmtparam;     /*!< Power Management message body */
@@ -3561,13 +3561,14 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler,
 /**
  *  @brief WILC_HostIf_PackStaParam
  *  @details       Handling packing of the station params in a buffer
- *  @param[in]   u8* pu8Buffer, tstrWILC_AddStaParam* pstrStationParam
+ *  @param[in]   u8* pu8Buffer, struct add_sta_param *pstrStationParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrStationParam)
+static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
+				    struct add_sta_param *pstrStationParam)
 {
 	u8 *pu8CurrByte;
 
@@ -3615,13 +3616,14 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer, tstrWILC_AddStaParam *pstrSta
 /**
  *  @brief Handle_AddStation
  *  @details       Sending config packet to add station
- *  @param[in]   tstrWILC_AddStaParam* pstrStationParam
+ *  @param[in]   struct add_sta_param *pstrStationParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler,
+			      struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -3750,13 +3752,14 @@ ERRORHANDLER:
 /**
  *  @brief Handle_EditStation
  *  @details        Sending config packet to edit station
- *  @param[in]   tstrWILC_AddStaParam* pstrStationParam
+ *  @param[in]   struct add_sta_param *pstrStationParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam *pstrStationParam)
+static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler,
+			       struct add_sta_param *pstrStationParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -7058,18 +7061,19 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 /**
  *  @brief host_int_add_station
  *  @details       Setting add station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    WILC_WFIDrvHandle hWFIDrv, struct add_sta_param *pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
+			 struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.body.strAddStaParam;
+	struct add_sta_param *pstrAddStationMsg = &msg.body.strAddStaParam;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -7086,7 +7090,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drvHandler = hWFIDrv;
 
-	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
+	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
@@ -7209,18 +7213,19 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 /**
  *  @brief host_int_edit_station
  *  @details       Setting edit station params in message queue
- *  @param[in]    WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam* pstrStaParams
+ *  @param[in]    WILC_WFIDrvHandle hWFIDrv, struct add_sta_param *pstrStaParams
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
+s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
+			  struct add_sta_param *pstrStaParams)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.body.strAddStaParam;
+	struct add_sta_param *pstrAddStationMsg = &msg.body.strAddStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7236,7 +7241,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.drvHandler = hWFIDrv;
 
-	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
+	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(struct add_sta_param));
 	if (pstrAddStationMsg->u8NumRates > 0) {
 		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e069a08..90493c6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -373,7 +373,7 @@ typedef enum {
 	WILC_STA_FLAG_AUTHENTICATED             /*!< station is authenticated*/
 } tenuWILC_StaFlag;
 
-typedef struct {
+struct add_sta_param {
 	u8 au8BSSID[ETH_ALEN];
 	u16 u16AssocID;
 	u8 u8NumRates;
@@ -387,7 +387,7 @@ typedef struct {
 	u8 u8ASELCap;
 	u16 u16FlagsMask;               /*<! Determines which of u16FlagsSet were changed>*/
 	u16 u16FlagsSet;                /*<! Decoded according to tenuWILC_StaFlag */
-} tstrWILC_AddStaParam;
+};
 
 /*****************************************************************************/
 /*																			 */
@@ -1053,7 +1053,8 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv);
 
 /*!
- *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_add_station(WILC_WFIDrvHandle hWFIDrv,
+ *					 struct add_sta_param *pstrStaParams)
  *  @brief		Notifies the firmware with a new associated stations
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1065,7 +1066,8 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv);
  *  @date		12 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
+			 struct add_sta_param *pstrStaParams);
 
 /*!
  *  @fn		s32 host_int_del_allstation(WILC_WFIDrvHandle hWFIDrv, const u8* pu8MacAddr)
@@ -1098,7 +1100,8 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr);
 
 /*!
- *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv, tstrWILC_AddStaParam strStaParams)
+ *  @fn		s32 host_int_edit_station(WILC_WFIDrvHandle hWFIDrv,
+ *					  struct add_sta_param *pstrStaParams)
  *  @brief		Notifies the firmware with new parameters of an already associated station
  *  @details
  *  @param[in,out]	hWFIDrv		handle to the wifi driver
@@ -1110,7 +1113,8 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr);
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams);
+s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
+			  struct add_sta_param *pstrStaParams);
 
 /*!
  *  @fn		s32 host_int_set_power_mgmt(WILC_WFIDrvHandle hWFIDrv, bool bIsEnabled, u32 u32Timeout)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a2c80db..30858cb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3203,7 +3203,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
-	tstrWILC_AddStaParam strStaParams = { {0} };
+	struct add_sta_param strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
 	if (!wiphy)
@@ -3314,7 +3314,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
-	tstrWILC_AddStaParam strStaParams = { {0} };
+	struct add_sta_param strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
 
-- 
1.9.1

