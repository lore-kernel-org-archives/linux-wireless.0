Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0H0Q44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/27] iwlwifi: allow using multiple contexts
Date: Fri, 27 Aug 2010 09:59:55 -0700
Message-Id: <1282928395-32762-28-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're now ready to start using multiple contexts.
We do this by keeping track of the valid interface
types per context (exclusive [ibss] and normal)
and checking which context is "free" when a new
interface is added.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   25 +++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   80 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +++-
 5 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1d58b1c..ad0e67f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2828,8 +2828,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
+		struct iwl_rxon_context *tmp;
 		/* Initialize our rx_config data */
-		iwl_connection_init_rx_config(priv, NULL);
+		for_each_context(priv, tmp)
+			iwl_connection_init_rx_config(priv, tmp);
 
 		if (priv->cfg->ops->hcmd->set_rxon_chain)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
@@ -3370,6 +3372,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 {
 	int ret;
 	struct ieee80211_hw *hw = priv->hw;
+	struct iwl_rxon_context *ctx;
+
 	hw->rate_control_algorithm = "iwl-agn-rs";
 
 	/* Tell mac80211 our characteristics */
@@ -3389,9 +3393,10 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->vif_data_size = sizeof(struct iwl_vif_priv);
 
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+	for_each_context(priv, ctx) {
+		hw->wiphy->interface_modes |= ctx->interface_modes;
+		hw->wiphy->interface_modes |= ctx->exclusive_interface_modes;
+	}
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
@@ -4289,6 +4294,13 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
 	priv->contexts[IWL_RXON_CTX_BSS].ac_to_fifo = iwlagn_bss_ac_to_fifo;
 	priv->contexts[IWL_RXON_CTX_BSS].ac_to_queue = iwlagn_bss_ac_to_queue;
+	priv->contexts[IWL_RXON_CTX_BSS].exclusive_interface_modes =
+		BIT(NL80211_IFTYPE_ADHOC);
+	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
+		BIT(NL80211_IFTYPE_STATION);
+	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
+	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
+	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
 
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_cmd = REPLY_WIPAN_RXON;
 	priv->contexts[IWL_RXON_CTX_PAN].rxon_timing_cmd = REPLY_WIPAN_RXON_TIMING;
@@ -4301,6 +4313,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_PAN].ac_to_fifo = iwlagn_pan_ac_to_fifo;
 	priv->contexts[IWL_RXON_CTX_PAN].ac_to_queue = iwlagn_pan_ac_to_queue;
 	priv->contexts[IWL_RXON_CTX_PAN].mcast_queue = IWL_IPAN_MCAST_QUEUE;
+	priv->contexts[IWL_RXON_CTX_PAN].interface_modes =
+		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP);
+	priv->contexts[IWL_RXON_CTX_PAN].ap_devtype = RXON_DEV_TYPE_CP;
+	priv->contexts[IWL_RXON_CTX_PAN].station_devtype = RXON_DEV_TYPE_2STA;
+	priv->contexts[IWL_RXON_CTX_PAN].unused_devtype = RXON_DEV_TYPE_P2P;
 
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a2b39fd..87a2e40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1028,38 +1028,34 @@ EXPORT_SYMBOL(iwl_set_flags_for_band);
  * initialize rxon structure with default values from eeprom
  */
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif)
+				   struct iwl_rxon_context *ctx)
 {
 	const struct iwl_channel_info *ch_info;
-	enum nl80211_iftype type = NL80211_IFTYPE_STATION;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-
-	if (vif) {
-		type = vif->type;
-		ctx = iwl_rxon_ctx_from_vif(vif);
-	}
 
 	memset(&ctx->staging, 0, sizeof(ctx->staging));
 
-	switch (type) {
+	if (!ctx->vif) {
+		ctx->staging.dev_type = ctx->unused_devtype;
+	} else switch (ctx->vif->type) {
 	case NL80211_IFTYPE_AP:
-		ctx->staging.dev_type = RXON_DEV_TYPE_AP;
+		ctx->staging.dev_type = ctx->ap_devtype;
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		ctx->staging.dev_type = RXON_DEV_TYPE_ESS;
+		ctx->staging.dev_type = ctx->station_devtype;
 		ctx->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
 	case NL80211_IFTYPE_ADHOC:
-		ctx->staging.dev_type = RXON_DEV_TYPE_IBSS;
+		ctx->staging.dev_type = ctx->ibss_devtype;
 		ctx->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
 		ctx->staging.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
 						  RXON_FILTER_ACCEPT_GRP_MSK;
 		break;
 
 	default:
-		IWL_ERR(priv, "Unsupported interface type %d\n", type);
+		IWL_ERR(priv, "Unsupported interface type %d\n",
+			ctx->vif->type);
 		break;
 	}
 
@@ -1081,7 +1077,7 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 	ctx->staging.channel = cpu_to_le16(ch_info->channel);
 	priv->band = ch_info->band;
 
-	iwl_set_flags_for_band(priv, ctx, priv->band, vif);
+	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
 
 	ctx->staging.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -1091,8 +1087,8 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 	/* clear both MIX and PURE40 mode flag */
 	ctx->staging.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
 					RXON_FLG_CHANNEL_MODE_PURE_40);
-	if (vif)
-		memcpy(ctx->staging.node_addr, vif->addr, ETH_ALEN);
+	if (ctx->vif)
+		memcpy(ctx->staging.node_addr, ctx->vif->addr, ETH_ALEN);
 
 	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
 	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
@@ -1952,7 +1948,7 @@ static int iwl_set_mode(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
 
-	iwl_connection_init_rx_config(priv, vif);
+	iwl_connection_init_rx_config(priv, ctx);
 
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
@@ -1964,7 +1960,7 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-	struct iwl_rxon_context *ctx;
+	struct iwl_rxon_context *tmp, *ctx = NULL;
 	int err = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: type %d, addr %pM\n",
@@ -1972,23 +1968,45 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	mutex_lock(&priv->mutex);
 
-	/* For now always use this context. */
-	ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-
-	vif_priv->ctx = ctx;
-
 	if (WARN_ON(!iwl_is_ready_rf(priv))) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (ctx->vif) {
-		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
+	for_each_context(priv, tmp) {
+		u32 possible_modes =
+			tmp->interface_modes | tmp->exclusive_interface_modes;
+
+		if (tmp->vif) {
+			/* check if this busy context is exclusive */
+			if (tmp->exclusive_interface_modes &
+						BIT(tmp->vif->type)) {
+				err = -EINVAL;
+				goto out;
+			}
+			continue;
+		}
+
+		if (!(possible_modes & BIT(vif->type)))
+			continue;
+
+		/* have maybe usable context w/o interface */
+		ctx = tmp;
+		break;
+	}
+
+	if (!ctx) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
+	vif_priv->ctx = ctx;
 	ctx->vif = vif;
+	/*
+	 * This variable will be correct only when there's just
+	 * a single context, but all code using it is for hardware
+	 * that supports only one context.
+	 */
 	priv->iw_mode = vif->type;
 
 	err = iwl_set_mode(priv, vif);
@@ -2029,11 +2047,11 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (iwl_is_ready_rf(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
-		ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-		iwlcore_commit_rxon(priv, ctx);
-	}
+	WARN_ON(ctx->vif != vif);
+	ctx->vif = NULL;
+
+	iwl_scan_cancel_timeout(priv, 100);
+	iwl_set_mode(priv, vif);
 
 	if (priv->scan_vif == vif) {
 		scan_completed = true;
@@ -2051,8 +2069,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_ADHOC)
 		priv->bt_traffic_load = priv->notif_bt_traffic_load;
 
-	WARN_ON(ctx->vif != vif);
-	ctx->vif = NULL;
 	memset(priv->bssid, 0, ETH_ALEN);
 	mutex_unlock(&priv->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4d79100..f7b57ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -394,7 +394,7 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    struct ieee80211_sta_ht_cap *ht_cap);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
-				   struct ieee80211_vif *vif);
+				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
 int iwl_set_decrypted_flag(struct iwl_priv *priv,
 			   struct ieee80211_hdr *hdr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 422c71e..4dd38b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1117,6 +1117,10 @@ struct iwl_rxon_context {
 	u8 mcast_queue;
 
 	enum iwl_rxon_context_id ctxid;
+
+	u32 interface_modes, exclusive_interface_modes;
+	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
+
 	/*
 	 * We declare this const so it can only be
 	 * changed via explicit cast within the
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 76a45b2..68e624a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2540,7 +2540,7 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
-		iwl_connection_init_rx_config(priv, NULL);
+		iwl_connection_init_rx_config(priv, ctx);
 	}
 
 	/* Configure Bluetooth device coexistence support */
@@ -3955,8 +3955,7 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		priv->contexts[IWL_RXON_CTX_BSS].interface_modes;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS;
@@ -4024,6 +4023,12 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
 	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
+	priv->contexts[IWL_RXON_CTX_BSS].interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+	priv->contexts[IWL_RXON_CTX_BSS].ibss_devtype = RXON_DEV_TYPE_IBSS;
+	priv->contexts[IWL_RXON_CTX_BSS].station_devtype = RXON_DEV_TYPE_ESS;
+	priv->contexts[IWL_RXON_CTX_BSS].unused_devtype = RXON_DEV_TYPE_ESS;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
-- 
1.7.0.4

