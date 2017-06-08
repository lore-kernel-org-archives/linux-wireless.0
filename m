Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:62096 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdFHFJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 01:09:05 -0400
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <gregkh@linuxfoundation.org>
CC: <ganesh.krishna@microchip.com>, <linux-wireless@vger.kernel.org>,
        <arend.vanspriel@broadcom.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v4] staging: wilc1000: New cfg packet format in handle_set_wfi_drv_handler
Date: Thu, 8 Jun 2017 10:37:23 +0530
Message-ID: <1496898443-5133-1-git-send-email-aditya.shankar@microchip.com> (sfid-20170608_070909_600129_BA5F8C05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the config packet format used in handle_set_wfi_drv_handler()
to align the host driver with the new format used in the wilc firmware.

The change updates the format in which the host driver provides the
firmware with the drv_handler index and also uses two new
fields viz. "mode" and 'name" in the config packet along with this index
to directly provide details about the interface and its mode to the
firmware instead of having multiple if-else statements in the host driver
to decide which interface to configure.

This change requires users to move to the newer version of the wilc
firmware(14.02 or higher) available on the vendor tree on github or on the
linux-firmware project. The existing firmware files on the linux-firmware
project are very old and best not used.

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
---
Change in v2: Fix build warning
Change in v3: Address review comments from v2
Change in v4:
- Address review comments from v3.
- The new firmwaie is available as part of the commit below
http://lkml.kernel.org/r/1496479001-2733-1-git-send-email-aditya.shankar@microchip.com
- Will update the firmware name as part of a separate patch.
---
 drivers/staging/wilc1000/host_interface.c         | 68 +++++++++++++++++------
 drivers/staging/wilc1000/host_interface.h         |  9 ++-
 drivers/staging/wilc1000/linux_wlan.c             | 37 ++++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 drivers/staging/wilc1000/wilc_wlan_if.h           |  2 +-
 6 files changed, 71 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c8e3229..f7c22d7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -329,25 +329,53 @@ static void handle_set_channel(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set channel\n");
 }
 
-static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
-				       struct drv_handler *hif_drv_handler)
+static int handle_set_wfi_drv_handler(struct wilc_vif *vif,
+				      struct drv_handler *hif_drv_handler)
 {
 	int ret = 0;
 	struct wid wid;
+	u8 *currbyte, *buffer;
+	struct host_if_drv *hif_drv = NULL;
+
+	if (!vif->hif_drv)
+		return -EINVAL;
+
+	if (!hif_drv_handler)
+		return -EINVAL;
+
+	hif_drv	= vif->hif_drv;
+
+	buffer = kzalloc(DRV_HANDLER_SIZE, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	currbyte = buffer;
+	*currbyte = hif_drv->driver_handler_id & DRV_HANDLER_MASK;
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
-
-	if (!hif_drv_handler->handler)
-		complete(&hif_driver_comp);
-
-	if (ret)
+				   hif_drv->driver_handler_id);
+	if (ret) {
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
+		complete(&hif_driver_comp);
+		kfree(buffer);
+		return ret;
+	}
+	complete(&hif_driver_comp);
+	kfree(buffer);
+	return 0;
 }
 
 static void handle_set_operation_mode(struct wilc_vif *vif,
@@ -2389,9 +2417,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 
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
@@ -2449,6 +2477,7 @@ static void host_if_work(struct work_struct *work)
 {
 	struct host_if_msg *msg;
 	struct wilc *wilc;
+	int ret = 0;
 
 	msg = container_of(work, struct host_if_msg, work);
 	wilc = msg->vif->wilc;
@@ -2554,7 +2583,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_SET_WFIDRV_HANDLER:
-		handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
+		ret = handle_set_wfi_drv_handler(msg->vif, &msg->body.drv);
 		break;
 
 	case HOST_IF_MSG_SET_OPERATION_MODE:
@@ -2608,6 +2637,8 @@ static void host_if_work(struct work_struct *work)
 		break;
 	}
 free_msg:
+	if (ret)
+		netdev_err(msg->vif->ndev, "Host cmd %d failed\n", msg->id);
 	kfree(msg);
 	complete(&hif_thread_comp);
 }
@@ -3085,7 +3116,8 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 	return 0;
 }
 
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
+			     u8 ifc_id)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3093,7 +3125,8 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
 	msg.body.drv.handler = index;
-	msg.body.drv.mac_idx = mac_idx;
+	msg.body.drv.mode = mode;
+	msg.body.drv.name = ifc_id;
 	msg.vif = vif;
 
 	result = wilc_enqueue_cmd(&msg);
@@ -3316,6 +3349,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	for (i = 0; i < wilc->vif_num; i++)
 		if (dev == wilc->vif[i]->ndev) {
 			wilc->vif[i]->hif_drv = hif_drv;
+			hif_drv->driver_handler_id = i + 1;
 			break;
 		}
 
@@ -3389,7 +3423,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(vif, 0, 0);
+	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
 	wait_for_completion(&hif_driver_comp);
 
 	if (hif_drv->usr_scan_req.scan_result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0e72b91..1ce5ead 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -50,6 +50,8 @@
 #define WILC_ADD_STA_LENGTH			40
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
+#define DRV_HANDLER_SIZE			5
+#define DRV_HANDLER_MASK			0x000000FF
 
 struct rf_info {
 	u8 link_speed;
@@ -216,7 +218,8 @@ struct user_conn_req {
 
 struct drv_handler {
 	u32 handler;
-	u8 mac_idx;
+	u8 mode;
+	u8 name;
 };
 
 struct op_mode {
@@ -280,6 +283,7 @@ struct host_if_drv {
 	struct timer_list remain_on_ch_timer;
 
 	bool IFC_UP;
+	int driver_handler_id;
 };
 
 struct add_sta_param {
@@ -348,7 +352,8 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   void *user_arg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
-int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mac_idx);
+int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
+			     u8 ifc_id);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d6d8034..3087084 100644
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
+						 vif->iftype, vif->ifc_id);
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
 
@@ -1246,11 +1227,13 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		vif = netdev_priv(ndev);
 		memset(vif, 0, sizeof(struct wilc_vif));
 
-		if (i == 0)
+		if (i == 0) {
 			strcpy(ndev->name, "wlan%d");
-		else
+			vif->ifc_id = 1;
+		} else {
 			strcpy(ndev->name, "p2p%d");
-
+			vif->ifc_id = 0;
+		}
 		vif->wilc = *wilc;
 		vif->ndev = ndev;
 		wl->vif[i] = vif;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index cae9c8f..68fd5b3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1874,7 +1874,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 0);
+						 0, vif->ifc_id);
 			wilc_set_operation_mode(vif, AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d431673..c89bf43 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -158,6 +158,7 @@ struct wilc_vif {
 	struct host_if_drv *hif_drv;
 	struct net_device *ndev;
 	u8 mode;
+	u8 ifc_id;
 };
 
 struct wilc {
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
