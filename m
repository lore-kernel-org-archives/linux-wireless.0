Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1GVFnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 21/31] ath6kl: Move chk_irq_status_cnt from ath6kl_device to htc_target
Date: Fri, 22 Jul 2011 08:41:54 +0300
Message-ID: <1311313324-6766-23-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074329_960592_FD8B51E7)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c     |    4 ++--
 drivers/net/wireless/ath/ath6kl/htc.h     |    2 ++
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    6 +++---
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    1 -
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index ea87a19..8367979 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1774,7 +1774,7 @@ int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
 			 * A recv bundle was detected, force IRQ status
 			 * re-check again
 			 */
-			target->dev->chk_irq_status_cnt = 1;
+			target->chk_irq_status_cnt = 1;
 
 		n_fetched += get_queue_depth(&rx_pktq);
 
@@ -1799,7 +1799,7 @@ int htc_rxmsg_pending_handler(struct htc_target *target, u32 msg_look_ahead[],
 		 * before leaving IRQ processing, this can net better
 		 * performance in high throughput situations.
 		 */
-		target->dev->chk_irq_status_cnt = 1;
+		target->chk_irq_status_cnt = 1;
 	}
 
 	if (status) {
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index bf9c725..d844d36 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -536,6 +536,8 @@ struct htc_target {
 
 	int max_scat_entries;
 	int max_xfer_szper_scatreq;
+
+	int chk_irq_status_cnt;
 };
 
 void *htc_create(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 7ab40c1..5d397b5 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -426,7 +426,7 @@ static int proc_pending_irqs(struct ath6kl_device *dev, bool *done)
 			 * HTC could not pull any messages out due to lack
 			 * of resources.
 			 */
-			dev->chk_irq_status_cnt = 0;
+			dev->htc_cnxt->chk_irq_status_cnt = 0;
 	}
 
 	/* now handle the rest of them */
@@ -469,7 +469,7 @@ out:
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
 		   "bypassing irq status re-check, forcing done\n");
 
-	if (!dev->chk_irq_status_cnt)
+	if (!dev->htc_cnxt->chk_irq_status_cnt)
 		*done = true;
 
 	ath6kl_dbg(ATH6KL_DBG_IRQ,
@@ -489,7 +489,7 @@ int ath6kldev_intr_bh_handler(struct ath6kl *ar)
 	 * Reset counter used to flag a re-scan of IRQ status registers on
 	 * the target.
 	 */
-	dev->chk_irq_status_cnt = 0;
+	dev->htc_cnxt->chk_irq_status_cnt = 0;
 
 	/*
 	 * IRQ processing is synchronous, interrupt status registers can be
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 47f086c..498701f 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -80,7 +80,6 @@ struct ath6kl_device {
 	struct ath6kl_irq_enable_reg irq_en_reg;
 	u8 pad3[A_CACHE_LINE_PAD];
 	struct htc_target *htc_cnxt;
-	int chk_irq_status_cnt;
 	struct ath6kl *ar;
 };
 
-- 
1.7.1

