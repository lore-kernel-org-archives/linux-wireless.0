Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57899 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:36:47 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/24] staging: wilc1000: move hif specific static variables to 'wilc' structure
Date: Tue, 14 Aug 2018 12:20:03 +0530
Message-ID: <1534229416-13254-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085102_262914_4C275A56)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variable and move it in 'wilc' structure related to
hif and added NULL before accessing hif_workqueue in wilc_enqueue_work().

Below variables are moved to 'wilc' struct:
 struct workqueue_struct *hif_workqueue;
 struct mutex hif_deinit_lock;
 struct completion hif_driver_comp;

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 43 ++++++++++++++-------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  4 +++
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 642c314..d5d81843 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -187,9 +187,6 @@ struct join_bss_param {
 
 static struct host_if_drv *terminated_handle;
 static u8 p2p_listen_state;
-static struct workqueue_struct *hif_workqueue;
-static struct completion hif_driver_comp;
-static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
 static struct wilc_vif *periodic_rssi_vif;
 
@@ -225,7 +222,11 @@ wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
 static int wilc_enqueue_work(struct host_if_msg *msg)
 {
 	INIT_WORK(&msg->work, msg->fn);
-	if (!hif_workqueue || !queue_work(hif_workqueue, &msg->work))
+
+	if (!msg->vif || !msg->vif->wilc || !msg->vif->wilc->hif_workqueue)
+		return -EINVAL;
+
+	if (!queue_work(msg->vif->wilc->hif_workqueue, &msg->work))
 		return -EINVAL;
 
 	return 0;
@@ -316,7 +317,7 @@ static void handle_set_wfi_drv_handler(struct work_struct *work)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
 
-	complete(&hif_driver_comp);
+	complete(&vif->wilc->hif_driver_comp);
 	kfree(buffer);
 
 free_msg:
@@ -340,7 +341,7 @@ static void handle_set_operation_mode(struct work_struct *work)
 				   wilc_get_vif_idx(vif));
 
 	if (hif_op_mode->mode == IDLE_MODE)
-		complete(&hif_driver_comp);
+		complete(&vif->wilc->hif_driver_comp);
 
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set operation mode\n");
@@ -3454,11 +3455,11 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	vif->obtaining_ip = false;
 
 	if (wilc->clients_count == 0) {
-		init_completion(&hif_driver_comp);
-		mutex_init(&hif_deinit_lock);
+		init_completion(&wilc->hif_driver_comp);
+		mutex_init(&wilc->hif_deinit_lock);
 
-		hif_workqueue = create_singlethread_workqueue("WILC_wq");
-		if (!hif_workqueue) {
+		wilc->hif_workqueue = create_singlethread_workqueue("WILC_wq");
+		if (!wilc->hif_workqueue) {
 			netdev_err(vif->ndev, "Failed to create workqueue\n");
 			kfree(hif_drv);
 			return -ENOMEM;
@@ -3502,7 +3503,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		return -EFAULT;
 	}
 
-	mutex_lock(&hif_deinit_lock);
+	mutex_lock(&vif->wilc->hif_deinit_lock);
 
 	terminated_handle = hif_drv;
 
@@ -3512,7 +3513,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	wilc_set_wfi_drv_handler(vif, 0, 0, 0);
-	wait_for_completion(&hif_driver_comp);
+	wait_for_completion(&vif->wilc->hif_driver_comp);
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
@@ -3536,14 +3537,14 @@ int wilc_deinit(struct wilc_vif *vif)
 				wait_for_completion(&msg->work_comp);
 			kfree(msg);
 		}
-		destroy_workqueue(hif_workqueue);
+		destroy_workqueue(vif->wilc->hif_workqueue);
 	}
 
 	kfree(hif_drv);
 
 	vif->wilc->clients_count--;
 	terminated_handle = NULL;
-	mutex_unlock(&hif_deinit_lock);
+	mutex_unlock(&vif->wilc->hif_deinit_lock);
 	return result;
 }
 
@@ -3596,7 +3597,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 
-	mutex_lock(&hif_deinit_lock);
+	mutex_lock(&wilc->hif_deinit_lock);
 
 	id = buffer[length - 4];
 	id |= (buffer[length - 3] << 8);
@@ -3604,26 +3605,26 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	id |= (buffer[length - 1] << 24);
 	vif = wilc_get_vif_from_idx(wilc, id);
 	if (!vif) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
 
 	hif_drv = vif->hif_drv;
 
 	if (!hif_drv || hif_drv == terminated_handle) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
 
 	if (!hif_drv->usr_conn_req.conn_result) {
 		netdev_err(vif->ndev, "%s: conn_result is NULL\n", __func__);
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
 
 	msg = wilc_alloc_work(vif, handle_rcvd_gnrl_async_info, false);
 	if (IS_ERR(msg)) {
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
 
@@ -3631,7 +3632,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 	msg->body.async_info.buffer = kmemdup(buffer, length, GFP_KERNEL);
 	if (!msg->body.async_info.buffer) {
 		kfree(msg);
-		mutex_unlock(&hif_deinit_lock);
+		mutex_unlock(&wilc->hif_deinit_lock);
 		return;
 	}
 
@@ -3642,7 +3643,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 length)
 		kfree(msg);
 	}
 
-	mutex_unlock(&hif_deinit_lock);
+	mutex_unlock(&wilc->hif_deinit_lock);
 }
 
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ee8eda7..eb00e42 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -173,6 +173,10 @@ struct wilc {
 	struct rf_info dummy_statistics;
 	bool enable_ps;
 	int clients_count;
+	struct workqueue_struct *hif_workqueue;
+	/* deinitialization lock */
+	struct mutex hif_deinit_lock;
+	struct completion hif_driver_comp;
 };
 
 struct wilc_wfi_mon_priv {
-- 
2.7.4
