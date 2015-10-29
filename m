Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4706 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbbJ2C5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:57:05 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 07/64] staging: wilc1000: rename hSemGetRSSI of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:30 +0900
Message-ID: <1446087567-16728-7-git-send-email-glen.lee@atmel.com> (sfid-20151029_035709_376589_5F5E14F3)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemGetRSSI of struct host_if_drv to sem_get_rssi
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4daef63..b40ce3b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2099,7 +2099,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->hSemGetRSSI);
+	up(&hif_drv->sem_get_rssi);
 }
 
 static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
@@ -3815,7 +3815,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 		return -EFAULT;
 	}
 
-	down(&hif_drv->hSemGetRSSI);
+	down(&hif_drv->sem_get_rssi);
 
 	if (!ps8Rssi) {
 		PRINT_ER("RSS pointer value is null");
@@ -4109,7 +4109,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	sema_init(&hif_drv->sem_test_key_block, 0);
 	sema_init(&hif_drv->sem_test_disconn_block, 0);
-	sema_init(&hif_drv->hSemGetRSSI, 0);
+	sema_init(&hif_drv->sem_get_rssi, 0);
 	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
 	sema_init(&hif_drv->hSemGetCHNL, 0);
 	sema_init(&hif_drv->hSemInactiveTime, 0);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0c7a773..dada9c5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -307,7 +307,7 @@ struct host_if_drv {
 	struct semaphore sem_cfg_values;
 	struct semaphore sem_test_key_block;
 	struct semaphore sem_test_disconn_block;
-	struct semaphore hSemGetRSSI;
+	struct semaphore sem_get_rssi;
 	struct semaphore hSemGetLINKSPEED;
 	struct semaphore hSemGetCHNL;
 	struct semaphore hSemInactiveTime;
-- 
1.9.1

