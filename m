Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:34876 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbbHJF7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 01:59:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<glen.lee@atmel.com>, <leo.kim@atmel.com>, <jude.lee@atmel.com>,
	<robin.hwang@atmel.com>, <tony.cho@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/5] staging: wilc1000: use id value as argument
Date: Mon, 10 Aug 2015 14:58:24 +0900
Message-ID: <1439186304-3480-6-git-send-email-tony.cho@atmel.com> (sfid-20150810_075917_996157_71FCCBB1)
In-Reply-To: <1439186304-3480-1-git-send-email-tony.cho@atmel.com>
References: <1439186304-3480-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johnny Kim <johnny.kim@atmel.com>

The driver communicates with the chipset via the address of handlers
to distinguish async data frame. The SendConfigPkt function gets the
pointer address indicating the handlers as the last argument, but this
requires redundant typecasting and does not support the 64 bit machine.

This patch adds the function which assigns ID values instead of pointer
representing the driver handler to the address and then uses the ID
instead of pointer as the last argument of SendConfigPkt. The driver
also gets the handler's address from the ID in the data frame when it
receives them.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c     | 242 +++++++++++++++++++-------
 drivers/staging/wilc1000/host_interface.h     |   1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   1 -
 3 files changed, 180 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c4e27c7..5a0277f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -532,7 +532,7 @@ typedef enum {
 /*																			 */
 /*****************************************************************************/
 
-
+static tstrWILC_WFIDrv *wfidrv_list[NUM_CONCURRENT_IFC];
 tstrWILC_WFIDrv *terminated_handle;
 tstrWILC_WFIDrv *gWFiDrvHandle;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -592,6 +592,70 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
 
+static u32 add_handler_in_list(tstrWILC_WFIDrv *handler)
+{
+	u32 id;
+
+	if (!handler)
+		return 0;
+
+	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
+		if (!wfidrv_list[id]) {
+			wfidrv_list[id++] = handler;
+			break;
+		}
+	}
+
+	if (id > NUM_CONCURRENT_IFC)
+		return 0;
+
+	return id;
+}
+
+static u32 remove_handler_in_list(tstrWILC_WFIDrv *handler)
+{
+	u32 id;
+
+	if (!handler)
+		return 0;
+
+	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
+		if (wfidrv_list[id] == handler) {
+			wfidrv_list[id++] = NULL;
+			break;
+		}
+	}
+
+	return id;
+}
+
+static u32 get_id_from_handler(tstrWILC_WFIDrv *handler)
+{
+	u32 id;
+
+	if (!handler)
+		return 0;
+
+	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
+		if (wfidrv_list[id] == handler) {
+			id += 1;
+			break;
+		}
+	}
+
+	if (id > NUM_CONCURRENT_IFC)
+		return 0;
+	else
+		return id;
+}
+
+static tstrWILC_WFIDrv *get_handler_from_id(u32 id)
+{
+	if (id > 0 && id <= NUM_CONCURRENT_IFC)
+		return wfidrv_list[id - 1];
+	else
+		return NULL;
+}
 /**
  *  @brief Handle_SetChannel
  *  @details    Sending config packet to firmware to set channel
@@ -616,7 +680,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -653,7 +718,8 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 pstrHostIfSetDrvHandler->u32Address);
 
 
 	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
@@ -698,7 +764,8 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
@@ -747,8 +814,8 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
@@ -791,7 +858,8 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
@@ -852,7 +920,8 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -890,7 +959,8 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false,
+				 get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1198,7 +1268,8 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
@@ -1355,7 +1426,8 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1432,7 +1504,8 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1629,7 +1702,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1952,7 +2026,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2081,7 +2156,8 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gu8FlushedJoinReqDrvHandler);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
 		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2166,7 +2242,8 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -2725,7 +2802,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true,
+						 get_id_from_handler(pstrWFIDrv));
 			WILC_FREE(pu8keybuf);
 
 
@@ -2753,7 +2831,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2765,7 +2844,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2774,7 +2854,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2820,7 +2901,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+						 get_id_from_handler(pstrWFIDrv));
 
 			WILC_FREE(pu8keybuf);
 
@@ -2866,7 +2948,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 
 			WILC_FREE(pu8keybuf);
 
@@ -2923,7 +3006,8 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+						 get_id_from_handler(pstrWFIDrv));
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2964,7 +3048,8 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3003,7 +3088,8 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3052,7 +3138,8 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3165,7 +3252,8 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	if (s32Error) {
@@ -3210,7 +3298,8 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3254,7 +3343,8 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3285,7 +3375,8 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3335,7 +3426,8 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(drvHandler));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3383,7 +3475,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3397,7 +3490,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3478,7 +3572,8 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3523,7 +3618,8 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3619,7 +3715,8 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3676,7 +3773,8 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3723,7 +3821,8 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3766,7 +3865,8 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3842,7 +3942,8 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -3897,7 +3998,8 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3948,7 +4050,8 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4033,7 +4136,8 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4084,7 +4188,8 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4152,7 +4257,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4176,7 +4282,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4226,7 +4333,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4244,7 +4352,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4295,7 +4404,8 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5323,7 +5433,8 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5689,7 +5800,8 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5814,7 +5926,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
+	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	/* strHostIFmsg.drvHandler=hWFIDrv; */
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg), NULL);
@@ -5935,7 +6047,8 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6027,7 +6140,8 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6497,6 +6611,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*return driver handle to user*/
 	*phWFIDrv = pstrWFIDrv;
 	/*save into globl handle*/
+	add_handler_in_list(pstrWFIDrv);
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
@@ -6744,6 +6859,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	/*Setting the gloabl driver handler with NULL*/
 	u32Intialized = 0;
 	/* gWFiDrvHandle = NULL; */
+	remove_handler_in_list(pstrWFIDrv);
 	if (pstrWFIDrv != NULL) {
 		WILC_FREE(pstrWFIDrv);
 		/* pstrWFIDrv=NULL; */
@@ -6772,11 +6888,11 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	u32 id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 
 
 
@@ -6821,14 +6937,14 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	u32 id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
 	down(&hSemHostIntDeinit);
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 
@@ -6883,11 +6999,11 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	u32 id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 
 
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5ac5563..58141af 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -63,6 +63,7 @@
 #define WILC_SUPP_MCS_SET_SIZE	16
 #define WILC_ADD_STA_LENGTH	40 /* Not including the rates field cause it has variable length*/
 #define SCAN_EVENT_DONE_ABORTED
+#define NUM_CONCURRENT_IFC 2
 /*****************************************************************************/
 /* Data Types                                                                */
 /*****************************************************************************/
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 77f320d..6a1aa9e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -172,7 +172,6 @@ typedef struct {
 
 } struct_frame_reg;
 
-#define NUM_CONCURRENT_IFC 2
 typedef struct {
 	uint8_t aSrcAddress[ETH_ALEN];
 	uint8_t aBSSID[ETH_ALEN];
-- 
1.9.1

