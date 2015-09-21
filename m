Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21051 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbbIUDRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:17:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 04/34] staging: wilc1000: rename u16MsgId
Date: Mon, 21 Sep 2015 12:16:33 +0900
Message-ID: <1442805423-3711-5-git-send-email-tony.cho@atmel.com> (sfid-20150921_051751_545562_D5C23012)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the name, u16MsgId simply to id to avoid the camelcase
notation.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 102 +++++++++++++++---------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79e3674..d2b0ea6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -459,7 +459,7 @@ typedef union _tuniHostIFmsgBody {
  *  @version		1.0
  */
 struct host_if_msg {
-	u16 u16MsgId;                                           /*!< Message ID */
+	u16 id;                                           /*!< Message ID */
 	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
 	tstrWILC_WFIDrv *drvHandler;
 };
@@ -3973,7 +3973,7 @@ static void ListenTimerCB(unsigned long arg)
 
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = pstrWFIDrv;
 	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
@@ -4301,7 +4301,7 @@ static int hostIFthread(void *pvArg)
 	while (1) {
 		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
 		pstrWFIDrv = (tstrWILC_WFIDrv *)msg.drvHandler;
-		if (msg.u16MsgId == HOST_IF_MSG_EXIT) {
+		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
 			break;
 		}
@@ -4315,14 +4315,14 @@ static int hostIFthread(void *pvArg)
 			continue;
 		}
 
-		if (msg.u16MsgId == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
+		if (msg.id == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
 			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
 		}
 
-		switch (msg.u16MsgId) {
+		switch (msg.id) {
 		case HOST_IF_MSG_Q_IDLE:
 			Handle_wait_msg_q_empty();
 			break;
@@ -4511,7 +4511,7 @@ static void TimerCB_Scan(unsigned long arg)
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.drvHandler = pvArg;
-	msg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
+	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
 	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4525,7 +4525,7 @@ static void TimerCB_Connect(unsigned long arg)
 	/* prepare the Timer Callback message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.drvHandler = pvArg;
-	msg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
+	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
 	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4591,7 +4591,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
 	msg.drvHandler = hWFIDrv;
@@ -4639,7 +4639,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
 	msg.drvHandler = hWFIDrv;
@@ -4693,7 +4693,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
@@ -4759,7 +4759,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 		for (i = 0; i < u8WepKeylen; i++)
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
 	}
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WEP;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
 	msg.drvHandler = hWFIDrv;
@@ -4834,7 +4834,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPAPtk;
 	if (mode == AP_MODE) {
 		msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
@@ -4937,7 +4937,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	}
 
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPARxGtk;
 	msg.drvHandler = hWFIDrv;
 
@@ -5026,7 +5026,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	/* prepare the Key Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_KEY;
+	msg.id = HOST_IF_MSG_KEY;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = PMKSA;
 	msg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
@@ -5134,7 +5134,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	/* prepare the Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_GET_MAC_ADDRESS;
+	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
 	msg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
@@ -5168,7 +5168,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 
 	/* prepare setting mac address message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_SET_MAC_ADDRESS;
+	msg.id = HOST_IF_MSG_SET_MAC_ADDRESS;
 	memcpy(msg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	msg.drvHandler = hWFIDrv;
 
@@ -5374,7 +5374,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 	/* prepare the Connect Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_CONNECT;
+	msg.id = HOST_IF_MSG_CONNECT;
 
 	msg.uniHostIFmsgBody.strHostIFconnectAttr.u8security = u8security;
 	msg.uniHostIFmsgBody.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
@@ -5453,7 +5453,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 		return s32Error;
 	}
 
-	msg.u16MsgId = HOST_IF_MSG_FLUSH_CONNECT;
+	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -5491,7 +5491,7 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	/* prepare the Disconnect Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_DISCONNECT;
+	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -5674,7 +5674,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 
 	/* prepare the set channel message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_SET_CHANNEL;
+	msg.id = HOST_IF_MSG_SET_CHANNEL;
 	msg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
 	msg.drvHandler = hWFIDrv;
 
@@ -5697,7 +5697,7 @@ s32 host_int_wait_msg_queue_idle(void)
 	/* prepare the set driver handler message */
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_Q_IDLE;
+	msg.id = HOST_IF_MSG_Q_IDLE;
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("wilc mq send fail\n");
@@ -5721,7 +5721,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	/* prepare the set driver handler message */
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_SET_WFIDRV_HANDLER;
+	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = get_id_from_handler(u32address);
 	msg.drvHandler = u32address;
 
@@ -5746,7 +5746,7 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	/* prepare the set driver handler message */
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_SET_OPERATION_MODE;
+	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
 	msg.drvHandler = hWFIDrv;
 
@@ -5788,7 +5788,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	/* prepare the Get Channel Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_GET_CHNL;
+	msg.id = HOST_IF_MSG_GET_CHNL;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -5876,7 +5876,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	memcpy(msg.uniHostIFmsgBody.strHostIfStaInactiveT.mac,
 		    mac, ETH_ALEN);
 
-	msg.u16MsgId = HOST_IF_MSG_GET_INACTIVETIME;
+	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -5957,7 +5957,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	/* prepare the Get RSSI Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_GET_RSSI;
+	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -5994,7 +5994,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	/* prepare the Get LINKSPEED Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_GET_LINKSPEED;
+	msg.id = HOST_IF_MSG_GET_LINKSPEED;
 	msg.drvHandler = hWFIDrv;
 
 	/* send the message */
@@ -6028,7 +6028,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	/* prepare the Get RSSI Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_GET_STATISTICS;
+	msg.id = HOST_IF_MSG_GET_STATISTICS;
 	msg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
@@ -6078,7 +6078,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	/* prepare the Scan Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_SCAN;
+	msg.id = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork != NULL) {
 		msg.uniHostIFmsgBody.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
@@ -6145,7 +6145,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	}
 	/* prepare the WiphyParams Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_CFG_PARAMS;
+	msg.id = HOST_IF_MSG_CFG_PARAMS;
 	msg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	msg.drvHandler = hWFIDrv;
 
@@ -6317,7 +6317,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		/* prepare the Get RSSI Message */
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
-		msg.u16MsgId = HOST_IF_MSG_GET_RSSI;
+		msg.id = HOST_IF_MSG_GET_RSSI;
 		msg.drvHandler = pstrWFIDrv;
 
 		/* send the message */
@@ -6575,7 +6575,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 			/* msleep(HOST_IF_CONNECT_TIMEOUT+1000); */
 		}
-		msg.u16MsgId = HOST_IF_MSG_EXIT;
+		msg.id = HOST_IF_MSG_EXIT;
 		msg.drvHandler = hWFIDrv;
 
 
@@ -6643,7 +6643,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	/* prepare the Asynchronous Network Info message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.u16MsgId = HOST_IF_MSG_RCVD_NTWRK_INFO;
+	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drvHandler = pstrWFIDrv;
 
 	msg.uniHostIFmsgBody.strRcvdNetworkInfo.u32Length = u32Length;
@@ -6699,7 +6699,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 
-	msg.u16MsgId = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
+	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
 	msg.drvHandler = pstrWFIDrv;
 
 
@@ -6746,7 +6746,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		/* prepare theScan Done message */
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
-		msg.u16MsgId = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
+		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.drvHandler = pstrWFIDrv;
 
 
@@ -6798,7 +6798,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_REMAIN_ON_CHAN;
+	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u16Channel = chan;
 	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
 	msg.uniHostIFmsgBody.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
@@ -6844,7 +6844,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 
 	/* prepare the timer fire Message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.u16MsgId = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = hWFIDrv;
 	msg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
@@ -6877,7 +6877,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_REGISTER_FRAME;
+	msg.id = HOST_IF_MSG_REGISTER_FRAME;
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
@@ -6938,7 +6938,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
+	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.drvHandler = hWFIDrv;
 	pstrSetBeaconParam->u32Interval = u32Interval;
 	pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
@@ -7002,7 +7002,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	}
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_DEL_BEACON;
+	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
@@ -7042,7 +7042,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_ADD_STATION;
+	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drvHandler = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
@@ -7091,7 +7091,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_DEL_STATION;
+	msg.id = HOST_IF_MSG_DEL_STATION;
 	msg.drvHandler = hWFIDrv;
 
 	if (pu8MacAddr == NULL)
@@ -7134,7 +7134,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	PRINT_D(HOSTINF_DBG, "Setting deauthenticating station message queue params\n");
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_DEL_ALL_STA;
+	msg.id = HOST_IF_MSG_DEL_ALL_STA;
 	msg.drvHandler = hWFIDrv;
 
 	/* Handling situation of deauthenticing all associated stations*/
@@ -7191,7 +7191,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_EDIT_STATION;
+	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.drvHandler = hWFIDrv;
 
 	memcpy(pstrAddStationMsg, pstrStaParams, sizeof(tstrWILC_AddStaParam));
@@ -7232,7 +7232,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_POWER_MGMT;
+	msg.id = HOST_IF_MSG_POWER_MGMT;
 	msg.drvHandler = hWFIDrv;
 
 	pstrPowerMgmtParam->bIsEnabled = bIsEnabled;
@@ -7265,7 +7265,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_SET_MULTICAST_FILTER;
+	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
 	msg.drvHandler = hWFIDrv;
 
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
@@ -7528,7 +7528,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_ADD_BA_SESSION;
+	msg.id = HOST_IF_MSG_ADD_BA_SESSION;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
@@ -7559,7 +7559,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_DEL_BA_SESSION;
+	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
@@ -7589,7 +7589,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
+	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
@@ -7629,7 +7629,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_SET_IPADDRESS;
+	msg.id = HOST_IF_MSG_SET_IPADDRESS;
 
 	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
@@ -7666,7 +7666,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	/* prepare the WiphyParams Message */
-	msg.u16MsgId = HOST_IF_MSG_GET_IPADDRESS;
+	msg.id = HOST_IF_MSG_GET_IPADDRESS;
 
 	msg.uniHostIFmsgBody.strHostIfSetIP.au8IPAddr = u16ipadd;
 	msg.drvHandler = hWFIDrv;
-- 
1.9.1

