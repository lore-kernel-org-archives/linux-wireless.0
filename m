Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161461Ab2COU2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/26] iwlwifi: move iwl_set_rxon_hwcrypto and mark it static
Date: Thu, 15 Mar 2012 13:27:00 -0700
Message-Id: <1331843226-29860-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212819_424968_8A80874C)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_set_rxon_hwcrypto is used only in
iwl-agn-rxon.c. Move it there and mark it
static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   12 ------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 --
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 6a2fad3..ed88cf9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -500,6 +500,18 @@ int iwlagn_set_pan_params(struct iwl_priv *priv)
 	return ret;
 }
 
+static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv,
+				  struct iwl_rxon_context *ctx, int hw_decrypt)
+{
+	struct iwl_rxon_cmd *rxon = &ctx->staging;
+
+	if (hw_decrypt)
+		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
+	else
+		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
+
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 796f4a1..4290d40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -88,18 +88,6 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			ctx->ht.extension_chan_offset);
 }
 
-void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			   int hw_decrypt)
-{
-	struct iwl_rxon_cmd *rxon = &ctx->staging;
-
-	if (hw_decrypt)
-		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
-	else
-		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
-
-}
-
 /* validate RXON structure is valid */
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7217be8..cdcf139 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -93,8 +93,6 @@ struct iwl_lib_ops {
  *   L i b                 *
  ***************************/
 
-void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			   int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 int iwl_full_rxon_required(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch,
-- 
1.7.0.4

