Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18530 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbHTHdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:33:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/5] staging: wilc1000: use id value as argument
Date: Thu, 20 Aug 2015 16:32:52 +0900
Message-ID: <1440055974-9998-4-git-send-email-tony.cho@atmel.com> (sfid-20150820_093357_258798_201BE6E2)
In-Reply-To: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
References: <1440055974-9998-1-git-send-email-tony.cho@atmel.com>
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
 drivers/staging/wilc1000/host_interface.c     | 241 +++++++++++++++++++-------
 drivers/staging/wilc1000/host_interface.h     |   1 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   1 -
 3 files changed, 176 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 47e43cc..4b5e62a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -531,8 +531,8 @@ typedef enum {
 /*							Global Variabls	                                                                 */
 /*																			 */
 /*****************************************************************************/
-
-
+/* Zero is not used, because a zero ID means termination */
+static tstrWILC_WFIDrv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 tstrWILC_WFIDrv *terminated_handle;
 tstrWILC_WFIDrv *gWFiDrvHandle;
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
@@ -592,6 +592,56 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
 
+static int add_handler_in_list(tstrWILC_WFIDrv *handler)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
+		if (!wfidrv_list[i]) {
+			wfidrv_list[i] = handler;
+			return 0;
+		}
+	}
+
+	return -ENOBUFS;
+}
+
+static int remove_handler_in_list(tstrWILC_WFIDrv *handler)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
+		if (wfidrv_list[i] == handler) {
+			wfidrv_list[i] = NULL;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int get_id_from_handler(tstrWILC_WFIDrv *handler)
+{
+	int i;
+
+	if (!handler)
+		return 0;
+
+	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
+		if (wfidrv_list[i] == handler)
+			return i;
+	}
+
+	return 0;
+}
+
+static tstrWILC_WFIDrv *get_handler_from_id(int id)
+{
+	if (id <= 0 || id > ARRAY_SIZE(wfidrv_list))
+		return NULL;
+	return wfidrv_list[id];
+}
+
 /**
  *  @brief Handle_SetChannel
  *  @details    Sending config packet to firmware to set channel
@@ -616,7 +666,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -654,8 +705,8 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 pstrHostIfSetDrvHandler->u32Address);
 
 	if (pstrWFIDrv == NULL)
 		up(&hSemDeinitDrvHandle);
@@ -699,7 +750,8 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
@@ -748,8 +800,8 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
-
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
@@ -792,7 +844,8 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
@@ -853,7 +906,8 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -891,7 +945,8 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false,
+				 get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1199,7 +1254,8 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
@@ -1356,7 +1412,8 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1433,7 +1490,8 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1630,7 +1688,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1953,7 +2012,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2082,7 +2142,8 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gu8FlushedJoinReqDrvHandler);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
 		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2167,7 +2228,8 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -2727,7 +2789,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true,
+						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 
@@ -2755,7 +2818,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2767,7 +2831,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2776,7 +2841,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2822,7 +2888,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
 
@@ -2868,7 +2935,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
 
@@ -2925,7 +2993,8 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2966,7 +3035,8 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3005,7 +3075,8 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 
 		kfree(pu8keybuf);
 		break;
@@ -3054,7 +3125,8 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3167,7 +3239,8 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 
 	if (s32Error) {
@@ -3212,7 +3285,8 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3256,7 +3330,8 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3287,7 +3362,8 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3337,7 +3413,8 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
+				 get_id_from_handler(drvHandler));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3385,7 +3462,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3399,7 +3477,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3480,7 +3559,8 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3525,7 +3605,8 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3621,7 +3702,8 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3678,7 +3760,8 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3725,7 +3808,8 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3768,7 +3852,8 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3844,7 +3929,8 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -3902,7 +3988,8 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3953,7 +4040,8 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+					 get_id_from_handler(pstrWFIDrv));
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4038,7 +4126,8 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4089,7 +4178,8 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
+				 get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4157,7 +4247,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4181,7 +4272,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
@@ -4231,7 +4323,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4249,7 +4342,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
@@ -4300,7 +4394,8 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5327,7 +5422,8 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
+				 get_id_from_handler(pstrWFIDrv));
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5695,7 +5791,8 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5820,7 +5917,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
+	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	strHostIFmsg.drvHandler = u32address;
 
 	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
@@ -5941,7 +6038,8 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6033,7 +6131,8 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
+				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6478,6 +6577,7 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv;
+	int err;
 
 	/*if(u32Intialized == 1)
 	 * {
@@ -6505,6 +6605,11 @@ s32 host_int_init(tstrWILC_WFIDrv **phWFIDrv)
 	/*return driver handle to user*/
 	*phWFIDrv = pstrWFIDrv;
 	/*save into globl handle*/
+	err = add_handler_in_list(pstrWFIDrv);
+	if (err) {
+		s32Error = WILC_FAIL;
+		goto _fail_timer_2;
+	}
 
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 
@@ -6638,7 +6743,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-
+	int ret;
 
 	/*obtain driver handle*/
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -6728,6 +6833,10 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 	/*Setting the gloabl driver handler with NULL*/
 	u32Intialized = 0;
 	/* gWFiDrvHandle = NULL; */
+	ret = remove_handler_in_list(pstrWFIDrv);
+	if (ret)
+		s32Error = WILC_NOT_FOUND;
+
 	if (pstrWFIDrv != NULL) {
 		kfree(pstrWFIDrv);
 		/* pstrWFIDrv=NULL; */
@@ -6756,11 +6865,11 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 
 
 
@@ -6802,14 +6911,14 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
 	down(&hSemHostIntDeinit);
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 
@@ -6863,11 +6972,11 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	pstrWFIDrv = get_handler_from_id(id);
 
 
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e66dee9..349d5f5 100644
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

