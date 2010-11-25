Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab0KYBi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/12] iwlagn: fix station powersave accounting for aggregation
Date: Wed, 24 Nov 2010 17:32:40 -0800
Message-Id: <1290648768-10075-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since aggregation queues are station-specific, the
device will not reject packets in them but rather
will stop the appropriate aggregation queues when
a station goes to sleep. I forgot to account for
this in the driver, so if a station went to sleep
that had aggregation enabled, traffic would stop
indefinitely.

Fix this by only accounting frames queued on the
normal AC queues for associated station.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   31 +++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e8bd0b3..c114c3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -531,6 +531,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u8 tid = 0;
 	u8 *qc = NULL;
 	unsigned long flags;
+	bool is_agg = false;
 
 	if (info->control.vif)
 		ctx = iwl_rxon_ctx_from_vif(info->control.vif);
@@ -616,6 +617,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
 		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+			is_agg = true;
 		}
 	}
 
@@ -763,8 +765,14 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	 * whether or not we should update the write pointer.
 	 */
 
-	/* avoid atomic ops if it isn't an associated client */
-	if (sta_priv && sta_priv->client)
+	/*
+	 * Avoid atomic ops if it isn't an associated client.
+	 * Also, if this is a packet for aggregation, don't
+	 * increase the counter because the ucode will stop
+	 * aggregation queues when their respective station
+	 * goes to sleep.
+	 */
+	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
 	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
@@ -1143,14 +1151,15 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 	return 0;
 }
 
-static void iwlagn_tx_status(struct iwl_priv *priv, struct iwl_tx_info *tx_info)
+static void iwlagn_non_agg_tx_status(struct iwl_priv *priv,
+				     struct iwl_rxon_context *ctx,
+				     const u8 *addr1)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx_info->skb->data;
 	struct ieee80211_sta *sta;
 	struct iwl_station_priv *sta_priv;
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(tx_info->ctx->vif, hdr->addr1);
+	sta = ieee80211_find_sta(ctx->vif, addr1);
 	if (sta) {
 		sta_priv = (void *)sta->drv_priv;
 		/* avoid atomic ops if this isn't a client */
@@ -1159,6 +1168,15 @@ static void iwlagn_tx_status(struct iwl_priv *priv, struct iwl_tx_info *tx_info)
 			ieee80211_sta_block_awake(priv->hw, sta, false);
 	}
 	rcu_read_unlock();
+}
+
+static void iwlagn_tx_status(struct iwl_priv *priv, struct iwl_tx_info *tx_info,
+			     bool is_agg)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx_info->skb->data;
+
+	if (!is_agg)
+		iwlagn_non_agg_tx_status(priv, tx_info->ctx, hdr->addr1);
 
 	ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb);
 }
@@ -1183,7 +1201,8 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwlagn_tx_status(priv, tx_info);
+		iwlagn_tx_status(priv, tx_info,
+				 txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
-- 
1.7.0.4

