Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21033 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbbIUDRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:17:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 03/34] staging: wilc1000: rename strHostIFmsg
Date: Mon, 21 Sep 2015 12:16:32 +0900
Message-ID: <1442805423-3711-4-git-send-email-tony.cho@atmel.com> (sfid-20150921_051744_652636_3C04FC27)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the name, strHostIFmsg simply to msg because the
camelcase notation is not recommended in Linux.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 794 +++++++++++++++---------------
 1 file changed, 397 insertions(+), 397 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fdb0b9b..79e3674 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3966,19 +3966,19 @@ _done_:
 static void ListenTimerCB(unsigned long arg)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)arg;
 	/*Stopping remain-on-channel timer*/
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.drvHandler = pstrWFIDrv;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 }
@@ -4293,15 +4293,15 @@ static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASe
 static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
-		wilc_mq_recv(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg), &u32Ret);
-		pstrWFIDrv = (tstrWILC_WFIDrv *)strHostIFmsg.drvHandler;
-		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_EXIT) {
+		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
+		pstrWFIDrv = (tstrWILC_WFIDrv *)msg.drvHandler;
+		if (msg.u16MsgId == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
 		}
@@ -4311,57 +4311,57 @@ static int hostIFthread(void *pvArg)
 		if ((!g_wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
-			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 			continue;
 		}
 
-		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+		if (msg.u16MsgId == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
-			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
 		}
 
-		switch (strHostIFmsg.u16MsgId) {
+		switch (msg.u16MsgId) {
 		case HOST_IF_MSG_Q_IDLE:
 			Handle_wait_msg_q_empty();
 			break;
 
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr);
+			Handle_Scan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFscanAttr);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr);
+			Handle_Connect(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFconnectAttr);
 			break;
 
 		case HOST_IF_MSG_FLUSH_CONNECT:
-			Handle_FlushConnect(strHostIFmsg.drvHandler);
+			Handle_FlushConnect(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo);
+			Handle_RcvdNtwrkInfo(msg.drvHandler, &msg.uniHostIFmsgBody.strRcvdNetworkInfo);
 			break;
 
 		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo);
+			Handle_RcvdGnrlAsyncInfo(msg.drvHandler, &msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo);
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr);
+			Handle_Key(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFkeyAttr);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
 
-			Handle_CfgParam(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr);
+			Handle_CfgParam(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFCfgParamAttr);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			Handle_SetChannel(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan);
+			Handle_SetChannel(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFSetChan);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(strHostIFmsg.drvHandler);
+			Handle_Disconnect(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
@@ -4372,124 +4372,124 @@ static int hostIFthread(void *pvArg)
 			if (!linux_wlan_get_num_conn_ifcs())
 				chip_sleep_manually(INFINITE_SLEEP_TIME);
 
-			Handle_ScanDone(strHostIFmsg.drvHandler, SCAN_EVENT_DONE);
+			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_DONE);
 
 			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
-				Handle_RemainOnChan(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
+				Handle_RemainOnChan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
 
 			break;
 
 		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(strHostIFmsg.drvHandler);
+			Handle_GetRssi(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_GET_LINKSPEED:
-			Handle_GetLinkspeed(strHostIFmsg.drvHandler);
+			Handle_GetLinkspeed(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(strHostIFmsg.drvHandler, (tstrStatistics *)strHostIFmsg.uniHostIFmsgBody.pUserData);
+			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.uniHostIFmsgBody.pUserData);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
-			Handle_GetChnl(strHostIFmsg.drvHandler);
+			Handle_GetChnl(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon);
+			Handle_AddBeacon(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFSetBeacon);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFDelBeacon);
+			Handle_DelBeacon(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFDelBeacon);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strAddStaParam);
+			Handle_AddStation(msg.drvHandler, &msg.uniHostIFmsgBody.strAddStaParam);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strDelStaParam);
+			Handle_DelStation(msg.drvHandler, &msg.uniHostIFmsgBody.strDelStaParam);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strEditStaParam);
+			Handle_EditStation(msg.drvHandler, &msg.uniHostIFmsgBody.strEditStaParam);
 			break;
 
 		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT);
+			Handle_Get_InActiveTime(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfStaInactiveT);
 			break;
 
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Scan Timeout\n");
 
-			Handle_ScanDone(strHostIFmsg.drvHandler, SCAN_EVENT_ABORTED);
+			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_ABORTED);
 			break;
 
 		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Connect Timeout\n");
-			Handle_ConnectTimeout(strHostIFmsg.drvHandler);
+			Handle_ConnectTimeout(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam);
+			Handle_PowerManagement(msg.drvHandler, &msg.uniHostIFmsgBody.strPowerMgmtparam);
 			break;
 
 		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			Handle_SetWfiDrvHandler(strHostIFmsg.drvHandler,
-						&strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler);
+			Handle_SetWfiDrvHandler(msg.drvHandler,
+						&msg.uniHostIFmsgBody.strHostIfSetDrvHandler);
 			break;
 
 		case HOST_IF_MSG_SET_OPERATION_MODE:
-			Handle_SetOperationMode(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode);
+			Handle_SetOperationMode(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetOperationMode);
 			break;
 
 		case HOST_IF_MSG_SET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_set_IPAddress(strHostIFmsg.drvHandler, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx);
+			Handle_set_IPAddress(msg.drvHandler, msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, msg.uniHostIFmsgBody.strHostIfSetIP.idx);
 			break;
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(strHostIFmsg.drvHandler, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx);
+			Handle_get_IPAddress(msg.drvHandler, msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr, msg.uniHostIFmsgBody.strHostIfSetIP.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			Handle_SetMacAddress(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress);
+			Handle_SetMacAddress(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetMacAddress);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			Handle_GetMacAddress(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress);
+			Handle_GetMacAddress(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfGetMacAddress);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
-			Handle_RemainOnChan(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
+			Handle_RemainOnChan(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame);
+			Handle_RegisterFrame(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRegisterFrame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan);
+			Handle_ListenStateExpired(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfRemainOnChan);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_MULTICAST_FILTER\n");
-			Handle_SetMulticastFilter(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti);
+			Handle_SetMulticastFilter(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfSetMulti);
 			break;
 
 		case HOST_IF_MSG_ADD_BA_SESSION:
-			Handle_AddBASession(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo);
+			Handle_AddBASession(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfBASessionInfo);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
-			Handle_DelAllRxBASessions(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo);
+			Handle_DelAllRxBASessions(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIfBASessionInfo);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta);
+			Handle_DelAllSta(msg.drvHandler, &msg.uniHostIFmsgBody.strHostIFDelAllSta);
 			break;
 
 		default:
@@ -4506,29 +4506,29 @@ static int hostIFthread(void *pvArg)
 static void TimerCB_Scan(unsigned long arg)
 {
 	void *pvArg = (void *)arg;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.drvHandler = pvArg;
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.drvHandler = pvArg;
+	msg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
-	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 }
 
 static void TimerCB_Connect(unsigned long arg)
 {
 	void *pvArg = (void *)arg;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	/* prepare the Timer Callback message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.drvHandler = pvArg;
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.drvHandler = pvArg;
+	msg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
-	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 }
 
 
@@ -4578,7 +4578,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4588,21 +4588,21 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	}
 
 	/* prepare the Remove Wep Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
+	msg.drvHandler = hWFIDrv;
 
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4626,7 +4626,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -4636,20 +4636,20 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
+	msg.drvHandler = hWFIDrv;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4681,7 +4681,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		s32Error = -EFAULT;
@@ -4690,30 +4690,30 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.drvHandler = hWFIDrv;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4743,7 +4743,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	u8 i;
 
 	if (pstrWFIDrv == NULL) {
@@ -4753,39 +4753,39 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (INFO) {
 		for (i = 0; i < u8WepKeylen; i++)
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
 	}
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+	msg.drvHandler = hWFIDrv;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, (u8WepKeylen));
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8mode = u8mode;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -4816,7 +4816,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	u8 u8KeyLen = u8PtkKeylen;
 	u32 i;
 
@@ -4831,30 +4831,30 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		u8KeyLen += TX_MIC_KEY_LEN;
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPAPtk;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPAPtk;
 	if (mode == AP_MODE) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 
 
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -4863,7 +4863,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -4871,17 +4871,17 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		}
 	}
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
@@ -4912,7 +4912,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	u8 u8KeyLen = u8GtkKeylen;
 
 	if (pstrWFIDrv == NULL) {
@@ -4921,7 +4921,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 		return s32Error;
 	}
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
 	if (pu8RxMic != NULL)
@@ -4929,57 +4929,57 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
 	}
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPARxGtk;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPARxGtk;
+	msg.drvHandler = hWFIDrv;
 
 	if (mode == AP_MODE) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
-		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 
 	}
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8KeyIdx;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8seqlen = u32KeyRSClen;
 
 
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
@@ -5013,7 +5013,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	u32 i;
 
 
@@ -5024,24 +5024,24 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* prepare the Key Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
+	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.drvHandler = hWFIDrv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
 
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(msg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
@@ -5128,17 +5128,17 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8PassPh
 s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	/* prepare the Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_MAC_ADDRESS;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_MAC_ADDRESS;
+	msg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
+	msg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
 		return -EFAULT;
@@ -5162,17 +5162,17 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	PRINT_D(GENERIC_DBG, "mac addr = %x:%x:%x\n", pu8MacAddress[0], pu8MacAddress[1], pu8MacAddress[2]);
 
 	/* prepare setting mac address message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
-	strHostIFmsg.drvHandler = hWFIDrv;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
+	memcpy(msg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 
@@ -5352,7 +5352,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || pfConnectResult == NULL) {
@@ -5372,36 +5372,36 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	}
 
 	/* prepare the Connect Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT;
+	msg.u16MsgId = HOST_IF_MSG_CONNECT;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.u8security = u8security;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.u8channel = u8channel;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pfConnectResult = pfConnectResult;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pvUserArg = pvUserArg;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pJoinParams = pJoinParams;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.u8security = u8security;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.u8channel = u8channel;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.pfConnectResult = pfConnectResult;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.pvUserArg = pvUserArg;
+	msg.uniHostIFmsgBody.strHostIFconnectAttr.pJoinParams = pJoinParams;
+	msg.drvHandler = hWFIDrv;
 
 	if (pu8bssid != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
+		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
+		msg.uniHostIFmsgBody.strHostIFconnectAttr.ssidLen = ssidLen;
+		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8ssid,
 
 			    pu8ssid, ssidLen);
 	}
 
 	if (pu8IEs != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
+		msg.uniHostIFmsgBody.strHostIFconnectAttr.IEsLen = IEsLen;
+		msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.uniHostIFmsgBody.strHostIFconnectAttr.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
 	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
@@ -5410,7 +5410,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
@@ -5439,7 +5439,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (!gu8FlushedJoinReq)	{
 		s32Error = -EFAULT;
@@ -5453,11 +5453,11 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 		return s32Error;
 	}
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
@@ -5480,7 +5480,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 	if (pstrWFIDrv == NULL) {
@@ -5489,13 +5489,13 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	}
 
 	/* prepare the Disconnect Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DISCONNECT;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_DISCONNECT;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 	/* ////////////// */
@@ -5665,7 +5665,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5673,12 +5673,12 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	}
 
 	/* prepare the set channel message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_CHANNEL;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_SET_CHANNEL;
+	msg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5692,13 +5692,13 @@ s32 host_int_wait_msg_queue_idle(void)
 {
 	s32 s32Error = 0;
 
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_Q_IDLE;
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5715,17 +5715,17 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
 	s32 s32Error = 0;
 
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
-	strHostIFmsg.drvHandler = u32address;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
+	msg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
+	msg.drvHandler = u32address;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5740,17 +5740,17 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
 	s32 s32Error = 0;
 
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	/* prepare the set driver handler message */
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_OPERATION_MODE;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_SET_OPERATION_MODE;
+	msg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
 		s32Error = -EINVAL;
@@ -5778,7 +5778,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -5786,13 +5786,13 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	}
 
 	/* prepare the Get Channel Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_CHNL;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_CHNL;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 	down(&(pstrWFIDrv->hSemGetCHNL));
@@ -5863,24 +5863,24 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
+	memcpy(msg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
 		    mac, ETH_ALEN);
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_INACTIVETIME;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_INACTIVETIME;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
@@ -5950,18 +5950,18 @@ s32 host_int_test_get_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 *pu32TestMemAddr)
 s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
 
 	/* prepare the Get RSSI Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_RSSI;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -5984,7 +5984,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 
 s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 {
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
@@ -5992,13 +5992,13 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 
 
 	/* prepare the Get LINKSPEED Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_LINKSPEED;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_LINKSPEED;
+	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return -EFAULT;
@@ -6022,17 +6022,17 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatistics)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	/* prepare the Get RSSI Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
-	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
+	msg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
+	msg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -6067,7 +6067,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	tenuScanConnTimer enuScanConnTimer;
 
 	if (pstrWFIDrv == NULL || ScanResult == NULL) {
@@ -6076,35 +6076,35 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	}
 
 	/* prepare the Scan Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN;
+	msg.u16MsgId = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork != NULL) {
-		strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
-		strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
+		msg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
+		msg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
-	strHostIFmsg.drvHandler = hWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanSource = u8ScanSource;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanType = u8ScanType;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pfScanResult = ScanResult;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pvUserArg = pvUserArg;
+	msg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanSource = u8ScanSource;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ScanType = u8ScanType;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.pfScanResult = ScanResult;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.pvUserArg = pvUserArg;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
+	msg.uniHostIFmsgBody.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.uniHostIFmsgBody.strHostIFscanAttr.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
+	msg.uniHostIFmsgBody.strHostIFscanAttr.IEsLen = IEsLen;
+	msg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.uniHostIFmsgBody.strHostIFscanAttr.pu8IEs,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
@@ -6136,7 +6136,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -6144,12 +6144,12 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 		return -EFAULT;
 	}
 	/* prepare the WiphyParams Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
-	strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
+	msg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 	return s32Error;
 
@@ -6312,16 +6312,16 @@ static void GetPeriodicRSSI(unsigned long arg)
 
 	if (pstrWFIDrv->enuHostIFstate == HOST_IF_CONNECTED) {
 		s32 s32Error = 0;
-		struct host_if_msg strHostIFmsg;
+		struct host_if_msg msg;
 
 		/* prepare the Get RSSI Message */
-		memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+		memset(&msg, 0, sizeof(struct host_if_msg));
 
-		strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_RSSI;
-		strHostIFmsg.drvHandler = pstrWFIDrv;
+		msg.u16MsgId = HOST_IF_MSG_GET_RSSI;
+		msg.drvHandler = pstrWFIDrv;
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 		if (s32Error) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
@@ -6507,7 +6507,7 @@ _fail_:
 s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	int ret;
 
 	/*obtain driver handle*/
@@ -6568,18 +6568,18 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 
 	gbScanWhileConnected = false;
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
 		if (del_timer_sync(&g_hPeriodicRSSI)) {
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
-		strHostIFmsg.u16MsgId = HOST_IF_MSG_EXIT;
-		strHostIFmsg.drvHandler = hWFIDrv;
+		msg.u16MsgId = HOST_IF_MSG_EXIT;
+		msg.drvHandler = hWFIDrv;
 
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
@@ -6625,7 +6625,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6641,18 +6641,18 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the Asynchronous Network Info message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
+	msg.drvHandler = pstrWFIDrv;
 
-	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
+	msg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
+	msg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.uniHostIFmsgBody.strRcvdNetworkInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
@@ -6671,7 +6671,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6696,20 +6696,20 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	}
 
 	/* prepare the General Asynchronous Info message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
-	strHostIFmsg.drvHandler = pstrWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
+	msg.drvHandler = pstrWFIDrv;
 
 
-	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
-	strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
-	memcpy(strHostIFmsg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
+	msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.u32Length = u32Length;
+	msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer = kmalloc(u32Length, GFP_KERNEL); /* will be deallocated by the receiving thread */
+	memcpy(msg.uniHostIFmsgBody.strRcvdGnrlAsyncInfo.pu8Buffer,
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
@@ -6728,7 +6728,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 {
 	s32 s32Error = 0;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 	int id;
 	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
 
@@ -6744,22 +6744,22 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 	/*if there is an ongoing scan request*/
 	if (pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult) {
 		/* prepare theScan Done message */
-		memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+		memset(&msg, 0, sizeof(struct host_if_msg));
 
-		strHostIFmsg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
-		strHostIFmsg.drvHandler = pstrWFIDrv;
+		msg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
+		msg.drvHandler = pstrWFIDrv;
 
 
 		/* will be deallocated by the receiving thread */
 		/*no need to send message body*/
 
-		/*strHostIFmsg.uniHostIFmsgBody.strScanComplete.u32Length = u32Length;
-		 * strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
-		 * memcpy(strHostIFmsg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
+		/*msg.uniHostIFmsgBody.strScanComplete.u32Length = u32Length;
+		 * msg.uniHostIFmsgBody.strScanComplete.pu8Buffer  = (u8*)WILC_MALLOC(u32Length);
+		 * memcpy(msg.uniHostIFmsgBody.strScanComplete.pu8Buffer,
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
-		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
 	}
@@ -6787,7 +6787,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6795,19 +6795,19 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	}
 
 	/* prepare the remainonchan Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u16Channel = chan;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.pVoid = pvUserArg;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32duration = u32duration;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
-	strHostIFmsg.drvHandler = hWFIDrv;
-
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u16Channel = chan;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pVoid = pvUserArg;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32duration = u32duration;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	msg.drvHandler = hWFIDrv;
+
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6832,7 +6832,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -6843,12 +6843,12 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	del_timer(&pstrWFIDrv->hRemainOnChannel);
 
 	/* prepare the timer fire Message */
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
-	strHostIFmsg.drvHandler = hWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	memset(&msg, 0, sizeof(struct host_if_msg));
+	msg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6867,37 +6867,37 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_REGISTER_FRAME;
+	msg.u16MsgId = HOST_IF_MSG_REGISTER_FRAME;
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
-		strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
+		msg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
 		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
-		strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
+		msg.uniHostIFmsgBody.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
 		break;
 
 	default:
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.u16FrameType = u16FrameType;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIfRegisterFrame.u16FrameType = u16FrameType;
+	msg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6924,22 +6924,22 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
+	struct host_if_msg msg;
+	tstrHostIFSetBeacon *pstrSetBeaconParam = &msg.uniHostIFmsgBody.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
+	msg.drvHandler = hWFIDrv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
 	pstrSetBeaconParam->u32HeadLen = u32HeadLen;
@@ -6963,7 +6963,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -6994,7 +6994,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7002,11 +7002,11 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	}
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
+	msg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7027,8 +7027,8 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
+	struct host_if_msg msg;
+	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.uniHostIFmsgBody.strAddStaParam;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -7036,14 +7036,14 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting adding station message queue params\n");
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_STATION;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_ADD_STATION;
+	msg.drvHandler = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -7057,7 +7057,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	}
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7076,30 +7076,30 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIFDelSta *pstrDelStationMsg = &strHostIFmsg.uniHostIFmsgBody.strDelStaParam;
+	struct host_if_msg msg;
+	tstrHostIFDelSta *pstrDelStationMsg = &msg.uniHostIFmsgBody.strDelStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deleting station message queue params\n");
 
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_STATION;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_DEL_STATION;
+	msg.drvHandler = hWFIDrv;
 
 	if (pu8MacAddr == NULL)
 		memset(pstrDelStationMsg->au8MacAddr, 255, ETH_ALEN);
 	else
 		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7117,8 +7117,8 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIFDelAllSta *pstrDelAllStationMsg = &strHostIFmsg.uniHostIFmsgBody.strHostIFDelAllSta;
+	struct host_if_msg msg;
+	tstrHostIFDelAllSta *pstrDelAllStationMsg = &msg.uniHostIFmsgBody.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
@@ -7129,13 +7129,13 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_ALL_STA;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_DEL_ALL_STA;
+	msg.drvHandler = hWFIDrv;
 
 	/* Handling situation of deauthenticing all associated stations*/
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -7152,7 +7152,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	}
 
 	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
 
 	if (s32Error)
@@ -7177,8 +7177,8 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrWILC_AddStaParam *pstrAddStationMsg = &strHostIFmsg.uniHostIFmsgBody.strAddStaParam;
+	struct host_if_msg msg;
+	tstrWILC_AddStaParam *pstrAddStationMsg = &msg.uniHostIFmsgBody.strAddStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7187,12 +7187,12 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	PRINT_D(HOSTINF_DBG, "Setting editing station message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_EDIT_STATION;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_EDIT_STATION;
+	msg.drvHandler = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
 	if (pstrAddStationMsg->u8NumRates > 0) {
@@ -7205,7 +7205,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7216,8 +7216,8 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &strHostIFmsg.uniHostIFmsgBody.strPowerMgmtparam;
+	struct host_if_msg msg;
+	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &msg.uniHostIFmsgBody.strPowerMgmtparam;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
@@ -7228,18 +7228,18 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 	PRINT_D(HOSTINF_DBG, "Setting Power management message queue params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_POWER_MGMT;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_POWER_MGMT;
+	msg.drvHandler = hWFIDrv;
 
 	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7250,8 +7250,8 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	s32 s32Error = 0;
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIFSetMulti *pstrMulticastFilterParam = &strHostIFmsg.uniHostIFmsgBody.strHostIfSetMulti;
+	struct host_if_msg msg;
+	tstrHostIFSetMulti *pstrMulticastFilterParam = &msg.uniHostIFmsgBody.strHostIfSetMulti;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -7261,17 +7261,17 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	PRINT_D(HOSTINF_DBG, "Setting Multicast Filter params\n");
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_MULTICAST_FILTER;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.u16MsgId = HOST_IF_MSG_SET_MULTICAST_FILTER;
+	msg.drvHandler = hWFIDrv;
 
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -7517,26 +7517,26 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	struct host_if_msg msg;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
+	msg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
 	pBASessionInfo->u16BufferSize = BufferSize;
 	pBASessionInfo->u16SessionTimeout = SessionTimeout;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7548,24 +7548,24 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	struct host_if_msg msg;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
+	msg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7578,24 +7578,24 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &strHostIFmsg.uniHostIFmsgBody.strHostIfBASessionInfo;
+	struct host_if_msg msg;
+	tstrHostIfBASessionInfo *pBASessionInfo = &msg.uniHostIFmsgBody.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
+	msg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
-	strHostIFmsg.drvHandler = hWFIDrv;
+	msg.drvHandler = hWFIDrv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7616,7 +7616,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	/* TODO: Enable This feature on softap firmware */
 	return 0;
@@ -7626,16 +7626,16 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
+	msg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
-	strHostIFmsg.drvHandler = hWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
+	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -7656,23 +7656,23 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
-	struct host_if_msg strHostIFmsg;
+	struct host_if_msg msg;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	memset(&strHostIFmsg, 0, sizeof(struct host_if_msg));
+	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	strHostIFmsg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
+	msg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
 
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
-	strHostIFmsg.drvHandler = hWFIDrv;
-	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
+	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
+	msg.drvHandler = hWFIDrv;
+	msg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-- 
1.9.1

