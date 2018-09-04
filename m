Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53839 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbeIDLEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:07 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 11/26] staging: wilc1000: move hif_workqueue static variables to 'wilc' structure
Date: Tue, 4 Sep 2018 12:09:27 +0530
Message-ID: <1536043182-19735-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084030_047480_4D2CD692)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid use of static variable hif_workqueue and move it inside 'wilc'
structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c     | 13 ++++++++-----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f5617ac..6facffc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -188,7 +188,6 @@ struct join_bss_param {
 
 static struct host_if_drv *terminated_handle;
 static u8 p2p_listen_state;
-static struct workqueue_struct *hif_workqueue;
 static struct completion hif_driver_comp;
 static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
@@ -226,7 +225,11 @@ wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
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
@@ -3459,8 +3462,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
 
-		hif_workqueue = create_singlethread_workqueue("WILC_wq");
-		if (!hif_workqueue) {
+		wilc->hif_workqueue = create_singlethread_workqueue("WILC_wq");
+		if (!wilc->hif_workqueue) {
 			netdev_err(vif->ndev, "Failed to create workqueue\n");
 			kfree(hif_drv);
 			return -ENOMEM;
@@ -3538,7 +3541,7 @@ int wilc_deinit(struct wilc_vif *vif)
 				wait_for_completion(&msg->work_comp);
 			kfree(msg);
 		}
-		destroy_workqueue(hif_workqueue);
+		destroy_workqueue(vif->wilc->hif_workqueue);
 	}
 
 	kfree(hif_drv);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 8cccbbc..77641eb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -172,6 +172,7 @@ struct wilc {
 	struct rf_info dummy_statistics;
 	bool enable_ps;
 	int clients_count;
+	struct workqueue_struct *hif_workqueue;
 };
 
 struct wilc_wfi_mon_priv {
-- 
2.7.4
