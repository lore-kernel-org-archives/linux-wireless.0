Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbYDQXDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/5] iwlwifi: arranging aggregation actions
Date: Thu, 17 Apr 2008 16:03:37 -0700
Message-Id: <1208473420-16550-3-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000352_723238_4D94A104)
In-Reply-To: <1208473420-16550-2-git-send-email-reinette.chatre@intel.com>
References: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch makes some renaming of the ampdu_action functions inside
iwlwifi, and adds checks for correct station id in Rx flows

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   70 ++++++++++++++++--------------
 1 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ddcd1b2..890dfa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4063,10 +4063,15 @@ void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	return;
 }
 
-static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
-					  int sta_id, int tid, u16 ssn)
+static int iwl4965_rx_agg_start(struct iwl_priv *priv,
+				const u8 *addr, int tid, u16 ssn)
 {
 	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
@@ -4076,13 +4081,19 @@ static void iwl4965_sta_modify_add_ba_tid(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
 }
 
-static void iwl4965_sta_modify_del_ba_tid(struct iwl_priv *priv,
-					  int sta_id, int tid)
+static int iwl4965_rx_agg_stop(struct iwl_priv *priv,
+			       const u8 *addr, int tid)
 {
 	unsigned long flags;
+	int sta_id;
+
+	sta_id = iwl_find_station(priv, addr);
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENXIO;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].sta.station_flags_msk = 0;
@@ -4091,7 +4102,8 @@ static void iwl4965_sta_modify_del_ba_tid(struct iwl_priv *priv,
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta,
+					CMD_ASYNC);
 }
 
 /*
@@ -4110,8 +4122,8 @@ static int iwl4965_txq_ctx_activate_free(struct iwl_priv *priv)
 	return -1;
 }
 
-static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
-				       u16 tid, u16 *start_seq_num)
+static int iwl4965_tx_agg_start(struct ieee80211_hw *hw, const u8 *ra,
+				u16 tid, u16 *start_seq_num)
 {
 	struct iwl_priv *priv = hw->priv;
 	int sta_id;
@@ -4128,10 +4140,10 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	else
 		return -EINVAL;
 
-	IWL_WARNING("%s on da = %s tid = %d\n",
-			__func__, print_mac(mac, da), tid);
+	IWL_WARNING("%s on ra = %s tid = %d\n",
+			__func__, print_mac(mac, ra), tid);
 
-	sta_id = iwl_find_station(priv, da);
+	sta_id = iwl_find_station(priv, ra);
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
 
@@ -4160,7 +4172,7 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	if (tid_data->tfds_in_queue == 0) {
 		printk(KERN_ERR "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(hw, da, tid);
+		ieee80211_start_tx_ba_cb_irqsafe(hw, ra, tid);
 	} else {
 		IWL_DEBUG_HT("HW queue is NOT empty: %d packets in HW queue\n",
 				tid_data->tfds_in_queue);
@@ -4169,10 +4181,8 @@ static int iwl4965_mac_ht_tx_agg_start(struct ieee80211_hw *hw, const u8 *da,
 	return ret;
 }
 
-static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
-				      u16 tid)
+static int iwl4965_tx_agg_stop(struct ieee80211_hw *hw, const u8 *ra, u16 tid)
 {
-
 	struct iwl_priv *priv = hw->priv;
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl4965_tid_data *tid_data;
@@ -4180,8 +4190,8 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-	if (!da) {
-		IWL_ERROR("da = NULL\n");
+	if (!ra) {
+		IWL_ERROR("ra = NULL\n");
 		return -EINVAL;
 	}
 
@@ -4190,7 +4200,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	else
 		return -EINVAL;
 
-	sta_id = iwl_find_station(priv, da);
+	sta_id = iwl_find_station(priv, ra);
 
 	if (sta_id == IWL_INVALID_STATION)
 		return -ENXIO;
@@ -4212,7 +4222,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 		return 0;
 	}
 
-	IWL_DEBUG_HT("HW queue empty\n");;
+	IWL_DEBUG_HT("HW queue is empty\n");
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -4222,10 +4232,7 @@ static int iwl4965_mac_ht_tx_agg_stop(struct ieee80211_hw *hw, const u8 *da,
 	if (ret)
 		return ret;
 
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, da, tid);
-
-	IWL_DEBUG_INFO("iwl4965_mac_ht_tx_agg_stop on da=%s tid=%d\n",
-			print_mac(mac, da), tid);
+	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
 
 	return 0;
 }
@@ -4235,27 +4242,24 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 			     const u8 *addr, u16 tid, u16 *ssn)
 {
 	struct iwl_priv *priv = hw->priv;
-	int sta_id;
 	DECLARE_MAC_BUF(mac);
 
-	IWL_DEBUG_HT("A-MPDU action on da=%s tid=%d ",
-			print_mac(mac, addr), tid);
-	sta_id = iwl_find_station(priv, addr);
+	IWL_DEBUG_HT("A-MPDU action on addr %s tid %d\n",
+		     print_mac(mac, addr), tid);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		IWL_DEBUG_HT("start Rx\n");
-		iwl4965_sta_modify_add_ba_tid(priv, sta_id, tid, *ssn);
-		break;
+		return iwl4965_rx_agg_start(priv, addr, tid, *ssn);
 	case IEEE80211_AMPDU_RX_STOP:
 		IWL_DEBUG_HT("stop Rx\n");
-		iwl4965_sta_modify_del_ba_tid(priv, sta_id, tid);
-		break;
+		return iwl4965_rx_agg_stop(priv, addr, tid);
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT("start Tx\n");
-		return iwl4965_mac_ht_tx_agg_start(hw, addr, tid, ssn);
+		return iwl4965_tx_agg_start(hw, addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT("stop Tx\n");
-		return iwl4965_mac_ht_tx_agg_stop(hw, addr, tid);
+		return iwl4965_tx_agg_stop(hw, addr, tid);
 	default:
 		IWL_DEBUG_HT("unknown\n");
 		return -EINVAL;
-- 
1.5.3.4

