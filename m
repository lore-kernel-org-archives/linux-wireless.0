Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784AbYF3J1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/33] iwlwifi: setup compressed BA handler
Date: Mon, 30 Jun 2008 17:23:11 +0800
Message-Id: <1214817813-17639-12-git-send-email-yi.zhu@intel.com> (sfid-20080630_113815_200643_CC74AF2B)
In-Reply-To: <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch sets the compressed BA handler for 5000. This allows the rate
scaling algorithm to take in count frames that were sent in AMPDUs.

The compressed BA handler has been moved to iwl-rx.c since it is common to
4965 and 5000.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  146 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  143 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +-
 5 files changed, 151 insertions(+), 150 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d8e6d2e..57a853d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1930,74 +1930,6 @@ static void iwl4965_temperature_calib(struct iwl_priv *priv,
 }
 
 /**
- * iwl4965_tx_status_reply_compressed_ba - Update tx status from block-ack
- *
- * Go through block-ack's bitmap of ACK'd frames, update driver's record of
- * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
- */
-static int iwl4965_tx_status_reply_compressed_ba(struct iwl_priv *priv,
-						 struct iwl_ht_agg *agg,
-						 struct iwl4965_compressed_ba_resp*
-						 ba_resp)
-
-{
-	int i, sh, ack;
-	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
-	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-	u64 bitmap;
-	int successes = 0;
-	struct ieee80211_tx_info *info;
-
-	if (unlikely(!agg->wait_for_ba))  {
-		IWL_ERROR("Received BA when not expected\n");
-		return -EINVAL;
-	}
-
-	/* Mark that the expected block-ack response arrived */
-	agg->wait_for_ba = 0;
-	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
-
-	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl>>4);
-	if (sh < 0) /* tbw something is wrong with indices */
-		sh += 0x100;
-
-	/* don't use 64-bit values for now */
-	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
-
-	if (agg->frame_count > (64 - sh)) {
-		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
-		return -1;
-	}
-
-	/* check for success or failure according to the
-	 * transmitted bitmap and block-ack bitmap */
-	bitmap &= agg->bitmap;
-
-	/* For each frame attempted in aggregation,
-	 * update driver's record of tx frame's status. */
-	for (i = 0; i < agg->frame_count ; i++) {
-		ack = bitmap & (1 << i);
-		successes += !!ack;
-		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
-			ack? "ACK":"NACK", i, (agg->start_idx + i) & 0xff,
-			agg->start_idx + i);
-	}
-
-	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
-	memset(&info->status, 0, sizeof(info->status));
-	info->flags = IEEE80211_TX_STAT_ACK;
-	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_map = successes;
-	info->status.ampdu_ack_len = agg->frame_count;
-	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
-
-	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
-
-	return 0;
-}
-
-/**
  * iwl4965_tx_queue_stop_scheduler - Stop queue, but keep configuration
  */
 static void iwl4965_tx_queue_stop_scheduler(struct iwl_priv *priv,
@@ -2048,82 +1980,6 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	return 0;
 }
 
-
-/**
- * iwl4965_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
- *
- * Handles block-acknowledge notification from device, which reports success
- * of frames sent via aggregation.
- */
-static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
-	int index;
-	struct iwl_tx_queue *txq = NULL;
-	struct iwl_ht_agg *agg;
-	DECLARE_MAC_BUF(mac);
-
-	/* "flow" corresponds to Tx queue */
-	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-
-	/* "ssn" is start of block-ack Tx window, corresponds to index
-	 * (in Tx queue's circular buffer) of first TFD/frame in window */
-	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
-
-	if (scd_flow >= priv->hw_params.max_txq_num) {
-		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
-		return;
-	}
-
-	txq = &priv->txq[scd_flow];
-	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
-
-	/* Find index just before block-ack window */
-	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
-
-	/* TODO: Need to get this copy more safely - now good for debug */
-
-	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d]Received from %s, "
-			   "sta_id = %d\n",
-			   agg->wait_for_ba,
-			   print_mac(mac, (u8*) &ba_resp->sta_addr_lo32),
-			   ba_resp->sta_id);
-	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
-			   "%d, scd_ssn = %d\n",
-			   ba_resp->tid,
-			   ba_resp->seq_ctl,
-			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
-			   ba_resp->scd_flow,
-			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx \n",
-			   agg->start_idx,
-			   (unsigned long long)agg->bitmap);
-
-	/* Update driver's record of ACK vs. not for each frame in window */
-	iwl4965_tx_status_reply_compressed_ba(priv, agg, ba_resp);
-
-	/* Release all TFDs before the SSN, i.e. all TFDs in front of
-	 * block-ack window (we assume that they've been successfully
-	 * transmitted ... if not, it's too late anyway). */
-	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
-		/* calculate mac80211 ampdu sw queue to wake */
-		int ampdu_q =
-		   scd_flow - priv->hw_params.first_ampdu_q + priv->hw->queues;
-		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
-		priv->stations[ba_resp->sta_id].
-			tid[ba_resp->tid].tfds_in_queue -= freed;
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-			priv->mac80211_registered &&
-			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
-			ieee80211_wake_queue(priv->hw, ampdu_q);
-
-		iwl_txq_check_empty(priv, ba_resp->sta_id,
-				    ba_resp->tid, scd_flow);
-	}
-}
-
 /**
  * iwl4965_tx_queue_set_q2ratid - Map unique receiver/tid combination to a queue
  */
@@ -2555,8 +2411,6 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_RX] = iwl_rx_reply_rx;
 	/* Tx response */
 	priv->rx_handlers[REPLY_TX] = iwl4965_rx_reply_tx;
-	/* block ack */
-	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
 }
 
 static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9f8446c..fe05d60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1536,7 +1536,7 @@ struct iwl5000_tx_resp {
  *
  * Reports Block-Acknowledge from recipient station
  */
-struct iwl4965_compressed_ba_resp {
+struct iwl_compressed_ba_resp {
 	__le32 sta_addr_lo32;
 	__le16 sta_addr_hi16;
 	__le16 reserved;
@@ -3001,7 +3001,7 @@ struct iwl_rx_packet {
 		struct iwl4965_sleep_notification sleep_notif;
 		struct iwl4965_spectrum_resp spectrum;
 		struct iwl_notif_statistics stats;
-		struct iwl4965_compressed_ba_resp compressed_ba;
+		struct iwl_compressed_ba_resp compressed_ba;
 		struct iwl4965_missed_beacon_notif missed_beacon;
 		struct iwl5000_calibration calib;
 		__le32 status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0d8cc8c..06c272c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -377,6 +377,8 @@ extern void iwl_rx_reply_rx(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb);
 extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
+					   struct iwl_rx_mem_buffer *rxb);
 
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7296e28..032641d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1350,6 +1350,149 @@ int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
 }
 EXPORT_SYMBOL(iwl_txq_check_empty);
 
+/**
+ * iwl_tx_status_reply_compressed_ba - Update tx status from block-ack
+ *
+ * Go through block-ack's bitmap of ACK'd frames, update driver's record of
+ * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
+ */
+static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
+				 struct iwl_ht_agg *agg,
+				 struct iwl_compressed_ba_resp *ba_resp)
+
+{
+	int i, sh, ack;
+	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	u64 bitmap;
+	int successes = 0;
+	struct ieee80211_tx_info *info;
+
+	if (unlikely(!agg->wait_for_ba))  {
+		IWL_ERROR("Received BA when not expected\n");
+		return -EINVAL;
+	}
+
+	/* Mark that the expected block-ack response arrived */
+	agg->wait_for_ba = 0;
+	IWL_DEBUG_TX_REPLY("BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
+
+	/* Calculate shift to align block-ack bits with our Tx window bits */
+	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl>>4);
+	if (sh < 0) /* tbw something is wrong with indices */
+		sh += 0x100;
+
+	/* don't use 64-bit values for now */
+	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
+
+	if (agg->frame_count > (64 - sh)) {
+		IWL_DEBUG_TX_REPLY("more frames than bitmap size");
+		return -1;
+	}
+
+	/* check for success or failure according to the
+	 * transmitted bitmap and block-ack bitmap */
+	bitmap &= agg->bitmap;
+
+	/* For each frame attempted in aggregation,
+	 * update driver's record of tx frame's status. */
+	for (i = 0; i < agg->frame_count ; i++) {
+		ack = bitmap & (1 << i);
+		successes += !!ack;
+		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
+			ack? "ACK":"NACK", i, (agg->start_idx + i) & 0xff,
+			agg->start_idx + i);
+	}
+
+	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
+	memset(&info->status, 0, sizeof(info->status));
+	info->flags = IEEE80211_TX_STAT_ACK;
+	info->flags |= IEEE80211_TX_STAT_AMPDU;
+	info->status.ampdu_ack_map = successes;
+	info->status.ampdu_ack_len = agg->frame_count;
+	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
+
+	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
+
+	return 0;
+}
+
+/**
+ * iwl_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
+ *
+ * Handles block-acknowledge notification from device, which reports success
+ * of frames sent via aggregation.
+ */
+void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
+					   struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
+	int index;
+	struct iwl_tx_queue *txq = NULL;
+	struct iwl_ht_agg *agg;
+	DECLARE_MAC_BUF(mac);
+
+	/* "flow" corresponds to Tx queue */
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+
+	/* "ssn" is start of block-ack Tx window, corresponds to index
+	 * (in Tx queue's circular buffer) of first TFD/frame in window */
+	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
+
+	if (scd_flow >= priv->hw_params.max_txq_num) {
+		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
+		return;
+	}
+
+	txq = &priv->txq[scd_flow];
+	agg = &priv->stations[ba_resp->sta_id].tid[ba_resp->tid].agg;
+
+	/* Find index just before block-ack window */
+	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
+
+	/* TODO: Need to get this copy more safely - now good for debug */
+
+	IWL_DEBUG_TX_REPLY("REPLY_COMPRESSED_BA [%d]Received from %s, "
+			   "sta_id = %d\n",
+			   agg->wait_for_ba,
+			   print_mac(mac, (u8 *) &ba_resp->sta_addr_lo32),
+			   ba_resp->sta_id);
+	IWL_DEBUG_TX_REPLY("TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
+			   "%d, scd_ssn = %d\n",
+			   ba_resp->tid,
+			   ba_resp->seq_ctl,
+			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
+			   ba_resp->scd_flow,
+			   ba_resp->scd_ssn);
+	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx \n",
+			   agg->start_idx,
+			   (unsigned long long)agg->bitmap);
+
+	/* Update driver's record of ACK vs. not for each frame in window */
+	iwl_tx_status_reply_compressed_ba(priv, agg, ba_resp);
+
+	/* Release all TFDs before the SSN, i.e. all TFDs in front of
+	 * block-ack window (we assume that they've been successfully
+	 * transmitted ... if not, it's too late anyway). */
+	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
+		/* calculate mac80211 ampdu sw queue to wake */
+		int ampdu_q =
+		   scd_flow - priv->hw_params.first_ampdu_q + priv->hw->queues;
+		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
+		priv->stations[ba_resp->sta_id].
+			tid[ba_resp->tid].tfds_in_queue -= freed;
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
+			priv->mac80211_registered &&
+			agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)
+			ieee80211_wake_queue(priv->hw, ampdu_q);
+
+		iwl_txq_check_empty(priv, ba_resp->sta_id,
+				    ba_resp->tid, scd_flow);
+	}
+}
+EXPORT_SYMBOL(iwl_rx_reply_compressed_ba);
+
 #ifdef CONFIG_IWLWIF_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 4129e90..a87e870 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1249,7 +1249,7 @@ static void iwl4965_rx_card_state_notif(struct iwl_priv *priv,
  * This function chains into the hardware specific files for them to setup
  * any hardware specific handlers as well.
  */
-static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
+static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 {
 	priv->rx_handlers[REPLY_ALIVE] = iwl_rx_reply_alive;
 	priv->rx_handlers[REPLY_ERROR] = iwl4965_rx_reply_error;
@@ -1279,6 +1279,8 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	/* Rx handlers */
 	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl_rx_reply_rx_phy;
 	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl_rx_reply_rx;
+	/* block ack */
+	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl_rx_reply_compressed_ba;
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
@@ -4272,7 +4274,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 
 	iwl_setup_deferred_work(priv);
-	iwl4965_setup_rx_handlers(priv);
+	iwl_setup_rx_handlers(priv);
 
 	/********************
 	 * 9. Conclude
-- 
1.5.3.6

