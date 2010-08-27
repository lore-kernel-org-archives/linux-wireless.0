Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0H0Q4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/27] iwlwifi: introduce beacon context
Date: Fri, 27 Aug 2010 09:59:44 -0700
Message-Id: <1282928395-32762-17-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Only one context can be beaconing at a time,
but we need to track which one. Introduce a
new variable priv->beacon_ctx to do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   30 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +-
 5 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4efca99..55d1cd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -345,6 +345,13 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 	 * beacon contents.
 	 */
 
+	lockdep_assert_held(&priv->mutex);
+
+	if (!priv->beacon_ctx) {
+		IWL_ERR(priv, "trying to build beacon w/o beacon context!\n");
+		return -EINVAL;
+	}
+
 	/* Initialize memory */
 	tx_beacon_cmd = &frame->u.beacon;
 	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
@@ -357,9 +364,7 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
-#warning "Use proper STA ID"
-	tx_beacon_cmd->tx.sta_id =
-		priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id;
+	tx_beacon_cmd->tx.sta_id = priv->beacon_ctx->bcast_sta_id;
 	tx_beacon_cmd->tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	tx_beacon_cmd->tx.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK |
 		TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK;
@@ -369,7 +374,7 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 			frame_size);
 
 	/* Set up packet rate and flags */
-	rate = iwl_rate_get_lowest_plcp(priv);
+	rate = iwl_rate_get_lowest_plcp(priv, priv->beacon_ctx);
 	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 					      priv->hw_params.valid_tx_ant);
 	rate_flags = iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
@@ -602,25 +607,28 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 		container_of(work, struct iwl_priv, beacon_update);
 	struct sk_buff *beacon;
 
-	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-#warning "introduce and use beacon context"
-	beacon = ieee80211_beacon_get(priv->hw,
-			priv->contexts[IWL_RXON_CTX_BSS].vif);
+	mutex_lock(&priv->mutex);
+	if (!priv->beacon_ctx) {
+		IWL_ERR(priv, "updating beacon w/o beacon context!\n");
+		goto out;
+	}
 
+	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
+	beacon = ieee80211_beacon_get(priv->hw, priv->beacon_ctx->vif);
 	if (!beacon) {
 		IWL_ERR(priv, "update beacon failed\n");
-		return;
+		goto out;
 	}
 
-	mutex_lock(&priv->mutex);
 	/* new beacon skb is allocated every time; dispose previous.*/
 	if (priv->ibss_beacon)
 		dev_kfree_skb(priv->ibss_beacon);
 
 	priv->ibss_beacon = beacon;
-	mutex_unlock(&priv->mutex);
 
 	iwl_send_beacon_cmd(priv);
+ out:
+	mutex_unlock(&priv->mutex);
 }
 
 static void iwl_bg_bt_runtime_config(struct work_struct *work)
@@ -3477,6 +3485,8 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 	int ret = 0;
 
+	lockdep_assert_held(&priv->mutex);
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8ec042d..fb9173b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -699,11 +699,9 @@ int iwl_full_rxon_required(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_full_rxon_required);
 
-u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv)
+u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx)
 {
-#if !TODO
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-#endif
 	/*
 	 * Assign the lowest rate -- should really get this from
 	 * the beacon skb from mac80211.
@@ -1723,6 +1721,14 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
+	lockdep_assert_held(&priv->mutex);
+
+	if (!priv->beacon_ctx) {
+		IWL_ERR(priv, "update beacon but no beacon context!\n");
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - RF not ready\n");
 		return -EIO;
@@ -1741,9 +1747,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-#warning "use beacon context?"
-	priv->cfg->ops->lib->post_associate(
-			priv, priv->contexts[IWL_RXON_CTX_BSS].vif);
+	priv->cfg->ops->lib->post_associate(priv, priv->beacon_ctx->vif);
 
 	return 0;
 }
@@ -1773,6 +1777,18 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		/*
+		 * the add_interface code must make sure we only ever
+		 * have a single interface that could be beaconing at
+		 * any time.
+		 */
+		if (vif->bss_conf.enable_beacon)
+			priv->beacon_ctx = ctx;
+		else
+			priv->beacon_ctx = NULL;
+	}
+
 	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
 		dev_kfree_skb(priv->ibss_beacon);
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 289fef8..d2ee55d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -523,7 +523,8 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
 int iwl_hwrate_to_plcp_idx(u32 rate_n_flags);
 
-u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv);
+u8 iwl_rate_get_lowest_plcp(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx);
 
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c17c67f..e1565f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1437,6 +1437,8 @@ struct iwl_priv {
 	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
 	struct work_struct beacon_update;
+	struct iwl_rxon_context *beacon_ctx;
+
 	struct work_struct tt_work;
 	struct work_struct ct_enter;
 	struct work_struct ct_exit;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c048c1d..e81c438 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -343,7 +343,8 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
-	rate = iwl_rate_get_lowest_plcp(priv);
+	rate = iwl_rate_get_lowest_plcp(priv,
+				&priv->contexts[IWL_RXON_CTX_BSS]);
 
 	frame_size = iwl3945_hw_get_beacon_cmd(priv, frame, rate);
 
-- 
1.7.0.4

