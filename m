Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:53872 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbeIDLEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 24/26] staging: wilc1000: refactor code to move initilization in wilc_netdev_init()
Date: Tue, 4 Sep 2018 12:09:40 +0530
Message-ID: <1536043182-19735-25-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084115_546916_84D275C9)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor code to move the initialization of wilc related parameters in
wilc_netdev_init() and move their deinitialization in
wilc_netdev_cleanup(). For 'hif_workqueue' creation 'clients_count' check
is not required as the single instance is maintained.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 23 -----------------------
 drivers/staging/wilc1000/linux_wlan.c     |  8 ++++++++
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9d90994..85113fb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3392,13 +3392,6 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	if (wilc->clients_count == 0) {
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
-
-		wilc->hif_workqueue = create_singlethread_workqueue("WILC_wq");
-		if (!wilc->hif_workqueue) {
-			netdev_err(vif->ndev, "Failed to create workqueue\n");
-			kfree(hif_drv);
-			return -ENOMEM;
-		}
 	}
 
 	timer_setup(&vif->periodic_rssi, get_periodic_rssi, 0);
@@ -3458,22 +3451,6 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 
-	if (vif->wilc->clients_count == 1) {
-		struct host_if_msg *msg;
-
-		msg = wilc_alloc_work(vif, handle_hif_exit_work, true);
-		if (!IS_ERR(msg)) {
-			result = wilc_enqueue_work(msg);
-			if (result)
-				netdev_err(vif->ndev, "deinit : Error(%d)\n",
-					   result);
-			else
-				wait_for_completion(&msg->work_comp);
-			kfree(msg);
-		}
-		destroy_workqueue(vif->wilc->hif_workqueue);
-	}
-
 	kfree(hif_drv);
 
 	vif->wilc->clients_count--;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8c6b63a..d7d43fd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1036,6 +1036,8 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 		}
 	}
 
+	flush_workqueue(wilc->hif_workqueue);
+	destroy_workqueue(wilc->hif_workqueue);
 	kfree(wilc);
 	wilc_debugfs_remove();
 }
@@ -1070,6 +1072,12 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 	INIT_LIST_HEAD(&wl->txq_head.list);
 	INIT_LIST_HEAD(&wl->rxq_head.list);
 
+	wl->hif_workqueue = create_singlethread_workqueue("WILC_wq");
+	if (!wl->hif_workqueue) {
+		kfree(wl);
+		return -ENOMEM;
+	}
+
 	register_inetaddr_notifier(&g_dev_notifier);
 
 	for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-- 
2.7.4
