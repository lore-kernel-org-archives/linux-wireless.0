Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966093Ab2DLV6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/24] iwlwifi: move iwl_connection_init_rx_config to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:08 -0700
Message-Id: <1334267661-14654-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235903_988651_EA63B192)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   72 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   71 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 4 files changed, 74 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index fd09181..994fb21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -32,6 +32,78 @@
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 
+/*
+ * initialize rxon structure with default values from eeprom
+ */
+void iwl_connection_init_rx_config(struct iwl_priv *priv,
+				   struct iwl_rxon_context *ctx)
+{
+	const struct iwl_channel_info *ch_info;
+
+	memset(&ctx->staging, 0, sizeof(ctx->staging));
+
+	if (!ctx->vif) {
+		ctx->staging.dev_type = ctx->unused_devtype;
+	} else
+	switch (ctx->vif->type) {
+	case NL80211_IFTYPE_AP:
+		ctx->staging.dev_type = ctx->ap_devtype;
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		ctx->staging.dev_type = ctx->station_devtype;
+		ctx->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
+		break;
+
+	case NL80211_IFTYPE_ADHOC:
+		ctx->staging.dev_type = ctx->ibss_devtype;
+		ctx->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
+		ctx->staging.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
+						  RXON_FILTER_ACCEPT_GRP_MSK;
+		break;
+
+	default:
+		IWL_ERR(priv, "Unsupported interface type %d\n",
+			ctx->vif->type);
+		break;
+	}
+
+#if 0
+	/* TODO:  Figure out when short_preamble would be set and cache from
+	 * that */
+	if (!hw_to_local(priv->hw)->short_preamble)
+		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
+	else
+		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
+#endif
+
+	ch_info = iwl_get_channel_info(priv, priv->band,
+				       le16_to_cpu(ctx->active.channel));
+
+	if (!ch_info)
+		ch_info = &priv->channel_info[0];
+
+	ctx->staging.channel = cpu_to_le16(ch_info->channel);
+	priv->band = ch_info->band;
+
+	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
+
+	ctx->staging.ofdm_basic_rates =
+	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+	ctx->staging.cck_basic_rates =
+	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
+
+	/* clear both MIX and PURE40 mode flag */
+	ctx->staging.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
+					RXON_FLG_CHANNEL_MODE_PURE_40);
+	if (ctx->vif)
+		memcpy(ctx->staging.node_addr, ctx->vif->addr, ETH_ALEN);
+
+	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
+	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
+	ctx->staging.ofdm_ht_triple_stream_basic_rates = 0xff;
+}
+
 static int iwlagn_disable_bss(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx,
 			      struct iwl_rxon_cmd *send)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ecc217c..8f9ea33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -117,6 +117,8 @@ int iwl_dvm_send_cmd_pdu(struct iwl_priv *priv, u8 id,
 			 u32 flags, u16 len, const void *data);
 
 /* RXON */
+void iwl_connection_init_rx_config(struct iwl_priv *priv,
+				   struct iwl_rxon_context *ctx);
 int iwlagn_set_pan_params(struct iwl_priv *priv);
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwlagn_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fdca7ab..942cbdb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,77 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-/*
- * initialize rxon structure with default values from eeprom
- */
-void iwl_connection_init_rx_config(struct iwl_priv *priv,
-				   struct iwl_rxon_context *ctx)
-{
-	const struct iwl_channel_info *ch_info;
-
-	memset(&ctx->staging, 0, sizeof(ctx->staging));
-
-	if (!ctx->vif) {
-		ctx->staging.dev_type = ctx->unused_devtype;
-	} else switch (ctx->vif->type) {
-	case NL80211_IFTYPE_AP:
-		ctx->staging.dev_type = ctx->ap_devtype;
-		break;
-
-	case NL80211_IFTYPE_STATION:
-		ctx->staging.dev_type = ctx->station_devtype;
-		ctx->staging.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	case NL80211_IFTYPE_ADHOC:
-		ctx->staging.dev_type = ctx->ibss_devtype;
-		ctx->staging.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
-		ctx->staging.filter_flags = RXON_FILTER_BCON_AWARE_MSK |
-						  RXON_FILTER_ACCEPT_GRP_MSK;
-		break;
-
-	default:
-		IWL_ERR(priv, "Unsupported interface type %d\n",
-			ctx->vif->type);
-		break;
-	}
-
-#if 0
-	/* TODO:  Figure out when short_preamble would be set and cache from
-	 * that */
-	if (!hw_to_local(priv->hw)->short_preamble)
-		ctx->staging.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
-	else
-		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
-#endif
-
-	ch_info = iwl_get_channel_info(priv, priv->band,
-				       le16_to_cpu(ctx->active.channel));
-
-	if (!ch_info)
-		ch_info = &priv->channel_info[0];
-
-	ctx->staging.channel = cpu_to_le16(ch_info->channel);
-	priv->band = ch_info->band;
-
-	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
-
-	ctx->staging.ofdm_basic_rates =
-	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
-	ctx->staging.cck_basic_rates =
-	    (IWL_CCK_RATES_MASK >> IWL_FIRST_CCK_RATE) & 0xF;
-
-	/* clear both MIX and PURE40 mode flag */
-	ctx->staging.flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED |
-					RXON_FLG_CHANNEL_MODE_PURE_40);
-	if (ctx->vif)
-		memcpy(ctx->staging.node_addr, ctx->vif->addr, ETH_ALEN);
-
-	ctx->staging.ofdm_ht_single_stream_basic_rates = 0xff;
-	ctx->staging.ofdm_ht_dual_stream_basic_rates = 0xff;
-	ctx->staging.ofdm_ht_triple_stream_basic_rates = 0xff;
-}
-
 void iwl_set_rate(struct iwl_priv *priv)
 {
 	struct iwl_rxon_context *ctx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a2b131a..8f6b16b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -78,8 +78,6 @@ struct iwl_cmd;
  *   L i b                 *
  ***************************/
 
-void iwl_connection_init_rx_config(struct iwl_priv *priv,
-				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
 int iwl_cmd_echo_test(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.7.0.4

