Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30042 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964870AbbFJIG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 04:06:59 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>
Subject: [PATCH 1/4] staging: wilc1000: modify data type
Date: Wed, 10 Jun 2015 17:06:44 +0900
Message-ID: <1433923607-20927-2-git-send-email-johnny.kim@atmel.com> (sfid-20150610_100708_661414_D1CC11CB)
In-Reply-To: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This replace the argument of the function to the independent data type
in system.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h       |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 132 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h         |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             |  10 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   8 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 +-
 9 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e3e3f20..fa1c99a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1949,7 +1949,7 @@ WILC_Sint32 ConfigWaitResponse(WILC_Char *pcRespBuffer, WILC_Sint32 s32MaxRespBu
  */
 #ifdef SIMULATION
 WILC_Sint32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, WILC_Uint32 drvHandler)
+			  WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, size_t drvHandler)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	WILC_Sint32 err = WILC_SUCCESS;
@@ -2128,7 +2128,7 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
  *  @version	1.0
  */
 WILC_Sint32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, WILC_Uint32 drvHandler)
+			  WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, size_t drvHandler)
 {
 	WILC_Sint32 counter = 0, ret = 0;
 	if (gpstrWlanOps == NULL) {
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 73cdbef..03672d0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -476,7 +476,7 @@ extern WILC_Sint32 CoreConfiguratorInit(void);
 extern WILC_Sint32 CoreConfiguratorDeInit(void);
 
 extern WILC_Sint32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-				 WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, WILC_Uint32 drvHandler);
+				 WILC_Uint32 u32WIDsCount, WILC_Bool bRespRequired, size_t drvHandler);
 extern WILC_Sint32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 extern WILC_Sint32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index afe5126..cfe3364 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -584,7 +584,7 @@ u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 WILC_Uint32 gu32FlushedJoinReqSize;
 WILC_Uint32 gu32FlushedInfoElemAsocSize;
-WILC_Uint32 gu8FlushedJoinReqDrvHandler;
+size_t gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79     /* Position the byte indicating flushing in the flushed request */
@@ -622,7 +622,7 @@ static WILC_Sint32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHo
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -659,10 +659,10 @@ static WILC_Sint32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSe
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetDrvHandler->u32Address) == (WILC_Uint32)NULL) {
+	if ((pstrHostIfSetDrvHandler->u32Address) == (size_t)NULL) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -705,10 +705,10 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "(WILC_Uint32)pstrWFIDrv= %x \n", (WILC_Uint32)pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 
-	if ((pstrHostIfSetOperationMode->u32Mode) == (WILC_Uint32)NULL) {
+	if ((pstrHostIfSetOperationMode->u32Mode) == 0) {
 		up(&hSemDeinitDrvHandle);
 	}
 
@@ -755,7 +755,7 @@ WILC_Sint32 Handle_set_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 
 
@@ -799,7 +799,7 @@ WILC_Sint32 Handle_get_IPAddress(void *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 	PRINT_INFO(HOSTINF_DBG, "%d.%d.%d.%d\n", (u8)(strWID.ps8WidVal[0]), (u8)(strWID.ps8WidVal[1]), (u8)(strWID.ps8WidVal[2]), (u8)(strWID.ps8WidVal[3]));
 
@@ -859,7 +859,7 @@ static WILC_Sint32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddres
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -897,7 +897,7 @@ static WILC_Sint32 Handle_GetMacAddress(void *drvHandler, tstrHostIfGetMacAddres
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_FALSE, (size_t)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1205,7 +1205,7 @@ static WILC_Sint32 Handle_CfgParam(void *drvHandler, tstrHostIFCfgParamAttr *str
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, WILC_FALSE, (size_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Error in setting CFG params\n");
@@ -1372,7 +1372,7 @@ static WILC_Sint32 Handle_Scan(void *drvHandler, tstrHostIFscanAttr *pstrHostIFs
 		gbScanWhileConnected = WILC_FALSE;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (size_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1450,7 +1450,7 @@ static WILC_Sint32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(WILC_Char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1649,7 +1649,7 @@ static WILC_Sint32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrH
 		/* ////////////////////// */
 		#endif
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (size_t)pstrWFIDrv);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1978,7 +1978,7 @@ static WILC_Sint32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrH
 	/*BugID_5137*/
 	if (WILC_memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
-		gu8FlushedJoinReqDrvHandler = (WILC_Uint32)pstrWFIDrv;
+		gu8FlushedJoinReqDrvHandler = (size_t)pstrWFIDrv;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1990,7 +1990,7 @@ static WILC_Sint32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrH
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2206,7 +2206,7 @@ static WILC_Sint32 Handle_ConnectTimeout(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
 	}
@@ -2232,11 +2232,11 @@ static WILC_Sint32 Handle_ConnectTimeout(void *drvHandler)
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 	/*BugID_5213*/
 	/*Freeing flushed join request params on connect timeout*/
-	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+	if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 		WILC_FREE(gu8FlushedJoinReq);
 		gu8FlushedJoinReq = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 		WILC_FREE(gu8FlushedInfoElemAsoc);
 		gu8FlushedInfoElemAsoc = NULL;
 	}
@@ -2657,11 +2657,11 @@ static WILC_Sint32 Handle_RcvdGnrlAsyncInfo(void *drvHandler, tstrRcvdGnrlAsyncI
 			/*BugID_5213*/
 			/*Freeing flushed join request params on receiving*/
 			/*MAC_DISCONNECTED while connected*/
-			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+			if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 				WILC_FREE(gu8FlushedJoinReq);
 				gu8FlushedJoinReq = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 				WILC_FREE(gu8FlushedInfoElemAsoc);
 				gu8FlushedInfoElemAsoc = NULL;
 			}
@@ -2767,7 +2767,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[3].ps8WidVal = (WILC_Sint8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, WILC_TRUE, (size_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2795,7 +2795,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (WILC_Sint8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2807,7 +2807,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 		} else {
 			strWID.u16WIDid	= (WILC_Uint16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2816,7 +2816,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2862,7 +2862,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWIDList[1].ps8WidVal	= (WILC_Sint8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (size_t)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2909,7 +2909,7 @@ static int Handle_Key(void *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
 			strWID.ps8WidVal	= (WILC_Sint8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2966,7 +2966,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (WILC_Sint8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, WILC_TRUE, (size_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3007,7 +3007,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (WILC_Sint8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3046,7 +3046,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (WILC_Sint8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3095,7 +3095,7 @@ static void Handle_Disconnect(void *drvHandler)
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3159,11 +3159,11 @@ static void Handle_Disconnect(void *drvHandler)
 
 
 		/*BugID_5137*/
-		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+		if (gu8FlushedJoinReq != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 			WILC_FREE(gu8FlushedJoinReq);
 			gu8FlushedJoinReq = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (WILC_Uint32)drvHandler) {
+		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == (size_t)drvHandler) {
 			WILC_FREE(gu8FlushedInfoElemAsoc);
 			gu8FlushedInfoElemAsoc = NULL;
 		}
@@ -3208,7 +3208,7 @@ static WILC_Sint32 Switch_Log_Terminal(void *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(WILC_Char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 
 	if (s32Error) {
@@ -3252,7 +3252,7 @@ static WILC_Sint32 Handle_GetChnl(void *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3296,7 +3296,7 @@ static void Handle_GetRssi(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3327,7 +3327,7 @@ static void Handle_GetLinkspeed(void *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3377,7 +3377,7 @@ WILC_Sint32 Handle_GetStatistics(void *drvHandler, tstrStatistics *pstrStatistic
 	strWIDList[u32WidsCount].ps8WidVal = (WILC_Sint8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (WILC_Uint32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, WILC_FALSE, (size_t)drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3425,7 +3425,7 @@ static WILC_Sint32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInacti
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3439,7 +3439,7 @@ static WILC_Sint32 Handle_Get_InActiveTime(void *drvHandler, tstrHostIfStaInacti
 	strWID.s32ValueSize = sizeof(WILC_Uint32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3520,7 +3520,7 @@ static void Handle_AddBeacon(void *drvHandler, tstrHostIFSetBeacon *pstrSetBeaco
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3565,7 +3565,7 @@ static void Handle_DelBeacon(void *drvHandler, tstrHostIFDelBeacon *pstrDelBeaco
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3662,7 +3662,7 @@ static void Handle_AddStation(void *drvHandler, tstrWILC_AddStaParam *pstrStatio
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3718,7 +3718,7 @@ static void Handle_DelAllSta(void *drvHandler, tstrHostIFDelAllSta *pstrDelAllSt
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3766,7 +3766,7 @@ static void Handle_DelStation(void *drvHandler, tstrHostIFDelSta *pstrDelStaPara
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packe\n");
@@ -3810,7 +3810,7 @@ static void Handle_EditStation(void *drvHandler, tstrWILC_AddStaParam *pstrStati
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3887,7 +3887,7 @@ static int Handle_RemainOnChan(void *drvHandler, tstrHostIfRemainOnChan *pstrHos
 	strWID.ps8WidVal[1] = (WILC_Sint8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 		PRINT_ER("Failed to set remain on channel\n");
 	}
@@ -3945,7 +3945,7 @@ static int Handle_RegisterFrame(void *drvHandler, tstrHostIfRegisterFrame *pstrH
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3997,7 +3997,7 @@ static WILC_Uint32 Handle_ListenStateExpired(void *drvHandler, tstrHostIfRemainO
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4083,7 +4083,7 @@ static void Handle_PowerManagement(void *drvHandler, tstrHostIfPowerMgmtParam *s
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4135,7 +4135,7 @@ static void Handle_SetMulticastFilter(void *drvHandler, tstrHostIFSetMulti *strH
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (WILC_Uint32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_FALSE, (size_t)drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4203,7 +4203,7 @@ static WILC_Sint32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4227,7 +4227,7 @@ static WILC_Sint32 Handle_AddBASession(void *drvHandler, tstrHostIfBASessionInfo
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4277,7 +4277,7 @@ static WILC_Sint32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4295,7 +4295,7 @@ static WILC_Sint32 Handle_DelBASession(void *drvHandler, tstrHostIfBASessionInfo
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4346,7 +4346,7 @@ static WILC_Sint32 Handle_DelAllRxBASessions(void *drvHandler, tstrHostIfBASessi
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5443,7 +5443,7 @@ WILC_Sint32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, WILC_TRUE, (size_t)pstrWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5811,7 +5811,7 @@ WILC_Sint32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocR
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5928,7 +5928,7 @@ WILC_Sint32 host_int_wait_msg_queue_idle(void)
 
 }
 
-WILC_Sint32 host_int_set_wfi_drv_handler(WILC_Uint32 u32address)
+WILC_Sint32 host_int_set_wfi_drv_handler(size_t u32address)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 
@@ -6062,7 +6062,7 @@ WILC_Sint32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, WILC_Uint32 u32
 	strWID.s32ValueSize = sizeof(WILC_Uint32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6154,7 +6154,7 @@ WILC_Sint32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, WILC_Uint32 *pu
 	strWID.ps8WidVal = (WILC_Sint8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(WILC_Uint32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (WILC_Uint32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
@@ -6837,7 +6837,7 @@ WILC_Sint32 host_int_deinit(WILC_WFIDrvHandle hWFIDrv)
 	WILC_TimerDestroy(&(pstrWFIDrv->hRemainOnChannel), NULL);
 	#endif
 
-	host_int_set_wfi_drv_handler((WILC_Uint32)NULL);
+	host_int_set_wfi_drv_handler((size_t)NULL);
 	down(&hSemDeinitDrvHandle);
 
 
@@ -6918,7 +6918,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	WILC_Uint32 drvHandler;
+	size_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
@@ -6968,7 +6968,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	WILC_Uint32 drvHandler;
+	size_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
 	/*BugID_5348*/
@@ -7031,7 +7031,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrHostIFmsg strHostIFmsg;
-	WILC_Uint32 drvHandler;
+	size_t drvHandler;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
@@ -7241,7 +7241,7 @@ WILC_Sint32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, WILC_Uint32 u32Interv
 {
 	WILC_Sint32 s32Error = WILC_SUCCESS;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	tstrHostIFmsg strHostIFmsg;
+	tstrHostIFmsg strHostIFmsg = {0,};
 	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d03a575..fca93d5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -277,7 +277,7 @@ typedef void (*tWILCpfRemainOnChanReady)(void *); /*Remain on channel callback f
 
 /* typedef WILC_Uint32 WILC_WFIDrvHandle; */
 typedef struct {
-	WILC_Sint32 s32Dummy;
+	size_t s32Dummy;
 } *WILC_WFIDrvHandle;
 
 /*!
@@ -336,7 +336,7 @@ typedef struct {
 } tstrWILC_UsrConnReq;
 
 typedef struct {
-	WILC_Uint32 u32Address;
+	size_t u32Address;
 } tstrHostIfSetDrvHandler;
 
 typedef struct {
@@ -1323,7 +1323,7 @@ WILC_Sint32 host_int_frame_register(WILC_WFIDrvHandle hWFIDrv, WILC_Uint16 u16Fr
  *  @date
  *  @version	1.0
  */
-WILC_Sint32 host_int_set_wfi_drv_handler(WILC_Uint32 u32address);
+WILC_Sint32 host_int_set_wfi_drv_handler(size_t u32address);
 WILC_Sint32 host_int_set_operation_mode(WILC_WFIDrvHandle hWFIDrv, WILC_Uint32 u32mode);
 
 static WILC_Sint32 Handle_ScanDone(void *drvHandler, tenuScanEvent enuEvent);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 860f336..49d7d8c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1124,9 +1124,9 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 	}
 
-	*(int *)c_val = (WILC_Uint32)pstrWFIDrv;
+	*(size_t*)c_val = (size_t)pstrWFIDrv;
 
-	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, sizeof(size_t), 0, 0))
 		goto _fail_;
 
 	/*to tell fw that we are going to use PC test - WILC specific*/
@@ -1364,7 +1364,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 
 	c_val[0] = 1; /* Enable N with immediate block ack. */
-	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (WILC_Uint32)pstrWFIDrv))
+	if (!g_linux_wlan->oup.wlan_cfg_set(0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1, 1, (size_t)pstrWFIDrv))
 		goto _fail_;
 
 	return 0;
@@ -2100,7 +2100,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
-			g_linux_wlan->strInterfaceInfo[i].drvHandler = (WILC_Uint32)priv->hWILCWFIDrv;
+			g_linux_wlan->strInterfaceInfo[i].drvHandler = (size_t)priv->hWILCWFIDrv;
 			break;
 		}
 	}
@@ -2548,7 +2548,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
 			return;
 		}
 
-		skb_reserve(skb, (unsigned int)skb->data & 0x3);
+		skb_reserve(skb, (uintptr_t)skb->data & 0x3);
 
 		if (g_linux_wlan == NULL || wilc_netdev == NULL) {
 			PRINT_ER("wilc_netdev in g_linux_wlan is NULL");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0db7f3d..e6cc1e9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -747,7 +747,7 @@ static int WILC_WFI_CfgScan(struct wiphy *wiphy, struct cfg80211_scan_request *r
 
 	priv->u32RcvdChCount = 0;
 
-	host_int_set_wfi_drv_handler((WILC_Uint32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler((size_t)priv->hWILCWFIDrv);
 
 
 	reset_shadow_found(priv);
@@ -842,7 +842,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)(priv->hWILCWFIDrv);
 
-	host_int_set_wfi_drv_handler((WILC_Uint32)priv->hWILCWFIDrv);
+	host_int_set_wfi_drv_handler((size_t)priv->hWILCWFIDrv);
 
 	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%x]\n", sme->ssid, dev, (WILC_Uint32)priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b322f0f..39ec0ac 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -185,7 +185,7 @@ typedef struct {
 typedef struct {
 	uint8_t aSrcAddress[ETH_ALEN];
 	uint8_t aBSSID[ETH_ALEN];
-	uint32_t drvHandler;
+	size_t drvHandler;
 	struct net_device *wilc_netdev;
 } tstrInterfaceInfo;
 typedef struct {
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9edc851..739be55 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1863,13 +1863,13 @@ static void wilc_wlan_cleanup(void)
 
 }
 
-static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
+static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
-	int driver_handler = (WILC_Uint32)drvHandler;
+	size_t driver_handler = (size_t)drvHandler;
 
 
 	/**
@@ -1900,7 +1900,7 @@ static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
 	return 0;
 }
 
-static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t buffer_size, int commit, size_t drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
@@ -1939,7 +1939,7 @@ static int wilc_wlan_cfg_set(int start, uint32_t wid, uint8_t *buffer, uint32_t
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, uint32_t wid, int commit, uint32_t drvHandler)
+static int wilc_wlan_cfg_get(int start, WILC_Uint16 wid, int commit, size_t drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	uint32_t offset;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index dd86ca7..399d931 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -215,8 +215,8 @@ typedef struct {
 	void (*wlan_handle_rx_que)(void);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
-	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
-	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
+	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, size_t);
+	int (*wlan_cfg_get)(int, WILC_Uint16, int, size_t);
 	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
 	/*Bug3959: transmitting mgmt frames received from host*/
 	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
-- 
1.9.1

