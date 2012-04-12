Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966087Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/24] iwlwifi: move iwl_set_rxon_ht to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:05 -0700
Message-Id: <1334267661-14654-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_274254_25D04321)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Moving this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   90 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   75 ----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 4 files changed, 91 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 369cd8b..944ad73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -501,6 +501,96 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	return ret;
 }
 
+static void _iwl_set_rxon_ht(struct iwl_priv *priv,
+			     struct iwl_ht_config *ht_conf,
+			     struct iwl_rxon_context *ctx)
+{
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
+
+	if (!ctx->ht.enabled) {
+		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
+			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+			RXON_FLG_HT40_PROT_MSK |
+			RXON_FLG_HT_PROT_MSK);
+		return;
+	}
+
+	/* FIXME: if the definition of ht.protection changed, the "translation"
+	 * will be needed for rxon->flags
+	 */
+	rxon->flags |= cpu_to_le32(ctx->ht.protection <<
+				   RXON_FLG_HT_OPERATING_MODE_POS);
+
+	/* Set up channel bandwidth:
+	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
+	/* clear the HT channel mode before set the mode */
+	rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
+			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
+	if (iwl_is_ht40_tx_allowed(priv, ctx, NULL)) {
+		/* pure ht40 */
+		if (ctx->ht.protection ==
+		    IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
+			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
+			/*
+			 * Note: control channel is opposite of extension
+			 * channel
+			 */
+			switch (ctx->ht.extension_chan_offset) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				rxon->flags &=
+					~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				rxon->flags |=
+					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				break;
+			}
+		} else {
+			/*
+			 * Note: control channel is opposite of extension
+			 * channel
+			 */
+			switch (ctx->ht.extension_chan_offset) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				rxon->flags &=
+					~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
+				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+			default:
+				/*
+				 * channel location only valid if in Mixed
+				 * mode
+				 */
+				IWL_ERR(priv,
+					"invalid extension channel offset\n");
+				break;
+			}
+		}
+	} else {
+		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
+	}
+
+	iwlagn_set_rxon_chain(priv, ctx);
+
+	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
+			"extension channel offset 0x%x\n",
+			le32_to_cpu(rxon->flags), ctx->ht.protection,
+			ctx->ht.extension_chan_offset);
+}
+
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
+{
+	struct iwl_rxon_context *ctx;
+
+	for_each_context(priv, ctx)
+		_iwl_set_rxon_ht(priv, ht_conf, ctx);
+}
+
 static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 				  struct iwl_rxon_context *ctx, int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 90b1f3a..d7b1bd8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -127,6 +127,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			     u32 changes);
 void iwlagn_config_ht40(struct ieee80211_conf *conf,
 			struct iwl_rxon_context *ctx);
+void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 
 /* uCode */
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 42b5f90..ab5db2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,81 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-static void _iwl_set_rxon_ht(struct iwl_priv *priv,
-			     struct iwl_ht_config *ht_conf,
-			     struct iwl_rxon_context *ctx)
-{
-	struct iwl_rxon_cmd *rxon = &ctx->staging;
-
-	if (!ctx->ht.enabled) {
-		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
-			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
-			RXON_FLG_HT40_PROT_MSK |
-			RXON_FLG_HT_PROT_MSK);
-		return;
-	}
-
-	/* FIXME: if the definition of ht.protection changed, the "translation"
-	 * will be needed for rxon->flags
-	 */
-	rxon->flags |= cpu_to_le32(ctx->ht.protection << RXON_FLG_HT_OPERATING_MODE_POS);
-
-	/* Set up channel bandwidth:
-	 * 20 MHz only, 20/40 mixed or pure 40 if ht40 ok */
-	/* clear the HT channel mode before set the mode */
-	rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
-			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-	if (iwl_is_ht40_tx_allowed(priv, ctx, NULL)) {
-		/* pure ht40 */
-		if (ctx->ht.protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
-			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
-			/* Note: control channel is opposite of extension channel */
-			switch (ctx->ht.extension_chan_offset) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				rxon->flags &= ~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
-				break;
-			}
-		} else {
-			/* Note: control channel is opposite of extension channel */
-			switch (ctx->ht.extension_chan_offset) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				rxon->flags &= ~(RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
-				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
-				rxon->flags |= RXON_FLG_CHANNEL_MODE_MIXED;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_NONE:
-			default:
-				/* channel location only valid if in Mixed mode */
-				IWL_ERR(priv, "invalid extension channel offset\n");
-				break;
-			}
-		}
-	} else {
-		rxon->flags |= RXON_FLG_CHANNEL_MODE_LEGACY;
-	}
-
-	iwlagn_set_rxon_chain(priv, ctx);
-
-	IWL_DEBUG_ASSOC(priv, "rxon flags 0x%X operation mode :0x%X "
-			"extension channel offset 0x%x\n",
-			le32_to_cpu(rxon->flags), ctx->ht.protection,
-			ctx->ht.extension_chan_offset);
-}
-
-void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
-{
-	struct iwl_rxon_context *ctx;
-
-	for_each_context(priv, ctx)
-		_iwl_set_rxon_ht(priv, ht_conf, ctx);
-}
-
 /**
  * iwl_set_rxon_channel - Set the band and channel values in staging RXON
  * @ch: requested channel as a pointer to struct ieee80211_channel
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index eb0e785..e793b16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -84,7 +84,6 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
-void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-- 
1.7.0.4

