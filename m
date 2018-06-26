Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3364 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbeFZGHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/12] staging: wilc1000: remove host_if_work() to handle TODO list issue
Date: Tue, 26 Jun 2018 11:37:03 +0530
Message-ID: <1529993234-27294-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080727_726074_C42A7C5F)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove multiplexing of command at host_if_work().
Make use of function pointer instead of command ID to track individual
work_struct separately.

Modified the handler function to take work_struct pointer as argument
and its return type is changes to void. Now prototype of 'handle_'
function is same work_struct i.e. 'void (*fun)(struct struct *)' to
register with work_queue.
Removed host_if_work() because its not required now.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 574 +++++++++++++++---------------
 1 file changed, 278 insertions(+), 296 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0aaae33..4f6008e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -184,6 +184,7 @@ struct host_if_msg {
 	union message_body body;
 	struct wilc_vif *vif;
 	struct work_struct work;
+	void (*fn)(struct work_struct *ws);
 };
 
 struct join_bss_param {
@@ -239,7 +240,6 @@ static u32 clients_count;
 static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
-static void host_if_work(struct work_struct *work);
 
 /*!
  *  @author		syounan
@@ -255,7 +255,7 @@ static int wilc_enqueue_cmd(struct host_if_msg *msg)
 	if (!new_msg)
 		return -ENOMEM;
 
-	INIT_WORK(&new_msg->work, host_if_work);
+	INIT_WORK(&new_msg->work, msg->fn);
 	queue_work(hif_workqueue, &new_msg->work);
 	return 0;
 }
@@ -284,9 +284,11 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
 	return wilc->vif[index];
 }
 
-static void handle_set_channel(struct wilc_vif *vif,
-			       struct channel_attr *hif_set_ch)
+static void handle_set_channel(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct channel_attr *hif_set_ch = &msg->body.channel_info;
 	int ret = 0;
 	struct wid wid;
 
@@ -300,27 +302,28 @@ static void handle_set_channel(struct wilc_vif *vif,
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set channel\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static int handle_set_wfi_drv_handler(struct wilc_vif *vif,
-				      struct drv_handler *hif_drv_handler)
+static void handle_set_wfi_drv_handler(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct drv_handler *hif_drv_handler = &msg->body.drv;
 	int ret = 0;
 	struct wid wid;
 	u8 *currbyte, *buffer;
 	struct host_if_drv *hif_drv = NULL;
 
-	if (!vif->hif_drv)
-		return -EINVAL;
-
-	if (!hif_drv_handler)
-		return -EINVAL;
+	if (!vif->hif_drv || !hif_drv_handler)
+		goto free_msg;
 
 	hif_drv	= vif->hif_drv;
 
 	buffer = kzalloc(DRV_HANDLER_SIZE, GFP_KERNEL);
 	if (!buffer)
-		return -ENOMEM;
+		goto free_msg;
 
 	currbyte = buffer;
 	*currbyte = hif_drv->driver_handler_id & DRV_HANDLER_MASK;
@@ -340,20 +343,22 @@ static int handle_set_wfi_drv_handler(struct wilc_vif *vif,
 
 	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				   hif_drv->driver_handler_id);
-	if (ret) {
+	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
-		complete(&hif_driver_comp);
-		kfree(buffer);
-		return ret;
-	}
+
 	complete(&hif_driver_comp);
 	kfree(buffer);
-	return 0;
+
+free_msg:
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_set_operation_mode(struct wilc_vif *vif,
-				      struct op_mode *hif_op_mode)
+static void handle_set_operation_mode(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct op_mode *hif_op_mode = &msg->body.mode;
 	int ret = 0;
 	struct wid wid;
 
@@ -370,10 +375,16 @@ static void handle_set_operation_mode(struct wilc_vif *vif,
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
+static void handle_set_ip_address(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	u8 *ip_addr = msg->body.ip_info.ip_addr;
+	u8 idx = msg->body.ip_info.idx;
 	int ret = 0;
 	struct wid wid;
 	char firmware_ip_addr[4] = {0};
@@ -395,10 +406,15 @@ static void handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set IP address\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
+static void handle_get_ip_address(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	u8 idx = msg->body.ip_info.idx;
 	int ret = 0;
 	struct wid wid;
 
@@ -419,11 +435,15 @@ static void handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get IP address\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_get_mac_address(struct wilc_vif *vif,
-				   struct get_mac_addr *get_mac_addr)
+static void handle_get_mac_address(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct get_mac_addr *get_mac_addr = &msg->body.get_mac_info;
 	int ret = 0;
 	struct wid wid;
 
@@ -438,10 +458,15 @@ static void handle_get_mac_address(struct wilc_vif *vif,
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get mac address\n");
 	complete(&hif_wait_response);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_cfg_param(struct wilc_vif *vif, struct cfg_param_attr *param)
+static void handle_cfg_param(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct cfg_param_attr *param = &msg->body.cfg_info;
 	int ret = 0;
 	struct wid wid_list[32];
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -730,10 +755,15 @@ static void handle_cfg_param(struct wilc_vif *vif, struct cfg_param_attr *param)
 
 unlock:
 	mutex_unlock(&hif_drv->cfg_values_lock);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
+static void handle_scan(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct scan_attr *scan_info = &msg->body.scan_info;
 	s32 result = 0;
 	struct wid wid_list[5];
 	u32 index = 0;
@@ -843,7 +873,8 @@ static s32 handle_scan(struct wilc_vif *vif, struct scan_attr *scan_info)
 
 	kfree(hdn_ntwk_wid_val);
 
-	return result;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
@@ -885,9 +916,11 @@ static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt)
 }
 
 u8 wilc_connected_ssid[6] = {0};
-static s32 handle_connect(struct wilc_vif *vif,
-			  struct connect_attr *conn_attr)
+static void handle_connect(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct connect_attr *conn_attr = &msg->body.con_info;
 	s32 result = 0;
 	struct wid wid_list[8];
 	u32 wid_cnt = 0, dummyval = 0;
@@ -895,10 +928,18 @@ static s32 handle_connect(struct wilc_vif *vif,
 	struct join_bss_param *bss_param;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
+	if (msg->vif->hif_drv->usr_scan_req.scan_result) {
+		result = wilc_enqueue_cmd(msg);
+		if (result)
+			goto error;
+		usleep_range(2 * 1000, 2 * 1000);
+		kfree(msg);
+		return;
+	}
+
 	if (memcmp(conn_attr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
-		result = 0;
 		netdev_err(vif->ndev, "Discard connect request\n");
-		return result;
+		goto error;
 	}
 
 	bss_param = conn_attr->params;
@@ -1138,11 +1179,14 @@ static s32 handle_connect(struct wilc_vif *vif,
 	conn_attr->ies = NULL;
 
 	kfree(cur_byte);
-	return result;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static s32 handle_connect_timeout(struct wilc_vif *vif)
+static void handle_connect_timeout(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
 	s32 result = 0;
 	struct connect_info info;
 	struct wid wid;
@@ -1151,7 +1195,7 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 	if (!hif_drv) {
 		netdev_err(vif->ndev, "Driver handler is NULL\n");
-		return result;
+		goto out;
 	}
 
 	hif_drv->hif_state = HOST_IF_IDLE;
@@ -1170,7 +1214,7 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 					       hif_drv->usr_conn_req.ies_len,
 					       GFP_KERNEL);
 			if (!info.req_ies)
-				return -ENOMEM;
+				goto out;
 		}
 
 		hif_drv->usr_conn_req.conn_result(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1206,15 +1250,18 @@ static s32 handle_connect_timeout(struct wilc_vif *vif)
 
 	eth_zero_addr(wilc_connected_ssid);
 
-	return result;
+out:
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
-				  struct rcvd_net_info *rcvd_info)
+static void handle_rcvd_ntwrk_info(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct rcvd_net_info *rcvd_info = &msg->body.net_info;
 	u32 i;
 	bool found;
-	s32 result = 0;
 	struct network_info *info = NULL;
 	void *params = NULL;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1228,7 +1275,6 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 	wilc_parse_network_info(rcvd_info->buffer, &info);
 	if (!info || !scan_req->scan_result) {
 		netdev_err(vif->ndev, "driver is null\n");
-		result = -EINVAL;
 		goto done;
 	}
 
@@ -1274,7 +1320,8 @@ static s32 handle_rcvd_ntwrk_info(struct wilc_vif *vif,
 		kfree(info);
 	}
 
-	return result;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
@@ -1411,24 +1458,23 @@ static inline void host_int_handle_disconnect(struct wilc_vif *vif)
 	hif_drv->hif_state = HOST_IF_IDLE;
 }
 
-static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
-				       struct rcvd_async_info *rcvd_info)
+static void handle_rcvd_gnrl_async_info(struct work_struct *work)
 {
-	s32 result = 0;
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct rcvd_async_info *rcvd_info = &msg->body.async_info;
 	u8 msg_type = 0;
 	u8 mac_status;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!rcvd_info->buffer) {
 		netdev_err(vif->ndev, "Received buffer is NULL\n");
-		return -EINVAL;
+		goto free_msg;
 	}
 
 	if (!hif_drv) {
 		netdev_err(vif->ndev, "Driver handler is NULL\n");
-		kfree(rcvd_info->buffer);
-		rcvd_info->buffer = NULL;
-		return -ENODEV;
+		goto free_rcvd_info;
 	}
 
 	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP ||
@@ -1436,18 +1482,14 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 	    hif_drv->usr_scan_req.scan_result) {
 		if (!hif_drv->usr_conn_req.conn_result) {
 			netdev_err(vif->ndev, "driver is null\n");
-			kfree(rcvd_info->buffer);
-			rcvd_info->buffer = NULL;
-			return -EINVAL;
+			goto free_rcvd_info;
 		}
 
 		msg_type = rcvd_info->buffer[0];
 
 		if ('I' != msg_type) {
 			netdev_err(vif->ndev, "Received Message incorrect.\n");
-			kfree(rcvd_info->buffer);
-			rcvd_info->buffer = NULL;
-			return -EFAULT;
+			goto free_rcvd_info;
 		}
 
 		mac_status  = rcvd_info->buffer[7];
@@ -1464,10 +1506,13 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
 		}
 	}
 
+free_rcvd_info:
 	kfree(rcvd_info->buffer);
 	rcvd_info->buffer = NULL;
 
-	return result;
+free_msg:
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_key)
@@ -1504,8 +1549,11 @@ static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_key)
 	return ret;
 }
 
-static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
+static void handle_key(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct key_attr *hif_key = &msg->body.key_info;
 	int result = 0;
 	struct wid wid;
 	struct wid wid_list[5];
@@ -1726,11 +1774,14 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 	if (result)
 		netdev_err(vif->ndev, "Failed to send key config packet\n");
 
-	return result;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_disconnect(struct wilc_vif *vif)
+static void handle_disconnect(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	struct disconnect_info disconn_info;
@@ -1798,6 +1849,8 @@ static void handle_disconnect(struct wilc_vif *vif)
 out:
 
 	complete(&hif_drv->comp_test_disconn_block);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
@@ -1809,8 +1862,10 @@ void wilc_resolve_disconnect_aberration(struct wilc_vif *vif)
 		wilc_disconnect(vif, 1);
 }
 
-static void handle_get_rssi(struct wilc_vif *vif)
+static void handle_get_rssi(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
 	s32 result = 0;
 	struct wid wid;
 
@@ -1821,19 +1876,21 @@ static void handle_get_rssi(struct wilc_vif *vif)
 
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to get RSSI value\n");
-		result = -EFAULT;
-	}
 
 	complete(&vif->hif_drv->comp_get_rssi);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static s32 handle_get_statistics(struct wilc_vif *vif,
-				 struct rf_info *stats)
+static void handle_get_statistics(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
 	struct wid wid_list[5];
 	u32 wid_cnt = 0, result = 0;
+	struct rf_info *stats = (struct rf_info *)msg->body.data;
 
 	wid_list[wid_cnt].id = WID_LINKSPEED;
 	wid_list[wid_cnt].type = WID_CHAR;
@@ -1880,12 +1937,15 @@ static s32 handle_get_statistics(struct wilc_vif *vif,
 
 	if (stats != &vif->wilc->dummy_statistics)
 		complete(&hif_wait_response);
-	return 0;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static s32 handle_get_inactive_time(struct wilc_vif *vif,
-				    struct sta_inactive_t *hif_sta_inactive)
+static void handle_get_inactive_time(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct sta_inactive_t *hif_sta_inactive = &msg->body.mac_info;
 	s32 result = 0;
 	struct wid wid;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1895,7 +1955,7 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 	wid.val = kmalloc(wid.size, GFP_KERNEL);
 	if (!wid.val)
-		return -ENOMEM;
+		goto out;
 
 	ether_addr_copy(wid.val, hif_sta_inactive->mac);
 
@@ -1905,7 +1965,7 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 
 	if (result) {
 		netdev_err(vif->ndev, "Failed to SET inactive time\n");
-		return -EFAULT;
+		goto out;
 	}
 
 	wid.id = (u16)WID_GET_INACTIVE_TIME;
@@ -1916,18 +1976,21 @@ static s32 handle_get_inactive_time(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to get inactive time\n");
-		return -EFAULT;
-	}
 
+out:
 	complete(&hif_drv->comp_inactive_time);
 
-	return result;
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_add_beacon(struct wilc_vif *vif, struct beacon_attr *param)
+static void handle_add_beacon(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct beacon_attr *param = &msg->body.beacon_info;
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
@@ -1976,10 +2039,14 @@ static void handle_add_beacon(struct wilc_vif *vif, struct beacon_attr *param)
 	kfree(wid.val);
 	kfree(param->head);
 	kfree(param->tail);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_del_beacon(struct wilc_vif *vif)
+static void handle_del_beacon(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
 	s32 result = 0;
 	struct wid wid;
 	u8 del_beacon = 0;
@@ -1993,6 +2060,8 @@ static void handle_del_beacon(struct wilc_vif *vif)
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send delete beacon\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static u32 wilc_hif_pack_sta_param(u8 *buff, struct add_sta_param *param)
@@ -2025,9 +2094,11 @@ static u32 wilc_hif_pack_sta_param(u8 *buff, struct add_sta_param *param)
 	return cur_byte - buff;
 }
 
-static void handle_add_station(struct wilc_vif *vif,
-			       struct add_sta_param *param)
+static void handle_add_station(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct add_sta_param *param = &msg->body.add_sta_info;
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
@@ -2051,11 +2122,15 @@ static void handle_add_station(struct wilc_vif *vif,
 error:
 	kfree(param->rates);
 	kfree(wid.val);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_del_all_sta(struct wilc_vif *vif,
-			       struct del_all_sta *param)
+static void handle_del_all_sta(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct del_all_sta *param = &msg->body.del_all_sta_info;
 	s32 result = 0;
 	struct wid wid;
 	u8 *curr_byte;
@@ -2092,10 +2167,15 @@ static void handle_del_all_sta(struct wilc_vif *vif,
 	kfree(wid.val);
 
 	complete(&hif_wait_response);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
+static void handle_del_station(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct del_sta *param = &msg->body.del_sta_info;
 	s32 result = 0;
 	struct wid wid;
 
@@ -2116,11 +2196,15 @@ static void handle_del_station(struct wilc_vif *vif, struct del_sta *param)
 
 error:
 	kfree(wid.val);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_edit_station(struct wilc_vif *vif,
-				struct add_sta_param *param)
+static void handle_edit_station(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct add_sta_param *param = &msg->body.edit_sta_info;
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
@@ -2144,6 +2228,8 @@ static void handle_edit_station(struct wilc_vif *vif,
 error:
 	kfree(param->rates);
 	kfree(wid.val);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static int handle_remain_on_chan(struct wilc_vif *vif,
@@ -2213,9 +2299,11 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 	return result;
 }
 
-static int handle_register_frame(struct wilc_vif *vif,
-				 struct reg_frame *hif_reg_frame)
+static void handle_register_frame(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct reg_frame *hif_reg_frame = &msg->body.reg_frame;
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
@@ -2224,7 +2312,7 @@ static int handle_register_frame(struct wilc_vif *vif,
 	wid.type = WID_STR;
 	wid.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
 	if (!wid.val)
-		return -ENOMEM;
+		goto out;
 
 	cur_byte = wid.val;
 
@@ -2237,17 +2325,19 @@ static int handle_register_frame(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	kfree(wid.val);
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to frame register\n");
-		result = -EINVAL;
-	}
 
-	return result;
+out:
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static u32 handle_listen_state_expired(struct wilc_vif *vif,
-				       struct remain_ch *hif_remain_ch)
+static void handle_listen_state_expired(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct remain_ch *hif_remain_ch = &msg->body.remain_on_ch;
 	u8 remain_on_chan_flag;
 	struct wid wid;
 	s32 result = 0;
@@ -2261,7 +2351,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		wid.val = kmalloc(wid.size, GFP_KERNEL);
 
 		if (!wid.val)
-			return -ENOMEM;
+			goto free_msg;
 
 		wid.val[0] = remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
@@ -2271,7 +2361,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		kfree(wid.val);
 		if (result != 0) {
 			netdev_err(vif->ndev, "Failed to set remain channel\n");
-			return result;
+			goto free_msg;
 		}
 
 		if (hif_drv->remain_on_ch.expired) {
@@ -2281,10 +2371,11 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 		p2p_listen_state = 0;
 	} else {
 		netdev_dbg(vif->ndev, "Not in listen state\n");
-		result = -EFAULT;
 	}
 
-	return result;
+free_msg:
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
 static void listen_timer_cb(struct timer_list *t)
@@ -2298,7 +2389,7 @@ static void listen_timer_cb(struct timer_list *t)
 	del_timer(&vif->hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.fn = handle_listen_state_expired;
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = vif->hif_drv->remain_on_ch.id;
 
@@ -2307,9 +2398,11 @@ static void listen_timer_cb(struct timer_list *t)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 }
 
-static void handle_power_management(struct wilc_vif *vif,
-				    struct power_mgmt_param *pm_param)
+static void handle_power_management(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct power_mgmt_param *pm_param = &msg->body.pwr_mgmt_info;
 	s32 result = 0;
 	struct wid wid;
 	s8 power_mode;
@@ -2328,11 +2421,15 @@ static void handle_power_management(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send power management\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_set_mcast_filter(struct wilc_vif *vif,
-				    struct set_multicast *hif_set_mc)
+static void handle_set_mcast_filter(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	struct set_multicast *hif_set_mc = &msg->body.multicast_info;
 	s32 result = 0;
 	struct wid wid;
 	u8 *cur_byte;
@@ -2366,10 +2463,15 @@ static void handle_set_mcast_filter(struct wilc_vif *vif,
 
 error:
 	kfree(wid.val);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
+static void handle_set_tx_pwr(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	u8 tx_pwr = msg->body.tx_power.tx_pwr;
 	int ret;
 	struct wid wid;
 
@@ -2382,10 +2484,15 @@ static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
 				   wilc_get_vif_idx(vif));
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set TX PWR\n");
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
+static void handle_get_tx_pwr(struct work_struct *work)
 {
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc_vif *vif = msg->vif;
+	u8 *tx_pwr = &msg->body.tx_power.tx_pwr;
 	int ret = 0;
 	struct wid wid;
 
@@ -2400,174 +2507,50 @@ static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
 	complete(&hif_wait_response);
+	kfree(msg);
+	complete(&hif_thread_comp);
 }
 
-static void host_if_work(struct work_struct *work)
+static void handle_scan_timer(struct work_struct *work)
 {
-	struct host_if_msg *msg;
-	struct wilc *wilc;
-	int ret = 0;
-
-	msg = container_of(work, struct host_if_msg, work);
-	wilc = msg->vif->wilc;
-
-	if (msg->id == HOST_IF_MSG_CONNECT &&
-	    msg->vif->hif_drv->usr_scan_req.scan_result) {
-		wilc_enqueue_cmd(msg);
-		usleep_range(2 * 1000, 2 * 1000);
-		goto free_msg;
-	}
-	switch (msg->id) {
-	case HOST_IF_MSG_SCAN:
-		handle_scan(msg->vif, &msg->body.scan_info);
-		break;
-
-	case HOST_IF_MSG_CONNECT:
-		handle_connect(msg->vif, &msg->body.con_info);
-		break;
-
-	case HOST_IF_MSG_RCVD_NTWRK_INFO:
-		handle_rcvd_ntwrk_info(msg->vif, &msg->body.net_info);
-		break;
-
-	case HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO:
-		handle_rcvd_gnrl_async_info(msg->vif,
-					    &msg->body.async_info);
-		break;
-
-	case HOST_IF_MSG_KEY:
-		handle_key(msg->vif, &msg->body.key_info);
-		break;
-
-	case HOST_IF_MSG_CFG_PARAMS:
-		handle_cfg_param(msg->vif, &msg->body.cfg_info);
-		break;
-
-	case HOST_IF_MSG_SET_CHANNEL:
-		handle_set_channel(msg->vif, &msg->body.channel_info);
-		break;
-
-	case HOST_IF_MSG_DISCONNECT:
-		handle_disconnect(msg->vif);
-		break;
-
-	case HOST_IF_MSG_RCVD_SCAN_COMPLETE:
-		del_timer(&msg->vif->hif_drv->scan_timer);
-
-		if (!wilc_wlan_get_num_conn_ifcs(wilc))
-			wilc_chip_sleep_manually(wilc);
-
-		handle_scan_done(msg->vif, SCAN_EVENT_DONE);
-
-		if (msg->vif->hif_drv->remain_on_ch_pending)
-			handle_remain_on_chan(msg->vif,
-					      &msg->body.remain_on_ch);
-
-		break;
-
-	case HOST_IF_MSG_GET_RSSI:
-		handle_get_rssi(msg->vif);
-		break;
-
-	case HOST_IF_MSG_GET_STATISTICS:
-		handle_get_statistics(msg->vif,
-				      (struct rf_info *)msg->body.data);
-		break;
-
-	case HOST_IF_MSG_ADD_BEACON:
-		handle_add_beacon(msg->vif, &msg->body.beacon_info);
-		break;
-
-	case HOST_IF_MSG_DEL_BEACON:
-		handle_del_beacon(msg->vif);
-		break;
-
-	case HOST_IF_MSG_ADD_STATION:
-		handle_add_station(msg->vif, &msg->body.add_sta_info);
-		break;
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 
-	case HOST_IF_MSG_DEL_STATION:
-		handle_del_station(msg->vif, &msg->body.del_sta_info);
-		break;
-
-	case HOST_IF_MSG_EDIT_STATION:
-		handle_edit_station(msg->vif, &msg->body.edit_sta_info);
-		break;
-
-	case HOST_IF_MSG_GET_INACTIVETIME:
-		handle_get_inactive_time(msg->vif, &msg->body.mac_info);
-		break;
+	handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
+	kfree(msg);
+	complete(&hif_thread_comp);
+}
 
-	case HOST_IF_MSG_SCAN_TIMER_FIRED:
-		handle_scan_done(msg->vif, SCAN_EVENT_ABORTED);
-		break;
+static void handle_remain_on_chan_work(struct work_struct *work)
+{
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 
-	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-		handle_connect_timeout(msg->vif);
-		break;
+	handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
+	kfree(msg);
+	complete(&hif_thread_comp);
+}
 
-	case HOST_IF_MSG_POWER_MGMT:
-		handle_power_management(msg->vif,
-					&msg->body.pwr_mgmt_info);
-		break;
+static void handle_hif_exit_work(struct work_struct *work)
+{
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
 
-	case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-		ret = handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
-		break;
+	kfree(msg);
+	complete(&hif_thread_comp);
+}
 
-	case HOST_IF_MSG_SET_OPERATION_MODE:
-		handle_set_operation_mode(msg->vif, &msg->body.mode);
-		break;
+static void handle_scan_complete(struct work_struct *work)
+{
+	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
+	struct wilc *wilc = msg->vif->wilc;
 
-	case HOST_IF_MSG_SET_IPADDRESS:
-		handle_set_ip_address(msg->vif,
-				      msg->body.ip_info.ip_addr,
-				      msg->body.ip_info.idx);
-		break;
+	del_timer(&msg->vif->hif_drv->scan_timer);
 
-	case HOST_IF_MSG_GET_IPADDRESS:
-		handle_get_ip_address(msg->vif, msg->body.ip_info.idx);
-		break;
+	if (!wilc_wlan_get_num_conn_ifcs(wilc))
+		wilc_chip_sleep_manually(wilc);
 
-	case HOST_IF_MSG_GET_MAC_ADDRESS:
-		handle_get_mac_address(msg->vif,
-				       &msg->body.get_mac_info);
-		break;
+	handle_scan_done(msg->vif, SCAN_EVENT_DONE);
 
-	case HOST_IF_MSG_REMAIN_ON_CHAN:
+	if (msg->vif->hif_drv->remain_on_ch_pending)
 		handle_remain_on_chan(msg->vif, &msg->body.remain_on_ch);
-		break;
-
-	case HOST_IF_MSG_REGISTER_FRAME:
-		handle_register_frame(msg->vif, &msg->body.reg_frame);
-		break;
-
-	case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-		handle_listen_state_expired(msg->vif, &msg->body.remain_on_ch);
-		break;
-
-	case HOST_IF_MSG_SET_MULTICAST_FILTER:
-		handle_set_mcast_filter(msg->vif, &msg->body.multicast_info);
-		break;
-
-	case HOST_IF_MSG_DEL_ALL_STA:
-		handle_del_all_sta(msg->vif, &msg->body.del_all_sta_info);
-		break;
-
-	case HOST_IF_MSG_SET_TX_POWER:
-		handle_set_tx_pwr(msg->vif, msg->body.tx_power.tx_pwr);
-		break;
-
-	case HOST_IF_MSG_GET_TX_POWER:
-		handle_get_tx_pwr(msg->vif, &msg->body.tx_power.tx_pwr);
-		break;
-	default:
-		netdev_err(msg->vif->ndev, "[Host Interface] undefined\n");
-		break;
-	}
-free_msg:
-	if (ret)
-		netdev_err(msg->vif->ndev, "Host cmd %d failed\n", msg->id);
 	kfree(msg);
 	complete(&hif_thread_comp);
 }
@@ -2580,7 +2563,7 @@ static void timer_scan_cb(struct timer_list *t)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.vif = vif;
-	msg.id = HOST_IF_MSG_SCAN_TIMER_FIRED;
+	msg.fn = handle_scan_timer;
 
 	wilc_enqueue_cmd(&msg);
 }
@@ -2594,7 +2577,7 @@ static void timer_connect_cb(struct timer_list *t)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.vif = vif;
-	msg.id = HOST_IF_MSG_CONNECT_TIMER_FIRED;
+	msg.fn = handle_connect_timeout;
 
 	wilc_enqueue_cmd(&msg);
 }
@@ -2613,7 +2596,7 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = REMOVEKEY;
 	msg.vif = vif;
@@ -2642,7 +2625,7 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = DEFAULTKEY;
 	msg.vif = vif;
@@ -2671,7 +2654,7 @@ int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
 	msg.vif = vif;
@@ -2707,7 +2690,7 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.vif = vif;
@@ -2753,7 +2736,7 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WPA_PTK;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
@@ -2820,7 +2803,7 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 			return -ENOMEM;
 	}
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = WPA_RX_GTK;
 	msg.vif = vif;
 
@@ -2872,7 +2855,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_KEY;
+	msg.fn = handle_key;
 	msg.body.key_info.type = PMKSA;
 	msg.body.key_info.action = ADDKEY;
 	msg.vif = vif;
@@ -2898,7 +2881,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_GET_MAC_ADDRESS;
+	msg.fn = handle_get_mac_address;
 	msg.body.get_mac_info.mac_addr = mac_addr;
 	msg.vif = vif;
 
@@ -2934,8 +2917,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_CONNECT;
-
+	msg.fn = handle_connect;
 	msg.body.con_info.security = security;
 	msg.body.con_info.auth_type = auth_type;
 	msg.body.con_info.ch = channel;
@@ -2992,7 +2974,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_DISCONNECT;
+	msg.fn = handle_disconnect;
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
@@ -3035,7 +3017,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_SET_CHANNEL;
+	msg.fn = handle_set_channel;
 	msg.body.channel_info.set_ch = channel;
 	msg.vif = vif;
 
@@ -3055,7 +3037,7 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
+	msg.fn = handle_set_wfi_drv_handler;
 	msg.body.drv.handler = index;
 	msg.body.drv.mode = mode;
 	msg.body.drv.name = ifc_id;
@@ -3076,7 +3058,7 @@ int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode)
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
+	msg.fn = handle_set_operation_mode;
 	msg.body.mode.mode = mode;
 	msg.vif = vif;
 
@@ -3104,7 +3086,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	memcpy(msg.body.mac_info.mac, mac, ETH_ALEN);
 
-	msg.id = HOST_IF_MSG_GET_INACTIVETIME;
+	msg.fn = handle_get_inactive_time;
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
@@ -3125,7 +3107,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_GET_RSSI;
+	msg.fn = handle_get_rssi;
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
@@ -3152,7 +3134,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_GET_STATISTICS;
+	msg.fn = handle_get_statistics;
 	msg.body.data = (char *)stats;
 	msg.vif = vif;
 
@@ -3184,7 +3166,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_SCAN;
+	msg.fn = handle_scan;
 
 	if (hidden_network) {
 		scan_info->hidden_network.net_info = hidden_network->net_info;
@@ -3234,7 +3216,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 	}
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_CFG_PARAMS;
+	msg.fn = handle_cfg_param;
 	msg.body.cfg_info = *cfg_param;
 	msg.vif = vif;
 
@@ -3364,7 +3346,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
-		msg.id = HOST_IF_MSG_EXIT;
+		msg.fn = handle_hif_exit_work;
 		msg.vif = vif;
 
 		result = wilc_enqueue_cmd(&msg);
@@ -3408,7 +3390,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
+	msg.fn = handle_rcvd_ntwrk_info;
 	msg.vif = vif;
 
 	msg.body.net_info.len = length;
@@ -3458,7 +3440,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
+	msg.fn = handle_rcvd_gnrl_async_info;
 	msg.vif = vif;
 
 	msg.body.async_info.len = length;
@@ -3500,7 +3482,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
 	if (hif_drv->usr_scan_req.scan_result) {
 		memset(&msg, 0, sizeof(struct host_if_msg));
 
-		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
+		msg.fn = handle_scan_complete;
 		msg.vif = vif;
 
 		result = wilc_enqueue_cmd(&msg);
@@ -3520,7 +3502,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
+	msg.fn = handle_remain_on_chan_work;
 	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.expired = expired;
 	msg.body.remain_on_ch.ready = ready;
@@ -3550,7 +3532,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 	del_timer(&hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
-	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
+	msg.fn = handle_listen_state_expired;
 	msg.vif = vif;
 	msg.body.remain_on_ch.id = session_id;
 
@@ -3568,7 +3550,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_REGISTER_FRAME;
+	msg.fn = handle_register_frame;
 	switch (frame_type) {
 	case ACTION:
 		msg.body.reg_frame.reg_id = ACTION_FRM_IDX;
@@ -3601,7 +3583,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_ADD_BEACON;
+	msg.fn = handle_add_beacon;
 	msg.vif = vif;
 	beacon_info->interval = interval;
 	beacon_info->dtim_period = dtim_period;
@@ -3642,7 +3624,7 @@ int wilc_del_beacon(struct wilc_vif *vif)
 	int result = 0;
 	struct host_if_msg msg;
 
-	msg.id = HOST_IF_MSG_DEL_BEACON;
+	msg.fn = handle_del_beacon;
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
@@ -3660,7 +3642,7 @@ int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_ADD_STATION;
+	msg.fn = handle_add_station;
 	msg.vif = vif;
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
@@ -3688,7 +3670,7 @@ int wilc_del_station(struct wilc_vif *vif, const u8 *mac_addr)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_DEL_STATION;
+	msg.fn = handle_del_station;
 	msg.vif = vif;
 
 	if (!mac_addr)
@@ -3713,7 +3695,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_DEL_ALL_STA;
+	msg.fn = handle_del_all_sta;
 	msg.vif = vif;
 
 	for (i = 0; i < MAX_NUM_STA; i++) {
@@ -3746,7 +3728,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_EDIT_STATION;
+	msg.fn = handle_edit_station;
 	msg.vif = vif;
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
@@ -3778,7 +3760,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_POWER_MGMT;
+	msg.fn = handle_power_management;
 	msg.vif = vif;
 
 	pwr_mgmt_info->enabled = enabled;
@@ -3799,7 +3781,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_SET_MULTICAST_FILTER;
+	msg.fn = handle_set_mcast_filter;
 	msg.vif = vif;
 
 	multicast_filter_param->enabled = enabled;
@@ -3983,7 +3965,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_SET_IPADDRESS;
+	msg.fn = handle_set_ip_address;
 
 	msg.body.ip_info.ip_addr = ip_addr;
 	msg.vif = vif;
@@ -4003,7 +3985,7 @@ static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_GET_IPADDRESS;
+	msg.fn = handle_get_ip_address;
 
 	msg.body.ip_info.ip_addr = ip_addr;
 	msg.vif = vif;
@@ -4023,7 +4005,7 @@ int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_SET_TX_POWER;
+	msg.fn = handle_set_tx_pwr;
 	msg.body.tx_power.tx_pwr = tx_power;
 	msg.vif = vif;
 
@@ -4041,7 +4023,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-	msg.id = HOST_IF_MSG_GET_TX_POWER;
+	msg.fn = handle_get_tx_pwr;
 	msg.vif = vif;
 
 	ret = wilc_enqueue_cmd(&msg);
-- 
2.7.4
