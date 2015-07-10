Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44346 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbbGJF4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:46 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 4/5] staging: wilc1000: SendConfigPkt(): replace integer with void pointer
Date: Fri, 10 Jul 2015 14:55:58 +0900
Message-ID: <f2a06d72df5600df11f0591cfdd2a1178f11d54e.1436504598.git.johnny.kim@atmel.com> (sfid-20150710_075649_808631_767204D7)
In-Reply-To: <5398ffb63f5799c0fbab0c2fe1416bb09c4bae6b.1436504598.git.johnny.kim@atmel.com>
References: <5398ffb63f5799c0fbab0c2fe1416bb09c4bae6b.1436504598.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces a integer argument of SendConfigPkt function with
void type pointer and fix code that the function is called.

Because tstrWILC_WFIDrv structure is defined after SendConfigPkt function
is defined, the function can not refer to the structure type.
So this patch change the argument to void type pointer.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h |   2 +-
 drivers/staging/wilc1000/host_interface.c   | 102 ++++++++++++++--------------
 3 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 5c1096d..e274f1b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1893,7 +1893,7 @@ s32 ConfigWaitResponse(char *pcRespBuffer, s32 s32MaxRespBuffLen, s32 *ps32Bytes
  */
 #ifdef SIMULATION
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
+			  u32 u32WIDsCount, bool bRespRequired, void *drvHandler)
 {
 	s32 s32Error = WILC_SUCCESS;
 	s32 err = WILC_SUCCESS;
@@ -2072,7 +2072,7 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
  *  @version	1.0
  */
 s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
+			  u32 u32WIDsCount, bool bRespRequired, void *drvHandler)
 {
 	s32 counter = 0, ret = 0;
 	if (gpstrWlanOps == NULL) {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 9059c8d..c39802f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -175,7 +175,7 @@ extern s32 CoreConfiguratorInit(void);
 extern s32 CoreConfiguratorDeInit(void);
 
 extern s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-				 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+				 u32 u32WIDsCount, bool bRespRequired, void *drvHandler);
 extern s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 extern s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c089e73..dfd8e01 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -619,7 +619,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -656,7 +656,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
@@ -701,7 +701,7 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
@@ -750,7 +750,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 
@@ -794,7 +794,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
@@ -855,7 +855,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -893,7 +893,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1201,7 +1201,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, pstrWFIDrv);
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
@@ -1359,7 +1359,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 		gbScanWhileConnected = false;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1436,7 +1436,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1635,7 +1635,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		/* ////////////////////// */
 		#endif
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1960,7 +1960,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2089,7 +2089,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gu8FlushedJoinReqDrvHandler);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (void *)gu8FlushedJoinReqDrvHandler);
 	if (s32Error) {
 		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2174,7 +2174,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -2733,7 +2733,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2761,7 +2761,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2773,7 +2773,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2782,7 +2782,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2828,7 +2828,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2875,7 +2875,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2932,7 +2932,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2973,7 +2973,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3012,7 +3012,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3061,7 +3061,7 @@ static void Handle_Disconnect(void *drvHandler)
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3174,7 +3174,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if (s32Error) {
@@ -3219,7 +3219,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3263,7 +3263,7 @@ static void Handle_GetRssi(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3294,7 +3294,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3344,7 +3344,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3392,7 +3392,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3406,7 +3406,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3487,7 +3487,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3532,7 +3532,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3628,7 +3628,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3685,7 +3685,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3732,7 +3732,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3775,7 +3775,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3851,7 +3851,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -3906,7 +3906,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3957,7 +3957,7 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4043,7 +4043,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4094,7 +4094,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4162,7 +4162,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4186,7 +4186,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4236,7 +4236,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4254,7 +4254,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4305,7 +4305,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5333,7 +5333,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, pstrWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5699,7 +5699,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5945,7 +5945,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6037,7 +6037,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
-- 
1.9.1

