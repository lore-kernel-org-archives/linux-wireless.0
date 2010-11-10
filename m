Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab0KJSBP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:15 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/16] iwlagn: fix RXON issues
Date: Wed, 10 Nov 2010 09:56:45 -0800
Message-Id: <1289411810-23093-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The RXON rework resulted in a massive loss of
throughput because we weren't programming the
device completely correctly -- the BSSID has
to be programmed into the device before the
AP station is uploaded. To fix this, simply
always send the unassoc RXON, i.e. even when
it was already unassoc so that the BSSID and
some other parameters are updated properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   50 +++++++++++---------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 1fab1bb..d594a16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -96,7 +96,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	/* cast away the const for active_rxon in this function */
 	struct iwl_rxon_cmd *active = (void *)&ctx->active;
-	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
 	bool new_assoc = !!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
 	int ret;
 
@@ -172,37 +171,30 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		       ctx->staging.bssid_addr);
 
 	/*
-	 * If we are currently associated and the new config is also
-	 * going to be associated, OR if the new config is simply not
-	 * associated, clear associated.
+	 * Always clear associated first, but with the correct config.
+	 * This is required as for example station addition for the
+	 * AP station must be done after the BSSID is set to correctly
+	 * set up filters in the device.
 	 */
-	if ((old_assoc && new_assoc) || !new_assoc) {
-		struct iwl_rxon_cmd *send = active;
-
-		if (!new_assoc)
-			send = &ctx->staging;
-
-		if (ctx->ctxid == IWL_RXON_CTX_BSS)
-			ret = iwlagn_disable_bss(priv, ctx, send);
-		else
-			ret = iwlagn_disable_pan(priv, ctx, send);
-		if (ret)
-			return ret;
+	if (ctx->ctxid == IWL_RXON_CTX_BSS)
+		ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
+	else
+		ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
+	if (ret)
+		return ret;
 
-		if (send != active)
-			memcpy(active, send, sizeof(*active));
+	memcpy(active, &ctx->staging, sizeof(*active));
 
-		/*
-		 * Un-assoc RXON clears the station table and WEP
-		 * keys, so we have to restore those afterwards.
-		 */
-		iwl_clear_ucode_stations(priv, ctx);
-		iwl_restore_stations(priv, ctx);
-		ret = iwl_restore_default_wep_keys(priv, ctx);
-		if (ret) {
-			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
-			return ret;
-		}
+	/*
+	 * Un-assoc RXON clears the station table and WEP
+	 * keys, so we have to restore those afterwards.
+	 */
+	iwl_clear_ucode_stations(priv, ctx);
+	iwl_restore_stations(priv, ctx);
+	ret = iwl_restore_default_wep_keys(priv, ctx);
+	if (ret) {
+		IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+		return ret;
 	}
 
 	/* RXON timing must be before associated RXON */
-- 
1.7.0.4

