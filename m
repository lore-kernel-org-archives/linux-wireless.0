Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab3CDOA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/11] iwlwifi: don't map complete commands bidirectionally
Date: Mon,  4 Mar 2013 15:00:41 +0100
Message-Id: <1362405651-26456-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_150113_105184_FA2054D9)
In-Reply-To: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
References: <1362405609.21028.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The reason we mapped them bidirectionally was that not doing
so had caused IOMMU exceptions, due to the fact that the HW
writes back into the command. Now that the first part of the
command including the write-back part is always in the first
buffer, we don't need to map the remaining buffer(s) bidi
and can get rid of the special-casing for commands.

This is a requisite patch for another one to fix DMA mapping.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 8b625a7..975492f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -367,8 +367,8 @@ static inline u8 iwl_pcie_tfd_get_num_tbs(struct iwl_tfd *tfd)
 }
 
 static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
-			       struct iwl_cmd_meta *meta, struct iwl_tfd *tfd,
-			       enum dma_data_direction dma_dir)
+			       struct iwl_cmd_meta *meta,
+			       struct iwl_tfd *tfd)
 {
 	int i;
 	int num_tbs;
@@ -392,7 +392,8 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
 		dma_unmap_single(trans->dev, iwl_pcie_tfd_tb_get_addr(tfd, i),
-				 iwl_pcie_tfd_tb_get_len(tfd, i), dma_dir);
+				 iwl_pcie_tfd_tb_get_len(tfd, i),
+				 DMA_TO_DEVICE);
 
 	tfd->num_tbs = 0;
 }
@@ -406,8 +407,7 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
-				  enum dma_data_direction dma_dir)
+static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
@@ -418,8 +418,7 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 	lockdep_assert_held(&txq->lock);
 
 	/* We have only q->n_window txq->entries, but we use q->n_bd tfds */
-	iwl_pcie_tfd_unmap(trans, &txq->entries[idx].meta, &tfd_tmp[rd_ptr],
-			   dma_dir);
+	iwl_pcie_tfd_unmap(trans, &txq->entries[idx].meta, &tfd_tmp[rd_ptr]);
 
 	/* free SKB */
 	if (txq->entries) {
@@ -565,22 +564,13 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	enum dma_data_direction dma_dir;
 
 	if (!q->n_bd)
 		return;
 
-	/* In the command queue, all the TBs are mapped as BIDI
-	 * so unmap them as such.
-	 */
-	if (txq_id == trans_pcie->cmd_queue)
-		dma_dir = DMA_BIDIRECTIONAL;
-	else
-		dma_dir = DMA_TO_DEVICE;
-
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
-		iwl_pcie_txq_free_tfd(trans, txq, dma_dir);
+		iwl_pcie_txq_free_tfd(trans, txq);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 	spin_unlock_bh(&txq->lock);
@@ -962,7 +952,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 		iwl_pcie_txq_inval_byte_cnt_tbl(trans, txq);
 
-		iwl_pcie_txq_free_tfd(trans, txq, DMA_TO_DEVICE);
+		iwl_pcie_txq_free_tfd(trans, txq);
 	}
 
 	iwl_pcie_txq_progress(trans_pcie, txq);
@@ -1340,11 +1330,10 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		if (cmd->dataflags[i] & IWL_HCMD_DFL_DUP)
 			data = dup_buf;
 		phys_addr = dma_map_single(trans->dev, (void *)data,
-					   cmdlen[i], DMA_BIDIRECTIONAL);
+					   cmdlen[i], DMA_TO_DEVICE);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr],
-					   DMA_BIDIRECTIONAL);
+					   &txq->tfds[q->write_ptr]);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -1418,7 +1407,7 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	cmd = txq->entries[cmd_index].cmd;
 	meta = &txq->entries[cmd_index].meta;
 
-	iwl_pcie_tfd_unmap(trans, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
+	iwl_pcie_tfd_unmap(trans, meta, &txq->tfds[index]);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-- 
1.8.0

