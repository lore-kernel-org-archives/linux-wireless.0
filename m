Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab0KPQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:44 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/18] iwlagn: update QoS before commit associated RXON
Date: Tue, 16 Nov 2010 08:01:48 -0800
Message-Id: <1289923311-14920-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

RXON command without association bit can clear the QoS info in the
uCode. Therefore, before sending the associated RXON, we need to
send the QoS command just in case.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   59 ++++++++++++++-------------
 1 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 9db3924..203ee60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -72,6 +72,34 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	return ret;
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
 static int iwlagn_update_beacon(struct iwl_priv *priv,
 				struct ieee80211_vif *vif)
 {
@@ -208,6 +236,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	}
 
 	if (new_assoc) {
+		/* QoS info may be cleared by previous un-assoc RXON */
+		iwlagn_update_qos(priv, ctx);
+
 		/*
 		 * We'll run into this code path when beaconing is
 		 * enabled, but then we also need to send the beacon
@@ -266,34 +297,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	return 0;
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
 int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct iwl_priv *priv = hw->priv;
-- 
1.7.0.4

