Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6118 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbbJOE0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:26:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/40] staging: wilc1000: rename variable gMsgQHostIF
Date: Thu, 15 Oct 2015 13:24:53 +0900
Message-ID: <1444883121-31757-12-git-send-email-tony.cho@atmel.com> (sfid-20151015_062655_337783_C2C52B11)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gMsgQHostIF to hif_msg_q
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 109 +++++++++++++++---------------
 1 file changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4f24a05..bb770ab1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -240,7 +240,7 @@ struct host_if_drv *terminated_handle;
 bool g_obtainingIP;
 u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
-static WILC_MsgQueueHandle gMsgQHostIF;
+static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hSemHostIFthrdEnd;
 
 struct semaphore hSemDeinitDrvHandle;
@@ -2738,7 +2738,7 @@ static void ListenTimerCB(unsigned long arg)
 	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = hif_drv->strHostIfRemainOnChan.u32ListenSessionID;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 }
@@ -2926,7 +2926,7 @@ static int hostIFthread(void *pvArg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	while (1) {
-		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
+		wilc_mq_recv(&hif_msg_q, &msg, sizeof(struct host_if_msg), &u32Ret);
 		hif_drv = (struct host_if_drv *)msg.drv;
 		if (msg.id == HOST_IF_MSG_EXIT) {
 			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
@@ -2936,13 +2936,13 @@ static int hostIFthread(void *pvArg)
 		if ((!g_wilc_initialized)) {
 			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
-			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			continue;
 		}
 
 		if (msg.id == HOST_IF_MSG_CONNECT && hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL) {
 			PRINT_D(HOSTINF_DBG, "Requeue connect request till scan done received\n");
-			wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			usleep_range(2 * 1000, 2 * 1000);
 			continue;
 		}
@@ -3136,7 +3136,7 @@ static void TimerCB_Scan(unsigned long arg)
 	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
-	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 }
 
 static void TimerCB_Connect(unsigned long arg)
@@ -3148,7 +3148,7 @@ static void TimerCB_Connect(unsigned long arg)
 	msg.drv = pvArg;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
-	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 }
 
 s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
@@ -3182,7 +3182,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	msg.drv = hif_drv;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
 	down(&hif_drv->hSemTestKeyBlock);
@@ -3211,7 +3211,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	msg.drv = hif_drv;
 	msg.body.key_info.attr.wep.index = u8Index;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue : Default key index\n");
 	down(&hif_drv->hSemTestKeyBlock);
@@ -3246,7 +3246,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
 	msg.body.key_info.attr.wep.index = u8Keyidx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
 	down(&hif_drv->hSemTestKeyBlock);
@@ -3290,7 +3290,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.attr.wep.mode = u8mode;
 	msg.body.key_info.attr.wep.auth_type = tenuAuth_type;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
@@ -3355,7 +3355,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
@@ -3418,7 +3418,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 
@@ -3454,7 +3454,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 			    PMKID_LEN);
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER(" Error in sending messagequeue: PMKID Info\n");
 
@@ -3502,7 +3502,7 @@ s32 host_int_get_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	msg.body.get_mac_info.u8MacAddress = pu8MacAddress;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get mac address\n");
 		return -EFAULT;
@@ -3524,7 +3524,7 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 	memcpy(msg.body.set_mac_info.u8MacAddress, pu8MacAddress, ETH_ALEN);
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: Set mac address\n");
 
@@ -3624,7 +3624,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	else
 		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' as state is %d\n", hif_drv->enuHostIFstate);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Set join request\n");
 		return -EFAULT;
@@ -3658,7 +3658,7 @@ s32 host_int_flush_join_req(struct host_if_drv *hif_drv)
 	msg.id = HOST_IF_MSG_FLUSH_CONNECT;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send message queue: Flush join request\n");
 		return -EFAULT;
@@ -3682,7 +3682,7 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 
@@ -3773,7 +3773,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 	msg.body.channel_info.set_ch = channel;
 	msg.drv = hif_drv;
 
-	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
 		return -EINVAL;
@@ -3789,7 +3789,7 @@ int host_int_wait_msg_queue_idle(void)
 	struct host_if_msg msg;
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_Q_IDLE;
-	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
 		result = -EINVAL;
@@ -3810,7 +3810,7 @@ int host_int_set_wfi_drv_handler(struct host_if_drv *hif_drv)
 	msg.body.drv.u32Address = get_id_from_handler(hif_drv);
 	msg.drv = hif_drv;
 
-	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
 		result = -EINVAL;
@@ -3829,7 +3829,7 @@ int host_int_set_operation_mode(struct host_if_drv *hif_drv, u32 mode)
 	msg.body.mode.u32Mode = mode;
 	msg.drv = hif_drv;
 
-	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
 		result = -EINVAL;
@@ -3853,7 +3853,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 	msg.id = HOST_IF_MSG_GET_CHNL;
 	msg.drv = hif_drv;
 
-	s32Error =	wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 	down(&hif_drv->hSemGetCHNL);
@@ -3885,7 +3885,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
@@ -3935,7 +3935,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -3965,7 +3965,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 	msg.id = HOST_IF_MSG_GET_LINKSPEED;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send GET_LINKSPEED to message queue ");
 		return -EFAULT;
@@ -3996,7 +3996,7 @@ s32 host_int_get_statistics(struct host_if_drv *hif_drv, struct rf_info *pstrSta
 	msg.body.data = (char *)pstrStatistics;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Failed to send get host channel param's message queue ");
 		return -EFAULT;
@@ -4046,7 +4046,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ies, pu8IEs, IEsLen);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
 		PRINT_ER("Error in sending message queue\n");
 		return -EINVAL;
@@ -4080,7 +4080,7 @@ s32 hif_set_cfg(struct host_if_drv *hif_drv,
 	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	return s32Error;
 
@@ -4204,7 +4204,7 @@ static void GetPeriodicRSSI(unsigned long arg)
 		msg.id = HOST_IF_MSG_GET_RSSI;
 		msg.drv = hif_drv;
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (s32Error) {
 			PRINT_ER("Failed to send get host channel param's message queue ");
 			return;
@@ -4265,7 +4265,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
 	if (clients_count == 0)	{
-		result = wilc_mq_create(&gMsgQHostIF);
+		result = wilc_mq_create(&hif_msg_q);
 
 		if (result < 0) {
 			PRINT_ER("Failed to creat MQ\n");
@@ -4320,7 +4320,7 @@ _fail_timer_2:
 	del_timer_sync(&hif_drv->hScanTimer);
 	kthread_stop(hif_thread_handler);
 _fail_mq_:
-	wilc_mq_destroy(&gMsgQHostIF);
+	wilc_mq_destroy(&hif_msg_q);
 _fail_:
 	return result;
 }
@@ -4379,14 +4379,13 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.drv = hif_drv;
 
-
-		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (s32Error != 0)
 			PRINT_ER("Error in sending deinit's message queue message function: Error(%d)\n", s32Error);
 
 		down(&hSemHostIFthrdEnd);
 
-		wilc_mq_destroy(&gMsgQHostIF);
+		wilc_mq_destroy(&hif_msg_q);
 	}
 
 	down(&(hif_drv->gtOsCfgValuesSem));
@@ -4430,7 +4429,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending network info message queue message parameters: Error(%d)\n", s32Error);
 }
@@ -4471,7 +4470,7 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length)
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("Error in sending message queue asynchronous message info: Error(%d)\n", s32Error);
 
@@ -4500,7 +4499,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length)
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.drv = hif_drv;
 
-		s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+		s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (s32Error)
 			PRINT_ER("Error in sending message queue scan complete parameters: Error(%d)\n", s32Error);
 	}
@@ -4535,7 +4534,7 @@ s32 host_int_remain_on_channel(struct host_if_drv *hif_drv, u32 u32SessionID,
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -4559,7 +4558,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 	msg.drv = hif_drv;
 	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -4598,7 +4597,7 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 	msg.body.reg_frame.bReg = bReg;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -4648,7 +4647,7 @@ s32 host_int_add_beacon(struct host_if_drv *hif_drv, u32 u32Interval,
 		pstrSetBeaconParam->tail = NULL;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc mq send fail\n");
 
@@ -4679,7 +4678,7 @@ s32 host_int_del_beacon(struct host_if_drv *hif_drv)
 	msg.drv = hif_drv;
 	PRINT_D(HOSTINF_DBG, "Setting deleting beacon message queue params\n");
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -4717,8 +4716,7 @@ s32 host_int_add_station(struct host_if_drv *hif_drv,
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -4747,7 +4745,7 @@ s32 host_int_del_station(struct host_if_drv *hif_drv, const u8 *pu8MacAddr)
 	else
 		memcpy(pstrDelStationMsg->mac_addr, pu8MacAddr, ETH_ALEN);
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -4795,8 +4793,7 @@ s32 host_int_del_allstation(struct host_if_drv *hif_drv,
 	}
 
 	pstrDelAllStationMsg->assoc_sta = u8AssocNumb;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
@@ -4837,7 +4834,7 @@ s32 host_int_edit_station(struct host_if_drv *hif_drv,
 		pstrAddStationMsg->pu8Rates = rates;
 	}
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -4869,7 +4866,7 @@ s32 host_int_set_power_mgmt(struct host_if_drv *hif_drv,
 	pstrPowerMgmtParam->enabled = bIsEnabled;
 	pstrPowerMgmtParam->timeout = u32Timeout;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -4899,7 +4896,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hif_drv,
 	pstrMulticastFilterParam->enabled = bIsEnabled;
 	pstrMulticastFilterParam->cnt = u32count;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 	return s32Error;
@@ -5093,7 +5090,7 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -5123,7 +5120,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -5152,7 +5149,7 @@ s32 host_int_setup_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
@@ -5179,7 +5176,7 @@ s32 host_int_get_ipaddress(struct host_if_drv *hif_drv, u8 *u16ipadd, u8 idx)
 	msg.drv = hif_drv;
 	msg.body.ip_info.idx = idx;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	s32Error = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
 		PRINT_ER("wilc_mq_send fail\n");
 
-- 
1.9.1

