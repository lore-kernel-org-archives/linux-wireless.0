Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41955 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:02 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/80] staging: wilc1000: rename hSemGetLINKSPEED of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:44 +0900
Message-ID: <1446015640-29398-24-git-send-email-glen.lee@atmel.com> (sfid-20151028_081656_931738_D6459D5C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemGetLINKSPEED of struct host_if_drv to sem_get_link_speed
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 04b3056..ba643567 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2124,7 +2124,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 		result = -EFAULT;
 	}
 
-	up(&hif_drv->hSemGetLINKSPEED);
+	up(&hif_drv->sem_get_link_speed);
 }
 
 s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatistics)
@@ -3839,7 +3839,7 @@ s32 host_int_get_link_speed(struct host_if_drv *hif_drv, s8 *ps8lnkspd)
 		return -EFAULT;
 	}
 
-	down(&hif_drv->hSemGetLINKSPEED);
+	down(&hif_drv->sem_get_link_speed);
 
 	if (!ps8lnkspd) {
 		PRINT_ER("LINKSPEED pointer value is null");
@@ -4107,7 +4107,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->sem_test_key_block, 0);
 	sema_init(&hif_drv->sem_test_disconn_block, 0);
 	sema_init(&hif_drv->sem_get_rssi, 0);
-	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
+	sema_init(&hif_drv->sem_get_link_speed, 0);
 	sema_init(&hif_drv->hSemGetCHNL, 0);
 	sema_init(&hif_drv->hSemInactiveTime, 0);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b18ed17..8a68d64 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -308,7 +308,7 @@ struct host_if_drv {
 	struct semaphore sem_test_key_block;
 	struct semaphore sem_test_disconn_block;
 	struct semaphore sem_get_rssi;
-	struct semaphore hSemGetLINKSPEED;
+	struct semaphore sem_get_link_speed;
 	struct semaphore hSemGetCHNL;
 	struct semaphore hSemInactiveTime;
 /* timer handlers */
-- 
1.9.1

