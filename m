Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab0IKQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlwifi: remove code repetition
Date: Sat, 11 Sep 2010 09:08:38 -0700
Message-Id: <1284221318-28281-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move the duplicated code into single static function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   60 +++++++++++++---------------
 1 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a8f2adf..ec99a72 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -46,6 +46,28 @@ static inline u32 iwlagn_get_scd_ssn(struct iwl5000_tx_resp *tx_resp)
 			    tx_resp->frame_count) & MAX_SN;
 }
 
+static void iwlagn_set_tx_status(struct iwl_priv *priv,
+				 struct ieee80211_tx_info *info,
+				 struct iwl5000_tx_resp *tx_resp,
+				 int txq_id, bool is_agg)
+{
+	u16  status = le16_to_cpu(tx_resp->status.status);
+
+	info->status.rates[0].count = tx_resp->failure_frame + 1;
+	if (is_agg)
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+	info->flags |= iwl_tx_status_to_mac80211(status);
+	iwlagn_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
+				    info);
+
+	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
+			   "0x%x retries %d\n",
+			   txq_id,
+			   iwl_get_tx_fail_reason(status), status,
+			   le32_to_cpu(tx_resp->rate_n_flags),
+			   tx_resp->failure_frame);
+}
+
 static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
 				      struct iwl5000_tx_resp *tx_resp,
@@ -53,9 +75,7 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 {
 	u16 status;
 	struct agg_tx_status *frame_status = &tx_resp->status;
-	struct ieee80211_tx_info *info = NULL;
 	struct ieee80211_hdr *hdr = NULL;
-	u32 rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	int i, sh, idx;
 	u16 seq;
 
@@ -64,31 +84,20 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
-	agg->rate_n_flags = rate_n_flags;
+	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	agg->bitmap = 0;
 
 	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
 		/* Only one frame was attempted; no block-ack will arrive */
-		status = le16_to_cpu(frame_status[0].status);
 		idx = start_idx;
 
-		/* FIXME: code repetition */
 		IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
-
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb);
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwlagn_hwrate_to_tx_control(priv, rate_n_flags, info);
-
-		/* FIXME: code repetition end */
-
-		IWL_DEBUG_TX_REPLY(priv, "1 Frame 0x%x failure :%d\n",
-				    status & 0xff, tx_resp->failure_frame);
-		IWL_DEBUG_TX_REPLY(priv, "Rate Info rate_n_flags=%x\n", rate_n_flags);
-
+		iwlagn_set_tx_status(priv,
+				     IEEE80211_SKB_CB(
+					priv->txq[txq_id].txb[idx].skb),
+				     tx_resp, txq_id, true);
 		agg->wait_for_ba = 0;
 	} else {
 		/* Two or more frames were attempted; expect block-ack */
@@ -281,20 +290,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		}
 	} else {
 		BUG_ON(txq_id != txq->swq_id);
-
-		info->status.rates[0].count = tx_resp->failure_frame + 1;
-		info->flags |= iwl_tx_status_to_mac80211(status);
-		iwlagn_hwrate_to_tx_control(priv,
-					le32_to_cpu(tx_resp->rate_n_flags),
-					info);
-
-		IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
-				   "0x%x retries %d\n",
-				   txq_id,
-				   iwl_get_tx_fail_reason(status), status,
-				   le32_to_cpu(tx_resp->rate_n_flags),
-				   tx_resp->failure_frame);
-
+		iwlagn_set_tx_status(priv, info, tx_resp, txq_id, false);
 		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
-- 
1.7.0.4

