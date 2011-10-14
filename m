Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab1JNUoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/6] iwlagn: fix the race in the unmapping of the HCMD
Date: Fri, 14 Oct 2011 12:54:47 -0700
Message-Id: <1318622088-14679-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224442_253361_CC3B62CE)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

As Stanislaw pointed out, my patch

	iwlagn: fix a race in the unmapping of the TFDs

solved only part of the problem. The race still exists for TFDs of
the host commands. Fix that too.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 8e8c75c..da34110 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -407,6 +407,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_queue *q = &txq->q;
 	enum dma_data_direction dma_dir;
 	unsigned long flags;
+	spinlock_t *lock;
 
 	if (!q->n_bd)
 		return;
@@ -414,19 +415,22 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	/* In the command queue, all the TBs are mapped as BIDI
 	 * so unmap them as such.
 	 */
-	if (txq_id == trans->shrd->cmd_queue)
+	if (txq_id == trans->shrd->cmd_queue) {
 		dma_dir = DMA_BIDIRECTIONAL;
-	else
+		lock = &trans->hcmd_lock;
+	} else {
 		dma_dir = DMA_TO_DEVICE;
+		lock = &trans->shrd->sta_lock;
+	}
 
-	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+	spin_lock_irqsave(lock, flags);
 	while (q->write_ptr != q->read_ptr) {
 		/* The read_ptr needs to bound by q->n_window */
 		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
 				    dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
-	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
+	spin_unlock_irqrestore(lock, flags);
 }
 
 /**
-- 
1.7.0.4

