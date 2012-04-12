Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63195 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966090Ab2DLV6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/24] iwlwifi: move iwl_set_flags_for_band to iwl-agn-rxon.c
Date: Thu, 12 Apr 2012 14:54:07 -0700
Message-Id: <1334267661-14654-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235818_042216_C5CF3483)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Moving this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   23 -----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ----
 4 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 2fcc50c..fd09181 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -620,6 +620,29 @@ void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 
 }
 
+void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    enum ieee80211_band band,
+			    struct ieee80211_vif *vif)
+{
+	if (band == IEEE80211_BAND_5GHZ) {
+		ctx->staging.flags &=
+		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
+		      | RXON_FLG_CCK_MSK);
+		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+	} else {
+		/* Copied from iwl_post_associate() */
+		if (vif && vif->bss_conf.use_short_slot)
+			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
+		else
+			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
+
+		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
+		ctx->staging.flags |= RXON_FLG_AUTO_DETECT_MSK;
+		ctx->staging.flags &= ~RXON_FLG_CCK_MSK;
+	}
+}
+
 static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 				  struct iwl_rxon_context *ctx, int hw_decrypt)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 9eec4e6..ecc217c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -130,7 +130,10 @@ void iwlagn_config_ht40(struct ieee80211_conf *conf,
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
-
+void iwl_set_flags_for_band(struct iwl_priv *priv,
+			    struct iwl_rxon_context *ctx,
+			    enum ieee80211_band band,
+			    struct ieee80211_vif *vif);
 /* uCode */
 int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
 void iwl_send_prio_tbl(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f65f989..fdca7ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,29 +43,6 @@
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-void iwl_set_flags_for_band(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    enum ieee80211_band band,
-			    struct ieee80211_vif *vif)
-{
-	if (band == IEEE80211_BAND_5GHZ) {
-		ctx->staging.flags &=
-		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
-		      | RXON_FLG_CCK_MSK);
-		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
-	} else {
-		/* Copied from iwl_post_associate() */
-		if (vif && vif->bss_conf.use_short_slot)
-			ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
-		else
-			ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
-
-		ctx->staging.flags |= RXON_FLG_BAND_24G_MSK;
-		ctx->staging.flags |= RXON_FLG_AUTO_DETECT_MSK;
-		ctx->staging.flags &= ~RXON_FLG_CCK_MSK;
-	}
-}
-
 /*
  * initialize rxon structure with default values from eeprom
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b3cbeb2..a2b131a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -78,10 +78,6 @@ struct iwl_cmd;
  *   L i b                 *
  ***************************/
 
-void iwl_set_flags_for_band(struct iwl_priv *priv,
-			    struct iwl_rxon_context *ctx,
-			    enum ieee80211_band band,
-			    struct ieee80211_vif *vif);
 void iwl_connection_init_rx_config(struct iwl_priv *priv,
 				   struct iwl_rxon_context *ctx);
 void iwl_set_rate(struct iwl_priv *priv);
-- 
1.7.0.4

