Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2362 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731023AbeISLm4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 19/29] staging: wilc1000: avoid the use of 'hif_driver_comp' completion variable
Date: Wed, 19 Sep 2018 11:35:09 +0530
Message-ID: <1537337119-14952-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080639_152032_A399BE4A)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using extra completion variable to handle the sync call now
using msg->is_sync flag to handle the sync call.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 23 +++++++++++------------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/linux_wlan.c             |  3 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 237a098d..529390d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -187,7 +187,6 @@ struct join_bss_param {
 };
 
 static struct host_if_drv *terminated_handle;
-static struct completion hif_driver_comp;
 static struct mutex hif_deinit_lock;
 
 /* 'msg' should be free by the caller for syc */
@@ -310,10 +309,12 @@ static void handle_set_wfi_drv_handler(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
 
-	complete(&hif_driver_comp);
 	kfree(buffer);
 
 free_msg:
+	if (msg->is_sync)
+		complete(&msg->work_comp);
+
 	kfree(msg);
 }
 
@@ -333,9 +334,6 @@ static void handle_set_operation_mode(struct work_struct *work)
 	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				   wilc_get_vif_idx(vif));
 
-	if (hif_op_mode->mode == IDLE_MODE)
-		complete(&hif_driver_comp);
-
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set operation mode\n");
 
@@ -3118,12 +3116,12 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel)
 }
 
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
-			     u8 ifc_id)
+			     u8 ifc_id, bool is_sync)
 {
 	int result;
 	struct host_if_msg *msg;
 
-	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler, false);
+	msg = wilc_alloc_work(vif, handle_set_wfi_drv_handler, is_sync);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -3135,8 +3133,12 @@ int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
 	if (result) {
 		netdev_err(vif->ndev, "%s: enqueue work failed\n", __func__);
 		kfree(msg);
+		return result;
 	}
 
+	if (is_sync)
+		wait_for_completion(&msg->work_comp);
+
 	return result;
 }
 
@@ -3380,10 +3382,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	vif->obtaining_ip = false;
 
-	if (wilc->clients_count == 0) {
-		init_completion(&hif_driver_comp);
+	if (wilc->clients_count == 0)
 		mutex_init(&hif_deinit_lock);
-	}
 
 	timer_setup(&vif->periodic_rssi, get_periodic_rssi, 0);
 	mod_timer(&vif->periodic_rssi, jiffies + msecs_to_jiffies(5000));
@@ -3430,8 +3430,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&vif->periodic_rssi);
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
-	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
-	wait_for_completion(&hif_driver_comp);
+	wilc_set_wfi_drv_handler(vif, 0, 0, 0, true);
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 15ffaeb..4416f8f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -350,7 +350,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 void wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index, u8 mode,
-			     u8 ifc_id);
+			     u8 ifc_id, bool is_sync);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats,
 			bool is_sync);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8ecd664..b666e1e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -753,7 +753,8 @@ static int wilc_mac_open(struct net_device *ndev)
 	for (i = 0; i < wl->vif_num; i++) {
 		if (ndev == wl->vif[i]->ndev) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 vif->iftype, vif->ifc_id);
+						 vif->iftype, vif->ifc_id,
+						 false);
 			wilc_set_operation_mode(vif, vif->iftype);
 			break;
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 02a8846..76d017d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1779,7 +1779,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		if (wl->initialized) {
 			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
-						 0, vif->ifc_id);
+						 0, vif->ifc_id, false);
 			wilc_set_operation_mode(vif, AP_MODE);
 			wilc_set_power_mgmt(vif, 0, 0);
 		}
-- 
2.7.4
