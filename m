Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753945AbeDRLlD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:41:03 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 18/22] staging: wilc1000: remove the use of goto label in wilc_init()
Date: Wed, 18 Apr 2018 17:09:20 +0530
Message-ID: <1524051564-15497-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134109_102354_633AE078)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added direct return in wilc_init() instead of goto label. Changes
are done to avoid the use of '_' in label name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 65caa6d..12414f4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3331,7 +3331,6 @@ static void get_periodic_rssi(struct timer_list *unused)
 
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
-	int result = 0;
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
@@ -3345,10 +3344,9 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	init_completion(&hif_wait_response);
 
 	hif_drv  = kzalloc(sizeof(*hif_drv), GFP_KERNEL);
-	if (!hif_drv) {
-		result = -ENOMEM;
-		goto _fail_;
-	}
+	if (!hif_drv)
+		return -ENOMEM;
+
 	*hif_drv_handler = hif_drv;
 	for (i = 0; i < wilc->vif_num; i++)
 		if (dev == wilc->vif[i]->ndev) {
@@ -3359,7 +3357,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	wilc_optaining_ip = false;
 
-	if (clients_count == 0)	{
+	if (clients_count == 0) {
 		init_completion(&hif_thread_comp);
 		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
@@ -3370,12 +3368,12 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	init_completion(&hif_drv->comp_get_rssi);
 	init_completion(&hif_drv->comp_inactive_time);
 
-	if (clients_count == 0)	{
+	if (clients_count == 0) {
 		hif_workqueue = create_singlethread_workqueue("WILC_wq");
 		if (!hif_workqueue) {
 			netdev_err(vif->ndev, "Failed to create workqueue\n");
-			result = -ENOMEM;
-			goto _fail_;
+			kfree(hif_drv);
+			return -ENOMEM;
 		}
 
 		periodic_rssi_vif = vif;
@@ -3403,8 +3401,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	clients_count++;
 
-_fail_:
-	return result;
+	return 0;
 }
 
 int wilc_deinit(struct wilc_vif *vif)
-- 
2.7.4
