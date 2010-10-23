Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:49685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab0JWQSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/8] iwlagn: don't resent RXON timing
Date: Sat, 23 Oct 2010 09:15:40 -0700
Message-Id: <1287850546-23500-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Resending RXON timing here caused issues with
dual-mode under certain circumstances, so avoid
doing it here right now.

This effectively reverts b01efe434bd6ea807eb72b
and partially 2491fa42d9bdf26075765. The next
patch will make all this cleaner for just the
devices that need it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ad8754f..a126113 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -105,7 +105,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	int ret;
 	bool new_assoc =
 		!!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
-	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
 		return -EBUSY;
@@ -186,19 +185,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
 
-	if (!old_assoc) {
-		/*
-		 * First of all, before setting associated, we need to
-		 * send RXON timing so the device knows about the DTIM
-		 * period and other timing values
-		 */
-		ret = iwl_send_rxon_timing(priv, ctx);
-		if (ret) {
-			IWL_ERR(priv, "Error setting RXON timing!\n");
-			return ret;
-		}
-	}
-
 	if (priv->cfg->ops->hcmd->set_pan_params) {
 		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
 		if (ret)
-- 
1.7.0.4

