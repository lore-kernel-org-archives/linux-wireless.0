Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab0EJW2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:31 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 42/47] iwlagn: use iwl_sta_id() for aggregation
Date: Mon, 10 May 2010 15:28:13 -0700
Message-Id: <1273530498-11876-43-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the station ID being stored in the
station struct, which mac80211 gives us
for aggregation callbacks, we can also
remove the use of iwl_find_station() in
those code paths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   21 ++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   13 +++++++------
 drivers/net/wireless/iwlwifi/iwl-sta.h    |    7 ++++---
 5 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 89c85d1..c402bfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -962,7 +962,7 @@ static int iwlagn_txq_ctx_activate_free(struct iwl_priv *priv)
 }
 
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
-			const u8 *ra, u16 tid, u16 *ssn)
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
 	int sta_id;
 	int tx_fifo;
@@ -976,9 +976,9 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		return tx_fifo;
 
 	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
-			__func__, ra, tid);
+			__func__, sta->addr, tid);
 
-	sta_id = iwl_find_station(priv, ra);
+	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Start AGG on invalid station\n");
 		return -ENXIO;
@@ -1012,7 +1012,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (tid_data->tfds_in_queue == 0) {
 		IWL_DEBUG_HT(priv, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(vif, ra, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
 		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
 			     tid_data->tfds_in_queue);
@@ -1022,23 +1022,18 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 }
 
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
-		       const u8 *ra, u16 tid)
+		       struct ieee80211_sta *sta, u16 tid)
 {
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl_tid_data *tid_data;
 	int write_ptr, read_ptr;
 	unsigned long flags;
 
-	if (!ra) {
-		IWL_ERR(priv, "ra = NULL\n");
-		return -EINVAL;
-	}
-
 	tx_fifo_id = get_fifo_from_tid(tid);
 	if (unlikely(tx_fifo_id < 0))
 		return tx_fifo_id;
 
-	sta_id = iwl_find_station(priv, ra);
+	sta_id = iwl_sta_id(sta);
 
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
@@ -1048,7 +1043,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	if (priv->stations[sta_id].tid[tid].agg.state ==
 				IWL_EMPTYING_HW_QUEUE_ADDBA) {
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, ra, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 		return 0;
 	}
@@ -1085,7 +1080,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 						   tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	ieee80211_stop_tx_ba_cb_irqsafe(vif, ra, tid);
+	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8a4b830..3265b63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3154,17 +3154,17 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT(priv, "start Rx\n");
-		return iwl_sta_rx_agg_start(priv, sta->addr, tid, *ssn);
+		return iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT(priv, "stop Rx\n");
-		ret = iwl_sta_rx_agg_stop(priv, sta->addr, tid);
+		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			return 0;
 		else
 			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
-		ret = iwlagn_tx_agg_start(priv, vif, sta->addr, tid, ssn);
+		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
 		if (ret == 0) {
 			priv->_agn.agg_tids_count++;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
@@ -3173,7 +3173,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		return ret;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
-		ret = iwlagn_tx_agg_stop(priv, vif, sta->addr, tid);
+		ret = iwlagn_tx_agg_stop(priv, vif, sta, tid);
 		if ((ret == 0) && (priv->_agn.agg_tids_count > 0)) {
 			priv->_agn.agg_tids_count--;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index c441773..2d74805 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -136,9 +136,9 @@ void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
-			const u8 *ra, u16 tid, u16 *ssn);
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
-		       const u8 *ra, u16 tid);
+		       struct ieee80211_sta *sta, u16 tid);
 int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 4be7940..8fec026 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1324,13 +1324,13 @@ void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
 }
 EXPORT_SYMBOL(iwl_sta_tx_modify_enable_tid);
 
-int iwl_sta_rx_agg_start(struct iwl_priv *priv,
-			 const u8 *addr, int tid, u16 ssn)
+int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			 int tid, u16 ssn)
 {
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
@@ -1343,16 +1343,17 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta,
-					CMD_ASYNC);
+				CMD_ASYNC);
 }
 EXPORT_SYMBOL(iwl_sta_rx_agg_start);
 
-int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid)
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			int tid)
 {
 	unsigned long flags;
 	int sta_id;
 
-	sta_id = iwl_find_station(priv, addr);
+	sta_id = iwl_sta_id(sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
 		return -ENXIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 646f644..d0ab3f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -80,9 +80,10 @@ int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 void iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
-int iwl_sta_rx_agg_start(struct iwl_priv *priv,
-			 const u8 *addr, int tid, u16 ssn);
-int iwl_sta_rx_agg_stop(struct iwl_priv *priv, const u8 *addr, int tid);
+int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			 int tid, u16 ssn);
+int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
+			int tid);
 void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 
-- 
1.6.3.3

