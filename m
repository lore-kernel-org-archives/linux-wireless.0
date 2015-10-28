Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41872 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbbJ1G7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:38 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/80] staging: wilc1000: rename gtOsCfgValuesSem of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:40 +0900
Message-ID: <1446015640-29398-20-git-send-email-glen.lee@atmel.com> (sfid-20151028_081701_961429_B0EC6D2C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames gtOsCfgValuesSem of struct host_if_drv to sem_cfg_values
to avoid CamelCase naming convention.
And, remove the relation comment.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 drivers/staging/wilc1000/host_interface.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 72779a1..85c376a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -525,7 +525,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	struct wid strWIDList[32];
 	u8 u8WidCnt = 0;
 
-	down(&hif_drv->gtOsCfgValuesSem);
+	down(&hif_drv->sem_cfg_values);
 
 	PRINT_D(HOSTINF_DBG, "Setting CFG params\n");
 
@@ -797,7 +797,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		PRINT_ER("Error in setting CFG params\n");
 
 ERRORHANDLER:
-	up(&hif_drv->gtOsCfgValuesSem);
+	up(&hif_drv->sem_cfg_values);
 	return result;
 }
 
@@ -3949,7 +3949,7 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 {
 	s32 result = 0;
 
-	down(&hif_drv->gtOsCfgValuesSem);
+	down(&hif_drv->sem_cfg_values);
 
 	if (!hif_drv) {
 		PRINT_ER("hif_drv NULL\n");
@@ -4033,7 +4033,7 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
 		break;
 	}
 
-	up(&hif_drv->gtOsCfgValuesSem);
+	up(&hif_drv->sem_cfg_values);
 
 	return result;
 }
@@ -4140,8 +4140,8 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
 
-	sema_init(&hif_drv->gtOsCfgValuesSem, 1);
-	down(&hif_drv->gtOsCfgValuesSem);
+	sema_init(&hif_drv->sem_cfg_values, 1);
+	down(&hif_drv->sem_cfg_values);
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 	hif_drv->cfg_values.site_survey_enabled = SITE_SURVEY_OFF;
@@ -4159,14 +4159,14 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 		   hif_drv->cfg_values.passive_scan_time,
 		   hif_drv->cfg_values.curr_tx_rate);
 
-	up(&hif_drv->gtOsCfgValuesSem);
+	up(&hif_drv->sem_cfg_values);
 
 	clients_count++;
 
 	return result;
 
 _fail_timer_2:
-	up(&hif_drv->gtOsCfgValuesSem);
+	up(&hif_drv->sem_cfg_values);
 	del_timer_sync(&hif_drv->hConnectTimer);
 	del_timer_sync(&hif_drv->hScanTimer);
 	kthread_stop(hif_thread_handler);
@@ -4235,7 +4235,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		wilc_mq_destroy(&hif_msg_q);
 	}
 
-	down(&hif_drv->gtOsCfgValuesSem);
+	down(&hif_drv->sem_cfg_values);
 
 	ret = remove_handler_in_list(hif_drv);
 	if (ret)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bb18081..700b80a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -303,8 +303,8 @@ struct host_if_drv {
 
 	u8 assoc_bssid[ETH_ALEN];
 	struct cfg_param_val cfg_values;
-/* semaphores */
-	struct semaphore gtOsCfgValuesSem;
+
+	struct semaphore sem_cfg_values;
 	struct semaphore hSemTestKeyBlock;
 
 	struct semaphore hSemTestDisconnectBlock;
-- 
1.9.1

