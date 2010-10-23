Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921Ab0JWQSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/8] iwlwifi: implement switching iftype while up
Date: Sat, 23 Oct 2010 09:15:43 -0700
Message-Id: <1287850546-23500-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement switching the interface while an
interface is up in iwlwifi. Interfaces have
to stay on the context they were created on.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |  168 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 5 files changed, 130 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6e80ab5..6a3c0ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2593,6 +2593,7 @@ struct ieee80211_ops iwl4965_hw_ops = {
 	.stop = iwlagn_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
+	.change_interface = iwl_mac_change_interface,
 	.config = iwl_legacy_mac_config,
 	.configure_filter = iwlagn_configure_filter,
 	.set_key = iwlagn_mac_set_key,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4afad96..6a82b20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3904,6 +3904,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.stop = iwlagn_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
+	.change_interface = iwl_mac_change_interface,
 	.config = iwlagn_mac_config,
 	.configure_filter = iwlagn_configure_filter,
 	.set_key = iwlagn_mac_set_key,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 84a9514..9809c57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1423,10 +1423,8 @@ int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(iwl_mac_tx_last_beacon);
 
-static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
+static int iwl_set_mode(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
-
 	iwl_connection_init_rx_config(priv, ctx);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
@@ -1435,12 +1433,49 @@ static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	return iwlcore_commit_rxon(priv, ctx);
 }
 
+static int iwl_setup_interface(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
+{
+	struct ieee80211_vif *vif = ctx->vif;
+	int err;
+
+	lockdep_assert_held(&priv->mutex);
+
+	/*
+	 * This variable will be correct only when there's just
+	 * a single context, but all code using it is for hardware
+	 * that supports only one context.
+	 */
+	priv->iw_mode = vif->type;
+
+	ctx->is_active = true;
+
+	err = iwl_set_mode(priv, ctx);
+	if (err) {
+		if (!ctx->always_active)
+			ctx->is_active = false;
+		return err;
+	}
+
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist &&
+	    vif->type == NL80211_IFTYPE_ADHOC) {
+		/*
+		 * pretend to have high BT traffic as long as we
+		 * are operating in IBSS mode, as this will cause
+		 * the rate scaling etc. to behave as intended.
+		 */
+		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+	}
+
+	return 0;
+}
+
 int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *tmp, *ctx = NULL;
-	int err = 0;
+	int err;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
 			   vif->type, vif->addr);
@@ -1482,36 +1517,11 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	vif_priv->ctx = ctx;
 	ctx->vif = vif;
-	/*
-	 * This variable will be correct only when there's just
-	 * a single context, but all code using it is for hardware
-	 * that supports only one context.
-	 */
-	priv->iw_mode = vif->type;
-
-	ctx->is_active = true;
-
-	err = iwl_set_mode(priv, vif);
-	if (err) {
-		if (!ctx->always_active)
-			ctx->is_active = false;
-		goto out_err;
-	}
-
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
-		/*
-		 * pretend to have high BT traffic as long as we
-		 * are operating in IBSS mode, as this will cause
-		 * the rate scaling etc. to behave as intended.
-		 */
-		priv->bt_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
-	}
 
-	goto out;
+	err = iwl_setup_interface(priv, ctx);
+	if (!err)
+		goto out;
 
- out_err:
 	ctx->vif = NULL;
 	priv->iw_mode = NL80211_IFTYPE_STATION;
  out:
@@ -1522,27 +1532,24 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(iwl_mac_add_interface);
 
-void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif)
+static void iwl_teardown_interface(struct iwl_priv *priv,
+				   struct ieee80211_vif *vif,
+				   bool mode_change)
 {
-	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
-	IWL_DEBUG_MAC80211(priv, "enter\n");
-
-	mutex_lock(&priv->mutex);
-
-	WARN_ON(ctx->vif != vif);
-	ctx->vif = NULL;
+	lockdep_assert_held(&priv->mutex);
 
 	if (priv->scan_vif == vif) {
 		iwl_scan_cancel_timeout(priv, 200);
 		iwl_force_scan_end(priv);
 	}
-	iwl_set_mode(priv, vif);
 
-	if (!ctx->always_active)
-		ctx->is_active = false;
+	if (!mode_change) {
+		iwl_set_mode(priv, ctx);
+		if (!ctx->always_active)
+			ctx->is_active = false;
+	}
 
 	/*
 	 * When removing the IBSS interface, overwrite the
@@ -1553,6 +1560,22 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	 */
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		priv->bt_traffic_load = priv->notif_bt_traffic_load;
+}
+
+void iwl_mac_remove_interface(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
+	mutex_lock(&priv->mutex);
+
+	WARN_ON(ctx->vif != vif);
+	ctx->vif = NULL;
+
+	iwl_teardown_interface(priv, vif, false);
 
 	memset(priv->bssid, 0, ETH_ALEN);
 	mutex_unlock(&priv->mutex);
@@ -1904,6 +1927,63 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 	return 0;
 }
 
+int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			     enum nl80211_iftype newtype, bool newp2p)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	struct iwl_rxon_context *tmp;
+	u32 interface_modes;
+	int err;
+
+	newtype = ieee80211_iftype_p2p(newtype, newp2p);
+
+	mutex_lock(&priv->mutex);
+
+	interface_modes = ctx->interface_modes | ctx->exclusive_interface_modes;
+
+	if (!(interface_modes & BIT(newtype))) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (ctx->exclusive_interface_modes & BIT(newtype)) {
+		for_each_context(priv, tmp) {
+			if (ctx == tmp)
+				continue;
+
+			if (!tmp->vif)
+				continue;
+
+			/*
+			 * The current mode switch would be exclusive, but
+			 * another context is active ... refuse the switch.
+			 */
+			err = -EBUSY;
+			goto out;
+		}
+	}
+
+	/* success */
+	iwl_teardown_interface(priv, vif, true);
+	vif->type = newtype;
+	err = iwl_setup_interface(priv, ctx);
+	WARN_ON(err);
+	/*
+	 * We've switched internally, but submitting to the
+	 * device may have failed for some reason. Mask this
+	 * error, because otherwise mac80211 will not switch
+	 * (and set the interface type back) and we'll be
+	 * out of sync with it.
+	 */
+	err = 0;
+
+ out:
+	mutex_unlock(&priv->mutex);
+	return err;
+}
+EXPORT_SYMBOL(iwl_mac_change_interface);
+
 /**
  * iwl_bg_monitor_recover - Timer callback to check for stuck queue and recover
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3a8b481..39ea13c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -432,6 +432,9 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
+int iwl_mac_change_interface(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     enum nl80211_iftype newtype, bool newp2p);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
 void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8a37b25..193247a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3832,6 +3832,7 @@ struct ieee80211_ops iwl3945_hw_ops = {
 	.stop = iwl3945_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
+	.change_interface = iwl_mac_change_interface,
 	.config = iwl_legacy_mac_config,
 	.configure_filter = iwl3945_configure_filter,
 	.set_key = iwl3945_mac_set_key,
-- 
1.7.0.4

