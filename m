Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab0IKQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlwifi: improve timing handling with dual-mode
Date: Sat, 11 Sep 2010 09:08:35 -0700
Message-Id: <1284221318-28281-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In dual-mode, a number of scenarios need to be
considered, and the firmware can be very picky
about them. Adjust the timing (most importantly
the beacon interval) according to the different
modes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f67cab5..c393b20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -529,10 +529,22 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	ctx->timing.atim_window = 0;
 
 	if (ctx->ctxid == IWL_RXON_CTX_PAN &&
-	    (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION)) {
+	    (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION) &&
+	    iwl_is_associated(priv, IWL_RXON_CTX_BSS) &&
+	    priv->contexts[IWL_RXON_CTX_BSS].vif &&
+	    priv->contexts[IWL_RXON_CTX_BSS].vif->bss_conf.beacon_int) {
 		ctx->timing.beacon_interval =
 			priv->contexts[IWL_RXON_CTX_BSS].timing.beacon_interval;
 		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
+	} else if (ctx->ctxid == IWL_RXON_CTX_BSS &&
+		   iwl_is_associated(priv, IWL_RXON_CTX_PAN) &&
+		   priv->contexts[IWL_RXON_CTX_PAN].vif &&
+		   priv->contexts[IWL_RXON_CTX_PAN].vif->bss_conf.beacon_int &&
+		   (!iwl_is_associated_ctx(ctx) || !ctx->vif ||
+		    !ctx->vif->bss_conf.beacon_int)) {
+		ctx->timing.beacon_interval =
+			priv->contexts[IWL_RXON_CTX_PAN].timing.beacon_interval;
+		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
 	} else {
 		beacon_int = iwl_adjust_beacon_interval(beacon_int,
 				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
-- 
1.7.0.4

