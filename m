Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41935 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1G74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:56 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/80] staging: wilc1000: rename hSemGetRSSI of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:43 +0900
Message-ID: <1446015640-29398-23-git-send-email-glen.lee@atmel.com> (sfid-20151028_081656_364369_EBD9D117)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index 0dfec3c..04b3056 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2100,7 +2100,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->hSemGetRSSI);
+	up(&hif_drv->sem_get_rssi);
 }
 
 static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
@@ -3812,7 +3812,7 @@ s32 host_int_get_rssi(struct host_if_drv *hif_drv, s8 *ps8Rssi)
 		return -EFAULT;
 	}
 
-	down(&hif_drv->hSemGetRSSI);
+	down(&hif_drv->sem_get_rssi);
 
 	if (!ps8Rssi) {
 		PRINT_ER("RSS pointer value is null");
@@ -4106,7 +4106,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	sema_init(&hif_drv->sem_test_key_block, 0);
 	sema_init(&hif_drv->sem_test_disconn_block, 0);
-	sema_init(&hif_drv->hSemGetRSSI, 0);
+	sema_init(&hif_drv->sem_get_rssi, 0);
 	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
 	sema_init(&hif_drv->hSemGetCHNL, 0);
 	sema_init(&hif_drv->hSemInactiveTime, 0);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index ff13be4..b18ed17 100644
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

