Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab0H0Q44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/27] iwlwifi: pass context to iwl_send_rxon_timing
Date: Fri, 27 Aug 2010 09:59:52 -0700
Message-Id: <1282928395-32762-25-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes we need to send RXON timing even
when we don't have a virtual interface yet,
so pass the context and allow passing one
without a virtual interface pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |   20 +++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f2884b5..85eea94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -183,14 +183,12 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	iwl_set_rxon_hwcrypto(priv, ctx, !priv->cfg->mod_params->sw_crypto);
 
 	if (new_assoc) {
-		if (WARN_ON(!ctx->vif))
-			return -EINVAL;
 		/*
 		 * First of all, before setting associated, we need to
 		 * send RXON timing so the device knows about the DTIM
 		 * period and other timing values
 		 */
-		ret = iwl_send_rxon_timing(priv, ctx->vif);
+		ret = iwl_send_rxon_timing(priv, ctx);
 		if (ret) {
 			IWL_ERR(priv, "Error setting RXON timing!\n");
 			return ret;
@@ -3296,7 +3294,7 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv, ctx);
 
-	ret = iwl_send_rxon_timing(priv, vif);
+	ret = iwl_send_rxon_timing(priv, ctx);
 	if (ret)
 		IWL_WARN(priv, "RXON timing - "
 			    "Attempting to continue.\n");
@@ -3536,7 +3534,7 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		iwlcore_commit_rxon(priv, ctx);
 
 		/* RXON Timing */
-		ret = iwl_send_rxon_timing(priv, vif);
+		ret = iwl_send_rxon_timing(priv, ctx);
 		if (ret)
 			IWL_WARN(priv, "RXON timing failed - "
 					"Attempting to continue.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b61b838..91ca517 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -500,13 +500,13 @@ static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 	return new_val;
 }
 
-int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	u64 tsf;
 	s32 interval_tm, rem;
 	struct ieee80211_conf *conf = NULL;
 	u16 beacon_int;
-	struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
+	struct ieee80211_vif *vif = ctx->vif;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -517,15 +517,13 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	ctx->timing.timestamp = cpu_to_le64(priv->timestamp);
 	ctx->timing.listen_interval = cpu_to_le16(conf->listen_interval);
 
-	beacon_int = vif->bss_conf.beacon_int;
+	beacon_int = vif ? vif->bss_conf.beacon_int : 0;
 
-	if (vif->type == NL80211_IFTYPE_ADHOC) {
-		/* TODO: we need to get atim_window from upper stack
-		 * for now we set to 0 */
-		ctx->timing.atim_window = 0;
-	} else {
-		ctx->timing.atim_window = 0;
-	}
+	/*
+	 * TODO: For IBSS we need to get atim_window from mac80211,
+	 *	 for now just always use 0
+	 */
+	ctx->timing.atim_window = 0;
 
 	beacon_int = iwl_adjust_beacon_interval(beacon_int,
 				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
@@ -536,7 +534,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rem = do_div(tsf, interval_tm);
 	ctx->timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
-	ctx->timing.dtim_period = vif->bss_conf.dtim_period;
+	ctx->timing.dtim_period = vif ? (vif->bss_conf.dtim_period ?: 1) : 1;
 
 	IWL_DEBUG_ASSOC(priv,
 			"beacon interval %d beacon timer %d beacon tim %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index ab465c5..4d79100 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -728,7 +728,7 @@ extern int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
-int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv,
 				      struct iwl_rxon_context *ctx)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e81c438..76a45b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3110,7 +3110,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv, ctx);
 
-	rc = iwl_send_rxon_timing(priv, vif);
+	rc = iwl_send_rxon_timing(priv, ctx);
 	if (rc)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
@@ -3285,7 +3285,7 @@ void iwl3945_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		iwlcore_commit_rxon(priv, ctx);
 
 		/* RXON Timing */
-		rc = iwl_send_rxon_timing(priv, vif);
+		rc = iwl_send_rxon_timing(priv, ctx);
 		if (rc)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
-- 
1.7.0.4

