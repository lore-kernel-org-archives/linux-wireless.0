Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15537 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcDAIrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:17 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/7] staging: wilc1000: changes logic when happened mq_send fail
Date: Fri, 1 Apr 2016 17:44:13 +0900
Message-ID: <1459500259-27873-1-git-send-email-leo.kim@atmel.com> (sfid-20160401_104722_241249_BD1E91B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes logic when happened mq_send fail.
The check as a result value that mq_send fail.
But, regardless of the result value then perform a semaphore up.
That is an occur that semaphore locking.
Add to 'else' routine and move to 'else' position a semaphore up.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 33 +++++++++++++++++--------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 04cbff5..12f1630 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2731,7 +2731,8 @@ int wilc_remove_wep_key(struct wilc_vif *vif, u8 index)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		netdev_err(vif->ndev, "Request to remove WEP key\n");
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
 }
@@ -2759,7 +2760,8 @@ int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		netdev_err(vif->ndev, "Default key index\n");
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
 }
@@ -2828,7 +2830,8 @@ int wilc_add_wep_key_bss_ap(struct wilc_vif *vif, const u8 *key, u8 len,
 
 	if (result)
 		netdev_err(vif->ndev, "AP - WEP Key\n");
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
 }
@@ -2883,8 +2886,8 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 
 	if (result)
 		netdev_err(vif->ndev, "PTK Key\n");
-
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
 }
@@ -2951,8 +2954,8 @@ int wilc_add_rx_gtk(struct wilc_vif *vif, const u8 *rx_gtk, u8 gtk_key_len,
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		netdev_err(vif->ndev, "RX GTK\n");
-
-	wait_for_completion(&hif_drv->comp_test_key_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_key_block);
 
 	return result;
 }
@@ -3098,8 +3101,8 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send message: disconnect\n");
-
-	wait_for_completion(&hif_drv->comp_test_disconn_block);
+	else
+		wait_for_completion(&hif_drv->comp_test_disconn_block);
 
 	return result;
 }
@@ -3220,8 +3223,8 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		netdev_err(vif->ndev, "Failed to send get host ch param\n");
-
-	wait_for_completion(&hif_drv->comp_inactive_time);
+	else
+		wait_for_completion(&hif_drv->comp_inactive_time);
 
 	*pu32InactiveTime = inactive_time;
 
@@ -3502,8 +3505,8 @@ int wilc_deinit(struct wilc_vif *vif)
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result != 0)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
-
-		wait_for_completion(&hif_thread_comp);
+		else
+			wait_for_completion(&hif_thread_comp);
 
 		wilc_mq_destroy(&hif_msg_q);
 	}
@@ -3882,8 +3885,8 @@ int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN])
 
 	if (result)
 		netdev_err(vif->ndev, "wilc_mq_send fail\n");
-
-	wait_for_completion(&hif_wait_response);
+	else
+		wait_for_completion(&hif_wait_response);
 
 	return result;
 }
-- 
1.9.1

