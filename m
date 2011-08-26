Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1HZGxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 28/60] iwlagn: reclaim the packets in transport layer
Date: Thu, 25 Aug 2011 23:11:00 -0700
Message-Id: <1314339092-20797-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085341_347269_1347DE3F)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The reclaim flow is really transport related. Define a simple API to allow the
upper layer to request from the transport layer to reclaim packets until an
index written in the Tx response / BA notification.
The transport layer prepares a list of the packets that are being freed and
passes this list to the upper layer.
Between the two layers, the CB of the skb is used to pass a pointer to the
context (BSS / PAN) in which the skb was sent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |  271 +--------------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |  429 +++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    5 +
 drivers/net/wireless/iwlwifi/iwl-helpers.h       |    6 +
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   56 +++
 drivers/net/wireless/iwlwifi/iwl-trans.c         |   31 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   10 +
 8 files changed, 374 insertions(+), 442 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 57839ca..52ddb49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -42,12 +42,6 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 
-static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
-{
-	return le32_to_cpup((__le32 *)&tx_resp->status +
-			    tx_resp->frame_count) & MAX_SN;
-}
-
 static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 {
 	status &= TX_STATUS_MSK;
@@ -125,7 +119,7 @@ static void iwlagn_count_tx_err_status(struct iwl_priv *priv, u16 status)
 	}
 }
 
-static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
+void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
 {
 	status &= AGG_TX_STATUS_MSK;
 
@@ -172,11 +166,10 @@ static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
 	}
 }
 
-static void iwlagn_set_tx_status(struct iwl_priv *priv,
+void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
-				 struct iwl_rxon_context *ctx,
 				 struct iwlagn_tx_resp *tx_resp,
-				 int txq_id, bool is_agg)
+				 bool is_agg)
 {
 	u16  status = le16_to_cpu(tx_resp->status.status);
 
@@ -188,20 +181,6 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				    info);
 	if (!iwl_is_tx_success(status))
 		iwlagn_count_tx_err_status(priv, status);
-
-	if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
-	    iwl_is_associated_ctx(ctx) && ctx->vif &&
-	    ctx->vif->type == NL80211_IFTYPE_STATION) {
-		ctx->last_tx_rejected = true;
-		iwl_stop_queue(priv, &priv->txq[txq_id]);
-	}
-
-	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
-			   "0x%x retries %d\n",
-			   txq_id,
-			   iwl_get_tx_fail_reason(status), status,
-			   le32_to_cpu(tx_resp->rate_n_flags),
-			   tx_resp->failure_frame);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -231,157 +210,6 @@ const char *iwl_get_agg_tx_fail_reason(u16 status)
 }
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
-static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
-				      struct iwl_ht_agg *agg,
-				      struct iwlagn_tx_resp *tx_resp,
-				      int txq_id, u16 start_idx)
-{
-	u16 status;
-	struct agg_tx_status *frame_status = &tx_resp->status;
-	struct ieee80211_hdr *hdr = NULL;
-	int i, sh, idx;
-	u16 seq;
-
-	if (agg->wait_for_ba)
-		IWL_DEBUG_TX_REPLY(priv, "got tx response w/o block-ack\n");
-
-	agg->frame_count = tx_resp->frame_count;
-	agg->start_idx = start_idx;
-	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
-	agg->bitmap = 0;
-
-	/* # frames attempted by Tx command */
-	if (agg->frame_count == 1) {
-		struct iwl_tx_info *txb;
-
-		/* Only one frame was attempted; no block-ack will arrive */
-		idx = start_idx;
-
-		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
-				   agg->frame_count, agg->start_idx, idx);
-		txb = &priv->txq[txq_id].txb[idx];
-		iwlagn_set_tx_status(priv, IEEE80211_SKB_CB(txb->skb),
-				     txb->ctx, tx_resp, txq_id, true);
-		agg->wait_for_ba = 0;
-	} else {
-		/* Two or more frames were attempted; expect block-ack */
-		u64 bitmap = 0;
-
-		/*
-		 * Start is the lowest frame sent. It may not be the first
-		 * frame in the batch; we figure this out dynamically during
-		 * the following loop.
-		 */
-		int start = agg->start_idx;
-
-		/* Construct bit-map of pending frames within Tx window */
-		for (i = 0; i < agg->frame_count; i++) {
-			u16 sc;
-			status = le16_to_cpu(frame_status[i].status);
-			seq  = le16_to_cpu(frame_status[i].sequence);
-			idx = SEQ_TO_INDEX(seq);
-			txq_id = SEQ_TO_QUEUE(seq);
-
-			if (status & AGG_TX_STATUS_MSK)
-				iwlagn_count_agg_tx_err_status(priv, status);
-
-			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
-				      AGG_TX_STATE_ABORT_MSK))
-				continue;
-
-			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
-					   agg->frame_count, txq_id, idx);
-			IWL_DEBUG_TX_REPLY(priv, "status %s (0x%08x), "
-					   "try-count (0x%08x)\n",
-					   iwl_get_agg_tx_fail_reason(status),
-					   status & AGG_TX_STATUS_MSK,
-					   status & AGG_TX_TRY_MSK);
-
-			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
-			if (!hdr) {
-				IWL_ERR(priv,
-					"BUG_ON idx doesn't point to valid skb"
-					" idx=%d, txq_id=%d\n", idx, txq_id);
-				return -1;
-			}
-
-			sc = le16_to_cpu(hdr->seq_ctrl);
-			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-				IWL_ERR(priv,
-					"BUG_ON idx doesn't match seq control"
-					" idx=%d, seq_idx=%d, seq=%d\n",
-					  idx, SEQ_TO_SN(sc),
-					  hdr->seq_ctrl);
-				return -1;
-			}
-
-			IWL_DEBUG_TX_REPLY(priv, "AGG Frame i=%d idx %d seq=%d\n",
-					   i, idx, SEQ_TO_SN(sc));
-
-			/*
-			 * sh -> how many frames ahead of the starting frame is
-			 * the current one?
-			 *
-			 * Note that all frames sent in the batch must be in a
-			 * 64-frame window, so this number should be in [0,63].
-			 * If outside of this window, then we've found a new
-			 * "first" frame in the batch and need to change start.
-			 */
-			sh = idx - start;
-
-			/*
-			 * If >= 64, out of window. start must be at the front
-			 * of the circular buffer, idx must be near the end of
-			 * the buffer, and idx is the new "first" frame. Shift
-			 * the indices around.
-			 */
-			if (sh >= 64) {
-				/* Shift bitmap by start - idx, wrapped */
-				sh = 0x100 - idx + start;
-				bitmap = bitmap << sh;
-				/* Now idx is the new start so sh = 0 */
-				sh = 0;
-				start = idx;
-			/*
-			 * If <= -64 then wraps the 256-pkt circular buffer
-			 * (e.g., start = 255 and idx = 0, sh should be 1)
-			 */
-			} else if (sh <= -64) {
-				sh  = 0x100 - start + idx;
-			/*
-			 * If < 0 but > -64, out of window. idx is before start
-			 * but not wrapped. Shift the indices around.
-			 */
-			} else if (sh < 0) {
-				/* Shift by how far start is ahead of idx */
-				sh = start - idx;
-				bitmap = bitmap << sh;
-				/* Now idx is the new start so sh = 0 */
-				start = idx;
-				sh = 0;
-			}
-			/* Sequence number start + sh was sent in this batch */
-			bitmap |= 1ULL << sh;
-			IWL_DEBUG_TX_REPLY(priv, "start=%d bitmap=0x%llx\n",
-					   start, (unsigned long long)bitmap);
-		}
-
-		/*
-		 * Store the bitmap and possibly the new start, if we wrapped
-		 * the buffer above
-		 */
-		agg->bitmap = bitmap;
-		agg->start_idx = start;
-		IWL_DEBUG_TX_REPLY(priv, "Frames %d start_idx=%d bitmap=0x%llx\n",
-				   agg->frame_count, agg->start_idx,
-				   (unsigned long long)agg->bitmap);
-
-		if (bitmap)
-			agg->wait_for_ba = 1;
-	}
-	return 0;
-}
-
 void iwl_check_abort_status(struct iwl_priv *priv,
 			    u8 frame_count, u32 status)
 {
@@ -392,99 +220,6 @@ void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct ieee80211_tx_info *info;
-	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	struct ieee80211_hdr *hdr;
-	struct iwl_tx_info *txb;
-	u32 status = le16_to_cpu(tx_resp->status.status);
-	int tid;
-	int sta_id;
-	int freed;
-	unsigned long flags;
-
-	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
-		IWL_ERR(priv, "%s: Read index for DMA queue txq_id (%d) "
-			  "index %d is out of range [0-%d] %d %d\n", __func__,
-			  txq_id, index, txq->q.n_bd, txq->q.write_ptr,
-			  txq->q.read_ptr);
-		return;
-	}
-
-	txq->time_stamp = jiffies;
-	txb = &txq->txb[txq->q.read_ptr];
-	info = IEEE80211_SKB_CB(txb->skb);
-	memset(&info->status, 0, sizeof(info->status));
-
-	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
-		IWLAGN_TX_RES_TID_POS;
-	sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
-		IWLAGN_TX_RES_RA_POS;
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-
-	hdr = (void *)txb->skb->data;
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		priv->last_seq_ctl = tx_resp->seq_ctl;
-
-	if (txq->sched_retry) {
-		const u32 scd_ssn = iwlagn_get_scd_ssn(tx_resp);
-		struct iwl_ht_agg *agg;
-
-		agg = &priv->stations[sta_id].tid[tid].agg;
-		/*
-		 * If the BT kill count is non-zero, we'll get this
-		 * notification again.
-		 */
-		if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
-		    priv->cfg->bt_params &&
-		    priv->cfg->bt_params->advanced_bt_coexist) {
-			IWL_DEBUG_COEX(priv, "receive reply tx with bt_kill\n");
-		}
-		iwlagn_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
-
-		/* check if BAR is needed */
-		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status))
-			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-
-		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim "
-					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
-					scd_ssn , index, txq_id, txq->swq_id);
-
-			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
-			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-			if (priv->mac80211_registered &&
-			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-				iwl_wake_queue(priv, txq);
-		}
-	} else {
-		iwlagn_set_tx_status(priv, info, txb->ctx, tx_resp,
-				     txq_id, false);
-		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-		if (priv->mac80211_registered &&
-		    iwl_queue_space(&txq->q) > txq->q.low_mark &&
-		    status != TX_STATUS_FAIL_PASSIVE_NO_RX)
-			iwl_wake_queue(priv, txq);
-	}
-
-	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
-
-	iwl_check_abort_status(priv, tx_resp->frame_count, status);
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-}
-
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 0e9deb7..f2c11c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/ieee80211.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -696,147 +697,224 @@ static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
 	rcu_read_unlock();
 }
 
-static void iwlagn_tx_status(struct iwl_priv *priv, struct iwl_tx_info *tx_info,
-			     bool is_agg)
+/**
+ * translate ucode response to mac80211 tx status control values
+ */
+void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
+				  struct ieee80211_tx_info *info)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx_info->skb->data;
-
-	if (!is_agg)
-		iwlagn_non_agg_tx_status(priv, tx_info->ctx, hdr->addr1);
+	struct ieee80211_tx_rate *r = &info->control.rates[0];
 
-	ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb);
+	info->antenna_sel_tx =
+		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
+	if (rate_n_flags & RATE_MCS_HT_MSK)
+		r->flags |= IEEE80211_TX_RC_MCS;
+	if (rate_n_flags & RATE_MCS_GF_MSK)
+		r->flags |= IEEE80211_TX_RC_GREEN_FIELD;
+	if (rate_n_flags & RATE_MCS_HT40_MSK)
+		r->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+	if (rate_n_flags & RATE_MCS_DUP_MSK)
+		r->flags |= IEEE80211_TX_RC_DUP_DATA;
+	if (rate_n_flags & RATE_MCS_SGI_MSK)
+		r->flags |= IEEE80211_TX_RC_SHORT_GI;
+	r->idx = iwlagn_hwrate_to_mac80211_idx(rate_n_flags, info->band);
 }
 
-int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+#ifdef CONFIG_IWLWIFI_DEBUG
+const char *iwl_get_tx_fail_reason(u32 status)
 {
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_tx_info *tx_info;
-	int nfreed = 0;
-	struct ieee80211_hdr *hdr;
+#define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
+#define TX_STATUS_POSTPONE(x) case TX_STATUS_POSTPONE_ ## x: return #x
 
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERR(priv, "%s: Read index for DMA queue txq id (%d), "
-			  "index %d is out of range [0-%d] %d %d.\n", __func__,
-			  txq_id, index, q->n_bd, q->write_ptr, q->read_ptr);
-		return 0;
+	switch (status & TX_STATUS_MSK) {
+	case TX_STATUS_SUCCESS:
+		return "SUCCESS";
+	TX_STATUS_POSTPONE(DELAY);
+	TX_STATUS_POSTPONE(FEW_BYTES);
+	TX_STATUS_POSTPONE(BT_PRIO);
+	TX_STATUS_POSTPONE(QUIET_PERIOD);
+	TX_STATUS_POSTPONE(CALC_TTAK);
+	TX_STATUS_FAIL(INTERNAL_CROSSED_RETRY);
+	TX_STATUS_FAIL(SHORT_LIMIT);
+	TX_STATUS_FAIL(LONG_LIMIT);
+	TX_STATUS_FAIL(FIFO_UNDERRUN);
+	TX_STATUS_FAIL(DRAIN_FLOW);
+	TX_STATUS_FAIL(RFKILL_FLUSH);
+	TX_STATUS_FAIL(LIFE_EXPIRE);
+	TX_STATUS_FAIL(DEST_PS);
+	TX_STATUS_FAIL(HOST_ABORTED);
+	TX_STATUS_FAIL(BT_RETRY);
+	TX_STATUS_FAIL(STA_INVALID);
+	TX_STATUS_FAIL(FRAG_DROPPED);
+	TX_STATUS_FAIL(TID_DISABLE);
+	TX_STATUS_FAIL(FIFO_FLUSHED);
+	TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
+	TX_STATUS_FAIL(PASSIVE_NO_RX);
+	TX_STATUS_FAIL(NO_BEACON_ON_RADAR);
 	}
 
-	for (index = iwl_queue_inc_wrap(index, q->n_bd);
-	     q->read_ptr != index;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	return "UNKNOWN";
 
-		tx_info = &txq->txb[txq->q.read_ptr];
+#undef TX_STATUS_FAIL
+#undef TX_STATUS_POSTPONE
+}
+#endif /* CONFIG_IWLWIFI_DEBUG */
 
-		if (WARN_ON_ONCE(tx_info->skb == NULL))
-			continue;
+static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
+				struct iwlagn_tx_resp *tx_resp)
+{
+	struct agg_tx_status *frame_status = &tx_resp->status;
+	int tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
+		IWLAGN_TX_RES_TID_POS;
+	int sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
+		IWLAGN_TX_RES_RA_POS;
+	struct iwl_ht_agg *agg = &priv->stations[sta_id].tid[tid].agg;
+	u32 status = le16_to_cpu(tx_resp->status.status);
+	int i;
+
+	if (agg->wait_for_ba)
+		IWL_DEBUG_TX_REPLY(priv,
+			"got tx response w/o block-ack\n");
 
-		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
-		if (ieee80211_is_data_qos(hdr->frame_control))
-			nfreed++;
+	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
+	agg->wait_for_ba = (tx_resp->frame_count > 1);
+
+	/*
+	 * If the BT kill count is non-zero, we'll get this
+	 * notification again.
+	 */
+	if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		IWL_DEBUG_COEX(priv, "receive reply tx w/ bt_kill\n");
+	}
+
+	/* Construct bit-map of pending frames within Tx window */
+	for (i = 0; i < tx_resp->frame_count; i++) {
+		u16 fstatus = le16_to_cpu(frame_status[i].status);
 
-		iwlagn_tx_status(priv, tx_info,
-				 txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
-		tx_info->skb = NULL;
+		if (status & AGG_TX_STATUS_MSK)
+			iwlagn_count_agg_tx_err_status(priv, fstatus);
 
-		iwlagn_txq_inval_byte_cnt_tbl(priv, txq);
+		if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
+			      AGG_TX_STATE_ABORT_MSK))
+			continue;
 
-		iwlagn_txq_free_tfd(priv, txq, txq->q.read_ptr);
+		IWL_DEBUG_TX_REPLY(priv, "status %s (0x%08x), "
+				   "try-count (0x%08x)\n",
+				   iwl_get_agg_tx_fail_reason(fstatus),
+				   fstatus & AGG_TX_STATUS_MSK,
+				   fstatus & AGG_TX_TRY_MSK);
 	}
-	return nfreed;
 }
 
-/**
- * iwlagn_tx_status_reply_compressed_ba - Update tx status from block-ack
- *
- * Go through block-ack's bitmap of ACK'd frames, update driver's record of
- * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
- */
-static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
-				 struct iwl_ht_agg *agg,
-				 struct iwl_compressed_ba_resp *ba_resp)
+static inline u32 iwlagn_get_scd_ssn(struct iwlagn_tx_resp *tx_resp)
+{
+	return le32_to_cpup((__le32 *)&tx_resp->status +
+			    tx_resp->frame_count) & MAX_SN;
+}
 
+void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
-	int sh;
-	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
-	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
+	int txq_id = SEQ_TO_QUEUE(sequence);
+	int cmd_index = SEQ_TO_INDEX(sequence);
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	struct ieee80211_hdr *hdr;
+	u32 status = le16_to_cpu(tx_resp->status.status);
+	u32 ssn = iwlagn_get_scd_ssn(tx_resp);
+	int tid;
+	int sta_id;
+	int freed;
 	struct ieee80211_tx_info *info;
-	u64 bitmap, sent_bitmap;
+	unsigned long flags;
+	struct sk_buff_head skbs;
+	struct sk_buff *skb;
+	struct iwl_rxon_context *ctx;
 
-	if (unlikely(!agg->wait_for_ba))  {
-		if (unlikely(ba_resp->bitmap))
-			IWL_ERR(priv, "Received BA when not expected\n");
-		return -EINVAL;
+	if ((cmd_index >= txq->q.n_bd) ||
+	    (iwl_queue_used(&txq->q, cmd_index) == 0)) {
+		IWL_ERR(priv, "%s: Read index for DMA queue txq_id (%d) "
+			  "cmd_index %d is out of range [0-%d] %d %d\n",
+			  __func__, txq_id, cmd_index, txq->q.n_bd,
+			  txq->q.write_ptr, txq->q.read_ptr);
+		return;
 	}
 
-	/* Mark that the expected block-ack response arrived */
-	agg->wait_for_ba = 0;
-	IWL_DEBUG_TX_REPLY(priv, "BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
+	txq->time_stamp = jiffies;
 
-	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
-	if (sh < 0)
-		sh += 0x100;
-
-	/*
-	 * Check for success or failure according to the
-	 * transmitted bitmap and block-ack bitmap
-	 */
-	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
-	sent_bitmap = bitmap & agg->bitmap;
-
-	/* Sanity check values reported by uCode */
-	if (ba_resp->txed_2_done > ba_resp->txed) {
-		IWL_DEBUG_TX_REPLY(priv,
-			"bogus sent(%d) and ack(%d) count\n",
-			ba_resp->txed, ba_resp->txed_2_done);
-		/*
-		 * set txed_2_done = txed,
-		 * so it won't impact rate scale
-		 */
-		ba_resp->txed = ba_resp->txed_2_done;
-	}
-	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
-			ba_resp->txed, ba_resp->txed_2_done);
+	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
+		IWLAGN_TX_RES_TID_POS;
+	sta_id = (tx_resp->ra_tid & IWLAGN_TX_RES_RA_MSK) >>
+		IWLAGN_TX_RES_RA_POS;
 
-	/* Find the first ACKed frame to store the TX status */
-	while (sent_bitmap && !(sent_bitmap & 1)) {
-		agg->start_idx = (agg->start_idx + 1) & 0xff;
-		sent_bitmap >>= 1;
-	}
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 
-	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb);
-	memset(&info->status, 0, sizeof(info->status));
-	info->flags |= IEEE80211_TX_STAT_ACK;
-	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_len = ba_resp->txed_2_done;
-	info->status.ampdu_len = ba_resp->txed;
-	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
+	if (txq->sched_retry)
+		iwl_rx_reply_tx_agg(priv, tx_resp);
+
+	if (tx_resp->frame_count == 1) {
+		bool is_agg = (txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
+
+		__skb_queue_head_init(&skbs);
+		/*we can free until ssn % q.n_bd not inclusive */
+		iwl_trans_reclaim(trans(priv), txq_id, ssn, status, &skbs);
+		freed = 0;
+		while (!skb_queue_empty(&skbs)) {
+			skb = __skb_dequeue(&skbs);
+			hdr = (struct ieee80211_hdr *)skb->data;
+
+			if (!ieee80211_is_data_qos(hdr->frame_control))
+				priv->last_seq_ctl = tx_resp->seq_ctl;
+
+			info = IEEE80211_SKB_CB(skb);
+			ctx = info->driver_data[0];
+
+			memset(&info->status, 0, sizeof(info->status));
+
+			if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
+			    iwl_is_associated_ctx(ctx) && ctx->vif &&
+			    ctx->vif->type == NL80211_IFTYPE_STATION) {
+				ctx->last_tx_rejected = true;
+				iwl_stop_queue(priv, &priv->txq[txq_id]);
+
+				IWL_DEBUG_TX_REPLY(priv,
+					   "TXQ %d status %s (0x%08x) "
+					   "rate_n_flags 0x%x retries %d\n",
+					   txq_id,
+					   iwl_get_tx_fail_reason(status),
+					   status,
+					   le32_to_cpu(tx_resp->rate_n_flags),
+					   tx_resp->failure_frame);
+
+				IWL_DEBUG_TX_REPLY(priv,
+					   "FrameCnt = %d, idx=%d\n",
+					   tx_resp->frame_count, cmd_index);
+			}
+
+			/* check if BAR is needed */
+			if (is_agg && !iwl_is_tx_success(status))
+				info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+			iwlagn_set_tx_status(priv, IEEE80211_SKB_CB(skb),
+				     tx_resp, is_agg);
+			if (!is_agg)
+				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
+
+			ieee80211_tx_status_irqsafe(priv->hw, skb);
+
+			freed++;
+		}
 
-	return 0;
-}
+		WARN_ON(!is_agg && freed != 1);
 
-/**
- * translate ucode response to mac80211 tx status control values
- */
-void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
-				  struct ieee80211_tx_info *info)
-{
-	struct ieee80211_tx_rate *r = &info->control.rates[0];
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
+	}
 
-	info->antenna_sel_tx =
-		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
-	if (rate_n_flags & RATE_MCS_HT_MSK)
-		r->flags |= IEEE80211_TX_RC_MCS;
-	if (rate_n_flags & RATE_MCS_GF_MSK)
-		r->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-	if (rate_n_flags & RATE_MCS_HT40_MSK)
-		r->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
-	if (rate_n_flags & RATE_MCS_DUP_MSK)
-		r->flags |= IEEE80211_TX_RC_DUP_DATA;
-	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		r->flags |= IEEE80211_TX_RC_SHORT_GI;
-	r->idx = iwlagn_hwrate_to_mac80211_idx(rate_n_flags, info->band);
+	iwl_check_abort_status(priv, tx_resp->frame_count, status);
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
 
 /**
@@ -852,10 +930,15 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
+	struct sk_buff_head reclaimed_skbs;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb;
+	unsigned long flags;
 	int index;
 	int sta_id;
 	int tid;
-	unsigned long flags;
+	int freed;
 
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
@@ -874,6 +957,12 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
 	agg = &priv->stations[sta_id].tid[tid].agg;
+
+	/* Find index of block-ack window */
+	index = ba_resp_scd_ssn & (txq->q.n_bd - 1);
+
+	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+
 	if (unlikely(agg->txq_id != scd_flow)) {
 		/*
 		 * FIXME: this is a uCode bug which need to be addressed,
@@ -884,88 +973,84 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY(priv,
 			"BA scd_flow %d does not match txq_id %d\n",
 			scd_flow, agg->txq_id);
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 		return;
 	}
 
-	/* Find index just before block-ack window */
-	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
-
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
+	if (unlikely(!agg->wait_for_ba)) {
+		if (unlikely(ba_resp->bitmap))
+			IWL_ERR(priv, "Received BA when not expected\n");
+		spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+		return;
+	}
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
 			   agg->wait_for_ba,
 			   (u8 *) &ba_resp->sta_addr_lo32,
 			   ba_resp->sta_id);
-	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
-			   "%d, scd_ssn = %d\n",
+	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, "
+			   "scd_flow = %d, scd_ssn = %d\n",
 			   ba_resp->tid,
 			   ba_resp->seq_ctl,
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx\n",
-			   agg->start_idx,
-			   (unsigned long long)agg->bitmap);
 
-	/* Update driver's record of ACK vs. not for each frame in window */
-	iwlagn_tx_status_reply_compressed_ba(priv, agg, ba_resp);
+	/* Mark that the expected block-ack response arrived */
+	agg->wait_for_ba = 0;
+
+	/* Sanity check values reported by uCode */
+	if (ba_resp->txed_2_done > ba_resp->txed) {
+		IWL_DEBUG_TX_REPLY(priv,
+			"bogus sent(%d) and ack(%d) count\n",
+			ba_resp->txed, ba_resp->txed_2_done);
+		/*
+		 * set txed_2_done = txed,
+		 * so it won't impact rate scale
+		 */
+		ba_resp->txed = ba_resp->txed_2_done;
+	}
+	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
+			ba_resp->txed, ba_resp->txed_2_done);
+
+	__skb_queue_head_init(&reclaimed_skbs);
 
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
-		/* calculate mac80211 ampdu sw queue to wake */
-		int freed = iwlagn_tx_queue_reclaim(priv, scd_flow, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-		    priv->mac80211_registered &&
-		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-			iwl_wake_queue(priv, txq);
-
-		iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
-	}
+	iwl_trans_reclaim(trans(priv), scd_flow, ba_resp_scd_ssn, 0,
+			  &reclaimed_skbs);
+	freed = 0;
+	while (!skb_queue_empty(&reclaimed_skbs)) {
 
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
-}
+		skb = __skb_dequeue(&reclaimed_skbs);
+		hdr = (struct ieee80211_hdr *)skb->data;
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-const char *iwl_get_tx_fail_reason(u32 status)
-{
-#define TX_STATUS_FAIL(x) case TX_STATUS_FAIL_ ## x: return #x
-#define TX_STATUS_POSTPONE(x) case TX_STATUS_POSTPONE_ ## x: return #x
+		if (ieee80211_is_data_qos(hdr->frame_control))
+			freed++;
+		else
+			WARN_ON_ONCE(1);
+
+		if (freed == 0) {
+			/* this is the first skb we deliver in this batch */
+			/* put the rate scaling data there */
+			info = IEEE80211_SKB_CB(skb);
+			memset(&info->status, 0, sizeof(info->status));
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			info->flags |= IEEE80211_TX_STAT_AMPDU;
+			info->status.ampdu_ack_len = ba_resp->txed_2_done;
+			info->status.ampdu_len = ba_resp->txed;
+			iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags,
+						    info);
+		}
 
-	switch (status & TX_STATUS_MSK) {
-	case TX_STATUS_SUCCESS:
-		return "SUCCESS";
-	TX_STATUS_POSTPONE(DELAY);
-	TX_STATUS_POSTPONE(FEW_BYTES);
-	TX_STATUS_POSTPONE(BT_PRIO);
-	TX_STATUS_POSTPONE(QUIET_PERIOD);
-	TX_STATUS_POSTPONE(CALC_TTAK);
-	TX_STATUS_FAIL(INTERNAL_CROSSED_RETRY);
-	TX_STATUS_FAIL(SHORT_LIMIT);
-	TX_STATUS_FAIL(LONG_LIMIT);
-	TX_STATUS_FAIL(FIFO_UNDERRUN);
-	TX_STATUS_FAIL(DRAIN_FLOW);
-	TX_STATUS_FAIL(RFKILL_FLUSH);
-	TX_STATUS_FAIL(LIFE_EXPIRE);
-	TX_STATUS_FAIL(DEST_PS);
-	TX_STATUS_FAIL(HOST_ABORTED);
-	TX_STATUS_FAIL(BT_RETRY);
-	TX_STATUS_FAIL(STA_INVALID);
-	TX_STATUS_FAIL(FRAG_DROPPED);
-	TX_STATUS_FAIL(TID_DISABLE);
-	TX_STATUS_FAIL(FIFO_FLUSHED);
-	TX_STATUS_FAIL(INSUFFICIENT_CF_POLL);
-	TX_STATUS_FAIL(PASSIVE_NO_RX);
-	TX_STATUS_FAIL(NO_BEACON_ON_RADAR);
+		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
-	return "UNKNOWN";
+	iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+	iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
 
-#undef TX_STATUS_FAIL
-#undef TX_STATUS_POSTPONE
+	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
 }
-#endif /* CONFIG_IWLWIFI_DEBUG */
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d2fa77a..f345907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -146,6 +146,11 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 				 enum iwlagn_ucode_type ucode_type);
 
 /* lib */
+void iwlagn_set_tx_status(struct iwl_priv *priv,
+				 struct ieee80211_tx_info *info,
+				 struct iwlagn_tx_resp *tx_resp,
+				 bool is_agg);
+void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status);
 void iwl_check_abort_status(struct iwl_priv *priv,
 			    u8 frame_count, u32 status);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
@@ -178,7 +183,8 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
+void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+	struct sk_buff_head *skbs);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f3852ed..022cfc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -166,6 +166,8 @@ struct iwl_tx_info {
  * @time_stamp: time (in jiffies) of last read_ptr change
  * @need_update: indicates need to update read/write index
  * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
+ * @sta_id: valid if sched_retry is set
+ * @tid: valid if sched_retry is set
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
@@ -184,6 +186,9 @@ struct iwl_tx_queue {
 	u8 sched_retry;
 	u8 active;
 	u8 swq_id;
+
+	u16 sta_id;
+	u16 tid;
 };
 
 #define IWL_NUM_SCAN_RATES         (2)
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 09ed7af..f744fdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -90,6 +90,9 @@ static inline void iwl_wake_queue(struct iwl_priv *priv,
 	u8 ac = queue & 3;
 	u8 hwq = (queue >> 2) & 0x1f;
 
+	if (unlikely(!priv->mac80211_registered))
+		return;
+
 	if (test_and_clear_bit(hwq, priv->queue_stopped))
 		if (atomic_dec_return(&priv->queue_stop_count[ac]) <= 0)
 			ieee80211_wake_queue(priv->hw, ac);
@@ -102,6 +105,9 @@ static inline void iwl_stop_queue(struct iwl_priv *priv,
 	u8 ac = queue & 3;
 	u8 hwq = (queue >> 2) & 0x1f;
 
+	if (unlikely(!priv->mac80211_registered))
+		return;
+
 	if (!test_and_set_bit(hwq, priv->queue_stopped))
 		if (atomic_inc_return(&priv->queue_stop_count[ac]) > 0)
 			ieee80211_stop_queue(priv->hw, ac);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 9d7287e..3247df4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -480,6 +480,9 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
 
+	priv->txq[txq_id].sta_id = sta_id;
+	priv->txq[txq_id].tid = tid;
+
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 }
 
@@ -1035,3 +1038,56 @@ int iwl_trans_pcie_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 
 	return iwl_trans_pcie_send_cmd(priv, &cmd);
 }
+
+/* Frees buffers until index _not_ inclusive */
+void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
+			    struct sk_buff_head *skbs)
+
+{
+	struct iwl_tx_queue *txq = &priv(trans)->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_tx_info *tx_info;
+	struct ieee80211_tx_info *info;
+	int last_to_free;
+
+	/*Since we free until index _not_ inclusive, the one before index is
+	 * the last we will free. This one must be used */
+	last_to_free = iwl_queue_dec_wrap(index, q->n_bd);
+
+	if ((index >= q->n_bd) ||
+	   (iwl_queue_used(q, last_to_free) == 0)) {
+		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
+			  "last_to_free %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, last_to_free, q->n_bd,
+			  q->write_ptr, q->read_ptr);
+		return;
+	}
+
+	IWL_DEBUG_TX_REPLY(trans, "reclaim: [%d, %d, %d]\n", txq_id,
+			   q->read_ptr, index);
+
+	if (WARN_ON(!skb_queue_empty(skbs)))
+		return;
+
+	for (;
+	     q->read_ptr != index;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		tx_info = &txq->txb[txq->q.read_ptr];
+
+		if (WARN_ON_ONCE(tx_info->skb == NULL))
+			continue;
+
+		info = IEEE80211_SKB_CB(tx_info->skb);
+		info->driver_data[0] = tx_info->ctx;
+
+		__skb_queue_tail(skbs, tx_info->skb);
+
+		tx_info->skb = NULL;
+
+		iwlagn_txq_inval_byte_cnt_tbl(priv(trans), txq);
+
+		iwlagn_txq_free_tfd(priv(trans), txq, txq->q.read_ptr);
+	}
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 63a3101..06cec82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1106,7 +1106,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	 * regardless of the value of ret. "ret" only indicates
 	 * whether or not we should update the write pointer.
 	 */
-	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
+	if (iwl_queue_space(q) < q->high_mark) {
 		if (wait_write_ptr) {
 			txq->need_update = 1;
 			iwl_txq_update_write_ptr(priv, txq);
@@ -1148,6 +1148,34 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 	return 0;
 }
 
+static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id,
+		      int ssn, u32 status, struct sk_buff_head *skbs)
+{
+	struct iwl_priv *priv = priv(trans);
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	/* n_bd is usually 256 => n_bd - 1 = 0xff */
+	int tfd_num = ssn & (txq->q.n_bd - 1);
+	u8 agg_state;
+	bool cond;
+
+	if (txq->sched_retry) {
+		agg_state =
+			priv->stations[txq->sta_id].tid[txq->tid].agg.state;
+		cond = (agg_state != IWL_EMPTYING_HW_QUEUE_DELBA);
+	} else {
+		cond = (status != TX_STATUS_FAIL_PASSIVE_NO_RX);
+	}
+
+	if (txq->q.read_ptr != tfd_num) {
+		IWL_DEBUG_TX_REPLY(trans, "Retry scheduler reclaim "
+				"scd_ssn=%d idx=%d txq=%d swq=%d\n",
+				ssn , tfd_num, txq_id, txq->swq_id);
+		iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
+			iwl_wake_queue(priv, txq);
+	}
+}
+
 static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
 {
 	unsigned long flags;
@@ -1626,6 +1654,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.get_tx_cmd = iwl_trans_pcie_get_tx_cmd,
 	.tx = iwl_trans_pcie_tx,
+	.reclaim = iwl_trans_pcie_reclaim,
 
 	.txq_agg_disable = iwl_trans_pcie_txq_agg_disable,
 	.txq_agg_setup = iwl_trans_pcie_txq_agg_setup,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b4c7166..519ad91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -90,6 +90,7 @@ struct iwl_shared;
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
  * @tx: send an skb
+ * @reclaim: free packet until ssn. Returns a list of freed packets.
  * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *                 ready and a successful ADDBA response has been received.
  * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
@@ -123,6 +124,8 @@ struct iwl_trans_ops {
 	int (*tx)(struct iwl_priv *priv, struct sk_buff *skb,
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
+	void (*reclaim)(struct iwl_trans *trans, int txq_id, int ssn,
+			u32 status, struct sk_buff_head *skbs);
 
 	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id,
 				  u16 ssn_idx, u8 tx_fifo);
@@ -213,6 +216,13 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	return trans->ops->tx(priv(trans), skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
+static inline void iwl_trans_reclaim(struct iwl_trans *trans, int txq_id,
+				 int ssn, u32 status,
+				 struct sk_buff_head *skbs)
+{
+	trans->ops->reclaim(trans, txq_id, ssn, status, skbs);
+}
+
 static inline int iwl_trans_txq_agg_disable(struct iwl_trans *trans, u16 txq_id,
 			  u16 ssn_idx, u8 tx_fifo)
 {
-- 
1.7.0.4

