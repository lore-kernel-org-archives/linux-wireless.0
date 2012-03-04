Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab2CDUnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 019/101] iwlwifi: use ieee80211_tx_status
Date: Sun,  4 Mar 2012 11:28:33 -0800
Message-Id: <1330889395-533-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214639_287183_CD5AA0C4)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently use the _irqsafe version, but that
isn't recommended together with ieee80211_rx()
as it can cause races. If the device reports
a TX-status and RX in that order then with the
current combination mac80211 might process them
in the other order, which can cause issues with
powersaving clients.

Use ieee80211_tx_status() to avoid this race.
Since we don't want to call it with locks held,
process the frame queues later -- this is fine
as they are on the stack.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e5ebc36..1914bee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1007,6 +1007,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 	if (is_agg)
 		iwl_rx_reply_tx_agg(priv, tx_resp);
 
+	__skb_queue_head_init(&skbs);
+
 	if (tx_resp->frame_count == 1) {
 		u16 next_reclaimed = le16_to_cpu(tx_resp->seq_ctl);
 		next_reclaimed = SEQ_TO_SN(next_reclaimed + 0x10);
@@ -1026,8 +1028,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			next_reclaimed = ssn;
 		}
 
-		__skb_queue_head_init(&skbs);
-
 		if (tid != IWL_TID_NON_QOS) {
 			priv->tid_data[sta_id][tid].next_reclaimed =
 				next_reclaimed;
@@ -1040,8 +1040,9 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 				  ssn, status, &skbs));
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
-		while (!skb_queue_empty(&skbs)) {
-			skb = __skb_dequeue(&skbs);
+
+		/* process frames */
+		skb_queue_walk(&skbs, skb) {
 			hdr = (struct ieee80211_hdr *)skb->data;
 
 			if (!ieee80211_is_data_qos(hdr->frame_control))
@@ -1083,8 +1084,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
-			ieee80211_tx_status_irqsafe(priv->hw, skb);
-
 			freed++;
 		}
 
@@ -1093,6 +1092,12 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 	spin_unlock(&priv->sta_lock);
+
+	while (!skb_queue_empty(&skbs)) {
+		skb = __skb_dequeue(&skbs);
+		ieee80211_tx_status(priv->hw, skb);
+	}
+
 	return 0;
 }
 
@@ -1186,9 +1191,8 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 
 	iwlagn_check_ratid_empty(priv, sta_id, tid);
 	freed = 0;
-	while (!skb_queue_empty(&reclaimed_skbs)) {
 
-		skb = __skb_dequeue(&reclaimed_skbs);
+	skb_queue_walk(&reclaimed_skbs, skb) {
 		hdr = (struct ieee80211_hdr *)skb->data;
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
@@ -1211,10 +1215,14 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags,
 						    info);
 		}
-
-		ieee80211_tx_status_irqsafe(priv->hw, skb);
 	}
 
 	spin_unlock(&priv->sta_lock);
+
+	while (!skb_queue_empty(&reclaimed_skbs)) {
+		skb = __skb_dequeue(&reclaimed_skbs);
+		ieee80211_tx_status(priv->hw, skb);
+	}
+
 	return 0;
 }
-- 
1.7.0.4

