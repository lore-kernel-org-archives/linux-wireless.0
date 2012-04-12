Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065Ab2DLV6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/24] iwlwifi: move iwl_set_rxon_channel to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:06 -0700
Message-Id: <1334267661-14654-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_130829_CBED38FD)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Moving this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   29 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   29 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 4 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 944ad73..2fcc50c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -591,6 +591,35 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 		_iwl_set_rxon_ht(priv, ht_conf, ctx);
 }
 
+/**
+ * iwl_set_rxon_channel - Set the band and channel values in staging RXON
+ * @ch: requested channel as a pointer to struct ieee80211_channel
+
+ * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
+ * in the staging RXON flag structure based on the ch->band
+ */
+void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+			 struct iwl_rxon_context *ctx)
+{
+	enum ieee80211_band band = ch->band;
+	u16 channel = ch->hw_value;
+
+	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
+	    (priv->band == band))
+		return;
+
+	ctx->staging.channel = cpu_to_le16(channel);
+	if (band == IEEE80211_BAND_5GHZ)
+		ctx->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
+	else
+		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
+
+	priv->band = band;
+
+	IWL_DEBUG_INFO(priv, "Staging channel set to %d [%d]\n", channel, band);
+
+}
+
 static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 				  struct iwl_rxon_context *ctx, int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d7b1bd8..9eec4e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -128,6 +128,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 void iwlagn_config_ht40(struct ieee80211_conf *conf,
 			struct iwl_rxon_context *ctx);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
+void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
+			 struct iwl_rxon_context *ctx);
 
 /* uCode */
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ab5db2e..f65f989 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,35 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-/**
- * iwl_set_rxon_channel - Set the band and channel values in staging RXON
- * @ch: requested channel as a pointer to struct ieee80211_channel
-
- * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
- * in the staging RXON flag structure based on the ch->band
- */
-void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
-			 struct iwl_rxon_context *ctx)
-{
-	enum ieee80211_band band = ch->band;
-	u16 channel = ch->hw_value;
-
-	if ((le16_to_cpu(ctx->staging.channel) == channel) &&
-	    (priv->band == band))
-		return;
-
-	ctx->staging.channel = cpu_to_le16(channel);
-	if (band == IEEE80211_BAND_5GHZ)
-		ctx->staging.flags &= ~RXON_FLG_BAND_24G_MSK;
-	else
-		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
-
-	priv->band = band;
-
-	IWL_DEBUG_INFO(priv, "Staging channel set to %d [%d]\n", channel, band);
-
-}
-
 void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e793b16..b3cbeb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -78,8 +78,6 @@ struct iwl_cmd;
  *   L i b                 *
  ***************************/
 
-void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
-			 struct iwl_rxon_context *ctx);
 void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
-- 
1.7.0.4

