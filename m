Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbYAJRYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:24:30 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 09/10] iwlwifi: A-MPDU Tx conform flows to mac80211
Date: Thu, 10 Jan 2008 19:22:21 +0200
Message-Id: <11999857502160-git-send-email-ron.rindjunsky@intel.com> (sfid-20080110_174505_614491_885EFE3C)
In-Reply-To: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch alters the current iwlwifi behavior to fit the flows introduced
by the mac80211, mainly queues handling and start/ stop call backs flows

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   24 ++-
 drivers/net/wireless/iwlwifi/iwl-4965.c          |  403 +++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   20 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |  121 ++++---
 4 files changed, 331 insertions(+), 237 deletions(-)

Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1300,6 +1300,25 @@ struct iwl4965_tx_resp {
 	__le32 status;	/* TX status (for aggregation status of 1st frame) */
 } __attribute__ ((packed));
 
+struct agg_tx_status {
+	__le16 status;
+	__le16 sequence;
+} __attribute__ ((packed));
+
+struct iwl4965_tx_resp_agg {
+	u8 frame_count;         /* 1 no aggregation, >1 aggregation */
+	u8 reserved1;
+	u8 failure_rts;
+	u8 failure_frame;
+	__le32 rate_n_flags;
+	__le16 wireless_media_time;
+	__le16 reserved3;
+	__le32 pa_power1;
+	__le32 pa_power2;
+	struct agg_tx_status status;    /* TX status (for aggregation status */
+					/* of 1st frame) */
+} __attribute__ ((packed));
+
 /*
  * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
  *
@@ -1313,9 +1332,8 @@ struct iwl4965_compressed_ba_resp {
 	/* Index of recipient (BA-sending) station in uCode's station table */
 	u8 sta_id;
 	u8 tid;
-	__le16 ba_seq_ctl;
-	__le32 ba_bitmap0;
-	__le32 ba_bitmap1;
+	__le16 seq_ctl;
+	__le64 bitmap;
 	__le16 scd_flow;
 	__le16 scd_ssn;
 } __attribute__ ((packed));
Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -79,6 +79,30 @@ const struct iwl4965_rate_info iwl4965_r
 	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
 };
 
+#ifdef CONFIG_IWL4965_HT
+
+static const u16 default_tid_to_tx_fifo[] = {
+	IWL_TX_FIFO_AC1,
+	IWL_TX_FIFO_AC0,
+	IWL_TX_FIFO_AC0,
+	IWL_TX_FIFO_AC1,
+	IWL_TX_FIFO_AC2,
+	IWL_TX_FIFO_AC2,
+	IWL_TX_FIFO_AC3,
+	IWL_TX_FIFO_AC3,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_NONE,
+	IWL_TX_FIFO_AC3
+};
+
+#endif	/*CONFIG_IWL4965_HT */
+
 static int is_fat_channel(__le32 rxon_flags)
 {
 	return (rxon_flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK) ||
@@ -4187,6 +4211,7 @@ static void iwl4965_set_tx_status(struct
 	tx_status->control.tx_rate = rate;
 }
 
+#endif/* CONFIG_IWL4965_HT_AGG */
 
 /**
  * iwl4965_sta_modify_enable_tid_tx - Enable Tx for this TID in station table
@@ -4206,7 +4231,6 @@ static void iwl4965_sta_modify_enable_ti
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
-
 /**
  * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
  *
@@ -4220,10 +4244,11 @@ static int iwl4965_tx_status_reply_compr
 
 {
 	int i, sh, ack;
-	u16 ba_seq_ctl = le16_to_cpu(ba_resp->ba_seq_ctl);
-	u32 bitmap0, bitmap1;
-	u32 resp_bitmap0 = le32_to_cpu(ba_resp->ba_bitmap0);
-	u32 resp_bitmap1 = le32_to_cpu(ba_resp->ba_bitmap1);
+	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	u64 bitmap;
+	int successes = 0;
+	struct ieee80211_tx_status *tx_status;
 
 	if (unlikely(!agg->wait_for_ba))  {
 		IWL_ERROR("Received BA when not expected\n");
@@ -4232,17 +4257,15 @@ static int iwl4965_tx_status_reply_compr
 
 	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = 0;
-	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->ba_seq_ctl);
+	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(ba_seq_ctl>>4);
+	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl>>4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
 	/* don't use 64-bit values for now */
-	bitmap0 = resp_bitmap0 >> sh;
-	bitmap1 = resp_bitmap1 >> sh;
-	bitmap0 |= (resp_bitmap1 & ((1<<sh)|((1<<sh)-1))) << (32 - sh);
+	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
 
 	if (agg->frame_count > (64 - sh)) {
 		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
@@ -4251,26 +4274,109 @@ static int iwl4965_tx_status_reply_compr
 
 	/* check for success or failure according to the
 	 * transmitted bitmap and block-ack bitmap */
-	bitmap0 &= agg->bitmap0;
-	bitmap1 &= agg->bitmap1;
+	bitmap &= agg->bitmap;
 
 	/* For each frame attempted in aggregation,
 	 * update driver's record of tx frame's status. */
 	for (i = 0; i < agg->frame_count ; i++) {
-		int idx = (agg->start_idx + i) & 0xff;
-		ack = bitmap0 & (1 << i);
+		ack = bitmap & (1 << i);
+		successes += !!ack;
 		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
-			ack? "ACK":"NACK", i, idx, agg->start_idx + i);
-		iwl4965_set_tx_status(priv, agg->txq_id, idx, ack, 0,
-			agg->rate_n_flags);
+			ack? "ACK":"NACK", i, (agg->start_idx + i) & 0xff,
+			agg->start_idx + i);
+	}
+
+	tx_status = &priv->txq[scd_flow].txb[agg->start_idx].status;
+	tx_status->flags = IEEE80211_TX_STATUS_ACK;
+	tx_status->retry_count++;
+#ifdef CONFIG_IWL4965_HT_AGG
+	tx_status->flags |= IEEE80211_TX_STATUS_AGG_STATS;
+	tx_status->successes = successes;
+	tx_status->frame_count = agg->frame_count;
+#endif	/* CONFIG_IWL4965_HT_AGG */
+	tx_status->control.tx_rate = agg->rate_n_flags;
+
+	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", bitmap);
 
+	return 0;
+}
+
+/**
+ * iwl4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
+ */
+static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv,
+					    u16 txq_id)
+{
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
+	iwl4965_write_prph(priv,
+		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+/**
+ * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
+ */
+static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
+					u16 ssn_idx, u8 tx_fifo)
+{
+	if (IWL_BACK_QUEUE_FIRST_ID > txq_id) {
+		IWL_WARNING("queue number too small: %d, must be > %d\n",
+				txq_id, IWL_BACK_QUEUE_FIRST_ID);
+		return -EINVAL;
 	}
 
-	IWL_DEBUG_TX_REPLY("Bitmap %x%x\n", bitmap0, bitmap1);
+	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
+
+	iwl4965_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
+
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	iwl4965_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl4965_txq_ctx_deactivate(priv, txq_id);
+	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
 	return 0;
 }
 
+int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
+					 u8 tid, int txq_id)
+{
+	struct iwl4965_queue *q = &priv->txq[txq_id].q;
+	u8 *addr = priv->stations[sta_id].sta.sta.addr;
+	struct iwl4965_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+
+	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* We are reclaiming the last packet of the */
+		/* aggregated HW queue */
+		if (txq_id  == tid_data->agg.txq_id &&
+		    q->read_ptr == q->write_ptr) {
+			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
+			int tx_fifo = default_tid_to_tx_fifo[tid];
+			IWL_DEBUG_HT("HW queue empty: continue DELBA flow\n");
+			iwl4965_tx_queue_agg_disable(priv, txq_id,
+						     ssn, tx_fifo);
+			tid_data->agg.state = IWL_AGG_OFF;
+			ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* We are reclaiming the last packet of the queue */
+		if (tid_data->tfds_in_queue == 0) {
+			IWL_DEBUG_HT("HW queue empty: continue ADDBA flow\n");
+			tid_data->agg.state = IWL_AGG_ON;
+			ieee80211_start_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+		}
+		break;
+	}
+	return 0;
+}
+
 /**
  * iwl4965_queue_dec_wrap - Decrement queue index, wrap back to end if needed
  * @index -- current index
@@ -4295,48 +4401,43 @@ static void iwl4965_rx_reply_compressed_
 	int index;
 	struct iwl4965_tx_queue *txq = NULL;
 	struct iwl4965_ht_agg *agg;
+	DECLARE_MAC_BUF(mac);
 
 	/* "flow" corresponds to Tx queue */
-	u16 ba_resp_scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
 
 	/* "ssn" is start of block-ack Tx window, corresponds to index
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (ba_resp_scd_flow >= ARRAY_SIZE(priv->txq)) {
+	if (scd_flow >= ARRAY_SIZE(priv->txq)) {
 		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
 		return;
 	}
 
-	txq = &priv->txq[ba_resp_scd_flow];
+	txq = &priv->txq[scd_flow];
 	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
 
 	/* Find index just before block-ack window */
 	index = iwl4965_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	/* TODO: Need to get this copy more safely - now good for debug */
-/*
-	{
-	DECLARE_MAC_BUF(mac);
+
 	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d]Received from %s, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
 			   print_mac(mac, (u8*) &ba_resp->sta_addr_lo32),
 			   ba_resp->sta_id);
-	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%X%X, scd_flow = "
+	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
 			   "%d, scd_ssn = %d\n",
 			   ba_resp->tid,
-			   ba_resp->ba_seq_ctl,
-			   ba_resp->ba_bitmap1,
-			   ba_resp->ba_bitmap0,
+			   ba_resp->seq_ctl,
+			   ba_resp->bitmap,
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%X%X \n",
+	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx \n",
 			   agg->start_idx,
-			   agg->bitmap1,
-			   agg->bitmap0);
-	}
-*/
+			   agg->bitmap);
 
 	/* Update driver's record of ACK vs. not for each frame in window */
 	iwl4965_tx_status_reply_compressed_ba(priv, agg, ba_resp);
@@ -4344,23 +4445,17 @@ static void iwl4965_rx_reply_compressed_
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff))
-		iwl4965_tx_queue_reclaim(priv, ba_resp_scd_flow, index);
-
-}
-
-
-/**
- * iwl4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
- */
-static void iwl4965_tx_queue_stop_scheduler(struct iwl4965_priv *priv, u16 txq_id)
-{
-	/* Simply stop the queue, but don't change any configuration;
-	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl4965_write_prph(priv,
-		KDR_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
+		int freed = iwl4965_tx_queue_reclaim(priv, scd_flow, index);
+		priv->stations[ba_resp->sta_id].
+			tid[ba_resp->tid].tfds_in_queue -= freed;
+		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+			priv->mac80211_registered &&
+			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
+			ieee80211_wake_queue(priv->hw, scd_flow);
+		iwl4965_check_empty_hw_queue(priv, ba_resp->sta_id,
+			ba_resp->tid, scd_flow);
+	}
 }
 
 /**
@@ -4390,6 +4485,7 @@ static int iwl4965_tx_queue_set_q2ratid(
 	return 0;
 }
 
+
 /**
  * iwl4965_tx_queue_agg_enable - Set up & enable aggregation for selected queue
  *
@@ -4457,48 +4553,6 @@ static int iwl4965_tx_queue_agg_enable(s
 	return 0;
 }
 
-/**
- * txq_id must be greater than IWL_BACK_QUEUE_FIRST_ID
- */
-static int iwl4965_tx_queue_agg_disable(struct iwl4965_priv *priv, u16 txq_id,
-					u16 ssn_idx, u8 tx_fifo)
-{
-	unsigned long flags;
-	int rc;
-
-	if (IWL_BACK_QUEUE_FIRST_ID > txq_id) {
-		IWL_WARNING("queue number too small: %d, must be > %d\n",
-				txq_id, IWL_BACK_QUEUE_FIRST_ID);
-		return -EINVAL;
-	}
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl4965_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
-	iwl4965_tx_queue_stop_scheduler(priv, txq_id);
-
-	iwl4965_clear_bits_prph(priv, KDR_SCD_QUEUECHAIN_SEL, (1 << txq_id));
-
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
-
-	iwl4965_clear_bits_prph(priv, KDR_SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl4965_txq_ctx_deactivate(priv, txq_id);
-	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
-
-	iwl4965_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
-#endif/* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 
 /**
@@ -4719,62 +4773,6 @@ static void iwl4965_sta_modify_del_ba_ti
 	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
-int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
-			     enum ieee80211_ampdu_mlme_action action,
-			     u8 *addr, u16 tid, u16 *ssn)
-{
-	struct iwl4965_priv *priv = hw->priv;
-	int sta_id;
-	DECLARE_MAC_BUF(mac);
-
-	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
-			print_mac(mac, addr), tid);
-	sta_id = iwl4965_hw_find_station(priv, addr);
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		IWL_DEBUG_HT("start Rx\n");
-		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		IWL_DEBUG_HT("stop Rx\n");
-		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
-		break;
-	case IEEE80211_AMPDU_TX_START:
-		IWL_DEBUG_HT("start Tx\n");
-		return iwl4965_mac_ht_tx_agg_start(hw, addr, tid, ssn);
-	case IEEE80211_AMPDU_TX_STOP:
-		IWL_DEBUG_HT("stop Tx\n");
-		return iwl4965_mac_ht_tx_agg_stop(hw, addr, tid);
-	default:
-		IWL_DEBUG_HT("unknown\n");
-		return -EINVAL;
-		break;
-	}
-	return 0;
-}
-
-#ifdef CONFIG_IWL4965_HT_AGG
-
-static const u16 default_tid_to_tx_fifo[] = {
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC0,
-	IWL_TX_FIFO_AC1,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC2,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_AC3,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_NONE,
-	IWL_TX_FIFO_AC3
-};
-
 /*
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
@@ -4794,54 +4792,61 @@ static int iwl4965_txq_ctx_activate_free
 int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da, u16 tid,
 			    u16 *start_seq_num)
 {
-
 	struct iwl4965_priv *priv = hw->priv;
 	int sta_id;
 	int tx_fifo;
 	int txq_id;
 	int ssn = -1;
+	int rc = 0;
 	unsigned long flags;
 	struct iwl4965_tid_data *tid_data;
 	DECLARE_MAC_BUF(mac);
 
-	/* Determine Tx DMA/FIFO channel for this Traffic ID */
 	if (likely(tid < ARRAY_SIZE(default_tid_to_tx_fifo)))
 		tx_fifo = default_tid_to_tx_fifo[tid];
 	else
 		return -EINVAL;
 
-	IWL_WARNING("iwl-AGG iwl4965_mac_ht_tx_agg_start on da=%s"
-		    " tid=%d\n", print_mac(mac, da), tid);
+	IWL_WARNING("%s on da = %s tid = %d\n",
+			__func__, print_mac(mac, da), tid);
 
-	/* Get index into station table */
 	sta_id = iwl4965_hw_find_station(priv, da);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
-	/* Find available Tx queue for aggregation */
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
+		IWL_ERROR("Start AGG when state is not IWL_AGG_OFF !\n");
+		return -ENXIO;
+	}
+
 	txq_id = iwl4965_txq_ctx_activate_free(priv);
 	if (txq_id == -1)
 		return -ENXIO;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	tid_data = &priv->stations[sta_id].tid[tid];
-
-	/* Get starting sequence number for 1st frame in block ack window.
-	 * We'll use least signif byte as 1st frame's index into Tx queue. */
 	ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	*start_seq_num = ssn;
-
-	/* Update driver's link quality manager */
-	iwl4965_ba_status(priv, tid, BA_STATUS_ACTIVE);
-
-	/* Set up and enable aggregation for selected Tx queue and FIFO */
-	return iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
+	rc = iwl4965_tx_queue_agg_enable(priv, txq_id, tx_fifo,
 					   sta_id, tid, ssn);
-}
+	if (rc)
+		return rc;
 
+	rc = 0;
+	if (tid_data->tfds_in_queue == 0) {
+		printk(KERN_ERR "HW queue is empty\n");
+		tid_data->agg.state = IWL_AGG_ON;
+		ieee80211_start_tx_ba_cb_irqsafe(hw, da, tid);
+	} else {
+		IWL_DEBUG_HT("HW queue is NOT empty: %d packets in HW queue\n",
+				tid_data->tfds_in_queue);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+	return rc;
+}
 
 int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, u8 *da, u16 tid)
 {
@@ -4849,7 +4854,8 @@ int iwl4965_mac_ht_tx_agg_stop(struct ie
 	struct iwl4965_priv *priv = hw->priv;
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl4965_tid_data *tid_data;
-	int rc;
+	int rc, write_ptr, read_ptr;
+	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
 	if (!da) {
@@ -4867,24 +4873,82 @@ int iwl4965_mac_ht_tx_agg_stop(struct ie
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
+		IWL_WARNING("Stopping AGG while state not IWL_AGG_ON\n");
+
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
 	txq_id = tid_data->agg.txq_id;
 
+	write_ptr = priv->txq[txq_id].q.write_ptr;
+	read_ptr = priv->txq[txq_id].q.read_ptr;
+
+	/* The queue is not empty */
+	if (write_ptr != read_ptr) {
+		IWL_DEBUG_HT("Stopping a non empty AGG HW QUEUE\n");
+		priv->stations[sta_id].tid[tid].agg.state =
+			IWL_EMPTYING_HW_QUEUE_DELBA;
+		return 0;
+	}
+
+	IWL_DEBUG_HT("HW queue empty\n");;
+	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	rc = iwl4965_grab_nic_access(priv);
+	if (rc) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return rc;
+	}
 	rc = iwl4965_tx_queue_agg_disable(priv, txq_id, ssn, tx_fifo_id);
+	iwl4965_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	/* FIXME: need more safe way to handle error condition */
 	if (rc)
 		return rc;
 
-	iwl4965_ba_status(priv, tid, BA_STATUS_INITIATOR_DELBA);
+	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, da, tid);
+
 	IWL_DEBUG_INFO("iwl4965_mac_ht_tx_agg_stop on da=%s tid=%d\n",
 		       print_mac(mac, da), tid);
 
 	return 0;
 }
 
+int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
+			     enum ieee80211_ampdu_mlme_action action,
+			     u8 *addr, u16 tid, u16 *ssn)
+{
+	struct iwl4965_priv *priv = hw->priv;
+	int sta_id;
+	DECLARE_MAC_BUF(mac);
+
+	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
+			print_mac(mac, addr), tid);
+	sta_id = iwl4965_hw_find_station(priv, addr);
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		IWL_DEBUG_HT("start Rx\n");
+		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		IWL_DEBUG_HT("stop Rx\n");
+		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		IWL_DEBUG_HT("start Tx\n");
+		return iwl4965_mac_ht_tx_agg_start(hw, addr, tid, ssn);
+	case IEEE80211_AMPDU_TX_STOP:
+		IWL_DEBUG_HT("stop Tx\n");
+		return iwl4965_mac_ht_tx_agg_stop(hw, addr, tid);
+	default:
+		IWL_DEBUG_HT("unknown\n");
+		return -EINVAL;
+		break;
+	}
+	return 0;
+}
 
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 
 /* Set up 4965-specific Rx frame reply handlers */
@@ -4901,9 +4965,7 @@ void iwl4965_hw_rx_handler_setup(struct 
 	    iwl4965_rx_missed_beacon_notif;
 
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 }
 
Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -433,7 +433,6 @@ struct iwl4965_rx_queue {
 #define IWL_INVALID_VALUE    -1
 
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 /**
  * struct iwl4965_ht_agg -- aggregation status while waiting for block-ack
  * @txq_id: Tx queue used for Tx attempt
@@ -453,19 +452,22 @@ struct iwl4965_ht_agg {
 	u16 frame_count;
 	u16 wait_for_ba;
 	u16 start_idx;
-	u32 bitmap0;
-	u32 bitmap1;
+	u64 bitmap;
 	u32 rate_n_flags;
+#define IWL_AGG_OFF 0
+#define IWL_AGG_ON 1
+#define IWL_EMPTYING_HW_QUEUE_ADDBA 2
+#define IWL_EMPTYING_HW_QUEUE_DELBA 3
+	u8 state;
 };
-#endif /* CONFIG_IWL4965_HT_AGG */
+
 #endif /* CONFIG_IWL4965_HT */
 
 struct iwl4965_tid_data {
 	u16 seq_number;
+	u16 tfds_in_queue;
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 	struct iwl4965_ht_agg agg;
-#endif	/* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 };
 
@@ -743,7 +745,7 @@ extern u8 iwl4965_hw_find_station(struct
 
 extern int iwl4965_hw_channel_switch(struct iwl4965_priv *priv, u16 channel);
 extern int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index);
-
+extern int iwl4965_queue_space(const struct iwl4965_queue *q);
 struct iwl4965_priv;
 
 /*
@@ -779,6 +781,8 @@ extern void iwl4965_set_ht_add_station(s
 extern int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 				    enum ieee80211_ampdu_mlme_action action,
 				    u8 *addr, u16 tid, u16 *ssn);
+extern int iwl4965_check_empty_hw_queue(struct iwl4965_priv *priv, int sta_id,
+					u8 tid, int txq_id);
 #ifdef CONFIG_IWL4965_HT_AGG
 extern void iwl4965_turn_off_agg(struct iwl4965_priv *priv, u8 tid);
 extern void iwl4965_tl_get_stats(struct iwl4965_priv *priv,
@@ -856,7 +860,7 @@ struct iwl4965_agg_control {
 	u32 ba_timeout;
 	struct iwl4965_traffic_load traffic_load[TID_MAX_LOAD_COUNT];
 };
-#endif				/*CONFIG_IWL4965_HT_AGG */
+#endif /*CONFIG_IWL4965_HT_AGG */
 
 struct iwl4965_lq_mngr {
 #ifdef CONFIG_IWL4965_HT_AGG
Index: wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- wl2_6_24_rc5_upstream.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ wl2_6_24_rc5_upstream/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -205,7 +205,7 @@ static void iwl4965_print_hex_dump(int l
  * See more detailed info in iwl-4965-hw.h.
  ***************************************************/
 
-static int iwl4965_queue_space(const struct iwl4965_queue *q)
+int iwl4965_queue_space(const struct iwl4965_queue *q)
 {
 	int s = q->read_ptr - q->write_ptr;
 
@@ -2959,11 +2959,10 @@ static int iwl4965_tx_skb(struct iwl4965
 				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 		/* aggregation is on for this <sta,tid> */
-		if (ctl->flags & IEEE80211_TXCTL_HT_MPDU_AGG)
+		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-#endif /* CONFIG_IWL4965_HT_AGG */
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 #endif /* CONFIG_IWL4965_HT */
 	}
 
@@ -3515,10 +3514,10 @@ int iwl4965_tx_queue_reclaim(struct iwl4
 		nfreed++;
 	}
 
-	if (iwl4965_queue_space(q) > q->low_mark && (txq_id >= 0) &&
+/*	if (iwl4965_queue_space(q) > q->low_mark && (txq_id >= 0) &&
 			(txq_id != IWL_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
-		ieee80211_wake_queue(priv->hw, txq_id);
+		ieee80211_wake_queue(priv->hw, txq_id); */
 
 
 	return nfreed;
@@ -3537,7 +3536,6 @@ static int iwl4965_is_tx_success(u32 sta
  *
  ******************************************************************************/
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 
 static inline int iwl4965_get_ra_sta_id(struct iwl4965_priv *priv,
 				    struct ieee80211_hdr *hdr)
@@ -3572,11 +3570,11 @@ static inline u32 iwl4965_get_scd_ssn(st
  */
 static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 				      struct iwl4965_ht_agg *agg,
-				      struct iwl4965_tx_resp *tx_resp,
+				      struct iwl4965_tx_resp_agg *tx_resp,
 				      u16 start_idx)
 {
-	u32 status;
-	__le32 *frame_status = &tx_resp->status;
+	u16 status;
+	struct agg_tx_status *frame_status = &tx_resp->status;
 	struct ieee80211_tx_status *tx_status = NULL;
 	struct ieee80211_hdr *hdr = NULL;
 	int i, sh;
@@ -3589,26 +3587,25 @@ static int iwl4965_tx_status_reply_tx(st
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
 	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
-	agg->bitmap0 = agg->bitmap1 = 0;
+	agg->bitmap = 0;
 
 	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
 		/* Only one frame was attempted; no block-ack will arrive */
-		struct iwl4965_tx_queue *txq ;
-		status = le32_to_cpu(frame_status[0]);
+		status = le16_to_cpu(frame_status[0].status);
+		seq  = le16_to_cpu(frame_status[0].sequence);
+		idx = SEQ_TO_INDEX(seq);
+		txq_id = SEQ_TO_QUEUE(seq);
 
-		txq_id = agg->txq_id;
-		txq = &priv->txq[txq_id];
 		/* FIXME: code repetition */
-		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d \n",
-				   agg->frame_count, agg->start_idx);
+		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
+				   agg->frame_count, agg->start_idx, idx);
 
-		tx_status = &(priv->txq[txq_id].txb[txq->q.read_ptr].status);
+		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
 		tx_status->queue_number = status & 0xff;
-		tx_status->queue_length = tx_resp->bt_kill_count;
-		tx_status->queue_length |= tx_resp->failure_rts;
-
+		tx_status->queue_length = tx_resp->failure_rts;
+		tx_status->control.flags &= ~IEEE80211_TXCTL_AMPDU;
 		tx_status->flags = iwl4965_is_tx_success(status)?
 			IEEE80211_TX_STATUS_ACK : 0;
 		tx_status->control.tx_rate =
@@ -3629,8 +3626,8 @@ static int iwl4965_tx_status_reply_tx(st
 		/* Construct bit-map of pending frames within Tx window */
 		for (i = 0; i < agg->frame_count; i++) {
 			u16 sc;
-			status = le32_to_cpu(frame_status[i]);
-			seq  = status >> 16;
+			status = le16_to_cpu(frame_status[i].status);
+			seq  = le16_to_cpu(frame_status[i].sequence);
 			idx = SEQ_TO_INDEX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
@@ -3674,13 +3671,12 @@ static int iwl4965_tx_status_reply_tx(st
 					   start, (u32)(bitmap & 0xFFFFFFFF));
 		}
 
-		agg->bitmap0 = bitmap & 0xFFFFFFFF;
-		agg->bitmap1 = bitmap >> 32;
+		agg->bitmap = bitmap;
 		agg->start_idx = start;
 		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
-		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%x\n",
+		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
-				   agg->bitmap0);
+				   agg->bitmap);
 
 		if (bitmap)
 			agg->wait_for_ba = 1;
@@ -3688,7 +3684,6 @@ static int iwl4965_tx_status_reply_tx(st
 	return 0;
 }
 #endif
-#endif
 
 /**
  * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
@@ -3705,9 +3700,9 @@ static void iwl4965_rx_reply_tx(struct i
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
-	int tid, sta_id;
-#endif
+	int tid = MAX_TID_COUNT, sta_id = IWL_INVALID_STATION;
+	struct ieee80211_hdr *hdr;
+	__le16 *qc;
 #endif
 
 	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
@@ -3719,44 +3714,51 @@ static void iwl4965_rx_reply_tx(struct i
 	}
 
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
+	hdr = iwl4965_tx_queue_get_hdr(priv, txq_id, index);
+	qc = ieee80211_get_qos_ctrl(hdr);
+
+	if (qc)
+		tid = le16_to_cpu(*qc) & 0xf;
+
+	sta_id = iwl4965_get_ra_sta_id(priv, hdr);
+	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
+		IWL_ERROR("Station not known\n");
+		return;
+	}
+
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl4965_get_scd_ssn(tx_resp);
-		struct ieee80211_hdr *hdr =
-			iwl4965_tx_queue_get_hdr(priv, txq_id, index);
 		struct iwl4965_ht_agg *agg = NULL;
-		__le16 *qc = ieee80211_get_qos_ctrl(hdr);
 
-		if (qc == NULL) {
-			IWL_ERROR("BUG_ON qc is null!!!!\n");
+		if (!qc)
 			return;
-		}
-
-		tid = le16_to_cpu(*qc) & 0xf;
-
-		sta_id = iwl4965_get_ra_sta_id(priv, hdr);
-		if (unlikely(sta_id == IWL_INVALID_STATION)) {
-			IWL_ERROR("Station not known for\n");
-			return;
-		}
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
 
-		iwl4965_tx_status_reply_tx(priv, agg, tx_resp, index);
+		iwl4965_tx_status_reply_tx(priv, agg,
+				(struct iwl4965_tx_resp_agg *)tx_resp, index);
 
 		if ((tx_resp->frame_count == 1) &&
 		    !iwl4965_is_tx_success(status)) {
 			/* TODO: send BAR */
 		}
 
-		if ((txq->q.read_ptr != (scd_ssn & 0xff))) {
+		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
+			int freed;
 			index = iwl4965_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
-			iwl4965_tx_queue_reclaim(priv, txq_id, index);
+			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+
+			if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+			    txq_id >= 0 && priv->mac80211_registered &&
+			    agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
+				ieee80211_wake_queue(priv->hw, txq_id);
+
+			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
 		}
 	} else {
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
@@ -3777,12 +3779,21 @@ static void iwl4965_rx_reply_tx(struct i
 		     tx_resp->failure_frame);
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
-	if (index != -1)
-		iwl4965_tx_queue_reclaim(priv, txq_id, index);
+	if (index != -1) {
+		int freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
+#ifdef CONFIG_IWL4965_HT
+		if (tid != MAX_TID_COUNT)
+			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
+		if (iwl4965_queue_space(&txq->q) > txq->q.low_mark &&
+			(txq_id >= 0) &&
+			priv->mac80211_registered)
+			ieee80211_wake_queue(priv->hw, txq_id);
+		if (tid != MAX_TID_COUNT)
+			iwl4965_check_empty_hw_queue(priv, sta_id, tid, txq_id);
+#endif
+	}
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 	}
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
@@ -9041,10 +9052,8 @@ static int iwl4965_pci_probe(struct pci_
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 #ifdef CONFIG_IWL4965_HT
-#ifdef CONFIG_IWL4965_HT_AGG
 	/* Enhanced value; more queues, to support 11n aggregation */
 	hw->queues = 16;
-#endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 
 	spin_lock_init(&priv->lock);
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

