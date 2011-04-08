Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab1DHPuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Garen Tamrazian <garenx.tamrazian@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/16] iwlagn: fix radar frame rejection
Date: Fri,  8 Apr 2011 08:30:23 -0700
Message-Id: <1302276636-12802-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Garen Tamrazian <garenx.tamrazian@intel.com>

The microcode may sometimes reject TX frames when
on a radar channel even after we associated as it
clears information during association and needs to
receive a new beacon before allowing that channel
again. This manifests itself as a TX status value
of TX_STATUS_FAIL_PASSIVE_NO_RX. So in this case,
stop the corresponding queue and give the frame
back to mac80211 for retransmission. We start the
queue again when a beacon from the AP is received
which will make the regulatory enforcement in the
device allow transmitting again.

Signed-off-by: Garen Tamrazian <garenx.tamrazian@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   29 ++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   13 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    3 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-helpers.h   |   13 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c        |   21 ++++++++++++++++++
 7 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9e47be6..cccf747 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -172,6 +172,7 @@ static void iwlagn_count_agg_tx_err_status(struct iwl_priv *priv, u16 status)
 
 static void iwlagn_set_tx_status(struct iwl_priv *priv,
 				 struct ieee80211_tx_info *info,
+				 struct iwl_rxon_context *ctx,
 				 struct iwlagn_tx_resp *tx_resp,
 				 int txq_id, bool is_agg)
 {
@@ -186,6 +187,13 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 	if (!iwl_is_tx_success(status))
 		iwlagn_count_tx_err_status(priv, status);
 
+	if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
+	    iwl_is_associated_ctx(ctx) && ctx->vif &&
+	    ctx->vif->type == NL80211_IFTYPE_STATION) {
+		ctx->last_tx_rejected = true;
+		iwl_stop_queue(priv, &priv->txq[txq_id]);
+	}
+
 	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
 			   "0x%x retries %d\n",
 			   txq_id,
@@ -242,15 +250,16 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 
 	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
+		struct iwl_tx_info *txb;
+
 		/* Only one frame was attempted; no block-ack will arrive */
 		idx = start_idx;
 
 		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
-		iwlagn_set_tx_status(priv,
-				     IEEE80211_SKB_CB(
-					priv->txq[txq_id].txb[idx].skb),
-				     tx_resp, txq_id, true);
+		txb = &priv->txq[txq_id].txb[idx];
+		iwlagn_set_tx_status(priv, IEEE80211_SKB_CB(txb->skb),
+				     txb->ctx, tx_resp, txq_id, true);
 		agg->wait_for_ba = 0;
 	} else {
 		/* Two or more frames were attempted; expect block-ack */
@@ -391,7 +400,8 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
-	u32  status = le16_to_cpu(tx_resp->status.status);
+	struct iwl_tx_info *txb;
+	u32 status = le16_to_cpu(tx_resp->status.status);
 	int tid;
 	int sta_id;
 	int freed;
@@ -406,7 +416,8 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	}
 
 	txq->time_stamp = jiffies;
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
+	txb = &txq->txb[txq->q.read_ptr];
+	info = IEEE80211_SKB_CB(txb->skb);
 	memset(&info->status, 0, sizeof(info->status));
 
 	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
@@ -450,12 +461,14 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 				iwl_wake_queue(priv, txq);
 		}
 	} else {
-		iwlagn_set_tx_status(priv, info, tx_resp, txq_id, false);
+		iwlagn_set_tx_status(priv, info, txb->ctx, tx_resp,
+				     txq_id, false);
 		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
-		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
+		    iwl_queue_space(&txq->q) > txq->q.low_mark &&
+		    status != TX_STATUS_FAIL_PASSIVE_NO_RX)
 			iwl_wake_queue(priv, txq);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index c335ee6..56f46ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -29,6 +29,7 @@
 #include "iwl-sta.h"
 #include "iwl-core.h"
 #include "iwl-agn-calib.h"
+#include "iwl-helpers.h"
 
 static int iwlagn_disable_bss(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx,
@@ -600,6 +601,18 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			priv->timestamp = bss_conf->timestamp;
 			ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		} else {
+			/*
+			 * If we disassociate while there are pending
+			 * frames, just wake up the queues and let the
+			 * frames "escape" ... This shouldn't really
+			 * be happening to start with, but we should
+			 * not get stuck in this case either since it
+			 * can happen if userspace gets confused.
+			 */
+			if (ctx->last_tx_rejected) {
+				ctx->last_tx_rejected = false;
+				iwl_wake_any_queue(priv, ctx);
+			}
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 01a6d2f..5c30f6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -428,6 +428,7 @@ void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
+	struct iwl_rxon_context *ctx;
 	u32 a;
 	unsigned long flags;
 	int i, chan;
@@ -501,6 +502,8 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
 	for (i = 0; i < 4; i++)
 		atomic_set(&priv->queue_stop_count[i], 0);
+	for_each_context(priv, ctx)
+		ctx->last_tx_rejected = false;
 
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 290a208..078a23e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -220,6 +220,7 @@ static inline u32 iwl_tx_status_to_mac80211(u32 status)
 	case TX_STATUS_DIRECT_DONE:
 		return IEEE80211_TX_STAT_ACK;
 	case TX_STATUS_FAIL_DEST_PS:
+	case TX_STATUS_FAIL_PASSIVE_NO_RX:
 		return IEEE80211_TX_STAT_TX_FILTERED;
 	default:
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7213336..14f7d8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1170,6 +1170,8 @@ struct iwl_rxon_context {
 		bool enabled, is_40mhz;
 		u8 extension_chan_offset;
 	} ht;
+
+	bool last_tx_rejected;
 };
 
 enum iwl_scan_type {
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 5da5761..9309ff2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -131,6 +131,19 @@ static inline void iwl_stop_queue(struct iwl_priv *priv,
 			ieee80211_stop_queue(priv->hw, ac);
 }
 
+static inline void iwl_wake_any_queue(struct iwl_priv *priv,
+				      struct iwl_rxon_context *ctx)
+{
+	u8 ac;
+
+	for (ac = 0; ac < AC_NUM; ac++) {
+		IWL_DEBUG_INFO(priv, "Queue Status: Q[%d] %s\n",
+			ac, (atomic_read(&priv->queue_stop_count[ac]) > 0)
+			      ? "stopped" : "awake");
+		iwl_wake_queue(priv, &priv->txq[ctx->ac_to_queue[ac]]);
+	}
+}
+
 #define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
 #define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c421f56..4472761 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -873,6 +873,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 {
 	struct sk_buff *skb;
 	__le16 fc = hdr->frame_control;
+	struct iwl_rxon_context *ctx;
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
@@ -895,6 +896,26 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len);
 
 	iwl_update_stats(priv, false, fc, len);
+
+	/*
+	* Wake any queues that were stopped due to a passive channel tx
+	* failure. This can happen because the regulatory enforcement in
+	* the device waits for a beacon before allowing transmission,
+	* sometimes even after already having transmitted frames for the
+	* association because the new RXON may reset the information.
+	*/
+	if (unlikely(ieee80211_is_beacon(fc))) {
+		for_each_context(priv, ctx) {
+			if (!ctx->last_tx_rejected)
+				continue;
+			if (compare_ether_addr(hdr->addr3,
+					       ctx->active.bssid_addr))
+				continue;
+			ctx->last_tx_rejected = false;
+			iwl_wake_any_queue(priv, ctx);
+		}
+	}
+
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(priv->hw, skb);
-- 
1.7.0.4

