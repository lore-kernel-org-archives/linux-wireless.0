Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59924 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0JGXIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/22] iwlwifi: introduce post_scan hook
Date: Thu,  7 Oct 2010 16:07:41 -0700
Message-Id: <1286492881-15743-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The different drivers need to do different things
after a scan, so create a post_scan hook to allow
them to do this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   11 +----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   12 ++++++++++++
 9 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index cfdff54..87943a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2713,6 +2713,7 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
 	.tx_cmd_protection = iwlcore_tx_cmd_protection,
 	.request_scan = iwl3945_request_scan,
+	.post_scan = iwl3945_post_scan,
 };
 
 static const struct iwl_ops iwl3945_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 98509c5..7ad4aff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -296,6 +296,7 @@ extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
 /* scanning */
 int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+void iwl3945_post_scan(struct iwl_priv *priv);
 
 /* Requires full declaration of iwl_priv before including */
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 09db940..e161f5d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2221,6 +2221,18 @@ static struct iwl_hcmd_ops iwl4965_hcmd = {
 	.send_bt_config = iwl_send_bt_config,
 };
 
+static void iwl4965_post_scan(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	/*
+	 * Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed
+	 */
+	if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+		iwlcore_commit_rxon(priv, ctx);
+}
+
 static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.get_hcmd_size = iwl4965_get_hcmd_size,
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
@@ -2229,6 +2241,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.tx_cmd_protection = iwlcore_tx_cmd_protection,
 	.calc_rssi = iwl4965_calc_rssi,
 	.request_scan = iwlagn_request_scan,
+	.post_scan = iwl4965_post_scan,
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 901452e..634177d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -384,4 +384,5 @@ struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.tx_cmd_protection = iwlagn_tx_cmd_protection,
 	.calc_rssi = iwlagn_calc_rssi,
 	.request_scan = iwlagn_request_scan,
+	.post_scan = iwlagn_post_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f5445d5..3fa2c5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1565,6 +1565,22 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	return ret;
 }
 
+void iwlagn_post_scan(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+
+	/*
+	 * Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed
+	 */
+	for_each_context(priv, ctx)
+		if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+			iwlagn_commit_rxon(priv, ctx);
+
+	if (priv->cfg->ops->hcmd->set_pan_params)
+		priv->cfg->ops->hcmd->set_pan_params(priv);
+}
+
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 2a1c83b..960fe2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -227,6 +227,7 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 
 /* scan */
 int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+void iwlagn_post_scan(struct iwl_priv *priv);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d6d5bb0..09908f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -112,6 +112,7 @@ struct iwl_hcmd_utils_ops {
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
 	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
+	void (*post_scan)(struct iwl_priv *priv);
 };
 
 struct iwl_apm_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index eaae49e..a7e8c7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -559,7 +559,6 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool aborted;
-	struct iwl_rxon_context *ctx;
 
 	IWL_DEBUG_SCAN(priv, "Completed %sscan.\n",
 		       priv->is_internal_short_scan ? "internal short " : "");
@@ -609,15 +608,7 @@ out_settings:
 	 * performing the scan, fire one off */
 	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 
-	/*
-	 * Since setting the RXON may have been deferred while
-	 * performing the scan, fire one off if needed
-	 */
-	for_each_context(priv, ctx)
-		iwlcore_commit_rxon(priv, ctx);
-
-	if (priv->cfg->ops->hcmd->set_pan_params)
-		priv->cfg->ops->hcmd->set_pan_params(priv);
+	priv->cfg->ops->utils->post_scan(priv);
 
  out:
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43db5f3..db148d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2983,6 +2983,18 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	return ret;
 }
 
+void iwl3945_post_scan(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+
+	/*
+	 * Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed
+	 */
+	if (memcmp(&ctx->staging, &ctx->active, sizeof(ctx->staging)))
+		iwlcore_commit_rxon(priv, ctx);
+}
+
 static void iwl3945_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
-- 
1.7.0.4

