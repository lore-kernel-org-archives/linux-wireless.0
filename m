Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34172 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbbHSG7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 02:59:47 -0400
Received: by pdbfa8 with SMTP id fa8so77336893pdb.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2015 23:59:47 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/13] staging: wilc1000: rename WILC_MsgQueueSend to wilc_mq_send
Date: Wed, 19 Aug 2015 15:59:06 +0900
Message-Id: <1439967548-25876-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150819_090108_587290_3524D78A)
In-Reply-To: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439967548-25876-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_MsgQueueSend with wilc_mq_send to
shorten function name and avoid CamelCase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 98 +++++++++++++++----------------
 drivers/staging/wilc1000/wilc_msgqueue.c  |  2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h  |  2 +-
 3 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 159734f..6be2348 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3997,7 +3997,7 @@ static void ListenTimerCB(unsigned long arg)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -4344,13 +4344,13 @@ static int hostIFthread(void *pvArg)
 		if ((!g_wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
-			WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 			continue;
 		}
 
 		if (strHostIFmsg.u16MsgId == HOST_IF_MSG_CONNECT && pstrWFIDrv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
-			WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+			wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
 		}
@@ -4557,7 +4557,7 @@ static void TimerCB_Scan(unsigned long arg)
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
 	/* send the message */
-	WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 }
 
 static void TimerCB_Connect(unsigned long arg)
@@ -4571,7 +4571,7 @@ static void TimerCB_Connect(unsigned long arg)
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
 	/* send the message */
-	WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 }
 
 
@@ -4642,7 +4642,7 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4690,7 +4690,7 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4757,7 +4757,7 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&(pstrWFIDrv->hSemTestKeyBlock));
@@ -4832,7 +4832,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -4931,7 +4931,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
@@ -5033,7 +5033,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 	/* ////////////// */
@@ -5096,7 +5096,7 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	}
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
@@ -5198,7 +5198,7 @@ s32 host_int_get_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfGetMacAddress.u8MacAddress = pu8MacAddress;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
 		return WILC_FAIL;
@@ -5232,7 +5232,7 @@ s32 host_int_set_MacAddress(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8MacAddress)
 	memcpy(strHostIFmsg.uniHostIFmsgBody.strHostIfSetMacAddress.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 		WILC_ERRORREPORT(s32Error, s32Error);
@@ -5484,7 +5484,7 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", pstrWFIDrv->enuHostIFstate);
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -5534,7 +5534,7 @@ s32 host_int_flush_join_req(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -5581,7 +5581,7 @@ s32 host_int_disconnect(tstrWILC_WFIDrv *hWFIDrv, u16 u16ReasonCode)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 	/* ////////////// */
@@ -5770,7 +5770,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	strHostIFmsg.uniHostIFmsgBody.strHostIFSetChan.u8SetChan = u8ChNum;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -5792,7 +5792,7 @@ s32 host_int_wait_msg_queue_idle(void)
 
 	memset(&strHostIFmsg, 0, sizeof(tstrHostIFmsg));
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_Q_IDLE;
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -5821,7 +5821,7 @@ s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetDrvHandler.u32Address = u32address;
 	/* strHostIFmsg.drvHandler=hWFIDrv; */
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -5848,7 +5848,7 @@ s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetOperationMode.u32Mode = u32mode;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -5892,7 +5892,7 @@ s32 host_int_get_host_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8ChNo)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error =	WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error =	wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 	down(&(pstrWFIDrv->hSemGetCHNL));
@@ -5988,7 +5988,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
@@ -6076,7 +6076,7 @@ s32 host_int_get_rssi(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8Rssi)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return WILC_FAIL;
@@ -6113,7 +6113,7 @@ s32 host_int_get_link_speed(tstrWILC_WFIDrv *hWFIDrv, s8 *ps8lnkspd)
 	strHostIFmsg.drvHandler = hWFIDrv;
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return WILC_FAIL;
@@ -6147,7 +6147,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	strHostIFmsg.uniHostIFmsgBody.pUserData = (char *)pstrStatistics;
 	strHostIFmsg.drvHandler = hWFIDrv;
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return WILC_FAIL;
@@ -6218,7 +6218,7 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue scanning parameters: Error(%d)\n", s32Error);
 		WILC_ERRORREPORT(s32Error, WILC_FAIL);
@@ -6265,7 +6265,7 @@ s32 hif_set_cfg(tstrWILC_WFIDrv *hWFIDrv, tstrCfgParamVal *pstrCfgParamVal)
 	strHostIFmsg.uniHostIFmsgBody.strHostIFCfgParamAttr.pstrCfgParamVal = *pstrCfgParamVal;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
 	WILC_CATCH(s32Error)
 	{
@@ -6444,7 +6444,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		strHostIFmsg.drvHandler = pstrWFIDrv;
 
 		/* send the message */
-		s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 		if (s32Error) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
@@ -6711,7 +6711,7 @@ s32 host_int_deinit(tstrWILC_WFIDrv *hWFIDrv)
 		strHostIFmsg.drvHandler = hWFIDrv;
 
 
-		s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 		if (s32Error != WILC_SUCCESS)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
@@ -6780,7 +6780,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
@@ -6840,7 +6840,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 		    pu8Buffer, u32Length);
 
 	/* send the message */
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
@@ -6891,7 +6891,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		 *                        pu8Buffer, u32Length); */
 
 		/* send the message */
-		s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+		s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
 	}
@@ -6938,7 +6938,7 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -6981,7 +6981,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7031,7 +7031,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	strHostIFmsg.uniHostIFmsgBody.strHostIfRegisterFrame.bReg = bReg;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7097,7 +7097,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 		pstrSetBeaconParam->pu8Tail = NULL;
 	}
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 
@@ -7138,7 +7138,7 @@ s32 host_int_del_beacon(tstrWILC_WFIDrv *hWFIDrv)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	WILC_ERRORCHECK(s32Error);
 
 	WILC_CATCH(s32Error)
@@ -7188,7 +7188,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSta
 	}
 
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 
@@ -7233,7 +7233,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->au8MacAddr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 
@@ -7288,7 +7288,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	}
 
 	pstrDelAllStationMsg->u8Num_AssocSta = u8AssocNumb;
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 
 
 	if (s32Error)
@@ -7341,7 +7341,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7377,7 +7377,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	pstrPowerMgmtParam->u32Timeout = u32Timeout;
 
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7410,7 +7410,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 	pstrMulticastFilterParam->bIsEnabled = bIsEnabled;
 	pstrMulticastFilterParam->u32count = u32count;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7678,7 +7678,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	pBASessionInfo->u16SessionTimeout = SessionTimeout;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7709,7 +7709,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7742,7 +7742,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	pBASessionInfo->u8Ted = TID;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7785,7 +7785,7 @@ s32 host_int_setup_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
@@ -7824,7 +7824,7 @@ s32 host_int_get_ipaddress(tstrWILC_WFIDrv *hWFIDrv, u8 *u16ipadd, u8 idx)
 	strHostIFmsg.drvHandler = hWFIDrv;
 	strHostIFmsg.uniHostIFmsgBody.strHostIfSetIP.idx = idx;
 
-	s32Error = WILC_MsgQueueSend(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
+	s32Error = wilc_mq_send(&gMsgQHostIF, &strHostIFmsg, sizeof(tstrHostIFmsg));
 	if (s32Error)
 		WILC_ERRORREPORT(s32Error, s32Error);
 	WILC_CATCH(s32Error)
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 0358099..b5d230b 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -50,7 +50,7 @@ int WILC_MsgQueueDestroy(WILC_MsgQueueHandle *pHandle)
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-int WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize)
 {
 	int s32RetStatus = WILC_SUCCESS;
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 555aa02..197b0a9 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -44,7 +44,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle);
  *  @date		30 Aug 2010
  *  @version		1.0
  */
-int WILC_MsgQueueSend(WILC_MsgQueueHandle *pHandle,
+int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 			     const void *pvSendBuffer, u32 u32SendBufferSize);
 
 /*!
-- 
1.9.1

