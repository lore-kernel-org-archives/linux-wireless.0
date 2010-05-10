Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48051 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703Ab0EJW22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 29/47] iwlagn: use virtual interface in TX aggregation handling
Date: Mon, 10 May 2010 15:28:00 -0700
Message-Id: <1273530498-11876-30-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Most of the TX aggregation handling can be passed
the virtual interface directly instead of having
to rely on priv->vif.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    5 +++--
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c2a5c85..6a306e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -961,7 +961,8 @@ static int iwlagn_txq_ctx_activate_free(struct iwl_priv *priv)
 	return -1;
 }
 
-int iwlagn_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
+int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
+			const u8 *ra, u16 tid, u16 *ssn)
 {
 	int sta_id;
 	int tx_fifo;
@@ -1011,7 +1012,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, ra, tid);
 	} else {
 		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
 			     tid_data->tfds_in_queue);
@@ -1020,7 +1021,8 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
 	return ret;
 }
 
-int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
+int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
+		       const u8 *ra, u16 tid)
 {
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl_tid_data *tid_data;
@@ -1046,7 +1048,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 	if (priv->stations[sta_id].tid[tid].agg.state ==
 				IWL_EMPTYING_HW_QUEUE_ADDBA) {
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, ra, tid);
 		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 		return 0;
 	}
@@ -1083,7 +1085,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 						   tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+	ieee80211_stop_tx_ba_cb_irqsafe(vif, ra, tid);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 270635e..85e045b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3130,8 +3130,8 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
-			     enum ieee80211_ampdu_mlme_action action,
-			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+				enum ieee80211_ampdu_mlme_action action,
+				struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
@@ -3155,7 +3155,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
-		ret = iwlagn_tx_agg_start(priv, sta->addr, tid, ssn);
+		ret = iwlagn_tx_agg_start(priv, vif, sta->addr, tid, ssn);
 		if (ret == 0) {
 			priv->_agn.agg_tids_count++;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
@@ -3164,7 +3164,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		return ret;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
-		ret = iwlagn_tx_agg_stop(priv, sta->addr, tid);
+		ret = iwlagn_tx_agg_stop(priv, vif, sta->addr, tid);
 		if ((ret == 0) && (priv->_agn.agg_tids_count > 0)) {
 			priv->_agn.agg_tids_count--;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f52bedb..c441773 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -135,9 +135,10 @@ void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
-int iwlagn_tx_agg_start(struct iwl_priv *priv,
+int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			const u8 *ra, u16 tid, u16 *ssn);
-int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
+int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
+		       const u8 *ra, u16 tid);
 int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
-- 
1.6.3.3

