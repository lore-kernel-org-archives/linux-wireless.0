Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26665 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2ADK1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 05:27:14 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Use a mutex_lock to avoid race in diabling and handling irq
Date: Wed, 4 Jan 2012 15:57:19 +0530
Message-ID: <1325672839-16608-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120104_112718_555433_DC5C3BE9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently this race is handled but in a messy way an atomic
variable is being checked in a loop which sleeps upto ms
in every iteration. Remove this logic and use a mutex
to make sure irq is not disabled when irq handling is in
progress.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 278a9f3..8b36904 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -49,11 +49,13 @@ struct ath6kl_sdio {
 	/* scatter request list head */
 	struct list_head scat_req;
 
+	/* Avoids disabling irq while the interrupts being handled */
+	struct mutex mtx_irq;
+
 	spinlock_t scat_lock;
 	bool scatter_enabled;
 
 	bool is_disabled;
-	atomic_t irq_handling;
 	const struct sdio_device_id *id;
 	struct work_struct wr_async_work;
 	struct list_head wr_asyncq;
@@ -460,8 +462,7 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 	ath6kl_dbg(ATH6KL_DBG_SDIO, "irq\n");
 
 	ar_sdio = sdio_get_drvdata(func);
-	atomic_set(&ar_sdio->irq_handling, 1);
-
+	mutex_lock(&ar_sdio->mtx_irq);
 	/*
 	 * Release the host during interrups so we can pick it back up when
 	 * we process commands.
@@ -470,7 +471,7 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 
 	status = ath6kl_hif_intr_bh_handler(ar_sdio->ar);
 	sdio_claim_host(ar_sdio->func);
-	atomic_set(&ar_sdio->irq_handling, 0);
+	mutex_unlock(&ar_sdio->mtx_irq);
 	WARN_ON(status && status != -ECANCELED);
 }
 
@@ -578,17 +579,14 @@ static void ath6kl_sdio_irq_disable(struct ath6kl *ar)
 
 	sdio_claim_host(ar_sdio->func);
 
-	/* Mask our function IRQ */
-	while (atomic_read(&ar_sdio->irq_handling)) {
-		sdio_release_host(ar_sdio->func);
-		schedule_timeout(HZ / 10);
-		sdio_claim_host(ar_sdio->func);
-	}
+	mutex_lock(&ar_sdio->mtx_irq);
 
 	ret = sdio_release_irq(ar_sdio->func);
 	if (ret)
 		ath6kl_err("Failed to release sdio irq: %d\n", ret);
 
+	mutex_unlock(&ar_sdio->mtx_irq);
+
 	sdio_release_host(ar_sdio->func);
 }
 
@@ -1253,6 +1251,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	spin_lock_init(&ar_sdio->scat_lock);
 	spin_lock_init(&ar_sdio->wr_async_lock);
 	mutex_init(&ar_sdio->dma_buffer_mutex);
+	mutex_init(&ar_sdio->mtx_irq);
 
 	INIT_LIST_HEAD(&ar_sdio->scat_req);
 	INIT_LIST_HEAD(&ar_sdio->bus_req_freeq);
-- 
1.7.0.4

