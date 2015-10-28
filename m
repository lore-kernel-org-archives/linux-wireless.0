Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:14 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/80] staging: wilc1000: rename hSemInactiveTime of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:46 +0900
Message-ID: <1446015640-29398-26-git-send-email-glen.lee@atmel.com> (sfid-20151028_081655_246112_7B38C66C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemInactiveTime of struct host_if_drv to sem_inactive_time
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cc5dac01..2e68f52 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2212,7 +2212,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	PRINT_D(CFG80211_DBG, "Getting inactive time : %d\n", inactive_time);
 
-	up(&hif_drv->hSemInactiveTime);
+	up(&hif_drv->sem_inactive_time);
 
 	return result;
 }
@@ -3762,7 +3762,7 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 	if (result)
 		PRINT_ER("Failed to send get host channel param's message queue ");
 
-	down(&hif_drv->hSemInactiveTime);
+	down(&hif_drv->sem_inactive_time);
 
 	*pu32InactiveTime = inactive_time;
 
@@ -4109,7 +4109,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	sema_init(&hif_drv->sem_get_rssi, 0);
 	sema_init(&hif_drv->sem_get_link_speed, 0);
 	sema_init(&hif_drv->sem_get_chnl, 0);
-	sema_init(&hif_drv->hSemInactiveTime, 0);
+	sema_init(&hif_drv->sem_inactive_time, 0);
 
 	PRINT_D(HOSTINF_DBG, "INIT: CLIENT COUNT %d\n", clients_count);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 474b43d..7236481 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -310,7 +310,7 @@ struct host_if_drv {
 	struct semaphore sem_get_rssi;
 	struct semaphore sem_get_link_speed;
 	struct semaphore sem_get_chnl;
-	struct semaphore hSemInactiveTime;
+	struct semaphore sem_inactive_time;
 /* timer handlers */
 	struct timer_list hScanTimer;
 	struct timer_list hConnectTimer;
-- 
1.9.1

