Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36595 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbbIUAZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 20:25:45 -0400
Received: by padhk3 with SMTP id hk3so99884656pad.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2015 17:25:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: rename SendConfigPkt
Date: Mon, 21 Sep 2015 09:25:32 +0900
Message-Id: <1442795132-19660-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_022609_960118_CC973F6B)
In-Reply-To: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442795132-19660-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces SendConfigPkt with send_config_pkt to avoid
CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h |   4 +-
 drivers/staging/wilc1000/host_interface.c   | 102 ++++++++++++++--------------
 3 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ad3b546..04e72b9 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -756,8 +756,8 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-			  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
+s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
+		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 8439066..a7904e2 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -159,8 +159,8 @@ typedef struct wid_site_survey_reslts {
 s32 CoreConfiguratorInit(void);
 s32 CoreConfiguratorDeInit(void);
 
-s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-		  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
+		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
 s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f997628..4ebc5eb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -651,7 +651,7 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to set channel\n");
@@ -686,7 +686,7 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 	/*Sending Cfg*/
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 pstrHostIfSetDrvHandler->u32Address);
 
 	if (pstrWFIDrv == NULL)
@@ -727,7 +727,7 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOpe
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
@@ -773,7 +773,7 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
@@ -812,7 +812,7 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
@@ -868,7 +868,7 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -902,7 +902,7 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(GET_CFG, &strWID, 1, false,
+	result = send_config_pkt(GET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
 	if (result) {
 		PRINT_ER("Failed to get mac address\n");
@@ -1243,7 +1243,7 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *
 		}
 		u8WidCnt++;
 	}
-	result = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
+	result = send_config_pkt(SET_CFG, strWIDList, u8WidCnt, false,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (result)
@@ -1398,7 +1398,7 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHost
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (result)
@@ -1473,7 +1473,7 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = send_config_pkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
 		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
@@ -1667,7 +1667,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+		result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
 					 get_id_from_handler(pstrWFIDrv));
 		if (result) {
 			PRINT_ER("failed to send config packet\n");
@@ -1988,7 +1988,7 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *ps
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -2119,7 +2119,7 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	#endif
 
-	result = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
+	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -2200,7 +2200,7 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2747,7 +2747,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			result = SendConfigPkt(SET_CFG, strWIDList, 4, true,
+			result = send_config_pkt(SET_CFG, strWIDList, 4, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2775,7 +2775,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = send_config_pkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
@@ -2788,7 +2788,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = send_config_pkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
@@ -2798,7 +2798,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = send_config_pkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2844,7 +2844,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			result = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+			result = send_config_pkt(SET_CFG, strWIDList, 2, true,
 						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2890,7 +2890,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = send_config_pkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2947,7 +2947,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			result = SendConfigPkt(SET_CFG, strWIDList, 2, true,
+			result = send_config_pkt(SET_CFG, strWIDList, 2, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2988,7 +2988,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+			result = send_config_pkt(SET_CFG, &strWID, 1, true,
 						 get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -3028,7 +3028,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = send_config_pkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
 
 		kfree(pu8keybuf);
@@ -3078,7 +3078,7 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (result) {
@@ -3184,7 +3184,7 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 
@@ -3224,7 +3224,7 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (result) {
@@ -3264,7 +3264,7 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -3292,7 +3292,7 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -3339,7 +3339,7 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	result = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
+	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount, false,
 				 get_id_from_handler(drvHandler));
 
 	if (result)
@@ -3383,7 +3383,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (result) {
@@ -3398,7 +3398,7 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (result) {
@@ -3474,7 +3474,7 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *p
 
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -3516,7 +3516,7 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *p
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3606,7 +3606,7 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3659,7 +3659,7 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *p
 	}
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3702,7 +3702,7 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pst
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3741,7 +3741,7 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler, tstrWILC_AddStaParam
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3816,7 +3816,7 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnCh
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -3875,7 +3875,7 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
 
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -3921,7 +3921,7 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRema
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+		result = send_config_pkt(SET_CFG, &strWID, 1, true,
 					 get_id_from_handler(pstrWFIDrv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -4001,7 +4001,7 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerM
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -4046,7 +4046,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, false,
+	result = send_config_pkt(SET_CFG, &strWID, 1, false,
 				 get_id_from_handler(drvHandler));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -4110,7 +4110,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
@@ -4135,7 +4135,7 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
@@ -4185,7 +4185,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -4204,7 +4204,7 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
@@ -4255,7 +4255,7 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -5248,7 +5248,7 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	result = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
+	result = send_config_pkt(GET_CFG, astrWIDList, 2, true,
 				 get_id_from_handler(pstrWFIDrv));
 
 	/*get the value by searching the local copy*/
@@ -5591,7 +5591,7 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5824,7 +5824,7 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	result = SendConfigPkt(SET_CFG, &strWID, 1, true,
+	result = send_config_pkt(SET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	if (result) {
 		PRINT_ER("Failed to set wid value\n");
@@ -5908,7 +5908,7 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	result = SendConfigPkt(GET_CFG, &strWID, 1, true,
+	result = send_config_pkt(GET_CFG, &strWID, 1, true,
 				 get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (result) {
-- 
2.5.1

