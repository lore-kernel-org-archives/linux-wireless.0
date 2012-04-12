Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966082Ab2DLV6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/24] iwlwifi: move iwl_is_ht40_tx_allowed out of iwl-core.c
Date: Thu, 12 Apr 2012 14:54:04 -0700
Message-Id: <1334267661-14654-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_356268_B3E57161)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

This is really something determined by
station parameters, so move it to
iwl-agn-sta.c.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   44 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl-core.c    |   44 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    3 --
 4 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 79cbaab..42af9f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -170,6 +170,50 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	return cmd.handler_status;
 }
 
+static bool iwl_is_channel_extension(struct iwl_priv *priv,
+				     enum ieee80211_band band,
+				     u16 channel, u8 extension_chan_offset)
+{
+	const struct iwl_channel_info *ch_info;
+
+	ch_info = iwl_get_channel_info(priv, band, channel);
+	if (!is_channel_valid(ch_info))
+		return false;
+
+	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
+		return !(ch_info->ht40_extension_channel &
+					IEEE80211_CHAN_NO_HT40PLUS);
+	else if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
+		return !(ch_info->ht40_extension_channel &
+					IEEE80211_CHAN_NO_HT40MINUS);
+
+	return false;
+}
+
+bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_sta_ht_cap *ht_cap)
+{
+	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
+		return false;
+
+	/*
+	 * We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
+	 * the bit will not set if it is pure 40MHz case
+	 */
+	if (ht_cap && !ht_cap->ht_supported)
+		return false;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (priv->disable_ht40)
+		return false;
+#endif
+
+	return iwl_is_channel_extension(priv, priv->band,
+			le16_to_cpu(ctx->staging.channel),
+			ctx->ht.extension_chan_offset);
+}
+
 static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
 				  struct ieee80211_sta *sta,
 				  struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 3b66e30..90b1f3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -261,6 +261,9 @@ int iwl_add_sta_callback(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 		      struct ieee80211_sta *sta);
 
+bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    struct ieee80211_sta_ht_cap *ht_cap);
 
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index e1129dc..42b5f90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,50 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-static bool iwl_is_channel_extension(struct iwl_priv *priv,
-				     enum ieee80211_band band,
-				     u16 channel, u8 extension_chan_offset)
-{
-	const struct iwl_channel_info *ch_info;
-
-	ch_info = iwl_get_channel_info(priv, band, channel);
-	if (!is_channel_valid(ch_info))
-		return false;
-
-	if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
-		return !(ch_info->ht40_extension_channel &
-					IEEE80211_CHAN_NO_HT40PLUS);
-	else if (extension_chan_offset == IEEE80211_HT_PARAM_CHA_SEC_BELOW)
-		return !(ch_info->ht40_extension_channel &
-					IEEE80211_CHAN_NO_HT40MINUS);
-
-	return false;
-}
-
-bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_sta_ht_cap *ht_cap)
-{
-	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
-		return false;
-
-	/*
-	 * We do not check for IEEE80211_HT_CAP_SUP_WIDTH_20_40
-	 * the bit will not set if it is pure 40MHz case
-	 */
-	if (ht_cap && !ht_cap->ht_supported)
-		return false;
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (priv->disable_ht40)
-		return false;
-#endif
-
-	return iwl_is_channel_extension(priv, priv->band,
-			le16_to_cpu(ctx->staging.channel),
-			ctx->ht.extension_chan_offset);
-}
-
 static void _iwl_set_rxon_ht(struct iwl_priv *priv,
 			     struct iwl_ht_config *ht_conf,
 			     struct iwl_rxon_context *ctx)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5cbe609..eb0e785 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -85,9 +85,6 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
-bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_sta_ht_cap *ht_cap);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-- 
1.7.0.4

