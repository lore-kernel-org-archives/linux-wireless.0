Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:41856 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeG2Hgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:33 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 4/8] staging: wilc1000: modified debug log messages description
Date: Sun, 29 Jul 2018 11:36:53 +0530
Message-ID: <1532844417-3192-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080721_994817_4756B110)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to update the debug logs message to provide correct
information. Also added the function name tag for same description log
to help identify the place from where log was captured.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 134 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  13 ++-
 drivers/staging/wilc1000/wilc_wlan.c              |   9 +-
 3 files changed, 80 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d960147..0df4d9c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -342,7 +342,8 @@ static void handle_set_operation_mode(struct work_struct *work)
 		complete(&hif_driver_comp);
 
 	if (ret)
-		netdev_err(vif->ndev, "Failed to set driver handler\n");
+		netdev_err(vif->ndev, "Failed to set operation mode\n");
+
 	kfree(msg);
 }
 
@@ -747,7 +748,7 @@ static int handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 	}
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
 		return result;
 	}
 
@@ -1155,7 +1156,7 @@ static void handle_connect_timeout(struct work_struct *work)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
 		goto out;
 	}
 
@@ -1187,7 +1188,7 @@ static void handle_connect_timeout(struct work_struct *work)
 		kfree(info.req_ies);
 		info.req_ies = NULL;
 	} else {
-		netdev_err(vif->ndev, "Connect callback is NULL\n");
+		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
 
 	wid.id = WID_DISCONNECT;
@@ -1400,7 +1401,8 @@ static void handle_rcvd_ntwrk_info(struct work_struct *work)
 
 	wilc_parse_network_info(rcvd_info->buffer, &info);
 	if (!info || !scan_req->scan_result) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: info or scan result NULL\n",
+			   __func__);
 		goto done;
 	}
 
@@ -1519,7 +1521,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	if (mac_status == MAC_STATUS_CONNECTED &&
 	    conn_info.status != WLAN_STATUS_SUCCESS) {
 		netdev_err(vif->ndev,
-			   "Received MAC status is MAC_STATUS_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
+			   "Received MAC status is MAC_STATUS_CONNECTED, Assoc Resp is not SUCCESS\n");
 		eth_zero_addr(wilc_connected_ssid);
 	} else if (mac_status == MAC_STATUS_DISCONNECTED)    {
 		netdev_err(vif->ndev, "Received MAC status is MAC_STATUS_DISCONNECTED\n");
@@ -1594,7 +1596,7 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 		conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL, 0,
 			    &disconn_info, hif_drv->usr_conn_req.arg);
 	} else {
-		netdev_err(vif->ndev, "Connect result NULL\n");
+		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
 
 	eth_zero_addr(hif_drv->assoc_bssid);
@@ -1613,12 +1615,12 @@ static void handle_rcvd_gnrl_async_info(struct work_struct *work)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!rcvd_info->buffer) {
-		netdev_err(vif->ndev, "Received buffer is NULL\n");
+		netdev_err(vif->ndev, "%s: buffer is NULL\n", __func__);
 		goto free_msg;
 	}
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
 		goto free_rcvd_info;
 	}
 
@@ -1626,7 +1628,8 @@ static void handle_rcvd_gnrl_async_info(struct work_struct *work)
 	    hif_drv->hif_state == HOST_IF_CONNECTED ||
 	    hif_drv->usr_scan_req.scan_result) {
 		if (!hif_drv->usr_conn_req.conn_result) {
-			netdev_err(vif->ndev, "driver is null\n");
+			netdev_err(vif->ndev, "%s: conn_result is NULL\n",
+				   __func__);
 			goto free_rcvd_info;
 		}
 
@@ -1969,7 +1972,7 @@ static void handle_disconnect(struct work_struct *work)
 		conn_req->conn_result(CONN_DISCONN_EVENT_DISCONN_NOTIF, NULL,
 				      0, &disconn_info, conn_req->arg);
 	} else {
-		netdev_err(vif->ndev, "conn_result = NULL\n");
+		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 	}
 
 	hif_drv->hif_state = HOST_IF_IDLE;
@@ -2101,7 +2104,7 @@ static void handle_get_inactive_time(struct work_struct *work)
 	kfree(wid.val);
 
 	if (result) {
-		netdev_err(vif->ndev, "Failed to SET inactive time\n");
+		netdev_err(vif->ndev, "Failed to set inactive mac\n");
 		goto out;
 	}
 
@@ -2293,7 +2296,7 @@ static void handle_del_all_sta(struct work_struct *work)
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "Failed to send add station\n");
+		netdev_err(vif->ndev, "Failed to send delete all station\n");
 
 error:
 	kfree(wid.val);
@@ -2323,7 +2326,7 @@ static void handle_del_station(struct work_struct *work)
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
-		netdev_err(vif->ndev, "Failed to send add station\n");
+		netdev_err(vif->ndev, "Failed to del station\n");
 
 error:
 	kfree(wid.val);
@@ -2523,7 +2526,7 @@ static void listen_timer_cb(struct timer_list *t)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 }
@@ -2719,7 +2722,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 	if (!hif_drv) {
 		result = -EFAULT;
-		netdev_err(vif->ndev, "Failed to send setup multicast\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return result;
 	}
 
@@ -2733,7 +2736,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "Request to remove WEP key\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -2749,7 +2752,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 
 	if (!hif_drv) {
 		result = -EFAULT;
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
 		return result;
 	}
 
@@ -2763,7 +2766,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "Default key index\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -2779,7 +2782,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -2820,7 +2823,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL\n", __func__);
 		return -EFAULT;
 	}
 
@@ -2865,7 +2868,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	u8 key_len = ptk_key_len;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -2907,7 +2910,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "PTK Key\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		goto free_key;
 	}
 
@@ -2932,7 +2935,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	u8 key_len = gtk_key_len;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -2985,7 +2988,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "RX GTK\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		goto free_key;
 	}
 
@@ -3025,7 +3028,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "PMKID Info\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3045,7 +3048,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "Failed to send get mac address\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -3065,12 +3068,14 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !connect_result) {
-		netdev_err(vif->ndev, "Driver is null\n");
+		netdev_err(vif->ndev,
+			   "%s: hif driver or connect result is NULL",
+			   __func__);
 		return -EFAULT;
 	}
 
 	if (!join_params) {
-		netdev_err(vif->ndev, "Unable to Join - JoinParams is NULL\n");
+		netdev_err(vif->ndev, "%s: joinparams is NULL\n", __func__);
 		return -EFAULT;
 	}
 
@@ -3115,7 +3120,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "send message: Set join request\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		goto free_ies;
 	}
 
@@ -3146,7 +3151,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "Driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3156,7 +3161,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -3177,7 +3182,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3200,7 +3205,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3219,7 +3224,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 	msg->body.mode.mode = mode;
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3234,7 +3239,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3246,7 +3251,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "Failed to send get host ch param\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -3262,7 +3267,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	struct host_if_msg *msg;
 
 	if (!rssi_level) {
-		netdev_err(vif->ndev, "RSS pointer value is null\n");
+		netdev_err(vif->ndev, "%s: RSSI level is NULL\n", __func__);
 		return -EFAULT;
 	}
 
@@ -3278,7 +3283,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "Failed to send get host ch param\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	} else {
 		wait_for_completion(&msg->work_comp);
 		*rssi_level = *msg->body.data;
@@ -3304,7 +3309,7 @@ wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats, bool is_sync)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "Failed to send get host channel\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 		return result;
 	}
@@ -3366,7 +3371,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "Error in sending message queue\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		goto free_ies;
 	}
 
@@ -3395,7 +3400,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	int result;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "hif_drv NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3416,7 +3421,7 @@ static void get_periodic_rssi(struct timer_list *unused)
 	struct wilc_vif *vif = periodic_rssi_vif;
 
 	if (!vif->hif_drv) {
-		netdev_err(vif->ndev, "Driver handler is NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return;
 	}
 
@@ -3494,7 +3499,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "hif_drv = NULL\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3578,7 +3583,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "message parameters (%d)\n", result);
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg->body.net_info.buffer);
 		kfree(msg);
 	}
@@ -3612,7 +3617,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	}
 
 	if (!hif_drv->usr_conn_req.conn_result) {
-		netdev_err(vif->ndev, "there is no current Connect Request\n");
+		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
 		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
@@ -3633,7 +3638,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg->body.async_info.buffer);
 		kfree(msg);
 	}
@@ -3669,7 +3674,8 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 		result = wilc_enqueue_work(msg);
 		if (result) {
-			netdev_err(vif->ndev, "complete param (%d)\n", result);
+			netdev_err(vif->ndev, "%s: enqueue work failed\n",
+				   __func__);
 			kfree(msg);
 		}
 	}
@@ -3697,7 +3703,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3711,7 +3717,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
-		netdev_err(vif->ndev, "driver is null\n");
+		netdev_err(vif->ndev, "%s: hif driver is NULL", __func__);
 		return -EFAULT;
 	}
 
@@ -3725,7 +3731,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3758,7 +3764,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3799,7 +3805,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 	result = wilc_enqueue_work(msg);
 	if (result)
-		netdev_err(vif->ndev, "wilc mq send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 
 error:
 	if (result) {
@@ -3822,7 +3828,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -3853,7 +3859,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(add_sta_info->rates);
 		kfree(msg);
 	}
@@ -3879,7 +3885,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 	return result;
@@ -3916,7 +3922,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	result = wilc_enqueue_work(msg);
 
 	if (result)
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	else
 		wait_for_completion(&msg->work_comp);
 
@@ -3950,7 +3956,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(add_sta_info->rates);
 		kfree(msg);
 	}
@@ -3975,7 +3981,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 	return result;
@@ -3996,7 +4002,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 	return result;
@@ -4016,7 +4022,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -4037,7 +4043,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	result = wilc_enqueue_work(msg);
 	if (result) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -4057,7 +4063,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 
 	ret = wilc_enqueue_work(msg);
 	if (ret) {
-		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
 	}
 
@@ -4075,7 +4081,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 
 	ret = wilc_enqueue_work(msg);
 	if (ret) {
-		netdev_err(vif->ndev, "Failed to get TX PWR\n");
+		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 	} else {
 		wait_for_completion(&msg->work_comp);
 		*tx_power = msg->body.tx_power.tx_pwr;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 42c0128..0eb2715 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -741,7 +741,8 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				security = ENCRYPT_ENABLED | WPA | AES;
 		} else {
 			ret = -ENOTSUPP;
-			netdev_err(dev, "Not supported cipher\n");
+			netdev_err(dev, "%s: Unsupported cipher\n",
+				   __func__);
 			wilc_connecting = 0;
 			return ret;
 		}
@@ -995,7 +996,7 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		break;
 
 	default:
-		netdev_err(netdev, "Not supported cipher\n");
+		netdev_err(netdev, "%s: Unsupported cipher\n", __func__);
 		ret = -ENOTSUPP;
 	}
 
@@ -1413,8 +1414,8 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 
 		default:
 			netdev_dbg(dev,
-				   "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n",
-				   buff[ACTION_SUBTYPE_ID]);
+				   "%s: Not handled action frame type:%x\n",
+				   __func__, buff[ACTION_SUBTYPE_ID]);
 			break;
 		}
 	}
@@ -1620,8 +1621,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 		default:
 			netdev_dbg(vif->ndev,
-				   "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n",
-				   buf[ACTION_SUBTYPE_ID]);
+				   "%s: Not handled action frame type:%x\n",
+				   __func__, buf[ACTION_SUBTYPE_ID]);
 			break;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 61dca05..6bac3f7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1148,10 +1148,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 	if (!commit)
 		return ret_size;
 
-	netdev_dbg(vif->ndev,
-		   "[WILC]PACKET Commit with sequence number %d\n",
-		   wilc->cfg_seq_no);
-	netdev_dbg(vif->ndev, "Processing cfg_set()\n");
+	netdev_dbg(vif->ndev, "%s: seqno[%d]\n", __func__, wilc->cfg_seq_no);
 	wilc->cfg_frame_in_use = 1;
 
 	if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
@@ -1159,7 +1156,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 
 	if (!wait_for_completion_timeout(&wilc->cfg_event,
 					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
-		netdev_dbg(vif->ndev, "Set Timed Out\n");
+		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
 		ret_size = 0;
 	}
 
@@ -1198,7 +1195,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 
 	if (!wait_for_completion_timeout(&wilc->cfg_event,
 					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
-		netdev_dbg(vif->ndev, "Get Timed Out\n");
+		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
 		ret_size = 0;
 	}
 	wilc->cfg_frame_in_use = 0;
-- 
2.7.4
