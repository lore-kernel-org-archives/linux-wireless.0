Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab0H0Q4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/27] iwlwifi: contextify command sending
Date: Fri, 27 Aug 2010 09:59:34 -0700
Message-Id: <1282928395-32762-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some commands will have different command IDs
for different contexts, so we need to store
those IDs in the context structure and use
them instead of hardcoding the commands.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 3e50699..2d4cdb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -77,7 +77,7 @@ int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 		 ctx->staging.ofdm_ht_triple_stream_basic_rates;
 	rxon_assoc.acquisition_data = ctx->staging.acquisition_data;
 
-	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
+	ret = iwl_send_cmd_pdu_async(priv, ctx->rxon_assoc_cmd,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 23db6c3..d3714f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -152,7 +152,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		IWL_DEBUG_INFO(priv, "Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
-		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
 				       sizeof(struct iwl_rxon_cmd),
 				       active_rxon);
 
@@ -187,7 +187,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * stations is needed after it (the RXON command) completes
 	 */
 	if (!new_assoc) {
-		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
 			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 		if (ret) {
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -209,7 +209,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
-		ret = iwl_send_cmd_pdu(priv, REPLY_RXON,
+		ret = iwl_send_cmd_pdu(priv, ctx->rxon_cmd,
 			      sizeof(struct iwl_rxon_cmd), &ctx->staging);
 		if (ret) {
 			IWL_ERR(priv, "Error setting new RXON (%d)\n", ret);
@@ -3244,7 +3244,7 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	ret = iwl_send_rxon_timing(priv, vif);
 	if (ret)
-		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
+		IWL_WARN(priv, "RXON timing - "
 			    "Attempting to continue.\n");
 
 	ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
@@ -3481,7 +3481,7 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		/* RXON Timing */
 		ret = iwl_send_rxon_timing(priv, vif);
 		if (ret)
-			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
+			IWL_WARN(priv, "RXON timing failed - "
 					"Attempting to continue.\n");
 
 		/* AP has all antennas */
@@ -4200,6 +4200,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
 		priv->contexts[i].ctxid = i;
 
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 1);
+
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f7bfe59..a145d17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -545,7 +545,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			le32_to_cpu(ctx->timing.beacon_init_val),
 			le16_to_cpu(ctx->timing.atim_window));
 
-	return iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+	return iwl_send_cmd_pdu(priv, ctx->rxon_timing_cmd,
 				sizeof(ctx->timing), &ctx->timing);
 }
 EXPORT_SYMBOL(iwl_send_rxon_timing);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index da54bd5..6a7e9ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1126,6 +1126,8 @@ struct iwl_rxon_context {
 	struct iwl_rxon_time_cmd timing;
 
 	u8 bcast_sta_id;
+
+	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
 };
 
 struct iwl_priv {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 630b8d6..4321d97 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4013,6 +4013,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	for (i = 0; i < NUM_IWL_RXON_CTX; i++)
 		priv->contexts[i].ctxid = i;
 
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
+	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
+
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan.
-- 
1.7.0.4

