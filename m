Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:1395 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbeFZGHd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/12] staging: wilc1000: rename wilc_enqueue_cmd() to wilc_enqueue_work()
Date: Tue, 26 Jun 2018 11:37:08 +0530
Message-ID: <1529993234-27294-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080738_819762_3B1F678B)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename wilc_enqueue_cmd() to wilc_enqueue_work() because its used to
enqueue the work queue. Also removed the function header comment for
wilc_enqueue_cmd() as its not correct.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 90 +++++++++++++++----------------
 1 file changed, 42 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17c20b9..6d27a9d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -227,13 +227,7 @@ wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
 	return msg;
 }
 
-/*!
- *  @author		syounan
- *  @date		1 Sep 2010
- *  @note		copied from FLO glue implementatuion
- *  @version		1.0
- */
-static int wilc_enqueue_cmd(struct host_if_msg *msg)
+static int wilc_enqueue_work(struct host_if_msg *msg)
 {
 	INIT_WORK(&msg->work, msg->fn);
 	if (!hif_workqueue || !queue_work(hif_workqueue, &msg->work))
@@ -903,7 +897,7 @@ static void handle_connect(struct work_struct *work)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (msg->vif->hif_drv->usr_scan_req.scan_result) {
-		result = wilc_enqueue_cmd(msg);
+		result = wilc_enqueue_work(msg);
 		if (result)
 			goto error;
 
@@ -2353,7 +2347,7 @@ static void listen_timer_cb(struct timer_list *t)
 
 	msg->body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -2521,7 +2515,7 @@ static void timer_scan_cb(struct timer_list *t)
 	if (IS_ERR(msg))
 		return;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		kfree(msg);
 }
@@ -2538,7 +2532,7 @@ static void timer_connect_cb(struct timer_list *t)
 	if (IS_ERR(msg))
 		return;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		kfree(msg);
 }
@@ -2563,7 +2557,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	msg->body.key_info.action = REMOVEKEY;
 	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
 	else
@@ -2593,7 +2587,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	msg->body.key_info.action = DEFAULTKEY;
 	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "Default key index\n");
 	else
@@ -2630,7 +2624,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg->body.key_info.attr.wep.key_len = len;
 	msg->body.key_info.attr.wep.index = index;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		goto free_key;
 
@@ -2675,7 +2669,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	msg->body.key_info.attr.wep.mode = mode;
 	msg->body.key_info.attr.wep.auth_type = auth_type;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		goto free_key;
 
@@ -2741,7 +2735,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	msg->body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg->body.key_info.attr.wpa.mode = cipher_mode;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "PTK Key\n");
 		goto free_key;
@@ -2821,7 +2815,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	msg->body.key_info.attr.wpa.key_len = key_len;
 	msg->body.key_info.attr.wpa.seq_len = key_rsc_len;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "RX GTK\n");
 		goto free_key;
@@ -2863,7 +2857,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 		       &pmkid->pmkidlist[i].pmkid, PMKID_LEN);
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "PMKID Info\n");
 		kfree(msg);
@@ -2883,7 +2877,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 	msg->body.get_mac_info.mac_addr = mac_addr;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send get mac address\n");
 	else
@@ -2953,7 +2947,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "send message: Set join request\n");
 		goto free_ies;
@@ -2994,7 +2988,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
 	else
@@ -3040,7 +3034,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 
 	msg->body.channel_info.set_ch = channel;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3063,7 +3057,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 	msg->body.drv.mode = mode;
 	msg->body.drv.name = ifc_id;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3082,7 +3076,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 		return PTR_ERR(msg);
 
 	msg->body.mode.mode = mode;
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3109,7 +3103,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 
 	memcpy(msg->body.mac_info.mac, mac, ETH_ALEN);
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 	else
@@ -3135,7 +3129,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
 	} else {
@@ -3160,7 +3154,7 @@ wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats, bool is_sync)
 
 	msg->body.data = (char *)stats;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Failed to send get host channel\n");
 		kfree(msg);
@@ -3222,7 +3216,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 		goto free_freq_list;
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "Error in sending message queue\n");
 		goto free_ies;
@@ -3262,7 +3256,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 		return PTR_ERR(msg);
 
 	msg->body.cfg_info = *cfg_param;
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		kfree(msg);
 
@@ -3387,7 +3381,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		if (IS_ERR(msg))
 			return PTR_ERR(msg);
 
-		result = wilc_enqueue_cmd(msg);
+		result = wilc_enqueue_work(msg);
 		if (result)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 		else
@@ -3437,7 +3431,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "message parameters (%d)\n", result);
 		kfree(msg->body.net_info.buffer);
@@ -3492,7 +3486,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		return;
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
 		kfree(msg->body.async_info.buffer);
@@ -3528,7 +3522,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 		if (IS_ERR(msg))
 			return;
 
-		result = wilc_enqueue_cmd(msg);
+		result = wilc_enqueue_work(msg);
 		if (result) {
 			netdev_err(vif->ndev, "complete param (%d)\n", result);
 			kfree(msg);
@@ -3556,7 +3550,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg->body.remain_on_ch.duration = duration;
 	msg->body.remain_on_ch.id = session_id;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3584,7 +3578,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 	msg->body.remain_on_ch.id = session_id;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3617,7 +3611,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	msg->body.reg_frame.frame_type = frame_type;
 	msg->body.reg_frame.reg = reg;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 		kfree(msg);
@@ -3658,7 +3652,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		beacon_info->tail = NULL;
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result)
 		netdev_err(vif->ndev, "wilc mq send fail\n");
 
@@ -3681,7 +3675,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -3712,7 +3706,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 		}
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(add_sta_info->rates);
@@ -3738,7 +3732,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 	else
 		memcpy(del_sta_info->mac_addr, mac_addr, ETH_ALEN);
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -3774,7 +3768,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	}
 
 	del_all_sta_info->assoc_sta = assoc_sta;
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
@@ -3809,7 +3803,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 		}
 	}
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(add_sta_info->rates);
@@ -3834,7 +3828,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	msg->body.pwr_mgmt_info.enabled = enabled;
 	msg->body.pwr_mgmt_info.timeout = timeout;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -3855,7 +3849,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	msg->body.multicast_info.enabled = enabled;
 	msg->body.multicast_info.cnt = count;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -4040,7 +4034,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg->body.ip_info.ip_addr = ip_addr;
 	msg->body.ip_info.idx = idx;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -4061,7 +4055,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	msg->body.ip_info.ip_addr = ip_addr;
 	msg->body.ip_info.idx = idx;
 
-	result = wilc_enqueue_cmd(msg);
+	result = wilc_enqueue_work(msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -4081,7 +4075,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 
 	msg->body.tx_power.tx_pwr = tx_power;
 
-	ret = wilc_enqueue_cmd(msg);
+	ret = wilc_enqueue_work(msg);
 	if (ret) {
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 		kfree(msg);
@@ -4099,7 +4093,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	ret = wilc_enqueue_cmd(msg);
+	ret = wilc_enqueue_work(msg);
 	if (ret) {
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 	} else {
-- 
2.7.4
