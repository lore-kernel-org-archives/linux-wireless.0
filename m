Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935436Ab1KJPtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 12/27] iwlagn: use per-vif AC parameters
Date: Thu, 10 Nov 2011 06:55:12 -0800
Message-Id: <1320936927-9078-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165035_102451_567F25EF)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Eliad added the ability to configure AC parameters
per virtual interface; make use of this in iwlwifi
and set the parameters in the right context. Since
storage and uploading to the device is already per
context, this is sufficient.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 001fdf1..989f9f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1125,10 +1125,14 @@ int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 		    const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
-	struct iwl_rxon_context *ctx;
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	unsigned long flags;
 	int q;
 
+	if (WARN_ON(!ctx))
+		return -EINVAL;
+
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	if (!iwl_is_ready_rf(priv->shrd)) {
@@ -1145,21 +1149,15 @@ int iwlagn_mac_conf_tx(struct ieee80211_hw *hw,
 
 	spin_lock_irqsave(&priv->shrd->lock, flags);
 
-	/*
-	 * MULTI-FIXME
-	 * This may need to be done per interface in nl80211/cfg80211/mac80211.
-	 */
-	for_each_context(priv, ctx) {
-		ctx->qos_data.def_qos_parm.ac[q].cw_min =
-			cpu_to_le16(params->cw_min);
-		ctx->qos_data.def_qos_parm.ac[q].cw_max =
-			cpu_to_le16(params->cw_max);
-		ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-		ctx->qos_data.def_qos_parm.ac[q].edca_txop =
-				cpu_to_le16((params->txop * 32));
-
-		ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
-	}
+	ctx->qos_data.def_qos_parm.ac[q].cw_min =
+		cpu_to_le16(params->cw_min);
+	ctx->qos_data.def_qos_parm.ac[q].cw_max =
+		cpu_to_le16(params->cw_max);
+	ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+	ctx->qos_data.def_qos_parm.ac[q].edca_txop =
+			cpu_to_le16((params->txop * 32));
+
+	ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 
-- 
1.7.0.4

