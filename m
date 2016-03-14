Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33671 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071AbcCNAko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2016 20:40:44 -0400
Received: by mail-pa0-f44.google.com with SMTP id fl4so143578631pad.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Mar 2016 17:40:44 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: use completion instead of struct semaphore hif_sema_wait_response
Date: Mon, 14 Mar 2016 09:40:27 +0900
Message-Id: <1457916027-5597-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160314_014048_340979_646ADE14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces struct semaphore hif_sema_wait_response with struct
completion hif_wait_response. In case of struct hif_sema_wait_response,
it better to use completion than semaphore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0a922c7..e73ee89 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -232,7 +232,7 @@ static struct task_struct *hif_thread_handler;
 static struct message_queue hif_msg_q;
 static struct semaphore hif_sema_thread;
 static struct semaphore hif_sema_driver;
-static struct semaphore hif_sema_wait_response;
+static struct completion hif_wait_response;
 static struct semaphore hif_sema_deinit;
 static struct timer_list periodic_rssi;
 
@@ -430,7 +430,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to get mac address\n");
 		result = -EFAULT;
 	}
-	up(&hif_sema_wait_response);
+	complete(&hif_wait_response);
 
 	return result;
 }
@@ -1938,7 +1938,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 		wilc_enable_tcp_ack_filter(false);
 
 	if (pstrStatistics != &vif->wilc->dummy_statistics)
-		up(&hif_sema_wait_response);
+		complete(&hif_wait_response);
 	return 0;
 }
 
@@ -2172,7 +2172,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 ERRORHANDLER:
 	kfree(wid.val);
 
-	up(&hif_sema_wait_response);
+	complete(&hif_wait_response);
 }
 
 static void Handle_DelStation(struct wilc_vif *vif,
@@ -2485,7 +2485,7 @@ static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
-	up(&hif_sema_wait_response);
+	complete(&hif_wait_response);
 }
 
 static int hostIFthread(void *pvArg)
@@ -3007,7 +3007,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 		return -EFAULT;
 	}
 
-	down(&hif_sema_wait_response);
+	wait_for_completion(&hif_wait_response);
 	return result;
 }
 
@@ -3272,7 +3272,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	}
 
 	if (stats != &vif->wilc->dummy_statistics)
-		down(&hif_sema_wait_response);
+		wait_for_completion(&hif_wait_response);
 	return result;
 }
 
@@ -3382,7 +3382,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	scan_while_connected = false;
 
-	sema_init(&hif_sema_wait_response, 0);
+	init_completion(&hif_wait_response);
 
 	hif_drv  = kzalloc(sizeof(struct host_if_drv), GFP_KERNEL);
 	if (!hif_drv) {
@@ -3888,7 +3888,7 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
 
-	down(&hif_sema_wait_response);
+	wait_for_completion(&hif_wait_response);
 
 	return result;
 }
@@ -4221,7 +4221,7 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
-	down(&hif_sema_wait_response);
+	wait_for_completion(&hif_wait_response);
 	*tx_power = msg.body.tx_power.tx_pwr;
 
 	return ret;
-- 
2.7.1

