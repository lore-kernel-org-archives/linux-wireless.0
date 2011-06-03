Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:19443 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1FCPWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 11:22:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlagn: direct call to post_scan function
Date: Fri,  3 Jun 2011 07:54:15 -0700
Message-Id: <1307112856-20231-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110603_172302_306141_E039129A)
In-Reply-To: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307112856-20231-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to use function "ops" for post_scan.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 ++-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index b12c72d..938230d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -332,5 +332,4 @@ struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.tx_cmd_protection = iwlagn_tx_cmd_protection,
 	.calc_rssi = iwlagn_calc_rssi,
 	.request_scan = iwlagn_request_scan,
-	.post_scan = iwlagn_post_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e430a4f..4ca0336 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -112,7 +112,6 @@ struct iwl_hcmd_utils_ops {
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
 	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
-	void (*post_scan)(struct iwl_priv *priv);
 };
 
 struct iwl_apm_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8c9af45..438eecd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -36,6 +36,7 @@
 #include "iwl-sta.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
+#include "iwl-agn.h"
 
 /* For active scan, listen ACTIVE_DWELL_TIME (msec) on each channel after
  * sending probe req.  This should be set long enough to hear probe responses
@@ -600,7 +601,7 @@ out_settings:
 	if (!iwl_is_ready_rf(priv))
 		goto out;
 
-	priv->cfg->ops->utils->post_scan(priv);
+	iwlagn_post_scan(priv);
 
 out:
 	mutex_unlock(&priv->mutex);
-- 
1.7.0.4

