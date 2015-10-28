Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41914 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbbJ1G7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:59:50 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/80] staging: wilc1000: rename hSemTestDisconnectBlock of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:42 +0900
Message-ID: <1446015640-29398-22-git-send-email-glen.lee@atmel.com> (sfid-20151028_081658_820529_EBF73C0A)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hSemTestDisconnectBlock of struct host_if_drv to
sem_test_disconn_block to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c35a6e3..0dfec3c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2042,7 +2042,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		}
 	}
 
-	up(&hif_drv->hSemTestDisconnectBlock);
+	up(&hif_drv->sem_test_disconn_block);
 }
 
 void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
@@ -3560,7 +3560,7 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	if (result)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 
-	down(&hif_drv->hSemTestDisconnectBlock);
+	down(&hif_drv->sem_test_disconn_block);
 
 	return result;
 }
@@ -4105,7 +4105,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	}
 
 	sema_init(&hif_drv->sem_test_key_block, 0);
-	sema_init(&hif_drv->hSemTestDisconnectBlock, 0);
+	sema_init(&hif_drv->sem_test_disconn_block, 0);
 	sema_init(&hif_drv->hSemGetRSSI, 0);
 	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
 	sema_init(&hif_drv->hSemGetCHNL, 0);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 846a636..ff13be4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -306,7 +306,7 @@ struct host_if_drv {
 
 	struct semaphore sem_cfg_values;
 	struct semaphore sem_test_key_block;
-	struct semaphore hSemTestDisconnectBlock;
+	struct semaphore sem_test_disconn_block;
 	struct semaphore hSemGetRSSI;
 	struct semaphore hSemGetLINKSPEED;
 	struct semaphore hSemGetCHNL;
-- 
1.9.1

