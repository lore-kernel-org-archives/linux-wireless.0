Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34264 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbcCUXjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 19:39:36 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so32536667pfn.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2016 16:39:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: use mutex instead of struct semaphore hif_sema_deinit
Date: Tue, 22 Mar 2016 08:39:24 +0900
Message-Id: <1458603564-5537-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160322_003940_429346_9E4453AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces struct semaphore hif_sema_deinit with struct mutex
hif_deinit_lock. It is better to use mutex because mutex gives better
performance than semaphore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4be8b31..b1ffa91 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -234,7 +234,7 @@ static struct message_queue hif_msg_q;
 static struct semaphore hif_sema_thread;
 static struct semaphore hif_sema_driver;
 static struct completion hif_wait_response;
-static struct semaphore hif_sema_deinit;
+static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
 
 u8 wilc_multicast_mac_addr_list[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
@@ -3402,7 +3402,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	if (clients_count == 0)	{
 		sema_init(&hif_sema_thread, 0);
 		sema_init(&hif_sema_driver, 0);
-		sema_init(&hif_sema_deinit, 1);
+		mutex_init(&hif_deinit_lock);
 	}
 
 	init_completion(&hif_drv->comp_test_key_block);
@@ -3470,7 +3470,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		return -EFAULT;
 	}
 
-	down(&hif_sema_deinit);
+	mutex_lock(&hif_deinit_lock);
 
 	terminated_handle = hif_drv;
 
@@ -3512,7 +3512,7 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	clients_count--;
 	terminated_handle = NULL;
-	up(&hif_sema_deinit);
+	mutex_unlock(&hif_deinit_lock);
 	return result;
 }
 
@@ -3559,25 +3559,25 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	struct host_if_drv *hif_drv = NULL;
 	struct wilc_vif *vif;
 
-	down(&hif_sema_deinit);
+	mutex_lock(&hif_deinit_lock);
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
 	vif = wilc_get_vif_from_idx(wilc, id);
 	if (!vif) {
-		up(&hif_sema_deinit);
+		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
 
 	hif_drv = vif->hif_drv;
 
 	if (!hif_drv || hif_drv == terminated_handle) {
-		up(&hif_sema_deinit);
+		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
 
 	if (!hif_drv->usr_conn_req.conn_result) {
 		netdev_err(vif->ndev, "there is no current Connect Request\n");
-		up(&hif_sema_deinit);
+		mutex_unlock(&hif_deinit_lock);
 		return;
 	}
 
@@ -3594,7 +3594,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	if (result)
 		netdev_err(vif->ndev, "synchronous info (%d)\n", result);
 
-	up(&hif_sema_deinit);
+	mutex_unlock(&hif_deinit_lock);
 }
 
 void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
-- 
2.7.3

