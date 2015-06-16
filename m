Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:18294 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbFPHMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:12:20 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH 1/2] staging: wilc1000: modify type casting warning
Date: Tue, 16 Jun 2015 16:11:24 +0900
Message-ID: <1434438685-24336-1-git-send-email-dean.lee@atmel.com> (sfid-20150616_091225_950209_2C4275DC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modify message "warning: cast from pointer to integer of different size".
add type cast 'uintptr_t'.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
Change Log:
 add Signed-off-by line

 drivers/staging/wilc1000/host_interface.c         | 129 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |   8 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  22 ++--
 3 files changed, 80 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3f139ae..358283f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,5 +1,6 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include <linux/types.h>
 
 extern s32 TransportInit(void);
 extern s32 TransportDeInit(void);
@@ -620,7 +621,7 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -646,7 +647,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	s32 s32Error = WILC_SUCCESS;
 	tstrWID	strWID;
-	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)((pstrHostIfSetDrvHandler->u32Address));
+	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)(uintptr_t)(pstrHostIfSetDrvHandler->u32Address);
 
 
 	/*prepare configuration packet*/
@@ -657,10 +658,10 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL) {
+	if (pstrHostIfSetDrvHandler == NULL) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -703,10 +704,10 @@ static s32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperationMode
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p \n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL) {
+	if (pstrHostIfSetOperationMode == NULL) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -753,7 +754,7 @@ s32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 
 
@@ -797,7 +798,7 @@ s32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 	PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", (u8)(strWID.ps8WidVal[0]), (u8)(strWID.ps8WidVal[1]), (u8)(strWID.ps8WidVal[2]), (u8)(strWID.ps8WidVal[3]));
 
@@ -857,7 +858,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -895,7 +896,7 @@ static s32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddress *pstrH
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)(uintptr_t)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1203,7 +1204,7 @@ static s32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *strHostIFCf
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)(uintptr_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Error in setting CFG params\n");
@@ -1370,7 +1371,7 @@ static s32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
 		gbScanWhileConnected = false;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)(uintptr_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1448,7 +1449,7 @@ static s32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1647,7 +1648,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		/* ////////////////////// */
 		#endif
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)(uintptr_t)pstrWFIDrv);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1976,7 +1977,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	/*BugID_5137*/
 	if (WILC_memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = (u32)pstrWFIDrv;
+		gu8FlushedJoinReqDrvHandler = (u32)(uintptr_t)pstrWFIDrv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1988,7 +1989,7 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2204,7 +2205,7 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	}
@@ -2230,11 +2231,11 @@ static s32 Handle_ConnectTimeout(void *drvHandler)
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 		WILC_FREE(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 		WILC_FREE(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
@@ -2655,11 +2656,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncInfo *pst
 			/*BugID_5213*/
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 				WILC_FREE(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 				WILC_FREE(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
@@ -2765,7 +2766,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)(uintptr_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2793,7 +2794,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2805,7 +2806,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2814,7 +2815,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2860,7 +2861,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)(uintptr_t)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2907,7 +2908,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2964,7 +2965,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)(uintptr_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3005,7 +3006,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3044,7 +3045,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3093,7 +3094,7 @@ static void Handle_Disconnect(void *drvHandler)
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3157,11 +3158,11 @@ static void Handle_Disconnect(void *drvHandler)
 
 
 		/*BugID_5137*/
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 			WILC_FREE(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)drvHandler) {
+		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (u32)(uintptr_t)drvHandler) {
 			WILC_FREE(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
@@ -3206,7 +3207,7 @@ static s32 Switch_Log_Terminal(void *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 
 	if (s32Error) {
@@ -3250,7 +3251,7 @@ static s32 Handle_GetChnl(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3294,7 +3295,7 @@ static void Handle_GetRssi(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3325,7 +3326,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3375,7 +3376,7 @@ s32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistics)
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)(uintptr_t)drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3423,7 +3424,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3437,7 +3438,7 @@ static s32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInactiveT *str
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3518,7 +3519,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3563,7 +3564,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3660,7 +3661,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3716,7 +3717,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3764,7 +3765,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3808,7 +3809,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3885,7 +3886,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to set remain on channel\n");
 	}
@@ -3943,7 +3944,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3995,7 +3996,7 @@ static u32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainOnChan *p
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4081,7 +4082,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4133,7 +4134,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)(uintptr_t)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4201,7 +4202,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4225,7 +4226,7 @@ static s32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4275,7 +4276,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4293,7 +4294,7 @@ static s32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo *strHos
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4344,7 +4345,7 @@ static s32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessionInfo *
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5441,7 +5442,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)(uintptr_t)pstrWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5809,7 +5810,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -6060,7 +6061,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6152,7 +6153,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)(uintptr_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6835,7 +6836,7 @@ s32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
 	#endif
 
-	host_int_set_wfi_drv_handler((u32)NULL);
+	host_int_set_wfi_drv_handler(0);
 	down(&hSemDeinitDrvHandle);
 
 
@@ -6920,7 +6921,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	pstrWFIDrv = (tstrWILC_WFIDrv *)(uintptr_t)drvHandler;
 
 
 
@@ -6973,7 +6974,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	down(&hSemHostIntDeinit);
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	pstrWFIDrv = (tstrWILC_WFIDrv *)(uintptr_t)drvHandler;
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received \n");
 
 
@@ -7032,7 +7033,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	u32 drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
+	pstrWFIDrv = (tstrWILC_WFIDrv *)(uintptr_t)drvHandler;
 
 
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c1e9272..dbbb456 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1124,7 +1124,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 	}
 
-	*(int *)c_val = (u32)pstrWFIDrv;
+	*(int *)c_val = (u32)(uintptr_t)pstrWFIDrv;
 
 	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
@@ -1364,7 +1364,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (u32)pstrWFIDrv))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (u32)(uintptr_t)pstrWFIDrv))
 		goto _fail_;
 
 	return 0;
@@ -2100,7 +2100,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)priv->hWILCWFIDrv;
+			g_linux_wlan->strInterfaceInfo[i].drvHandler = (u32)(uintptr_t)priv->hWILCWFIDrv;
 			break;
 		}
 	}
@@ -2542,7 +2542,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 			return;
 		}
 
-		skb_reserve(skb, (unsigned int)skb->data & 0x3);
+		skb_reserve(skb, (uintptr_t)skb->data & 0x3);
 
 		if (g_linux_wlan == NULL || wilc_netdev == NULL) {
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9dcb326..6a50908 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -747,7 +747,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler((u32)(uintptr_t)priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -842,7 +842,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler((u32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler((u32)(uintptr_t)priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
@@ -2907,15 +2907,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2995,15 +2995,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 			g_wilc_initialized = 1;
 
 			host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-			host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_MacAddress((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+				host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -3127,15 +3127,15 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		host_int_set_wfi_drv_handler(g_linux_wlan->strInterfaceInfo[0].drvHandler);
-		host_int_set_MacAddress((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+		host_int_set_MacAddress((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 					g_linux_wlan->strInterfaceInfo[0].aSrcAddress);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_set_WEPDefaultKeyID((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
+			host_int_add_wep_key_bss_sta((WILC_WFIDrvHandle)(uintptr_t)(g_linux_wlan->strInterfaceInfo[0].drvHandler),
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
-- 
2.4.3

