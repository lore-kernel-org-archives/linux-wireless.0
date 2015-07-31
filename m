Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44193 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbGaHjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:39:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/28] staging: wilc1000: remove unnecessary type cast
Date: Fri, 31 Jul 2015 16:38:13 +0900
Message-ID: <1438328316-30197-6-git-send-email-tony.cho@atmel.com> (sfid-20150731_093934_954484_147A7889)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

This patch removes unnecessary type cast since the u32 type of argument 5 in
SendConfigPkt was changed with WILC_WFIDrvHandle. Therefore, No need to cast u32.

Type cast (u32) cause build warning like below.
drivers/staging/wilc1000/host_interface.c:622:54: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
  s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 100 +++++++++++++++---------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 68762d2..265ff68 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -617,7 +617,7 @@ static s32 Handle_SetChannel(WILC_WFIDrvHandle drvHandler, tstrHostIFSetChan *ps
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -654,7 +654,7 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
@@ -699,7 +699,7 @@ static s32 Handle_SetOperationMode(WILC_WFIDrvHandle drvHandler, tstrHostIfSetOp
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL)
@@ -748,7 +748,7 @@ s32 Handle_set_IPAddress(WILC_WFIDrvHandle drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 
@@ -792,7 +792,7 @@ s32 Handle_get_IPAddress(WILC_WFIDrvHandle drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)WILC_MALLOC(IP_ALEN);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
@@ -853,7 +853,7 @@ static s32 Handle_SetMacAddress(WILC_WFIDrvHandle drvHandler, tstrHostIfSetMacAd
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -891,7 +891,7 @@ static s32 Handle_GetMacAddress(WILC_WFIDrvHandle drvHandler, tstrHostIfGetMacAd
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1199,7 +1199,7 @@ static s32 Handle_CfgParam(WILC_WFIDrvHandle drvHandler, tstrHostIFCfgParamAttr
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false, pstrWFIDrv);
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
@@ -1357,7 +1357,7 @@ static s32 Handle_Scan(WILC_WFIDrvHandle drvHandler, tstrHostIFscanAttr *pstrHos
 		gbScanWhileConnected = false;
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1434,7 +1434,7 @@ static s32 Handle_ScanDone(WILC_WFIDrvHandle drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set abort running scan\n");
 			WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -1631,7 +1631,7 @@ static s32 Handle_Connect(WILC_WFIDrvHandle drvHandler, tstrHostIFconnectAttr *p
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 		if (s32Error) {
 			PRINT_ER("Handle_Connect()] failed to send config packet\n");
 			WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -1954,7 +1954,7 @@ static s32 Handle_Connect(WILC_WFIDrvHandle drvHandler, tstrHostIFconnectAttr *p
 		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Handle_Connect()] failed to send config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -2168,7 +2168,7 @@ static s32 Handle_ConnectTimeout(WILC_WFIDrvHandle drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -2727,7 +2727,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 
@@ -2755,7 +2755,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2767,7 +2767,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2776,7 +2776,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2822,7 +2822,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2869,7 +2869,7 @@ static int Handle_Key(WILC_WFIDrvHandle drvHandler, tstrHostIFkeyAttr *pstrHostI
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 			WILC_FREE(pu8keybuf);
 
@@ -2926,7 +2926,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2967,7 +2967,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 			WILC_FREE(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3006,7 +3006,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 		WILC_FREE(pu8keybuf);
 		break;
@@ -3055,7 +3055,7 @@ static void Handle_Disconnect(WILC_WFIDrvHandle drvHandler)
 
 	WILC_memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3168,7 +3168,7 @@ static s32 Switch_Log_Terminal(WILC_WFIDrvHandle drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 
 	if (s32Error) {
@@ -3213,7 +3213,7 @@ static s32 Handle_GetChnl(WILC_WFIDrvHandle drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3257,7 +3257,7 @@ static void Handle_GetRssi(WILC_WFIDrvHandle drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3288,7 +3288,7 @@ static void Handle_GetLinkspeed(WILC_WFIDrvHandle drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3338,7 +3338,7 @@ s32 Handle_GetStatistics(WILC_WFIDrvHandle drvHandler, tstrStatistics *pstrStati
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false, drvHandler);
 
 	if (s32Error) {
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3386,7 +3386,7 @@ static s32 Handle_Get_InActiveTime(WILC_WFIDrvHandle drvHandler, tstrHostIfStaIn
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3400,7 +3400,7 @@ static s32 Handle_Get_InActiveTime(WILC_WFIDrvHandle drvHandler, tstrHostIfStaIn
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3481,7 +3481,7 @@ static void Handle_AddBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFSetBeacon *
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send add beacon config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -3526,7 +3526,7 @@ static void Handle_DelBeacon(WILC_WFIDrvHandle drvHandler, tstrHostIFDelBeacon *
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3622,7 +3622,7 @@ static void Handle_AddStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3679,7 +3679,7 @@ static void Handle_DelAllSta(WILC_WFIDrvHandle drvHandler, tstrHostIFDelAllSta *
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3726,7 +3726,7 @@ static void Handle_DelStation(WILC_WFIDrvHandle drvHandler, tstrHostIFDelSta *ps
 	WILC_memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3769,7 +3769,7 @@ static void Handle_EditStation(WILC_WFIDrvHandle drvHandler, tstrWILC_AddStaPara
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, pstrWFIDrv);
 	if (s32Error) {
 
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3845,7 +3845,7 @@ static int Handle_RemainOnChan(WILC_WFIDrvHandle drvHandler, tstrHostIfRemainOnC
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error != WILC_SUCCESS)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -3900,7 +3900,7 @@ static int Handle_RegisterFrame(WILC_WFIDrvHandle drvHandler, tstrHostIfRegister
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -3951,7 +3951,7 @@ static u32 Handle_ListenStateExpired(WILC_WFIDrvHandle drvHandler, tstrHostIfRem
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 		if (s32Error != WILC_SUCCESS) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4037,7 +4037,7 @@ static void Handle_PowerManagement(WILC_WFIDrvHandle drvHandler, tstrHostIfPower
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send power management config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -4088,7 +4088,7 @@ static void Handle_SetMulticastFilter(WILC_WFIDrvHandle drvHandler, tstrHostIFSe
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, (u32)drvHandler);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false, drvHandler);
 	if (s32Error) {
 		PRINT_ER("Failed to send setup multicast config packet\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -4156,7 +4156,7 @@ static s32 Handle_AddBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4180,7 +4180,7 @@ static s32 Handle_AddBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4230,7 +4230,7 @@ static s32 Handle_DelBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4248,7 +4248,7 @@ static s32 Handle_DelBASession(WILC_WFIDrvHandle drvHandler, tstrHostIfBASession
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 
 	if (strWID.ps8WidVal != NULL)
 		WILC_FREE(strWID.ps8WidVal);
@@ -4299,7 +4299,7 @@ static s32 Handle_DelAllRxBASessions(WILC_WFIDrvHandle drvHandler, tstrHostIfBAS
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5327,7 +5327,7 @@ s32 host_int_get_site_survey_results(WILC_WFIDrvHandle hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true, pstrWFIDrv);
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5693,7 +5693,7 @@ s32 host_int_get_assoc_res_info(WILC_WFIDrvHandle hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Failed to send association response config packet\n");
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5939,7 +5939,7 @@ s32 host_int_test_set_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, pstrWFIDrv);
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to set wid value\n");
 		WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
@@ -6031,7 +6031,7 @@ s32 host_int_test_get_int_wid(WILC_WFIDrvHandle hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
+	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true, pstrWFIDrv);
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Test Function: Failed to get wid value\n");
-- 
1.9.1

