Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbbJ2C4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:56:52 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 05/64] staging: wilc1000: rename hSemTestKeyBlock of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:28 +0900
Message-ID: <1446087567-16728-5-git-send-email-glen.lee@atmel.com> (sfid-20151029_035655_239669_CA2A5FD2)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemTestKeyBlock of struct host_if_drv to sem_test_key_block
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 drivers/staging/wilc1000/host_interface.h |  3 +--
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c6a08d2..99bf633 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1792,7 +1792,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		}
-		up(&hif_drv->hSemTestKeyBlock);
+		up(&hif_drv->sem_test_key_block);
 		break;
 
 	case WPARxGtk:
@@ -1826,7 +1826,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
-			up(&hif_drv->hSemTestKeyBlock);
+			up(&hif_drv->sem_test_key_block);
 		}
 
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
@@ -1859,7 +1859,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
-			up(&hif_drv->hSemTestKeyBlock);
+			up(&hif_drv->sem_test_key_block);
 		}
 _WPARxGtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
@@ -1897,7 +1897,7 @@ _WPARxGtk_end_case_:
 			result = send_config_pkt(SET_CFG, strWIDList, 2,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-			up(&hif_drv->hSemTestKeyBlock);
+			up(&hif_drv->sem_test_key_block);
 		}
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
@@ -1920,7 +1920,7 @@ _WPARxGtk_end_case_:
 			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-			up(&hif_drv->hSemTestKeyBlock);
+			up(&hif_drv->sem_test_key_block);
 		}
 
 _WPAPtk_end_case_:
@@ -3076,7 +3076,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -3103,7 +3103,7 @@ int host_int_set_wep_default_key(struct host_if_drv *hif_drv, u8 index)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Default key index\n");
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -3137,7 +3137,7 @@ int host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -3181,7 +3181,7 @@ int host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 	if (result)
 		PRINT_ER("Error in sending message queue :WEP Key\n");
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -3246,7 +3246,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	if (result)
 		PRINT_ER("Error in sending message queue:  PTK Key\n");
 
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -3308,7 +3308,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	if (result)
 		PRINT_ER("Error in sending message queue:  RX GTK\n");
 
-	down(&hif_drv->hSemTestKeyBlock);
+	down(&hif_drv->sem_test_key_block);
 
 	return result;
 }
@@ -4107,7 +4107,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		sema_init(&hif_sema_deinit, 1);
 	}
 
-	sema_init(&hif_drv->hSemTestKeyBlock, 0);
+	sema_init(&hif_drv->sem_test_key_block, 0);
 	sema_init(&hif_drv->hSemTestDisconnectBlock, 0);
 	sema_init(&hif_drv->hSemGetRSSI, 0);
 	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7b9930e..a8fd290 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -305,8 +305,7 @@ struct host_if_drv {
 	struct cfg_param_val cfg_values;
 
 	struct semaphore sem_cfg_values;
-	struct semaphore hSemTestKeyBlock;
-
+	struct semaphore sem_test_key_block;
 	struct semaphore hSemTestDisconnectBlock;
 	struct semaphore hSemGetRSSI;
 	struct semaphore hSemGetLINKSPEED;
-- 
1.9.1

