Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1E0QH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:07:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: fix dual-mode RXON
Date: Fri, 27 May 2011 08:40:26 -0700
Message-Id: <1306510833-32049-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180814_607087_860AEF59)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

 The PAN context has three states: disabled, disassociated
 and associated. It seems that wasn't quite as much of an
 issue in previous versions of the microcode, but now we
 really have to use all the three states properly. So add
 code to switch accordingly.

Additionally, PAN parameters need to be sent differently
and the timing for PAN RXON needs to be inbetween.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   52 ++++++++++++++++++++------
 1 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 58c095c..afb2f20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -81,6 +81,21 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	return ret;
 }
 
+static int iwlagn_disconn_pan(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx,
+			      struct iwl_rxon_cmd *send)
+{
+	__le32 old_filter = send->filter_flags;
+	int ret;
+
+	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd, sizeof(*send), send);
+
+	send->filter_flags = old_filter;
+
+	return ret;
+}
+
 static void iwlagn_update_qos(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx)
 {
@@ -175,10 +190,21 @@ static int iwlagn_rxon_disconn(struct iwl_priv *priv,
 	int ret;
 	struct iwl_rxon_cmd *active = (void *)&ctx->active;
 
-	if (ctx->ctxid == IWL_RXON_CTX_BSS)
+	if (ctx->ctxid == IWL_RXON_CTX_BSS) {
 		ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
-	else
+	} else {
 		ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
+		if (ret)
+			return ret;
+		if (ctx->vif) {
+			ret = iwl_send_rxon_timing(priv, ctx);
+			if (ret) {
+				IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
+				return ret;
+			}
+			ret = iwlagn_disconn_pan(priv, ctx, &ctx->staging);
+		}
+	}
 	if (ret)
 		return ret;
 
@@ -205,10 +231,12 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 	struct iwl_rxon_cmd *active = (void *)&ctx->active;
 
 	/* RXON timing must be before associated RXON */
-	ret = iwl_send_rxon_timing(priv, ctx);
-	if (ret) {
-		IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
-		return ret;
+	if (ctx->ctxid == IWL_RXON_CTX_BSS) {
+		ret = iwl_send_rxon_timing(priv, ctx);
+		if (ret) {
+			IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
+			return ret;
+		}
 	}
 	/* QoS info may be cleared by previous un-assoc RXON */
 	iwlagn_update_qos(priv, ctx);
@@ -370,12 +398,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		return 0;
 	}
 
-	if (priv->cfg->ops->hcmd->set_pan_params) {
-		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
-		if (ret)
-			return ret;
-	}
-
 	iwl_set_rxon_hwcrypto(priv, ctx, !iwlagn_mod_params.sw_crypto);
 
 	IWL_DEBUG_INFO(priv,
@@ -397,6 +419,12 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (ret)
 		return ret;
 
+	if (priv->cfg->ops->hcmd->set_pan_params) {
+		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
+		if (ret)
+			return ret;
+	}
+
 	if (new_assoc)
 		return iwlagn_rxon_connect(priv, ctx);
 
-- 
1.7.0.4

