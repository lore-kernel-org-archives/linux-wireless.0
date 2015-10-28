Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42024 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:08 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/80] staging: wilc1000: rename hSemGetCHNL of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:45 +0900
Message-ID: <1446015640-29398-25-git-send-email-glen.lee@atmel.com> (sfid-20151028_081656_108235_B237AF08)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index ba643567..cc5dac01 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2076,7 +2076,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->hSemGetCHNL);
+	up(&hif_drv->sem_get_chnl);
 
 	return result;
 }
@@ -3734,7 +3734,7 @@ s32 host_int_get_host_chnl_num(struct host_if_drv *hif_drv, u8 *pu8ChNo)
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("wilc mq send fail\n");
-	down(&hif_drv->hSemGetCHNL);
+	down(&hif_drv->sem_get_chnl);
 
 	*pu8ChNo = ch_no;
 
@@ -4108,7 +4108,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->sem_test_disconn_block, 0);
 	sema_init(&hif_drv->sem_get_rssi, 0);
 	sema_init(&hif_drv->sem_get_link_speed, 0);
-	sema_init(&hif_drv->hSemGetCHNL, 0);
+	sema_init(&hif_drv->sem_get_chnl, 0);
 	sema_init(&hif_drv->hSemInactiveTime, 0);
 
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8a68d64..474b43d 100644
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

