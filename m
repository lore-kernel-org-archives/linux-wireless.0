Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33045 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384AbbIVNrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:47:55 -0400
Received: by pacex6 with SMTP id ex6so10023280pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 06:47:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/9] staging: wilc1000: rename SendConfigPkt
Date: Tue, 22 Sep 2015 22:47:38 +0900
Message-Id: <1442929665-19709-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_154759_460506_A8303767)
In-Reply-To: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442929665-19709-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces SendConfigPkt with send_config_pkt to aovid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h |   4 +-
 drivers/staging/wilc1000/host_interface.c   | 204 ++++++++++++++--------------
 3 files changed, 106 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 9676044..3813767 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -717,8 +717,8 @@ extern wilc_wlan_oup_t *gpstrWlanOps;
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
index a255e45..7227c0f 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -156,8 +156,8 @@ typedef struct wid_site_survey_reslts {
 } wid_site_survey_reslts_s;
 #endif
 
-s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-		  u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
+		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
 s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 86dbe46..c4ef274 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -645,8 +645,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
 		return -EINVAL;
@@ -681,8 +681,8 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
 
 	/*Sending Cfg*/
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 pstrHostIfSetDrvHandler->u32Address);
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   pstrHostIfSetDrvHandler->u32Address);
 
 	if (pstrWFIDrv == NULL)
 		up(&hSemDeinitDrvHandle);
@@ -723,8 +723,8 @@ static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler,
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
@@ -769,8 +769,8 @@ s32 Handle_set_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 
 	host_int_get_ipaddress(drvHandler, firmwareIPAddress, idx);
@@ -808,8 +808,8 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
 
@@ -865,8 +865,8 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
 		s32Error = -EFAULT;
@@ -900,8 +900,8 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler,
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, false,
-				 get_id_from_handler(drvHandler));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, false,
+				   get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
 		s32Error = -EFAULT;
@@ -1242,8 +1242,8 @@ static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler,
 		}
 		u8WidCnt++;
 	}
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u8WidCnt, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u8WidCnt, false,
+				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
 		PRINT_ER("Error in setting CFG params\n");
@@ -1398,8 +1398,8 @@ static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler,
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -1473,8 +1473,8 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-					 get_id_from_handler(pstrWFIDrv));
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+					   get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
 			PRINT_ER("Failed to set abort running scan\n");
 			s32Error = -EFAULT;
@@ -1668,8 +1668,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 		gu32WidConnRstHack = 0;
 		/* ////////////////////// */
 
-		s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
-					 get_id_from_handler(pstrWFIDrv));
+		s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+					   get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
 			PRINT_ER("failed to send config packet\n");
 			s32Error = -EINVAL;
@@ -1989,8 +1989,8 @@ static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
 		s32Error = -EFAULT;
@@ -2120,8 +2120,8 @@ static s32 Handle_FlushConnect(tstrWILC_WFIDrv *drvHandler)
 
 	#endif
 
-	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false,
-				 get_id_from_handler(gu8FlushedJoinReqDrvHandler));
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+				   get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
 		s32Error = -EINVAL;
@@ -2201,8 +2201,8 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -2751,8 +2751,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 4, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 4, true,
+						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 
@@ -2779,8 +2779,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
 
@@ -2792,8 +2792,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+						   get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
 			strWID.enuWIDtype	= WID_CHAR;
@@ -2802,8 +2802,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+						   get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
 		break;
@@ -2848,8 +2848,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 2, true,
+						   get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
 
@@ -2894,8 +2894,8 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+						   get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
 
@@ -2951,8 +2951,8 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = SendConfigPkt(SET_CFG, strWIDList, 2, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 2, true,
+						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -2992,8 +2992,8 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-						 get_id_from_handler(pstrWFIDrv));
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
 			/* ////////////////////////// */
@@ -3032,8 +3032,8 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-					 get_id_from_handler(pstrWFIDrv));
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+					   get_id_from_handler(pstrWFIDrv));
 
 		kfree(pu8keybuf);
 		break;
@@ -3082,8 +3082,8 @@ static void Handle_Disconnect(tstrWILC_WFIDrv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -3188,8 +3188,8 @@ static s32 Switch_Log_Terminal(tstrWILC_WFIDrv *drvHandler)
 	strWID.ps8WidVal = &dummy;
 	strWID.s32ValueSize = sizeof(char);
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 
 	if (s32Error) {
@@ -3228,8 +3228,8 @@ static s32 Handle_GetChnl(tstrWILC_WFIDrv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get channel number\n");
@@ -3268,8 +3268,8 @@ static void Handle_GetRssi(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
 		s32Error = -EFAULT;
@@ -3296,8 +3296,8 @@ static void Handle_GetLinkspeed(tstrWILC_WFIDrv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		s32Error = -EFAULT;
@@ -3343,8 +3343,8 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = SendConfigPkt(GET_CFG, strWIDList, u32WidsCount, false,
-				 get_id_from_handler(drvHandler));
+	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount, false,
+				   get_id_from_handler(drvHandler));
 
 	if (s32Error)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -3388,8 +3388,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -3403,8 +3403,8 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get incative time\n");
@@ -3480,8 +3480,8 @@ static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler,
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
@@ -3523,8 +3523,8 @@ static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler,
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
@@ -3615,8 +3615,8 @@ static void Handle_AddStation(tstrWILC_WFIDrv *drvHandler,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3669,8 +3669,8 @@ static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler,
 	}
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3713,8 +3713,8 @@ static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler,
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -3753,8 +3753,8 @@ static void Handle_EditStation(tstrWILC_WFIDrv *drvHandler,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send edit station config packet\n");
 
@@ -3829,8 +3829,8 @@ static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler,
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -3889,8 +3889,8 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler,
 
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
 		s32Error = -EINVAL;
@@ -3936,8 +3936,8 @@ static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler,
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-					 get_id_from_handler(pstrWFIDrv));
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+					   get_id_from_handler(pstrWFIDrv));
 		if (s32Error != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -4017,8 +4017,8 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send power management config packet\n");
 }
@@ -4063,8 +4063,8 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler,
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, false,
-				 get_id_from_handler(drvHandler));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+				   get_id_from_handler(drvHandler));
 	if (s32Error)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
@@ -4128,8 +4128,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
@@ -4153,8 +4153,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
@@ -4204,8 +4204,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler,
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -4223,8 +4223,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler,
 	/* TID*/
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
 		kfree(strWID.ps8WidVal);
@@ -4275,8 +4275,8 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler,
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -5268,8 +5268,8 @@ s32 host_int_get_site_survey_results(tstrWILC_WFIDrv *hWFIDrv,
 	astrWIDList[1].ps8WidVal = ppu8RcvdSiteSurveyResults[1];
 	astrWIDList[1].s32ValueSize = u32MaxSiteSrvyFragLen;
 
-	s32Error = SendConfigPkt(GET_CFG, astrWIDList, 2, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, astrWIDList, 2, true,
+				   get_id_from_handler(pstrWFIDrv));
 
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -5611,8 +5611,8 @@ s32 host_int_get_assoc_res_info(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8AssocRespInfo,
 
 
 	/* Sending Configuration packet */
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
@@ -5844,8 +5844,8 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set wid value\n");
 		return -EINVAL;
@@ -5928,8 +5928,8 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = SendConfigPkt(GET_CFG, &strWID, 1, true,
-				 get_id_from_handler(pstrWFIDrv));
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
 		PRINT_ER("Failed to get wid value\n");
-- 
2.5.1

