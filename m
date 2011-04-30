Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab1D3Qks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/14] iwlagn: connect and disconnect sequence for RXON
Date: Sat, 30 Apr 2011 09:17:32 -0700
Message-Id: <1304180260-13875-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184115_617263_BA556890)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, separate the connect and disconnect sequences in
RXON commit function, easier to read and understand.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  194 +++++++++++++++------------
 1 files changed, 111 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7f52ab8..178b2b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -169,6 +169,103 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 	return ret;
 }
 
+static int iwlagn_rxon_disconn(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
+{
+	int ret;
+	struct iwl_rxon_cmd *active = (void *)&ctx->active;
+
+	if (ctx->ctxid == IWL_RXON_CTX_BSS)
+		ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
+	else
+		ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
+	if (ret)
+		return ret;
+
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
+	}
+
+	memcpy(active, &ctx->staging, sizeof(*active));
+	return 0;
+}
+
+static int iwlagn_rxon_connect(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx)
+{
+	int ret;
+	struct iwl_rxon_cmd *active = (void *)&ctx->active;
+
+	/* RXON timing must be before associated RXON */
+	ret = iwl_send_rxon_timing(priv, ctx);
+	if (ret) {
+		IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
+		return ret;
+	}
+	/* QoS info may be cleared by previous un-assoc RXON */
+	iwlagn_update_qos(priv, ctx);
+
+	/*
+	 * We'll run into this code path when beaconing is
+	 * enabled, but then we also need to send the beacon
+	 * to the device.
+	 */
+	if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_AP)) {
+		ret = iwlagn_update_beacon(priv, ctx->vif);
+		if (ret) {
+			IWL_ERR(priv,
+				"Error sending required beacon (%d)!\n",
+				ret);
+			return ret;
+		}
+	}
+
+	priv->start_calib = 0;
+	/*
+	 * Apply the new configuration.
+	 *
+	 * Associated RXON doesn't clear the station table in uCode,
+	 * so we don't need to restore stations etc. after this.
+	 */
+	ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
+		      sizeof(struct iwl_rxon_cmd), &ctx->staging);
+	if (ret) {
+		IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
+		return ret;
+	}
+	memcpy(active, &ctx->staging, sizeof(*active));
+
+	iwl_reprogram_ap_sta(priv, ctx);
+
+	/* IBSS beacon needs to be sent after setting assoc */
+	if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_ADHOC))
+		if (iwlagn_update_beacon(priv, ctx->vif))
+			IWL_ERR(priv, "Error sending IBSS beacon\n");
+	iwl_init_sensitivity(priv);
+
+	/*
+	 * If we issue a new RXON command which required a tune then
+	 * we must send a new TXPOWER command or we won't be able to
+	 * Tx any frames.
+	 *
+	 * It's expected we set power here if channel is changing.
+	 */
+	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
+	if (ret) {
+		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
 /**
  * iwlagn_commit_rxon - commit staging_rxon to hardware
  *
@@ -176,6 +273,16 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
  * the active_rxon structure is updated with the new data.  This
  * function correctly transitions out of the RXON_ASSOC_MSK state if
  * a HW tune is required based on the RXON structure changes.
+ *
+ * The connect/disconnect flow should be as the following:
+ *
+ * 1. make sure send RXON command with association bit unset if not connect
+ *	this should include the channel and the band for the candidate
+ *	to be connected to
+ * 2. Add Station before RXON association with the AP
+ * 3. RXON_timing has to send before RXON for connection
+ * 4. full RXON command - associated bit set
+ * 5. use RXON_ASSOC command to update any flags changes
  */
 int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
@@ -225,6 +332,7 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	else
 		ctx->staging.flags &= ~RXON_FLG_SHORT_SLOT_MSK;
 
+	iwl_print_rx_config_cmd(priv, ctx);
 	ret = iwl_check_rxon_cmd(priv, ctx);
 	if (ret) {
 		IWL_ERR(priv, "Invalid RXON configuration. Not committing.\n");
@@ -255,7 +363,6 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 
 		memcpy(active, &ctx->staging, sizeof(*active));
-		iwl_print_rx_config_cmd(priv, ctx);
 		return 0;
 	}
 
@@ -283,92 +390,13 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * set up filters in the device.
 	 */
 	if ((old_assoc && new_assoc) || !new_assoc) {
-		if (ctx->ctxid == IWL_RXON_CTX_BSS)
-			ret = iwlagn_disable_bss(priv, ctx, &ctx->staging);
-		else
-			ret = iwlagn_disable_pan(priv, ctx, &ctx->staging);
+		ret = iwlagn_rxon_disconn(priv, ctx);
 		if (ret)
 			return ret;
-
-		memcpy(active, &ctx->staging, sizeof(*active));
-
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
 	}
 
-	/* RXON timing must be before associated RXON */
-	ret = iwl_send_rxon_timing(priv, ctx);
-	if (ret) {
-		IWL_ERR(priv, "Failed to send timing (%d)!\n", ret);
-		return ret;
-	}
-
-	if (new_assoc) {
-		/* QoS info may be cleared by previous un-assoc RXON */
-		iwlagn_update_qos(priv, ctx);
-
-		/*
-		 * We'll run into this code path when beaconing is
-		 * enabled, but then we also need to send the beacon
-		 * to the device.
-		 */
-		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_AP)) {
-			ret = iwlagn_update_beacon(priv, ctx->vif);
-			if (ret) {
-				IWL_ERR(priv,
-					"Error sending required beacon (%d)!\n",
-					ret);
-				return ret;
-			}
-		}
-
-		priv->start_calib = 0;
-		/*
-		 * Apply the new configuration.
-		 *
-		 * Associated RXON doesn't clear the station table in uCode,
-		 * so we don't need to restore stations etc. after this.
-		 */
-		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
-			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
-		if (ret) {
-			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
-			return ret;
-		}
-		memcpy(active, &ctx->staging, sizeof(*active));
-
-		iwl_reprogram_ap_sta(priv, ctx);
-
-		/* IBSS beacon needs to be sent after setting assoc */
-		if (ctx->vif && (ctx->vif->type == NL80211_IFTYPE_ADHOC))
-			if (iwlagn_update_beacon(priv, ctx->vif))
-				IWL_ERR(priv, "Error sending IBSS beacon\n");
-	}
-
-	iwl_print_rx_config_cmd(priv, ctx);
-
-	iwl_init_sensitivity(priv);
-
-	/*
-	 * If we issue a new RXON command which required a tune then we must
-	 * send a new TXPOWER command or we won't be able to Tx any frames.
-	 *
-	 * It's expected we set power here if channel is changing.
-	 */
-	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
-	if (ret) {
-		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
-		return ret;
-	}
+	if (new_assoc)
+		return iwlagn_rxon_connect(priv, ctx);
 
 	return 0;
 }
-- 
1.7.0.4

