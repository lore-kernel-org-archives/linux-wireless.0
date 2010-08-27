Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0H0Q44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/27] iwlagn: always send RXON timing
Date: Fri, 27 Aug 2010 09:59:53 -0700
Message-Id: <1282928395-32762-26-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The PAN context requires also getting
RXON timing when we send an unassociated
RXON in some cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 85eea94..1d58b1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -105,6 +105,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	int ret;
 	bool new_assoc =
 		!!(ctx->staging.filter_flags & RXON_FILTER_ASSOC_MSK);
+	bool old_assoc = !!(ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK);
 
 	if (!iwl_is_alive(priv))
 		return -EBUSY;
@@ -182,7 +183,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
 
-	if (new_assoc) {
+	if (!old_assoc) {
 		/*
 		 * First of all, before setting associated, we need to
 		 * send RXON timing so the device knows about the DTIM
-- 
1.7.0.4

