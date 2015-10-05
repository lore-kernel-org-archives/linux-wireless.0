Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37106 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbJEK3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:29:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/6] staging: wilc1000: remove bool bRespRequired from send_config_pkt
Date: Mon, 5 Oct 2015 19:28:13 +0900
Message-ID: <1444040894-18709-5-git-send-email-tony.cho@atmel.com> (sfid-20151005_122903_797480_9F4E9BD9)
In-Reply-To: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
References: <1444040894-18709-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes 4th parameter, bool bRespRequired from the
send_config_pkt function because it is not used inside the funcntion.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  2 +-
 drivers/staging/wilc1000/coreconfigurator.h |  2 +-
 drivers/staging/wilc1000/host_interface.c   | 92 ++++++++++++++---------------
 3 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 65a130d..4bc17b2 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -596,7 +596,7 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @version	1.0
  */
 s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
-		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler)
+		    u32 u32WIDsCount, u32 drvHandler)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 58aa13c..4d65088 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -129,7 +129,7 @@ typedef struct {
 } tstrDisconnectNotifInfo;
 
 s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
-		    u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+		    u32 u32WIDsCount, u32 drvHandler);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b12801b..982bb4c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -582,7 +582,7 @@ static s32 Handle_SetChannel(struct host_if_drv *drvHandler,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set channel\n");
@@ -618,7 +618,7 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *drvHandler,
 
 	/*Sending Cfg*/
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   pstrHostIfSetDrvHandler->u32Address);
 
 	if (pstrWFIDrv == NULL)
@@ -660,7 +660,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *drvHandler,
 	/*Sending Cfg*/
 	PRINT_INFO(HOSTINF_DBG, "pstrWFIDrv= %p\n", pstrWFIDrv);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
 
@@ -706,7 +706,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = (u8 *)pu8IPAddr;
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
 
@@ -745,7 +745,7 @@ s32 Handle_get_IPAddress(struct host_if_drv *drvHandler, u8 *pu8IPAddr, u8 idx)
 	strWID.ps8WidVal = kmalloc(IP_ALEN, GFP_KERNEL);
 	strWID.s32ValueSize = IP_ALEN;
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.ps8WidVal);
@@ -802,7 +802,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *drvHandler,
 	strWID.s32ValueSize = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set mac address\n");
@@ -837,7 +837,7 @@ static s32 Handle_GetMacAddress(struct host_if_drv *drvHandler,
 	strWID.s32ValueSize = ETH_ALEN;
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(drvHandler));
 	if (s32Error) {
 		PRINT_ER("Failed to get mac address\n");
@@ -1179,7 +1179,7 @@ static s32 Handle_CfgParam(struct host_if_drv *drvHandler,
 		}
 		u8WidCnt++;
 	}
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u8WidCnt, false,
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
 				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
@@ -1331,7 +1331,7 @@ static s32 Handle_Scan(struct host_if_drv *drvHandler,
 	else if (pstrWFIDrv->enuHostIFstate == HOST_IF_IDLE)
 		gbScanWhileConnected = false;
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error)
@@ -1406,7 +1406,7 @@ static s32 Handle_ScanDone(struct host_if_drv *drvHandler, tenuScanEvent enuEven
 		strWID.s32ValueSize = sizeof(char);
 
 		/*Sending Cfg*/
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(pstrWFIDrv));
 		if (s32Error) {
 			PRINT_ER("Failed to set abort running scan\n");
@@ -1717,7 +1717,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
@@ -1843,7 +1843,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *drvHandler)
 
 	u32WidsCount++;
 
-	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount, false,
+	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(gu8FlushedJoinReqDrvHandler));
 	if (s32Error) {
 		PRINT_ER("failed to send config packet\n");
@@ -1924,7 +1924,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2461,7 +2461,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[3].ps8WidVal = (s8 *)pu8keybuf;
 
 
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 4, true,
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 4,
 						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2489,7 +2489,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
@@ -2502,7 +2502,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.ps8WidVal = s8idxarray;
 			strWID.s32ValueSize = 1;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 		} else {
 			strWID.u16WIDid	= (u16)WID_KEY_ID;
@@ -2512,7 +2512,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 		}
 		up(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -2558,7 +2558,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 2, true,
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2604,7 +2604,7 @@ static int Handle_Key(struct host_if_drv *drvHandler,
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = RX_MIC_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 
 			kfree(pu8keybuf);
@@ -2661,7 +2661,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].ps8WidVal	= (s8 *)pu8keybuf;
 			strWIDList[1].s32ValueSize = PTK_KEY_MSG_LEN + 1;
 
-			s32Error = send_config_pkt(SET_CFG, strWIDList, 2, true,
+			s32Error = send_config_pkt(SET_CFG, strWIDList, 2,
 						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2702,7 +2702,7 @@ _WPARxGtk_end_case_:
 			strWID.ps8WidVal	= (s8 *)pu8keybuf;
 			strWID.s32ValueSize = PTK_KEY_MSG_LEN;
 
-			s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(pstrWFIDrv));
 			kfree(pu8keybuf);
 
@@ -2742,7 +2742,7 @@ _WPAPtk_end_case_:
 		strWID.ps8WidVal = (s8 *)pu8keybuf;
 		strWID.s32ValueSize = (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFpmkidAttr.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(pstrWFIDrv));
 
 		kfree(pu8keybuf);
@@ -2789,7 +2789,7 @@ static void Handle_Disconnect(struct host_if_drv *drvHandler)
 
 	memset(u8ConnectedSSID, 0, ETH_ALEN);
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
 	if (s32Error) {
@@ -2906,7 +2906,7 @@ static s32 Handle_GetChnl(struct host_if_drv *drvHandler)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -2946,7 +2946,7 @@ static void Handle_GetRssi(struct host_if_drv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2974,7 +2974,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *drvHandler)
 	/*Sending Cfg*/
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -3021,7 +3021,7 @@ s32 Handle_GetStatistics(struct host_if_drv *drvHandler, tstrStatistics *pstrSta
 	strWIDList[u32WidsCount].ps8WidVal = (s8 *)(&(pstrStatistics->u32TxFailureCount));
 	u32WidsCount++;
 
-	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount, false,
+	s32Error = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(drvHandler));
 
 	if (s32Error)
@@ -3066,7 +3066,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -3081,7 +3081,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *drvHandler,
 	strWID.s32ValueSize = sizeof(u32);
 
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
@@ -3158,7 +3158,7 @@ static void Handle_AddBeacon(struct host_if_drv *drvHandler,
 
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -3200,7 +3200,7 @@ static void Handle_DelBeacon(struct host_if_drv *drvHandler)
 	/* TODO: build del beacon message*/
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -3292,7 +3292,7 @@ static void Handle_AddStation(struct host_if_drv *drvHandler,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3346,7 +3346,7 @@ static void Handle_DelAllSta(struct host_if_drv *drvHandler,
 	}
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3390,7 +3390,7 @@ static void Handle_DelStation(struct host_if_drv *drvHandler,
 	memcpy(pu8CurrByte, pstrDelStaParam->au8MacAddr, ETH_ALEN);
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -3430,7 +3430,7 @@ static void Handle_EditStation(struct host_if_drv *drvHandler,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -3504,7 +3504,7 @@ static int Handle_RemainOnChan(struct host_if_drv *drvHandler,
 	strWID.ps8WidVal[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -3564,7 +3564,7 @@ static int Handle_RegisterFrame(struct host_if_drv *drvHandler,
 
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -3611,7 +3611,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *drvHandler,
 		strWID.ps8WidVal[1] = FALSE_FRMWR_CHANNEL;
 
 		/*Sending Cfg*/
-		s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(pstrWFIDrv));
 		if (s32Error != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -3692,7 +3692,7 @@ static void Handle_PowerManagement(struct host_if_drv *drvHandler,
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -3738,7 +3738,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *drvHandler,
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->u32count) * ETH_ALEN));
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, false,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(drvHandler));
 	if (s32Error)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -3803,7 +3803,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	/* Group Buffer Timeout */
 	*ptr++ = 0;
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
@@ -3828,7 +3828,7 @@ static s32 Handle_AddBASession(struct host_if_drv *drvHandler,
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	/*Ack-Policy */
 	*ptr++ = 3;
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 
 	if (strWID.ps8WidVal != NULL)
@@ -3877,7 +3877,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *drvHandler,
 	/* Delba Reason */
 	*ptr++ = 32; /* Unspecific QOS reason */
 
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -5133,7 +5133,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv, u8 *pu8AssocRespInf
 
 
 	/* Sending Configuration packet */
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -5362,7 +5362,7 @@ s32 host_int_test_set_int_wid(struct host_if_drv *hWFIDrv, u32 u32TestMemAddr)
 	strWID.s32ValueSize = sizeof(u32);
 
 	/*Sending Cfg*/
-	s32Error = send_config_pkt(SET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	if (s32Error) {
 		PRINT_ER("Failed to set wid value\n");
@@ -5446,7 +5446,7 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hWFIDrv, u32 *pu32TestMemAddr)
 	strWID.ps8WidVal = (s8 *)pu32TestMemAddr;
 	strWID.s32ValueSize = sizeof(u32);
 
-	s32Error = send_config_pkt(GET_CFG, &strWID, 1, true,
+	s32Error = send_config_pkt(GET_CFG, &strWID, 1,
 				   get_id_from_handler(pstrWFIDrv));
 	/*get the value by searching the local copy*/
 	if (s32Error) {
-- 
1.9.1

