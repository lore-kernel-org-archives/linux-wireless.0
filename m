Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0HWOxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/26] iwlwifi: disable aggregation queue if stopped early
Date: Mon, 23 Aug 2010 07:57:17 -0700
Message-Id: <1282575437-23270-27-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When aggregation is stopped again for some reason
before the queue we selected has drained, we will
currently leak the TX queue and keep it enabled
for aggregation. Normally this doesn't happen, so
the problem is rarely seen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   32 +++++++++++++++++-----------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index e2497e7..a51a7cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1036,7 +1036,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid)
 {
-	int tx_fifo_id, txq_id, sta_id, ssn = -1;
+	int tx_fifo_id, txq_id, sta_id, ssn;
 	struct iwl_tid_data *tid_data;
 	int write_ptr, read_ptr;
 	unsigned long flags;
@@ -1054,21 +1054,26 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	if (priv->stations[sta_id].tid[tid].agg.state ==
-				IWL_EMPTYING_HW_QUEUE_ADDBA) {
-		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
-		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
-
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
 	txq_id = tid_data->agg.txq_id;
+
+	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/*
+		 * This can happen if the peer stops aggregation
+		 * again before we've had a chance to drain the
+		 * queue we selected previously, i.e. before the
+		 * session was really started completely.
+		 */
+		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
+		goto turn_off;
+	case IWL_AGG_ON:
+		break;
+	default:
+		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
+	}
+
 	write_ptr = priv->txq[txq_id].q.write_ptr;
 	read_ptr = priv->txq[txq_id].q.read_ptr;
 
@@ -1082,6 +1087,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	}
 
 	IWL_DEBUG_HT(priv, "HW queue is empty\n");
+ turn_off:
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	/* do not restore/save irqs */
-- 
1.7.0.4

