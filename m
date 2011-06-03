Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19443 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1FCPWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: move all post scan functions in one place
Date: Fri,  3 Jun 2011 07:54:14 -0700
Message-Id: <1307112856-20231-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172301_692903_3665555B)
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both tx power and power save are being done after scan complete, move into
post_scan function

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 5f562d9..18e6900 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -800,6 +800,13 @@ void iwlagn_post_scan(struct iwl_priv *priv)
 	struct iwl_rxon_context *ctx;
 
 	/*
+	 * We do not commit power settings while scan is pending,
+	 * do it now if the settings changed.
+	 */
+	iwl_power_set_mode(priv, &priv->power_data.sleep_cmd_next, false);
+	iwl_set_tx_power(priv, priv->tx_power_next, false);
+
+	/*
 	 * Since setting the RXON may have been deferred while
 	 * performing the scan, fire one off if needed
 	 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index d60d630..8c9af45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -600,13 +600,6 @@ out_settings:
 	if (!iwl_is_ready_rf(priv))
 		goto out;
 
-	/*
-	 * We do not commit power settings while scan is pending,
-	 * do it now if the settings changed.
-	 */
-	iwl_power_set_mode(priv, &priv->power_data.sleep_cmd_next, false);
-	iwl_set_tx_power(priv, priv->tx_power_next, false);
-
 	priv->cfg->ops->utils->post_scan(priv);
 
 out:
-- 
1.7.0.4

