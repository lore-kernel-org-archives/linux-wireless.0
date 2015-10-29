Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4690 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbbJ2C47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:56:59 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 06/64] staging: wilc1000: rename hSemTestDisconnectBlock of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:29 +0900
Message-ID: <1446087567-16728-6-git-send-email-glen.lee@atmel.com> (sfid-20151029_035701_656174_34ABCFCB)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
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
index 99bf633..4daef63 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2041,7 +2041,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		}
 	}
 
-	up(&hif_drv->hSemTestDisconnectBlock);
+	up(&hif_drv->sem_test_disconn_block);
 }
 
 void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
@@ -3563,7 +3563,7 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 	if (result)
 		PRINT_ER("Failed to send message queue: disconnect\n");
 
-	down(&hif_drv->hSemTestDisconnectBlock);
+	down(&hif_drv->sem_test_disconn_block);
 
 	return result;
 }
@@ -4108,7 +4108,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	}
 
 	sema_init(&hif_drv->sem_test_key_block, 0);
-	sema_init(&hif_drv->hSemTestDisconnectBlock, 0);
+	sema_init(&hif_drv->sem_test_disconn_block, 0);
 	sema_init(&hif_drv->hSemGetRSSI, 0);
 	sema_init(&hif_drv->hSemGetLINKSPEED, 0);
 	sema_init(&hif_drv->hSemGetCHNL, 0);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a8fd290..0c7a773 100644
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

