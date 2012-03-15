Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161465Ab2COU2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/26] iwlwifi: move iwl_check_rxon_cmd and mark it static
Date: Thu, 15 Mar 2012 13:27:01 -0700
Message-Id: <1331843226-29860-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212825_319103_659F22A4)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_check_rxon_cmd is used only in
iwl-agn-rxon.c. Move it there and mark it
static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   73 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   72 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 3 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ed88cf9..8eb2946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -512,6 +512,79 @@ static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
 
 }
 
+/* validate RXON structure is valid */
+static int iwl_check_rxon_cmd(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx)
+{
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
+	u32 errors = 0;
+
+	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
+		if (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK) {
+			IWL_WARN(priv, "check 2.4G: wrong narrow\n");
+			errors |= BIT(0);
+		}
+		if (rxon->flags & RXON_FLG_RADAR_DETECT_MSK) {
+			IWL_WARN(priv, "check 2.4G: wrong radar\n");
+			errors |= BIT(1);
+		}
+	} else {
+		if (!(rxon->flags & RXON_FLG_SHORT_SLOT_MSK)) {
+			IWL_WARN(priv, "check 5.2G: not short slot!\n");
+			errors |= BIT(2);
+		}
+		if (rxon->flags & RXON_FLG_CCK_MSK) {
+			IWL_WARN(priv, "check 5.2G: CCK!\n");
+			errors |= BIT(3);
+		}
+	}
+	if ((rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1) {
+		IWL_WARN(priv, "mac/bssid mcast!\n");
+		errors |= BIT(4);
+	}
+
+	/* make sure basic rates 6Mbps and 1Mbps are supported */
+	if ((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0 &&
+	    (rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0) {
+		IWL_WARN(priv, "neither 1 nor 6 are basic\n");
+		errors |= BIT(5);
+	}
+
+	if (le16_to_cpu(rxon->assoc_id) > 2007) {
+		IWL_WARN(priv, "aid > 2007\n");
+		errors |= BIT(6);
+	}
+
+	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) {
+		IWL_WARN(priv, "CCK and short slot\n");
+		errors |= BIT(7);
+	}
+
+	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
+		IWL_WARN(priv, "CCK and auto detect");
+		errors |= BIT(8);
+	}
+
+	if ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
+			    RXON_FLG_TGG_PROTECT_MSK)) ==
+			    RXON_FLG_TGG_PROTECT_MSK) {
+		IWL_WARN(priv, "TGg but no auto-detect\n");
+		errors |= BIT(9);
+	}
+
+	if (rxon->channel == 0) {
+		IWL_WARN(priv, "zero channel is invalid\n");
+		errors |= BIT(10);
+	}
+
+	WARN(errors, "Invalid RXON (%#x), channel %d",
+	     errors, le16_to_cpu(rxon->channel));
+
+	return errors ? -EINVAL : 0;
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4290d40..5633869 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -88,78 +88,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			ctx->ht.extension_chan_offset);
 }
 
-/* validate RXON structure is valid */
-int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	struct iwl_rxon_cmd *rxon = &ctx->staging;
-	u32 errors = 0;
-
-	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		if (rxon->flags & RXON_FLG_TGJ_NARROW_BAND_MSK) {
-			IWL_WARN(priv, "check 2.4G: wrong narrow\n");
-			errors |= BIT(0);
-		}
-		if (rxon->flags & RXON_FLG_RADAR_DETECT_MSK) {
-			IWL_WARN(priv, "check 2.4G: wrong radar\n");
-			errors |= BIT(1);
-		}
-	} else {
-		if (!(rxon->flags & RXON_FLG_SHORT_SLOT_MSK)) {
-			IWL_WARN(priv, "check 5.2G: not short slot!\n");
-			errors |= BIT(2);
-		}
-		if (rxon->flags & RXON_FLG_CCK_MSK) {
-			IWL_WARN(priv, "check 5.2G: CCK!\n");
-			errors |= BIT(3);
-		}
-	}
-	if ((rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1) {
-		IWL_WARN(priv, "mac/bssid mcast!\n");
-		errors |= BIT(4);
-	}
-
-	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	if ((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0 &&
-	    (rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0) {
-		IWL_WARN(priv, "neither 1 nor 6 are basic\n");
-		errors |= BIT(5);
-	}
-
-	if (le16_to_cpu(rxon->assoc_id) > 2007) {
-		IWL_WARN(priv, "aid > 2007\n");
-		errors |= BIT(6);
-	}
-
-	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK)) {
-		IWL_WARN(priv, "CCK and short slot\n");
-		errors |= BIT(7);
-	}
-
-	if ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK)) {
-		IWL_WARN(priv, "CCK and auto detect");
-		errors |= BIT(8);
-	}
-
-	if ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
-			    RXON_FLG_TGG_PROTECT_MSK)) ==
-			    RXON_FLG_TGG_PROTECT_MSK) {
-		IWL_WARN(priv, "TGg but no auto-detect\n");
-		errors |= BIT(9);
-	}
-
-	if (rxon->channel == 0) {
-		IWL_WARN(priv, "zero channel is invalid\n");
-		errors |= BIT(10);
-	}
-
-	WARN(errors, "Invalid RXON (%#x), channel %d",
-	     errors, le16_to_cpu(rxon->channel));
-
-	return errors ? -EINVAL : 0;
-}
-
 /**
  * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @priv: staging_rxon is compared to active_rxon
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cdcf139..f49a69c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -93,7 +93,6 @@ struct iwl_lib_ops {
  *   L i b                 *
  ***************************/
 
-int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
 			 struct iwl_rxon_context *ctx);
-- 
1.7.0.4

