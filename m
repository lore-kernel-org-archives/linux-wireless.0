Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbbLUUwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/45] iwlwifi: pcie: re-organize code towards TSO
Date: Mon, 21 Dec 2015 22:50:27 +0200
Message-Id: <1450731046-2796-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215222_596752_D7C4F681)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code that handles the TBs that contain the WiFi payload
will be changed for TSO. Move the current code into a
separate function.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 113 +++++++++++++++------------
 1 file changed, 64 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 6c460a5..890148c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1798,6 +1798,66 @@ int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	return iwl_pcie_send_hcmd_sync(trans, cmd);
 }
 
+static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
+			     struct iwl_txq *txq, u8 hdr_len,
+			     struct iwl_cmd_meta *out_meta,
+			     struct iwl_device_cmd *dev_cmd, u16 tb1_len)
+{
+	struct iwl_queue *q = &txq->q;
+	u16 tb2_len;
+	int i;
+
+	/*
+	 * Set up TFD's third entry to point directly to remainder
+	 * of skb's head, if any
+	 */
+	tb2_len = skb_headlen(skb) - hdr_len;
+
+	if (tb2_len > 0) {
+		dma_addr_t tb2_phys = dma_map_single(trans->dev,
+						     skb->data + hdr_len,
+						     tb2_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
+			iwl_pcie_tfd_unmap(trans, out_meta,
+					   &txq->tfds[q->write_ptr]);
+			return -EINVAL;
+		}
+		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
+	}
+
+	/* set up the remaining entries to point to the data */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		dma_addr_t tb_phys;
+		int tb_idx;
+
+		if (!skb_frag_size(frag))
+			continue;
+
+		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
+					   skb_frag_size(frag), DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
+			iwl_pcie_tfd_unmap(trans, out_meta,
+					   &txq->tfds[q->write_ptr]);
+			return -EINVAL;
+		}
+		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
+						skb_frag_size(frag), false);
+
+		out_meta->flags |= BIT(tb_idx + CMD_TB_BITMAP_POS);
+	}
+
+	trace_iwlwifi_dev_tx(trans->dev, skb,
+			     &txq->tfds[txq->q.write_ptr],
+			     sizeof(struct iwl_tfd),
+			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
+			     skb->data + hdr_len, tb2_len);
+	trace_iwlwifi_dev_tx_data(trans->dev, skb,
+				  hdr_len, skb->len - hdr_len);
+	return 0;
+}
+
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id)
 {
@@ -1809,12 +1869,11 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_queue *q;
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
 	void *tb1_addr;
-	u16 len, tb1_len, tb2_len;
+	u16 len, tb1_len;
 	bool wait_write_ptr;
 	__le16 fc;
 	u8 hdr_len;
 	u16 wifi_seq;
-	int i;
 
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
@@ -1910,57 +1969,13 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		goto out_err;
 	iwl_pcie_txq_build_tfd(trans, txq, tb1_phys, tb1_len, false);
 
-	/*
-	 * Set up TFD's third entry to point directly to remainder
-	 * of skb's head, if any
-	 */
-	tb2_len = skb_headlen(skb) - hdr_len;
-	if (tb2_len > 0) {
-		dma_addr_t tb2_phys = dma_map_single(trans->dev,
-						     skb->data + hdr_len,
-						     tb2_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(trans->dev, tb2_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
-			goto out_err;
-		}
-		iwl_pcie_txq_build_tfd(trans, txq, tb2_phys, tb2_len, false);
-	}
-
-	/* set up the remaining entries to point to the data */
-	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		dma_addr_t tb_phys;
-		int tb_idx;
-
-		if (!skb_frag_size(frag))
-			continue;
-
-		tb_phys = skb_frag_dma_map(trans->dev, frag, 0,
-					   skb_frag_size(frag), DMA_TO_DEVICE);
-
-		if (unlikely(dma_mapping_error(trans->dev, tb_phys))) {
-			iwl_pcie_tfd_unmap(trans, out_meta,
-					   &txq->tfds[q->write_ptr]);
-			goto out_err;
-		}
-		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
-						skb_frag_size(frag), false);
-
-		out_meta->flags |= BIT(tb_idx + CMD_TB_BITMAP_POS);
-	}
+	if (unlikely(iwl_fill_data_tbs(trans, skb, txq, hdr_len,
+				       out_meta, dev_cmd, tb1_len)))
+		goto out_err;
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
-	trace_iwlwifi_dev_tx(trans->dev, skb,
-			     &txq->tfds[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
-			     &dev_cmd->hdr, IWL_HCMD_SCRATCHBUF_SIZE + tb1_len,
-			     skb->data + hdr_len, tb2_len);
-	trace_iwlwifi_dev_tx_data(trans->dev, skb,
-				  hdr_len, skb->len - hdr_len);
-
 	wait_write_ptr = ieee80211_has_morefrags(fc);
 
 	/* start timer if queue currently empty */
-- 
2.5.0

