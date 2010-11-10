Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0KJSBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/16] iwlwifi: resending QoS command when HT changes
Date: Wed, 10 Nov 2010 09:56:43 -0800
Message-Id: <1289411810-23093-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"mac80211: Fix WMM driver queue configuration"
inadvertedly broke iwlwifi, because now mac80211
configures the QoS settings before assoc, and
therefore before HT. Thus, iwlwifi no longer told
the device about the HT setting, which it needs
to -- and thus throughput went down a lot. Fix
this by resending the QoS command to the device
not only when QoS/WMM settings change, but also
when HT changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   65 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-legacy.c   |   60 ++++++++++++++-----------
 2 files changed, 69 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index f0ddfb1..0228877 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -269,6 +269,34 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	return 0;
 }
 
+static void iwlagn_update_qos(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx)
+{
+	int ret;
+
+	if (!ctx->is_active)
+		return;
+
+	ctx->qos_data.def_qos_parm.qos_flags = 0;
+
+	if (ctx->qos_data.qos_active)
+		ctx->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
+
+	if (ctx->ht.enabled)
+		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+
+	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+		      ctx->qos_data.qos_active,
+		      ctx->qos_data.def_qos_parm.qos_flags);
+
+	ret = iwl_send_cmd_pdu(priv, ctx->qos_cmd,
+			       sizeof(struct iwl_qosparam_cmd),
+			       &ctx->qos_data.def_qos_parm);
+	if (ret)
+		IWL_ERR(priv, "Failed to update QoS\n");
+}
+
 int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -277,6 +305,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_channel *channel = conf->channel;
 	const struct iwl_channel_info *ch_info;
 	int ret = 0;
+	bool ht_changed[NUM_IWL_RXON_CTX] = {};
 
 	IWL_DEBUG_MAC80211(priv, "changed %#x", changed);
 
@@ -324,7 +353,11 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
-			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled != conf_is_ht(conf)) {
+				ctx->ht.enabled = conf_is_ht(conf);
+				ht_changed[ctx->ctxid] = true;
+			}
+
 			if (ctx->ht.enabled) {
 				if (conf_is_ht40_minus(conf)) {
 					ctx->ht.extension_chan_offset =
@@ -392,40 +425,14 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if (!memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
 			continue;
 		iwlagn_commit_rxon(priv, ctx);
+		if (ht_changed[ctx->ctxid])
+			iwlagn_update_qos(priv, ctx);
 	}
  out:
 	mutex_unlock(&priv->mutex);
 	return ret;
 }
 
-static void iwlagn_update_qos(struct iwl_priv *priv,
-			      struct iwl_rxon_context *ctx)
-{
-	int ret;
-
-	if (!ctx->is_active)
-		return;
-
-	ctx->qos_data.def_qos_parm.qos_flags = 0;
-
-	if (ctx->qos_data.qos_active)
-		ctx->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
-
-	if (ctx->ht.enabled)
-		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-
-	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-		      ctx->qos_data.qos_active,
-		      ctx->qos_data.def_qos_parm.qos_flags);
-
-	ret = iwl_send_cmd_pdu(priv, ctx->qos_cmd,
-			       sizeof(struct iwl_qosparam_cmd),
-			       &ctx->qos_data.def_qos_parm);
-	if (ret)
-		IWL_ERR(priv, "Failed to update QoS\n");
-}
-
 static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 				       struct iwl_rxon_context *ctx,
 				       struct ieee80211_bss_conf *bss_conf)
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
index 10d9c42..a08b4e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -34,6 +34,32 @@
 #include "iwl-helpers.h"
 #include "iwl-legacy.h"
 
+static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (!ctx->is_active)
+		return;
+
+	ctx->qos_data.def_qos_parm.qos_flags = 0;
+
+	if (ctx->qos_data.qos_active)
+		ctx->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
+
+	if (ctx->ht.enabled)
+		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+
+	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+		      ctx->qos_data.qos_active,
+		      ctx->qos_data.def_qos_parm.qos_flags);
+
+	iwl_send_cmd_pdu_async(priv, ctx->qos_cmd,
+			       sizeof(struct iwl_qosparam_cmd),
+			       &ctx->qos_data.def_qos_parm, NULL);
+}
+
 /**
  * iwl_legacy_mac_config - mac80211 config callback
  */
@@ -49,6 +75,7 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 	int ret = 0;
 	u16 ch;
 	int scan_active = 0;
+	bool ht_changed[NUM_IWL_RXON_CTX] = {};
 
 	if (WARN_ON(!priv->cfg->ops->legacy))
 		return -EOPNOTSUPP;
@@ -100,7 +127,10 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
-			ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled != conf_is_ht(conf)) {
+				ctx->ht.enabled = conf_is_ht(conf);
+				ht_changed[ctx->ctxid] = true;
+			}
 			if (ctx->ht.enabled) {
 				if (conf_is_ht40_minus(conf)) {
 					ctx->ht.extension_chan_offset =
@@ -177,6 +207,8 @@ int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed)
 		else
 			IWL_DEBUG_INFO(priv,
 				"Not re-sending same RXON configuration.\n");
+		if (ht_changed[ctx->ctxid])
+			iwl_update_qos(priv, ctx);
 	}
 
 out:
@@ -295,32 +327,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	IWL_DEBUG_ASSOC(priv, "leave\n");
 }
 
-static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (!ctx->is_active)
-		return;
-
-	ctx->qos_data.def_qos_parm.qos_flags = 0;
-
-	if (ctx->qos_data.qos_active)
-		ctx->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
-
-	if (ctx->ht.enabled)
-		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-
-	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-		      ctx->qos_data.qos_active,
-		      ctx->qos_data.def_qos_parm.qos_flags);
-
-	iwl_send_cmd_pdu_async(priv, ctx->qos_cmd,
-			       sizeof(struct iwl_qosparam_cmd),
-			       &ctx->qos_data.def_qos_parm, NULL);
-}
-
 static inline void iwl_set_no_assoc(struct iwl_priv *priv,
 				    struct ieee80211_vif *vif)
 {
-- 
1.7.0.4

