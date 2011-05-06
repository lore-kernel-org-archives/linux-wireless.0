Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1EFS2p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 7/7] iwlagn: check DMA mapping errors
Date: Fri,  6 May 2011 11:04:40 -0700
Message-Id: <1304705080-29349-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202855_277549_1DDFA31A)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

DMA mappings can fail, but the current code
doesn't check for that. Add checking, which
requires some restructuring for proper error
paths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   60 +++++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   13 +++++-
 2 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 26601b7..7c1becf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -537,7 +537,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl_tx_cmd *tx_cmd;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 	int txq_id;
-	dma_addr_t phys_addr;
+	dma_addr_t phys_addr = 0;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
 	u16 len, firstlen, secondlen;
@@ -564,7 +564,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
-		goto drop_unlock;
+		goto drop_unlock_priv;
 	}
 
 	fc = hdr->frame_control;
@@ -585,7 +585,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
-		goto drop_unlock;
+		goto drop_unlock_priv;
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
@@ -628,10 +628,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		if (WARN_ON_ONCE(tid >= MAX_TID_COUNT)) {
-			spin_unlock(&priv->sta_lock);
-			goto drop_unlock;
-		}
+
+		if (WARN_ON_ONCE(tid >= MAX_TID_COUNT))
+			goto drop_unlock_sta;
+
 		seq_number = priv->stations[sta_id].tid[tid].seq_number;
 		seq_number &= IEEE80211_SCTL_SEQ;
 		hdr->seq_ctrl = hdr->seq_ctrl &
@@ -649,18 +649,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
-	if (unlikely(iwl_queue_space(q) < q->high_mark)) {
-		spin_unlock(&priv->sta_lock);
-		goto drop_unlock;
-	}
-
-	if (ieee80211_is_data_qos(fc)) {
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
-		if (!ieee80211_has_morefrags(fc))
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-	}
-
-	spin_unlock(&priv->sta_lock);
+	if (unlikely(iwl_queue_space(q) < q->high_mark))
+		goto drop_unlock_sta;
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
@@ -724,12 +714,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txcmd_phys = pci_map_single(priv->pci_dev,
 				    &out_cmd->hdr, firstlen,
 				    PCI_DMA_BIDIRECTIONAL);
+	if (unlikely(pci_dma_mapping_error(priv->pci_dev, txcmd_phys)))
+		goto drop_unlock_sta;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   txcmd_phys, firstlen, 1, 0);
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -744,10 +732,30 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (secondlen > 0) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
 					   secondlen, PCI_DMA_TODEVICE);
+		if (unlikely(pci_dma_mapping_error(priv->pci_dev, phys_addr))) {
+			pci_unmap_single(priv->pci_dev,
+					 dma_unmap_addr(out_meta, mapping),
+					 dma_unmap_len(out_meta, len),
+					 PCI_DMA_BIDIRECTIONAL);
+			goto drop_unlock_sta;
+		}
+	}
+
+	if (ieee80211_is_data_qos(fc)) {
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
+		if (!ieee80211_has_morefrags(fc))
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+	}
+
+	spin_unlock(&priv->sta_lock);
+
+	/* Attach buffers to TFD */
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   txcmd_phys, firstlen, 1, 0);
+	if (secondlen > 0)
 		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 							   phys_addr, secondlen,
 							   0, 0);
-	}
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 				offsetof(struct iwl_tx_cmd, scratch);
@@ -813,7 +821,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	return 0;
 
-drop_unlock:
+drop_unlock_sta:
+	spin_unlock(&priv->sta_lock);
+drop_unlock_priv:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return -1;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 5a7cd17..e69597e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -500,7 +500,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	}
 
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
-	out_meta->flags = cmd->flags | CMD_MAPPED;
 	if (cmd->flags & CMD_WANT_SKB)
 		out_meta->source = cmd;
 	if (cmd->flags & CMD_ASYNC)
@@ -538,13 +537,20 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 				q->write_ptr, idx, priv->cmd_queue);
 	}
 #endif
-	txq->need_update = 1;
-
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
 				   fix_size, PCI_DMA_BIDIRECTIONAL);
+	if (unlikely(pci_dma_mapping_error(priv->pci_dev, phys_addr))) {
+		idx = -ENOMEM;
+		goto out;
+	}
+
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, fix_size);
 
+	out_meta->flags = cmd->flags | CMD_MAPPED;
+
+	txq->need_update = 1;
+
 	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
 
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
@@ -555,6 +561,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_txq_update_write_ptr(priv, txq);
 
+ out:
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
 	return idx;
 }
-- 
1.7.0.4

