Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576Ab2EPUyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/9] iwlwifi: s/iwlagn_txq_free_tfd/iwl_txq_free_tfd
Date: Wed, 16 May 2012 22:54:22 +0200
Message-Id: <1337201670-21604-2-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225445_942486_9708659B)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index e959207..ccb97b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -346,8 +346,8 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 				   int tx_fifo_id, bool active);
 void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int queue, int fifo,
 				 int sta_id, int tid, int frame_limit, u16 ssn);
-void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-			 enum dma_data_direction dma_dir);
+void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
+		      enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs);
 int iwl_queue_space(const struct iwl_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index a875023..cf8f3cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -209,7 +209,7 @@ static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
 }
 
 /**
- * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ * iwl_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
  * @trans - transport private data
  * @txq - tx queue
  * @dma_dir - the direction of the DMA mapping
@@ -217,8 +217,8 @@ static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
-			 enum dma_data_direction dma_dir)
+void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
+		      enum dma_data_direction dma_dir)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
@@ -979,7 +979,7 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
-		iwlagn_txq_free_tfd(trans, txq, DMA_TO_DEVICE);
+		iwl_txq_free_tfd(trans, txq, DMA_TO_DEVICE);
 		freed++;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ec6fb39..c119118 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -435,7 +435,7 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
-		iwlagn_txq_free_tfd(trans, txq, dma_dir);
+		iwl_txq_free_tfd(trans, txq, dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 	spin_unlock_bh(&txq->lock);
-- 
1.7.10

