Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38953 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2BIH1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 02:27:17 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix random system lockup
Date: Thu, 9 Feb 2012 12:57:12 +0530
Message-ID: <1328772432-21074-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120209_082727_579918_5A976742)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

The commit "ath6kl: Use a mutex_lock to avoid
race in diabling and handling irq" introduces a
state where ath6kl_sdio_irq_handler() would be waiting
to claim the sdio function for receive indefinitely
when things happen in the following order.

ath6kl_sdio_irq_handler()
	- aquires mtx_irq
	- sdio_release_host()
					ath6kl_sdio_irq_disable()
						- sdio_claim_host()
						- sleep on mtx_irq
	ath6kl_hif_intr_bh_handler()
		- (indefinitely) wait for the sdio
		  function to be released to exclusively claim
		  it again for receive operation.

Fix this by replacing the mtx_irq with an atomic
variable and a wait_queue.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index f4306e4..a7c0d8d 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -49,8 +49,8 @@ struct ath6kl_sdio {
 	/* scatter request list head */
 	struct list_head scat_req;
 
-	/* Avoids disabling irq while the interrupts being handled */
-	struct mutex mtx_irq;
+	atomic_t irq_handling;
+	wait_queue_head_t irq_wq;
 
 	spinlock_t scat_lock;
 	bool scatter_enabled;
@@ -462,7 +462,7 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 	ath6kl_dbg(ATH6KL_DBG_SDIO, "irq\n");
 
 	ar_sdio = sdio_get_drvdata(func);
-	mutex_lock(&ar_sdio->mtx_irq);
+	atomic_set(&ar_sdio->irq_handling, 1);
 	/*
 	 * Release the host during interrups so we can pick it back up when
 	 * we process commands.
@@ -471,7 +471,10 @@ static void ath6kl_sdio_irq_handler(struct sdio_func *func)
 
 	status = ath6kl_hif_intr_bh_handler(ar_sdio->ar);
 	sdio_claim_host(ar_sdio->func);
-	mutex_unlock(&ar_sdio->mtx_irq);
+
+	atomic_set(&ar_sdio->irq_handling, 0);
+	wake_up(&ar_sdio->irq_wq);
+
 	WARN_ON(status && status != -ECANCELED);
 }
 
@@ -579,14 +582,21 @@ static void ath6kl_sdio_irq_disable(struct ath6kl *ar)
 
 	sdio_claim_host(ar_sdio->func);
 
-	mutex_lock(&ar_sdio->mtx_irq);
+	if (atomic_read(&ar_sdio->irq_handling)) {
+		sdio_release_host(ar_sdio->func);
+
+		ret = wait_event_interruptible(ar_sdio->irq_wq,
+				!atomic_read(&ar_sdio->irq_handling));
+		if (ret)
+			return;
+
+		sdio_claim_host(ar_sdio->func);
+	}
 
 	ret = sdio_release_irq(ar_sdio->func);
 	if (ret)
 		ath6kl_err("Failed to release sdio irq: %d\n", ret);
 
-	mutex_unlock(&ar_sdio->mtx_irq);
-
 	sdio_release_host(ar_sdio->func);
 }
 
@@ -1285,7 +1295,6 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	spin_lock_init(&ar_sdio->scat_lock);
 	spin_lock_init(&ar_sdio->wr_async_lock);
 	mutex_init(&ar_sdio->dma_buffer_mutex);
-	mutex_init(&ar_sdio->mtx_irq);
 
 	INIT_LIST_HEAD(&ar_sdio->scat_req);
 	INIT_LIST_HEAD(&ar_sdio->bus_req_freeq);
@@ -1293,6 +1302,8 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	INIT_WORK(&ar_sdio->wr_async_work, ath6kl_sdio_write_async_work);
 
+	init_waitqueue_head(&ar_sdio->irq_wq);
+
 	for (count = 0; count < BUS_REQUEST_MAX_NUM; count++)
 		ath6kl_sdio_free_bus_req(ar_sdio, &ar_sdio->bus_req[count]);
 
-- 
1.7.0.4

