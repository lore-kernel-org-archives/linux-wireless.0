Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab1GPPcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/18] iwlagn: move Tx datapath to transport layer
Date: Sat, 16 Jul 2011 07:56:22 -0700
Message-Id: <1310828199-18000-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173215_664697_82BD3D84)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Split the Tx datapath in two parts:
* the first deals with the Tx cmd composition
* the second attaches the skb + Tx cmd to the queues

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |  158 ++--------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    4 +
 drivers/net/wireless/iwlwifi/iwl-trans.c  |  156 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   13 +++
 5 files changed, 189 insertions(+), 146 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 7d3aad8..f306824 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -39,6 +39,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 #include "iwl-agn.h"
+#include "iwl-trans.h"
 
 /*
  * mac80211 queues, ACs, hardware queues, FIFOs.
@@ -98,7 +99,7 @@ static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
 /**
  * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
-static void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt)
 {
@@ -547,26 +548,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
 	struct iwl_station_priv *sta_priv = NULL;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	struct iwl_device_cmd *out_cmd;
-	struct iwl_cmd_meta *out_meta;
-	struct iwl_tx_cmd *tx_cmd;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwl_tx_cmd *tx_cmd;
 	int txq_id;
-	dma_addr_t phys_addr = 0;
-	dma_addr_t txcmd_phys;
-	dma_addr_t scratch_phys;
-	u16 len, firstlen, secondlen;
+
 	u16 seq_number = 0;
 	__le16 fc;
 	u8 hdr_len;
+	u16 len;
 	u8 sta_id;
-	u8 wait_write_ptr = 0;
 	u8 tid = 0;
-	u8 *qc = NULL;
 	unsigned long flags;
 	bool is_agg = false;
 
@@ -614,8 +606,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
-	if (sta)
-		sta_priv = (void *)sta->drv_priv;
+	if (info->control.sta)
+		sta_priv = (void *)info->control.sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
 	    (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)) {
@@ -650,6 +642,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_lock(&priv->sta_lock);
 
 	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = NULL;
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 
@@ -670,38 +663,13 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		}
 	}
 
-	txq = &priv->txq[txq_id];
-	q = &txq->q;
-
-	if (unlikely(iwl_queue_space(q) < q->high_mark))
+	tx_cmd = trans_get_tx_cmd(priv, txq_id);
+	if (unlikely(!tx_cmd))
 		goto drop_unlock_sta;
 
-	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb = skb;
-	txq->txb[q->write_ptr].ctx = ctx;
-
-	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = txq->cmd[q->write_ptr];
-	out_meta = &txq->meta[q->write_ptr];
-	tx_cmd = &out_cmd->cmd.tx;
-	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
-
-	/*
-	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
-	 * after Tx, uCode's Tx response will return this value so driver can
-	 * locate the frame within the tx queue and do post-tx processing.
-	 */
-	out_cmd->hdr.cmd = REPLY_TX;
-	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
-
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
-
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
@@ -716,54 +684,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
 
 	iwl_update_stats(priv, true, fc, len);
-	/*
-	 * Use the first empty entry in this queue's command buffer array
-	 * to contain the Tx command and MAC header concatenated together
-	 * (payload data will be in another buffer).
-	 * Size of this varies, due to varying MAC header length.
-	 * If end is not dword aligned, we'll have 2 extra bytes at the end
-	 * of the MAC header (device reads on dword boundaries).
-	 * We'll tell device about this padding later.
-	 */
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-	firstlen = (len + 3) & ~3;
-
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (firstlen != len)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = dma_map_single(priv->bus.dev,
-				    &out_cmd->hdr, firstlen,
-				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(priv->bus.dev, txcmd_phys)))
-		goto drop_unlock_sta;
-	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, firstlen);
 
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	secondlen = skb->len - hdr_len;
-	if (secondlen > 0) {
-		phys_addr = dma_map_single(priv->bus.dev, skb->data + hdr_len,
-					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
-			dma_unmap_single(priv->bus.dev,
-					 dma_unmap_addr(out_meta, mapping),
-					 dma_unmap_len(out_meta, len),
-					 DMA_BIDIRECTIONAL);
-			goto drop_unlock_sta;
-		}
-	}
+	if (trans_tx(priv, skb, tx_cmd, txq_id, fc, is_agg, ctx))
+		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc)) {
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
@@ -772,55 +695,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	spin_unlock(&priv->sta_lock);
-
-	/* Attach buffers to TFD */
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1);
-	if (secondlen > 0)
-		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
-					     secondlen, 0);
-
-	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-				offsetof(struct iwl_tx_cmd, scratch);
-
-	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(priv->bus.dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
-	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
-
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x\n",
-		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
-
-	/* Set up entry for this TFD in Tx byte-count array */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
-					       le16_to_cpu(tx_cmd->len));
-
-	dma_sync_single_for_device(priv->bus.dev, txcmd_phys, firstlen,
-			DMA_BIDIRECTIONAL);
-
-	trace_iwlwifi_dev_tx(priv,
-			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
-			     &out_cmd->hdr, firstlen,
-			     skb->data + hdr_len, secondlen);
-
-	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/*
-	 * At this point the frame is "transmitted" successfully
-	 * and we will get a TX status notification eventually,
-	 * regardless of the value of ret. "ret" only indicates
-	 * whether or not we should update the write pointer.
-	 */
-
-	/*
 	 * Avoid atomic ops if it isn't an associated client.
 	 * Also, if this is a packet for aggregation, don't
 	 * increase the counter because the ucode will stop
@@ -830,17 +707,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
-	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
-		if (wait_write_ptr) {
-			spin_lock_irqsave(&priv->lock, flags);
-			txq->need_update = 1;
-			iwl_txq_update_write_ptr(priv, txq);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		} else {
-			iwl_stop_queue(priv, txq);
-		}
-	}
-
 	return 0;
 
 drop_unlock_sta:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5f58b44..aed86c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -142,6 +142,10 @@ void iwlagn_stop_device(struct iwl_priv *priv);
 /* tx queue */
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 		     int txq_id, u32 index);
+void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt);
+
 void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a0cca02..173fad2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1257,6 +1257,10 @@ struct iwl_trans_ops {
 
 	int (*send_cmd_pdu)(struct iwl_priv *priv, u8 id, u32 flags, u16 len,
 		     const void *data);
+	struct iwl_tx_cmd * (*get_tx_cmd)(struct iwl_priv *priv, int txq_id);
+	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
+		struct iwl_rxon_context *ctx);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index d760857..acd2a5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -552,6 +552,159 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	return 0;
 }
 
+static struct iwl_tx_cmd *iwl_trans_get_tx_cmd(struct iwl_priv *priv,
+						int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_device_cmd *dev_cmd;
+
+	if (unlikely(iwl_queue_space(q) < q->high_mark))
+		return NULL;
+
+	/*
+	 * Set up the Tx-command (not MAC!) header.
+	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * after Tx, uCode's Tx response will return this value so driver can
+	 * locate the frame within the tx queue and do post-tx processing.
+	 */
+	dev_cmd = txq->cmd[q->write_ptr];
+	memset(dev_cmd, 0, sizeof(*dev_cmd));
+	dev_cmd->hdr.cmd = REPLY_TX;
+	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->write_ptr)));
+	return &dev_cmd->cmd.tx;
+}
+
+static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
+		struct iwl_rxon_context *ctx)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_device_cmd *dev_cmd = txq->cmd[q->write_ptr];
+	struct iwl_cmd_meta *out_meta;
+
+	dma_addr_t phys_addr = 0;
+	dma_addr_t txcmd_phys;
+	dma_addr_t scratch_phys;
+	u16 len, firstlen, secondlen;
+	u8 wait_write_ptr = 0;
+	u8 hdr_len = ieee80211_hdrlen(fc);
+
+	/* Set up driver data for this TFD */
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
+	txq->txb[q->write_ptr].skb = skb;
+	txq->txb[q->write_ptr].ctx = ctx;
+
+	/* Set up first empty entry in queue's array of Tx/cmd buffers */
+	out_meta = &txq->meta[q->write_ptr];
+
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+	firstlen = (len + 3) & ~3;
+
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (firstlen != len)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = dma_map_single(priv->bus.dev,
+				    &dev_cmd->hdr, firstlen,
+				    DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(priv->bus.dev, txcmd_phys)))
+		return -1;
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, firstlen);
+
+	if (!ieee80211_has_morefrags(fc)) {
+		txq->need_update = 1;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
+
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	secondlen = skb->len - hdr_len;
+	if (secondlen > 0) {
+		phys_addr = dma_map_single(priv->bus.dev, skb->data + hdr_len,
+					   secondlen, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
+			dma_unmap_single(priv->bus.dev,
+					 dma_unmap_addr(out_meta, mapping),
+					 dma_unmap_len(out_meta, len),
+					 DMA_BIDIRECTIONAL);
+			return -1;
+		}
+	}
+
+	/* Attach buffers to TFD */
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1);
+	if (secondlen > 0)
+		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
+					     secondlen, 0);
+
+	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
+				offsetof(struct iwl_tx_cmd, scratch);
+
+	/* take back ownership of DMA buffer to enable update */
+	dma_sync_single_for_cpu(priv->bus.dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
+	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
+
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x\n",
+		     le16_to_cpu(dev_cmd->hdr.sequence));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+
+	/* Set up entry for this TFD in Tx byte-count array */
+	if (ampdu)
+		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
+					       le16_to_cpu(tx_cmd->len));
+
+	dma_sync_single_for_device(priv->bus.dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
+
+	trace_iwlwifi_dev_tx(priv,
+			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
+			     sizeof(struct iwl_tfd),
+			     &dev_cmd->hdr, firstlen,
+			     skb->data + hdr_len, secondlen);
+
+	/* Tell device the write index *just past* this latest filled TFD */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	iwl_txq_update_write_ptr(priv, txq);
+
+	/*
+	 * At this point the frame is "transmitted" successfully
+	 * and we will get a TX status notification eventually,
+	 * regardless of the value of ret. "ret" only indicates
+	 * whether or not we should update the write pointer.
+	 */
+	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
+		if (wait_write_ptr) {
+			txq->need_update = 1;
+			iwl_txq_update_write_ptr(priv, txq);
+		} else {
+			iwl_stop_queue(priv, txq);
+		}
+	}
+	return 0;
+}
+
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
 	.rx_stop = iwl_trans_rx_stop,
@@ -563,6 +716,9 @@ static const struct iwl_trans_ops trans_ops = {
 
 	.send_cmd = iwl_send_cmd,
 	.send_cmd_pdu = iwl_send_cmd_pdu,
+
+	.get_tx_cmd = iwl_trans_get_tx_cmd,
+	.tx = iwl_trans_tx,
 };
 
 void iwl_trans_register(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 111acca..f10bee8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -102,4 +102,17 @@ static inline int trans_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 	return priv->trans.ops->send_cmd_pdu(priv, id, flags, len, data);
 }
 
+static inline struct iwl_tx_cmd *trans_get_tx_cmd(struct iwl_priv *priv,
+					int txq_id)
+{
+	return priv->trans.ops->get_tx_cmd(priv, txq_id);
+}
+
+static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
+		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
+		struct iwl_rxon_context *ctx)
+{
+	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
+}
+
 void iwl_trans_register(struct iwl_trans *trans);
-- 
1.7.0.4

