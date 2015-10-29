Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4744 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbbJ2C5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:57:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 09/64] staging: wilc1000: rename hSemGetCHNL of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:32 +0900
Message-ID: <1446087567-16728-9-git-send-email-glen.lee@atmel.com> (sfid-20151029_035720_263906_1645BE67)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemGetCHNL of struct host_if_drv to sem_get_chnl
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7b654c5..b59551a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2075,7 +2075,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->hSemGetCHNL);
+	up(&hif_drv->sem_get_chnl);
 
 	return result;
 }
@@ -3737,7 +3737,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("wilc mq send fail\n");
-	down(&hif_drv->hSemGetCHNL);
+	down(&hif_drv->sem_get_chnl);
 
 	*pu8ChNo = ch_no;
 
@@ -4111,7 +4111,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->sem_test_disconn_block, 0);
 	sema_init(&hif_drv->sem_get_rssi, 0);
 	sema_init(&hif_drv->sem_get_link_speed, 0);
-	sema_init(&hif_drv->hSemGetCHNL, 0);
+	sema_init(&hif_drv->sem_get_chnl, 0);
 	sema_init(&hif_drv->hSemInactiveTime, 0);
 
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a603e84..8d12099 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -309,7 +309,7 @@ struct host_if_drv {
 	struct semaphore sem_test_disconn_block;
 	struct semaphore sem_get_rssi;
 	struct semaphore sem_get_link_speed;
-	struct semaphore hSemGetCHNL;
+	struct semaphore sem_get_chnl;
 	struct semaphore hSemInactiveTime;
 /* timer handlers */
 	struct timer_list hScanTimer;
-- 
1.9.1

