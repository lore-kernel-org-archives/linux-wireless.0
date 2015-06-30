Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38599 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbF3IgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:36:09 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: [PATCH 3/6] staging: wilc1000: rework driver handler
Date: Tue, 30 Jun 2015 17:34:35 +0900
Message-ID: <1435653278-5168-3-git-send-email-dean.lee@atmel.com> (sfid-20150630_103618_300900_59D14DD7)
In-Reply-To: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

argument type change for support 64 bit system.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |   2 +-
 drivers/staging/wilc1000/coreconfigurator.h       |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 218 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |  96 +++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   8 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 +-
 8 files changed, 170 insertions(+), 166 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ed6ac45..35c3c56 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -2098,7 +2098,7 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
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
index 55572bd..1d59f41 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -581,7 +581,7 @@ u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 u32 gu32FlushedJoinReqSize;
 u32 gu32FlushedInfoElemAsocSize;
-u32 gu8FlushedJoinReqDrvHandler;
+void *gpFlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
@@ -619,7 +619,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -702,10 +702,10 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL) {
+	if (pstrHostIfSetOperationMode == NULL) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -752,7 +752,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 
 
@@ -796,7 +796,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, drvHandler);
 
 	PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", (u8)(strWID.ps8WidVal[0]), (u8)(strWID.ps8WidVal[1]), (u8)(strWID.ps8WidVal[2]), (u8)(strWID.ps8WidVal[3]));
 
@@ -856,7 +856,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -894,7 +894,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1202,7 +1202,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Error in setting CFG params\n");
@@ -1362,7 +1362,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 		gbScanWhileConnected = false;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1440,7 +1440,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1639,7 +1639,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		/* ////////////////////// */
 		#endif
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1957,7 +1957,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	/*BugID_5137*/
 	if (WILC_memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = (u32)pstrWFIDrv;
+		gpFlushedJoinReqDrvHandler = pstrWFIDrv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1969,7 +1969,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2100,7 +2100,7 @@ static s32 Handle_FlushConnect(void *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gu8FlushedJoinReqDrvHandler);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, gpFlushedJoinReqDrvHandler);
 	if (s32Error) {
 		PRINT_ER("Handle_Flush_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2185,7 +2185,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	}
@@ -2211,11 +2211,11 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedJoinReq != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 		WILC_FREE(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedInfoElemAsoc != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 		WILC_FREE(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
@@ -2577,7 +2577,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 				PRINT_D(HOSTINF_DBG, "\n\n<< Abort the running OBSS Scan >> \n\n");
 				WILC_TimerStop(&(pstrWFIDrv->hScanTimer), NULL);
-				Handle_ScanDone((void *)pstrWFIDrv, SCAN_EVENT_ABORTED);
+				Handle_ScanDone(drvHandler, SCAN_EVENT_ABORTED);
 			}
 
 			strDisconnectNotifInfo.u16reason = 0;
@@ -2636,11 +2636,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*BugID_5213*/
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedJoinReq != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 				WILC_FREE(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedInfoElemAsoc != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 				WILC_FREE(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
@@ -2746,7 +2746,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, drvHandler);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2774,7 +2774,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2786,7 +2786,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2795,7 +2795,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2841,7 +2841,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, drvHandler);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2888,7 +2888,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2945,7 +2945,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, drvHandler);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2986,7 +2986,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3025,7 +3025,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3074,7 +3074,7 @@ static void Handle_Disconnect(void *drvHandler)
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3138,11 +3138,11 @@ static void Handle_Disconnect(void *drvHandler)
 
 
 		/*BugID_5137*/
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedJoinReq != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 			WILC_FREE(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedInfoElemAsoc != NULL && gpFlushedJoinReqDrvHandler == drvHandler) {
 			WILC_FREE(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
@@ -3187,7 +3187,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 
 	if (s32Error) {
@@ -3231,7 +3231,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, drvHandler);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3275,7 +3275,7 @@ static void Handle_GetRssi(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3306,7 +3306,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3356,7 +3356,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3404,7 +3404,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3418,7 +3418,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, drvHandler);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3499,7 +3499,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3544,7 +3544,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3641,7 +3641,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3697,7 +3697,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3745,7 +3745,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3789,7 +3789,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3866,7 +3866,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to set remain on channel\n");
 	}
@@ -3924,7 +3924,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3976,7 +3976,7 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4062,7 +4062,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4114,7 +4114,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4182,7 +4182,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4206,7 +4206,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4256,7 +4256,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4274,7 +4274,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4325,7 +4325,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, drvHandler);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4649,7 +4649,7 @@ s32 host_int_remove_wep_key(void *hWFIDrv, u8 u8keyIdx)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -4699,7 +4699,7 @@ s32 host_int_set_WEPDefaultKeyID(void *hWFIDrv, u8 u8Index)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5111,7 +5111,7 @@ s32 host_int_set_pmkid_info(void *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArra
 	u32 i;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5363,7 +5363,7 @@ s32 host_int_get_site_survey_results(void *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, hWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5719,8 +5719,8 @@ s32 host_int_get_assoc_res_info(void *hWFIDrv, u8 *pu8AssocRespInfo,
 	tstrWID strWID;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+	if (hWFIDrv == NULL) {
+		PRINT_ER("Driver not initialized: hWFIDrv = NULL \n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5731,7 +5731,7 @@ s32 host_int_get_assoc_res_info(void *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, hWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5799,7 +5799,7 @@ s32 host_int_set_mac_chnl_num(void *hWFIDrv, u8 u8ChNum)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5970,8 +5970,8 @@ s32 host_int_test_set_int_wid(void *hWFIDrv, u32 u32TestMemAddr)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+	if (hWFIDrv == NULL) {
+		PRINT_ER("Driver not initialized: hWFIDrv = NULL \n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -5982,7 +5982,7 @@ s32 host_int_test_set_int_wid(void *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, hWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6064,8 +6064,8 @@ s32 host_int_test_get_int_wid(void *hWFIDrv, u32 *pu32TestMemAddr)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
-	if (pstrWFIDrv == NULL) {
-		PRINT_ER("Driver not initialized: pstrWFIDrv = NULL \n");
+	if (hWFIDrv == NULL) {
+		PRINT_ER("Driver not initialized: hWFIDrv = NULL \n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -6074,7 +6074,7 @@ s32 host_int_test_get_int_wid(void *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, hWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6300,7 +6300,7 @@ s32 hif_set_cfg(void *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	tstrHostIFmsg strHostIFmsg;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 	/* prepare the WiphyParams Message */
@@ -6757,7 +6757,7 @@ s32 host_int_deinit(void *hWFIDrv)
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
 	#endif
 
-	host_int_set_wfi_drv_handler((u32)NULL);
+	host_int_set_wfi_drv_handler(NULL);
 	down(&hSemDeinitDrvHandle);
 
 
@@ -6838,17 +6838,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
-	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
-
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
-
+	uintptr_t drvData;
+	void *drvHandler = NULL;
 
+	drvData = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	drvHandler = (void *)drvData;
 
-
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle)	{
-		PRINT_ER("NetworkInfo received but driver not init[%p]\n", pstrWFIDrv);
+	if (drvHandler == NULL || drvHandler == terminated_handle)	{
+		PRINT_ER("NetworkInfo received but driver not init[%p]\n", drvHandler);
 		return;
 	}
 
@@ -6856,7 +6853,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	strHostIFmsg.drvHandler = drvHandler;
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
 	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = (u8 *)WILC_MALLOC(u32Length); /* will be deallocated by the receiving thread */
@@ -6888,24 +6885,26 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	uintptr_t drvData;
+	void *drvHandler = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
 	down(&hSemHostIntDeinit);
 
-	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	drvData = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	drvHandler = (void *)drvData;
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received \n");
 
-
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
+	if (drvHandler == NULL || drvHandler == terminated_handle) {
 		PRINT_D(HOSTINF_DBG, "Wifi driver handler is equal to NULL\n");
 		/*BugID_5348*/
 		up(&hSemHostIntDeinit);
 		return;
 	}
 
+	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	if (pstrWFIDrv->strWILC_UsrConnReq.pfUserConnectResult == NULL) {
 		/* received mac status is not needed when there is no current Connect Request */
 		PRINT_ER("Received mac status is not needed when there is no current Connect Reques\n");
@@ -6919,7 +6918,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	strHostIFmsg.drvHandler = drvHandler;
 
 
 	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
@@ -6951,25 +6950,30 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	u32 drvHandler;
+	uintptr_t drvData;
+	void *drvHandler = NULL;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
+	drvData = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
+	drvHandler = (void *)drvData;
 
-	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
+	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", drvHandler);
 
-	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
+	if (drvHandler == NULL || drvHandler == terminated_handle) {
 		return;
 	}
 
+	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
 		WILC_memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 
 		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		strHostIFmsg.drvHandler = pstrWFIDrv;
+		strHostIFmsg.drvHandler = drvHandler;
 
 
 		/* will be deallocated by the receiving thread */
@@ -7013,7 +7017,7 @@ s32 host_int_remain_on_channel(void *hWFIDrv, u32 u32SessionID, u32 u32duration,
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7100,7 +7104,7 @@ s32 host_int_frame_register(void *hWFIDrv, u16 u16FrameType, bool bReg)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7164,7 +7168,7 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7233,7 +7237,7 @@ s32 host_int_del_beacon(void *hWFIDrv)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7269,7 +7273,7 @@ s32 host_int_add_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7319,7 +7323,7 @@ s32 host_int_del_station(void *hWFIDrv, const u8 *pu8MacAddr)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7369,7 +7373,7 @@ s32 host_int_del_allstation(void *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	u8 u8AssocNumb = 0;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7429,7 +7433,7 @@ s32 host_int_edit_station(void *hWFIDrv, tstrWILC_AddStaParam *pstrStaParams)
 	tstrHostIFmsg strHostIFmsg;
 	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7471,7 +7475,7 @@ s32 host_int_set_power_mgmt(void *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d << \n\n", bIsEnabled);
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7507,7 +7511,7 @@ s32 host_int_setup_multicast_filter(void *hWFIDrv, bool bIsEnabled, u32 u32count
 	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7778,7 +7782,7 @@ static int host_int_addBASession(void *hWFIDrv, char *pBSSID, char TID, short in
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7813,7 +7817,7 @@ s32 host_int_delBASession(void *hWFIDrv, char *pBSSID, char TID)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7848,7 +7852,7 @@ s32 host_int_del_All_Rx_BASession(void *hWFIDrv, char *pBSSID, char TID)
 	tstrHostIFmsg strHostIFmsg;
 	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7893,7 +7897,7 @@ s32 host_int_setup_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
@@ -7934,7 +7938,7 @@ s32 host_int_get_ipaddress(void *hWFIDrv, u8 *u16ipadd, u8 idx)
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	tstrHostIFmsg strHostIFmsg;
 
-	if (pstrWFIDrv == NULL) {
+	if (hWFIDrv == NULL) {
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
 	}
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c6bf7e3..659b70a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1074,7 +1074,7 @@ _FAIL_:
 /* startup configuration - could be changed later using iconfig*/
 static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_nic)
 {
-
+  void *drvHandler = NULL;
 	unsigned char c_val[64];
 	#ifndef STATIC_MACADDRESS
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
@@ -1102,62 +1102,62 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 	}
 
-	*(int *)c_val = (u32)pstrWFIDrv;
+	*(int *)c_val = (uintptr_t)pstrWFIDrv;
 
-	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, drvHandler))
 		goto _fail_;
 
 	/*to tell fw that we are going to use PC test - WILC specific*/
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PC_TEST_MODE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = INFRASTRUCTURE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BSS_TYPE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 
 	/* c_val[0] = RATE_AUTO; / * bug 4275: Enable autorate and limit it to 24Mbps * / */
 	c_val[0] = RATE_AUTO;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_TX_RATE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11G_OPERATING_MODE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_CURRENT_CHANNEL, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = G_SHORT_PREAMBLE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_PREAMBLE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = AUTO_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_PROT_MECH, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 #ifdef SWITCH_LOG_TERMINAL
 	c_val[0] = AUTO_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LOGTerminal_Switch, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LOGTerminal_Switch, c_val, 1, 0, drvHandler))
 		goto _fail_;
 #endif
 
 	c_val[0] = ACTIVE_SCAN;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SCAN_TYPE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = SITE_SURVEY_OFF;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SITE_SURVEY, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	*((int *)c_val) = 0xffff; /* Never use RTS-CTS */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_RTS_THRESHOLD, c_val, 2, 0, drvHandler))
 		goto _fail_;
 
 	*((int *)c_val) = 2346;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_FRAG_THRESHOLD, c_val, 2, 0, drvHandler))
 		goto _fail_;
 
 	/*  SSID                                                                 */
@@ -1169,28 +1169,28 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  --------------------------------------------------------------       */
 #ifndef USE_WIRELESS
 	strcpy(c_val, "nwifi");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SSID, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SSID, c_val, (strlen(c_val) + 1), 0, drvHandler))
 		goto _fail_;
 #endif
 
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BCAST_SSID, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_QOS_ENABLE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = NO_POWERSAVE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = NO_ENCRYPT; /* NO_ENCRYPT, 0x79 */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = OPEN_SYSTEM;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_AUTH_TYPE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -1202,7 +1202,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  ------------------------------------------------------------------   */
 
 	strcpy(c_val, "123456790abcdef1234567890");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_WEP_KEY_VALUE, c_val, (strlen(c_val) + 1), 0, drvHandler))
 		goto _fail_;
 
 	/*  WEP/802 11I Configuration                                            */
@@ -1212,7 +1212,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                  and less than 64 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "12345678");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11I_PSK, c_val, (strlen(c_val)), 0, drvHandler))
 		goto _fail_;
 
 	/*  IEEE802.1X Key Configuration                                         */
@@ -1222,7 +1222,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*                  and less than 65 bytes                               */
 	/*  ------------------------------------------------------------------   */
 	strcpy(c_val, "password");
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_KEY, c_val, (strlen(c_val) + 1), 0, drvHandler))
 		goto _fail_;
 
 	/*   IEEE802.1X Server Address Configuration                             */
@@ -1234,31 +1234,31 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_1X_SERV_ADDR, c_val, 4, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_LISTEN_INTERVAL, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_DTIM_PERIOD, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = NORMAL_ACK;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_ACK_POLICY, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 48;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 28;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	/*  Beacon Interval                                                      */
@@ -1268,11 +1268,11 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  -------------------------------------------------------------------- */
 
 	*((int *)c_val) = 100;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_BEACON_INTERVAL, c_val, 2, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = REKEY_DISABLE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_POLICY, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	/*  Rekey Time (s) (Used only when the Rekey policy is 2 or 4)           */
@@ -1281,7 +1281,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  Values to set : 32-bit value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 84600;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PERIOD, c_val, 4, 0, drvHandler))
 		goto _fail_;
 
 	/*  Rekey Packet Count (in 1000s; used when Rekey Policy is 3)           */
@@ -1290,59 +1290,59 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	/*  Values to set : 32-bit Value                                         */
 	/*  -------------------------------------------------------------------- */
 	*((int *)c_val) = 500;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_REKEY_PACKET_COUNT, c_val, 4, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = G_SELF_CTS_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1;  /* Enable N */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_ENABLE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = HT_MIXED_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OPERATING_MODE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1;   /* TXOP Prot disable in N mode: No RTS-CTS on TX A-MPDUs to save air-time. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	memcpy(c_val, mac_add, 6);
 
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_MAC_ADDR, c_val, 6, 0, drvHandler))
 		goto _fail_;
 
 	/**
 	 *      AP only
 	 **/
 	c_val[0] = DETECT_PROTECT_REPORT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = MIMO_MODE;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_SMPS_MODE, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 7;
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0, drvHandler))
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (u32)pstrWFIDrv))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, pstrWFIDrv))
 		goto _fail_;
 
 	return 0;
@@ -2078,7 +2078,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)priv->hWILCWFIDrv;
+			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 28ec14d..fe83986 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -747,7 +747,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -842,7 +842,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler(priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4f76015..8719f12 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -173,7 +173,7 @@ typedef struct {
 typedef struct {
 	uint8_t aSrcAddress[ETH_ALEN];
 	uint8_t aBSSID[ETH_ALEN];
-	uint32_t drvHandler;
+	void *drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
 typedef struct {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3af91f7..2b1bb7b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1863,13 +1863,13 @@ static void wilc_wlan_cleanup(void)
 
 }
 
-static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
+static int wilc_wlan_cfg_commit(int type, void *drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
-	int driver_handler = (u32)drvHandler;
+	uintptr_t driver_handler = (uintptr_t)(drvHandler);
 
 
 	/**
@@ -1900,7 +1900,7 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, void *drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
@@ -1939,7 +1939,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, void *drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8ed51e3..a7b259a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -193,8 +193,8 @@ typedef struct {
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
+	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, void *);
+	int (*wlan_cfg_get)(int, uint32_t, int, void *);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-- 
2.4.4

