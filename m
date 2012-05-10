Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2EJQJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:09:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] iwlwifi: s/iwlagn_unmap_tfd/iwl_unmap_tfd
Date: Thu, 10 May 2012 18:09:07 +0200
Message-Id: <1336666148-24471-3-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180922_616917_10CEDC8C)
In-Reply-To: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
References: <1336666148-24471-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index cf8f3cf..e727c4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -178,8 +178,8 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
 	return tfd->num_tbs & 0x1f;
 }
 
-static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
-		     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
+static void iwl_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
+			  struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
 {
 	int i;
 	int num_tbs;
@@ -229,8 +229,8 @@ void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	lockdep_assert_held(&txq->lock);
 
 	/* We have only q->n_window txq->entries, but we use q->n_bd tfds */
-	iwlagn_unmap_tfd(trans, &txq->entries[idx].meta,
-			 &tfd_tmp[rd_ptr], dma_dir);
+	iwl_unmap_tfd(trans, &txq->entries[idx].meta, &tfd_tmp[rd_ptr],
+		      dma_dir);
 
 	/* free SKB */
 	if (txq->entries) {
@@ -647,9 +647,9 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 					   (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
-			iwlagn_unmap_tfd(trans, out_meta,
-					 &txq->tfds[q->write_ptr],
-					 DMA_BIDIRECTIONAL);
+			iwl_unmap_tfd(trans, out_meta,
+				      &txq->tfds[q->write_ptr],
+				      DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -784,8 +784,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 	cmd = txq->entries[cmd_index].cmd;
 	meta = &txq->entries[cmd_index].meta;
 
-	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
-			 DMA_BIDIRECTIONAL);
+	iwl_unmap_tfd(trans, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-- 
1.7.10

