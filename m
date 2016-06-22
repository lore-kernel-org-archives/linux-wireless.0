Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34659 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcFVKDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 06:03:47 -0400
Received: by mail-pa0-f54.google.com with SMTP id bz2so15627800pad.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 03:03:07 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 3/3] staging: wilc1000: Change interface wilc_mq_send to wilc_enqueue_cmd
Date: Wed, 22 Jun 2016 15:31:31 +0530
Message-Id: <1466589691-14798-4-git-send-email-binoy.jayan@linaro.org> (sfid-20160622_120637_730428_A043DECE)
In-Reply-To: <1466589691-14798-1-git-send-email-binoy.jayan@linaro.org>
References: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
 <1466589691-14798-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the interface 'wilc_mq_send' with 'wilc_enqueue_cmd'
and remove the now unused structures 'message' and 'message_queue'.
Restructure switch statement in the work queue helper function
host_if_work and remove unwanted indentation.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/host_interface.c | 332 ++++++++++++++----------------
 1 file changed, 158 insertions(+), 174 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 242c3d7..8ba48c2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -60,20 +60,6 @@
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
-struct message {
-	void *buf;
-	u32 len;
-	struct list_head list;
-};
-
-struct message_queue {
-	struct semaphore sem;
-	spinlock_t lock;
-	bool exiting;
-	u32 recv_count;
-	struct list_head msg_list;
-};
-
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
@@ -290,12 +276,11 @@ static void host_if_work(struct work_struct *work);
  *  @note		copied from FLO glue implementatuion
  *  @version		1.0
  */
-static int wilc_mq_send(struct message_queue *mq,
-			const void *send_buf, u32 send_buf_size)
+static int wilc_enqueue_cmd(struct host_if_msg *msg)
 {
 	struct host_if_msg *new_msg;
 
-	new_msg = kmemdup(send_buf, sizeof(*new_msg), GFP_ATOMIC);
+	new_msg = kmemdup(msg, sizeof(*new_msg), GFP_ATOMIC);
 	if (!new_msg)
 		return -ENOMEM;
 
@@ -2404,7 +2389,7 @@ static void ListenTimerCB(unsigned long arg)
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 }
@@ -2514,160 +2499,159 @@ static void host_if_work(struct work_struct *work)
 
 	if (msg->id == HOST_IF_MSG_CONNECT &&
 	    msg->vif->hif_drv->usr_scan_req.scan_result) {
-		wilc_mq_send(&hif_msg_q, msg, sizeof(struct host_if_msg));
+		wilc_enqueue_cmd(msg);
 		usleep_range(2 * 1000, 2 * 1000);
-	} else {
-
-		switch (msg->id) {
-		case HOST_IF_MSG_SCAN:
-			handle_scan(msg->vif, &msg->body.scan_info);
-			break;
-
-		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg->vif, &msg->body.con_info);
-			break;
+		goto free_msg;
+	}
+	switch (msg->id) {
+	case HOST_IF_MSG_SCAN:
+		handle_scan(msg->vif, &msg->body.scan_info);
+		break;
 
-		case HOST_IF_MSG_RCVD_NTWRK_INFO:
-			Handle_RcvdNtwrkInfo(msg->vif, &msg->body.net_info);
-			break;
+	case HOST_IF_MSG_CONNECT:
+		Handle_Connect(msg->vif, &msg->body.con_info);
+		break;
 
-		case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-			Handle_RcvdGnrlAsyncInfo(msg->vif,
-						 &msg->body.async_info);
-			break;
+	case HOST_IF_MSG_RCVD_NTWRK_INFO:
+		Handle_RcvdNtwrkInfo(msg->vif, &msg->body.net_info);
+		break;
 
-		case HOST_IF_MSG_KEY:
-			Handle_Key(msg->vif, &msg->body.key_info);
-			break;
+	case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
+		Handle_RcvdGnrlAsyncInfo(msg->vif,
+					 &msg->body.async_info);
+		break;
 
-		case HOST_IF_MSG_CFG_PARAMS:
-			handle_cfg_param(msg->vif, &msg->body.cfg_info);
-			break;
+	case HOST_IF_MSG_KEY:
+		Handle_Key(msg->vif, &msg->body.key_info);
+		break;
 
-		case HOST_IF_MSG_SET_CHANNEL:
-			handle_set_channel(msg->vif, &msg->body.channel_info);
-			break;
+	case HOST_IF_MSG_CFG_PARAMS:
+		handle_cfg_param(msg->vif, &msg->body.cfg_info);
+		break;
 
-		case HOST_IF_MSG_DISCONNECT:
-			Handle_Disconnect(msg->vif);
-			break;
+	case HOST_IF_MSG_SET_CHANNEL:
+		handle_set_channel(msg->vif, &msg->body.channel_info);
+		break;
 
-		case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-			del_timer(&msg->vif->hif_drv->scan_timer);
+	case HOST_IF_MSG_DISCONNECT:
+		Handle_Disconnect(msg->vif);
+		break;
 
-			if (!wilc_wlan_get_num_conn_ifcs(wilc))
-				wilc_chip_sleep_manually(wilc);
+	case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
+		del_timer(&msg->vif->hif_drv->scan_timer);
 
-			Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
+		if (!wilc_wlan_get_num_conn_ifcs(wilc))
+			wilc_chip_sleep_manually(wilc);
 
-			if (msg->vif->hif_drv->remain_on_ch_pending)
-				Handle_RemainOnChan(msg->vif,
-						    &msg->body.remain_on_ch);
+		Handle_ScanDone(msg->vif, SCAN_EVENT_DONE);
 
-			break;
+		if (msg->vif->hif_drv->remain_on_ch_pending)
+			Handle_RemainOnChan(msg->vif,
+					    &msg->body.remain_on_ch);
 
-		case HOST_IF_MSG_GET_RSSI:
-			Handle_GetRssi(msg->vif);
-			break;
+		break;
 
-		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg->vif,
-					     (struct rf_info *)msg->body.data);
-			break;
+	case HOST_IF_MSG_GET_RSSI:
+		Handle_GetRssi(msg->vif);
+		break;
 
-		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg->vif, &msg->body.beacon_info);
-			break;
+	case HOST_IF_MSG_GET_STATISTICS:
+		Handle_GetStatistics(msg->vif,
+				     (struct rf_info *)msg->body.data);
+		break;
 
-		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg->vif);
-			break;
+	case HOST_IF_MSG_ADD_BEACON:
+		Handle_AddBeacon(msg->vif, &msg->body.beacon_info);
+		break;
 
-		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg->vif, &msg->body.add_sta_info);
-			break;
+	case HOST_IF_MSG_DEL_BEACON:
+		Handle_DelBeacon(msg->vif);
+		break;
 
-		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg->vif, &msg->body.del_sta_info);
-			break;
+	case HOST_IF_MSG_ADD_STATION:
+		Handle_AddStation(msg->vif, &msg->body.add_sta_info);
+		break;
 
-		case HOST_IF_MSG_EDIT_STATION:
-			Handle_EditStation(msg->vif, &msg->body.edit_sta_info);
-			break;
+	case HOST_IF_MSG_DEL_STATION:
+		Handle_DelStation(msg->vif, &msg->body.del_sta_info);
+		break;
 
-		case HOST_IF_MSG_GET_INACTIVETIME:
-			Handle_Get_InActiveTime(msg->vif, &msg->body.mac_info);
-			break;
+	case HOST_IF_MSG_EDIT_STATION:
+		Handle_EditStation(msg->vif, &msg->body.edit_sta_info);
+		break;
 
-		case HOST_IF_MSG_SCAN_TIMER_FIRED:
+	case HOST_IF_MSG_GET_INACTIVETIME:
+		Handle_Get_InActiveTime(msg->vif, &msg->body.mac_info);
+		break;
 
-			Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
-			break;
+	case HOST_IF_MSG_SCAN_TIMER_FIRED:
+		Handle_ScanDone(msg->vif, SCAN_EVENT_ABORTED);
+		break;
 
-		case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-			Handle_ConnectTimeout(msg->vif);
-			break;
+	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
+		Handle_ConnectTimeout(msg->vif);
+		break;
 
-		case HOST_IF_MSG_POWER_MGMT:
-			Handle_PowerManagement(msg->vif,
-					       &msg->body.pwr_mgmt_info);
-			break;
+	case HOST_IF_MSG_POWER_MGMT:
+		Handle_PowerManagement(msg->vif,
+				       &msg->body.pwr_mgmt_info);
+		break;
 
-		case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-			handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
-			break;
+	case HOST_IF_MSG_SET_WFIDRV_HANDLER:
+		handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
+		break;
 
-		case HOST_IF_MSG_SET_OPERATION_MODE:
-			handle_set_operation_mode(msg->vif, &msg->body.mode);
-			break;
+	case HOST_IF_MSG_SET_OPERATION_MODE:
+		handle_set_operation_mode(msg->vif, &msg->body.mode);
+		break;
 
-		case HOST_IF_MSG_SET_IPADDRESS:
-			handle_set_ip_address(msg->vif,
-					      msg->body.ip_info.ip_addr,
-					      msg->body.ip_info.idx);
-			break;
+	case HOST_IF_MSG_SET_IPADDRESS:
+		handle_set_ip_address(msg->vif,
+				      msg->body.ip_info.ip_addr,
+				      msg->body.ip_info.idx);
+		break;
 
-		case HOST_IF_MSG_GET_IPADDRESS:
-			handle_get_ip_address(msg->vif, msg->body.ip_info.idx);
-			break;
+	case HOST_IF_MSG_GET_IPADDRESS:
+		handle_get_ip_address(msg->vif, msg->body.ip_info.idx);
+		break;
 
-		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			handle_get_mac_address(msg->vif,
-					       &msg->body.get_mac_info);
-			break;
+	case HOST_IF_MSG_GET_MAC_ADDRESS:
+		handle_get_mac_address(msg->vif,
+				       &msg->body.get_mac_info);
+		break;
 
-		case HOST_IF_MSG_REMAIN_ON_CHAN:
-			Handle_RemainOnChan(msg->vif, &msg->body.remain_on_ch);
-			break;
+	case HOST_IF_MSG_REMAIN_ON_CHAN:
+		Handle_RemainOnChan(msg->vif, &msg->body.remain_on_ch);
+		break;
 
-		case HOST_IF_MSG_REGISTER_FRAME:
-			Handle_RegisterFrame(msg->vif, &msg->body.reg_frame);
-			break;
+	case HOST_IF_MSG_REGISTER_FRAME:
+		Handle_RegisterFrame(msg->vif, &msg->body.reg_frame);
+		break;
 
-		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg->vif, &msg->body.remain_on_ch);
-			break;
+	case HOST_IF_MSG_LISTEN_TIMER_FIRED:
+		Handle_ListenStateExpired(msg->vif, &msg->body.remain_on_ch);
+		break;
 
-		case HOST_IF_MSG_SET_MULTICAST_FILTER:
-			Handle_SetMulticastFilter(msg->vif, &msg->body.multicast_info);
-			break;
+	case HOST_IF_MSG_SET_MULTICAST_FILTER:
+		Handle_SetMulticastFilter(msg->vif, &msg->body.multicast_info);
+		break;
 
-		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
-			break;
+	case HOST_IF_MSG_DEL_ALL_STA:
+		Handle_DelAllSta(msg->vif, &msg->body.del_all_sta_info);
+		break;
 
-		case HOST_IF_MSG_SET_TX_POWER:
-			handle_set_tx_pwr(msg->vif, msg->body.tx_power.tx_pwr);
-			break;
+	case HOST_IF_MSG_SET_TX_POWER:
+		handle_set_tx_pwr(msg->vif, msg->body.tx_power.tx_pwr);
+		break;
 
-		case HOST_IF_MSG_GET_TX_POWER:
-			handle_get_tx_pwr(msg->vif, &msg->body.tx_power.tx_pwr);
-			break;
-		default:
-			netdev_err(msg->vif->ndev, "[Host Interface] undefined\n");
-			break;
-		}
+	case HOST_IF_MSG_GET_TX_POWER:
+		handle_get_tx_pwr(msg->vif, &msg->body.tx_power.tx_pwr);
+		break;
+	default:
+		netdev_err(msg->vif->ndev, "[Host Interface] undefined\n");
+		break;
 	}
+free_msg:
 	kfree(msg);
 	complete(&hif_thread_comp);
 }
@@ -2681,7 +2665,7 @@ static void TimerCB_Scan(unsigned long arg)
 	msg.vif = vif;
 	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
 
-	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	wilc_enqueue_cmd(&msg);
 }
 
 static void TimerCB_Connect(unsigned long arg)
@@ -2693,7 +2677,7 @@ static void TimerCB_Connect(unsigned long arg)
 	msg.vif = vif;
 	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
 
-	wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	wilc_enqueue_cmd(&msg);
 }
 
 s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
@@ -2728,7 +2712,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
 	else
@@ -2757,7 +2741,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	msg.vif = vif;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Default key index\n");
 	else
@@ -2791,7 +2775,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.key_len = len;
 	msg.body.key_info.attr.wep.index = index;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "STA - WEP Key\n");
 	wait_for_completion(&hif_drv->comp_test_key_block);
@@ -2826,7 +2810,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg.body.key_info.attr.wep.mode = mode;
 	msg.body.key_info.attr.wep.auth_type = auth_type;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
 		netdev_err(vif->ndev, "AP - WEP Key\n");
@@ -2882,7 +2866,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	msg.body.key_info.attr.wpa.mode = cipher_mode;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
 		netdev_err(vif->ndev, "PTK Key\n");
@@ -2951,7 +2935,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.seq_len = key_rsc_len;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "RX GTK\n");
 	else
@@ -2981,7 +2965,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "PMKID Info\n");
 
@@ -2999,7 +2983,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	msg.body.get_mac_info.mac_addr = mac_addr;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get mac address\n");
 		return -EFAULT;
@@ -3063,7 +3047,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "send message: Set join request\n");
 		return -EFAULT;
@@ -3092,7 +3076,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	msg.id = HOST_IF_MSG_DISCONNECT;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
 	else
@@ -3136,7 +3120,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	msg.body.channel_info.set_ch = channel;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		return -EINVAL;
@@ -3156,7 +3140,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 	msg.body.drv.mac_idx = mac_idx;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
@@ -3175,7 +3159,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 	msg.body.mode.mode = mode;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		result = -EINVAL;
@@ -3202,7 +3186,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 	else
@@ -3223,7 +3207,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	msg.id = HOST_IF_MSG_GET_RSSI;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 		return -EFAULT;
@@ -3251,7 +3235,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	msg.body.data = (char *)stats;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host channel\n");
 		return -EFAULT;
@@ -3304,7 +3288,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	if (!scan_info->ies)
 		return -ENOMEM;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "Error in sending message queue\n");
 		return -EINVAL;
@@ -3334,7 +3318,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	msg.body.cfg_info = *cfg_param;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	return result;
 }
@@ -3477,7 +3461,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.vif = vif;
 
-		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		result = wilc_enqueue_cmd(&msg);
 		if (result != 0)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 		else
@@ -3523,7 +3507,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.net_info.buffer, pu8Buffer, u32Length);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "message parameters (%d)\n", result);
 }
@@ -3568,7 +3552,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
 	memcpy(msg.body.async_info.buffer, pu8Buffer, u32Length);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
 
@@ -3599,7 +3583,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.vif = vif;
 
-		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+		result = wilc_enqueue_cmd(&msg);
 		if (result)
 			netdev_err(vif->ndev, "complete param (%d)\n", result);
 	}
@@ -3625,7 +3609,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg.body.remain_on_ch.id = session_id;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3650,7 +3634,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = session_id;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3681,7 +3665,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	msg.body.reg_frame.reg = reg;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3719,7 +3703,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		beacon_info->tail = NULL;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3741,7 +3725,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	msg.id = HOST_IF_MSG_DEL_BEACON;
 	msg.vif = vif;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
@@ -3768,7 +3752,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 			return -ENOMEM;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
@@ -3790,7 +3774,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	else
 		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
@@ -3820,7 +3804,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 		return result;
 
 	del_all_sta_info->assoc_sta = assoc_sta;
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
@@ -3851,7 +3835,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 			return -ENOMEM;
 	}
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
@@ -3875,7 +3859,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	pwr_mgmt_info->enabled = enabled;
 	pwr_mgmt_info->timeout = timeout;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
@@ -3896,7 +3880,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	multicast_filter_param->enabled = enabled;
 	multicast_filter_param->cnt = count;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 	return result;
@@ -4069,7 +4053,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
@@ -4089,7 +4073,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg.vif = vif;
 	msg.body.ip_info.idx = idx;
 
-	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	result = wilc_enqueue_cmd(&msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
@@ -4107,7 +4091,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 	msg.body.tx_power.tx_pwr = tx_power;
 	msg.vif = vif;
 
-	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	ret = wilc_enqueue_cmd(&msg);
 	if (ret)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
@@ -4124,7 +4108,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 	msg.id = HOST_IF_MSG_GET_TX_POWER;
 	msg.vif = vif;
 
-	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	ret = wilc_enqueue_cmd(&msg);
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

