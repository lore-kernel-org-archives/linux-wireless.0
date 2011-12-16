Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760196Ab1LPQh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 11:37:56 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/24] iwlwifi: kill iwl_{start,stop}_tx_ba_trans_ready
Date: Fri, 16 Dec 2011 07:37:22 -0800
Message-Id: <1324049849-831-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111216_173822_009642_79DDF944)
In-Reply-To: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1324049849-831-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since my latest patches, the upper layer reports to mac80211 that the
driver is ready to continue the start / stop BA flow as opposed to
the transport layer. Hence, iwl_{start,stop}_tx_ba_trans_ready are
not needed any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   22 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.c   |   28 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h |    6 ------
 3 files changed, 11 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index b4f3c08..ae35c53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -432,7 +432,6 @@ drop_unlock_priv:
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid)
 {
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
 	int sta_id;
@@ -495,7 +494,7 @@ turn_off:
 
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
-	iwl_stop_tx_ba_trans_ready(priv, vif_priv->ctx->ctxid, sta_id, tid);
+	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 
 	return 0;
 }
@@ -503,7 +502,6 @@ turn_off:
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
 	int sta_id;
@@ -546,8 +544,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		IWL_DEBUG_TX_QUEUES(priv, "Can proceed: ssn = next_recl = %d",
 				    tid_data->agg.ssn);
 		tid_data->agg.state = IWL_AGG_ON;
-		iwl_start_tx_ba_trans_ready(priv, vif_priv->ctx->ctxid, sta_id,
-					    tid);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 	} else {
 		IWL_DEBUG_TX_QUEUES(priv, "Can't proceed: ssn %d, "
 				    "next_reclaimed = %d",
@@ -625,9 +622,16 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 {
 	struct iwl_tid_data *tid_data = &priv->tid_data[sta_id][tid];
+	enum iwl_rxon_context_id ctx;
+	struct ieee80211_vif *vif;
+	u8 *addr;
 
 	lockdep_assert_held(&priv->shrd->sta_lock);
 
+	addr = priv->stations[sta_id].sta.sta.addr;
+	ctx = priv->stations[sta_id].ctxid;
+	vif = priv->contexts[ctx].vif;
+
 	switch (priv->tid_data[sta_id][tid].agg.state) {
 	case IWL_EMPTYING_HW_QUEUE_DELBA:
 		/* There are no packets for this RA / TID in the HW any more */
@@ -637,9 +641,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 				" %d", tid_data->next_reclaimed);
 			iwl_trans_tx_agg_disable(trans(priv), sta_id, tid);
 			tid_data->agg.state = IWL_AGG_OFF;
-			iwl_stop_tx_ba_trans_ready(priv,
-						   NUM_IWL_RXON_CTX,
-						   sta_id, tid);
+			ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -649,9 +651,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 				"Can continue ADDBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
 			tid_data->agg.state = IWL_AGG_ON;
-			iwl_start_tx_ba_trans_ready(priv,
-						    NUM_IWL_RXON_CTX,
-						    sta_id, tid);
+			ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 		}
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d037f69..fb690a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1584,34 +1584,6 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
-void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
-				 enum iwl_rxon_context_id ctx,
-				 u8 sta_id, u8 tid)
-{
-	struct ieee80211_vif *vif;
-	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-
-	if (ctx == NUM_IWL_RXON_CTX)
-		ctx = priv->stations[sta_id].ctxid;
-	vif = priv->contexts[ctx].vif;
-
-	ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
-}
-
-void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
-				enum iwl_rxon_context_id ctx,
-				u8 sta_id, u8 tid)
-{
-	struct ieee80211_vif *vif;
-	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-
-	if (ctx == NUM_IWL_RXON_CTX)
-		ctx = priv->stations[sta_id].ctxid;
-	vif = priv->contexts[ctx].vif;
-
-	ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
-}
-
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state)
 {
 	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index c458137..aa1ed65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -532,12 +532,6 @@ int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
 				 struct iwl_device_cmd *cmd);
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
-void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
-				 enum iwl_rxon_context_id ctx,
-				 u8 sta_id, u8 tid);
-void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
-				enum iwl_rxon_context_id ctx,
-				u8 sta_id, u8 tid);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
 void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb);
-- 
1.7.0.4

