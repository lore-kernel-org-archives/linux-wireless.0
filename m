Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:17303 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933224AbdDGLyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 07:54:24 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Update handler assignment logic
Date: Fri, 7 Apr 2017 17:24:05 +0530
Message-ID: <1491566045-9265-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170407_135448_520977_5ECBAE51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this update, the host driver is consistent with the
implementation on the firmware side with respect to obtaining
the driver handler for all modes.
With this new format, the calls to set the wilc operation mode
is simplified.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 56 +++++++++++++++++++----
 drivers/staging/wilc1000/host_interface.h         |  9 +++-
 drivers/staging/wilc1000/linux_wlan.c             | 29 ++----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
 5 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3a8af0..c04643e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -198,6 +198,7 @@ struct host_if_msg {
 	union message_body body;
 	struct wilc_vif *vif;
 	struct work_struct work;
+	void *drv_handler;
 };
 
 struct join_bss_param {
@@ -334,14 +335,44 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
 {
 	int ret = 0;
 	struct wid wid;
+	u8 *currbyte;
+	struct host_if_drv *hif_drv = NULL;
+	int driver_handler_id = 0;
+	u8 *buffer = kzalloc(DRV_HANDLER_SIZE, GFP_ATOMIC);
+
+	if (!vif->hif_drv)
+		return;
+
+	if (!hif_drv_handler)
+		return;
+
+	hif_drv	= vif->hif_drv;
+
+	if (hif_drv)
+		driver_handler_id = hif_drv->driver_handler_id;
+	else
+		driver_handler_id = 0;
+
+	driver_handler_id = hif_drv->driver_handler_id;
+
+	currbyte = buffer;
+	*currbyte = driver_handler_id & DRV_HANDLER_MASK;
+	currbyte++;
+	*currbyte = (u32)0 & DRV_HANDLER_MASK;
+	currbyte++;
+	*currbyte = (u32)0 & DRV_HANDLER_MASK;
+	currbyte++;
+	*currbyte = (u32)0 & DRV_HANDLER_MASK;
+	currbyte++;
+	*currbyte = (hif_drv_handler->name | (hif_drv_handler->mode << 1));
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_STR;
-	wid.val = (s8 *)hif_drv_handler;
-	wid.size = sizeof(*hif_drv_handler);
+	wid.val = (s8 *)buffer;
+	wid.size = DRV_HANDLER_SIZE;
 
 	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				   hif_drv_handler->handler);
+				   driver_handler_id);
 
 	if (!hif_drv_handler->handler)
 		complete(&hif_driver_comp);
@@ -2403,9 +2434,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 
 	pu8CurrByte = wid.val;
 	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = 0;
-	*pu8CurrByte++ = 0;
-	*pu8CurrByte++ = 0;
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
+	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
 
 	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
@@ -3099,7 +3130,8 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	return 0;
 }
 
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode, char
+			     *ifname)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3107,9 +3139,14 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.handler = index;
-	msg.body.drv.mac_idx = mac_idx;
+	msg.body.drv.mode = mode;
 	msg.vif = vif;
 
+	if (!memcmp(ifname, "wlan0", 5))
+	msg.body.drv.name = 1;
+	else if (!memcmp(ifname, "p2p0", 4))
+	msg.body.drv.name = 0;
+
 	result = wilc_enqueue_cmd(&msg);
 	if (result) {
 		netdev_err(vif->ndev, "wilc mq send fail\n");
@@ -3330,6 +3367,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	for (i = 0; i < wilc->vif_num; i++)
 		if (dev == wilc->vif[i]->ndev) {
 			wilc->vif[i]->hif_drv = hif_drv;
+			hif_drv->driver_handler_id = i + 1;
 			break;
 		}
 
@@ -3403,7 +3441,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(vif, 0, 0);
+	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
 	wait_for_completion(&hif_driver_comp);
 
 	if (hif_drv->usr_scan_req.scan_result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f36d3b5..77e7f26 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -51,6 +51,8 @@
 #define WILC_ADD_STA_LENGTH			40
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
+#define DRV_HANDLER_SIZE			5
+#define DRV_HANDLER_MASK			0x000000FF
 
 struct rf_info {
 	u8 link_speed;
@@ -217,7 +219,8 @@ struct user_conn_req {
 
 struct drv_handler {
 	u32 handler;
-	u8 mac_idx;
+	u8 mode;
+	u8 name;
 };
 
 struct op_mode {
@@ -281,6 +284,7 @@ struct host_if_drv {
 	struct timer_list remain_on_ch_timer;
 
 	bool IFC_UP;
+	int driver_handler_id;
 };
 
 struct add_sta_param {
@@ -354,7 +358,8 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   void *user_arg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode, char
+			     *ifname);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2eebc62..cd2f602 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -858,34 +858,15 @@ static int wilc_mac_open(struct net_device *ndev)
 
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
-			if (vif->iftype == AP_MODE) {
-				wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 0);
-			} else if (!wilc_wlan_get_num_conn_ifcs(wl)) {
-				wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 wl->open_ifcs);
-			} else {
-				if (memcmp(wl->vif[i ^ 1]->bssid,
-					   wl->vif[i ^ 1]->src_addr, 6))
-					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 0);
-				else
-					wilc_set_wfi_drv_handler(vif,
-							 wilc_get_vif_idx(vif),
-							 1);
-			}
+			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
+						 vif->iftype, ndev->name);
 			wilc_set_operation_mode(vif, vif->iftype);
-
-			wilc_get_mac_address(vif, mac_add);
-			netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
-			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
-
 			break;
 		}
 	}
+			wilc_get_mac_address(vif, mac_add);
+			netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
+			memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
 
 	memcpy(ndev->dev_addr, wl->vif[i]->src_addr, ETH_ALEN);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b02a83b..d70e2e0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1887,7 +1887,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 0);
+						 0, dev->name);
 			wilc_set_operation_mode(vif, AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 439ac6f..f4d6005 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -845,7 +845,7 @@ typedef enum {
 	WID_MODEL_NAME			= 0x3027, /*Added for CAPI tool */
 	WID_MODEL_NUM			= 0x3028, /*Added for CAPI tool */
 	WID_DEVICE_NAME			= 0x3029, /*Added for CAPI tool */
-	WID_SET_DRV_HANDLER		= 0x3030,
+	WID_SET_DRV_HANDLER		= 0x3079,
 
 	/* NMAC String WID list */
 	WID_11N_P_ACTION_REQ		= 0x3080,
-- 
2.7.4
