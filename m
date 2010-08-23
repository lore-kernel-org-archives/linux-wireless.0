Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0HWOxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/26] iwlwifi: Relax uCode timeout/error checking for 6000g2b
Date: Mon, 23 Aug 2010 07:57:02 -0700
Message-Id: <1282575437-23270-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable plcp error checking for 6000g2b devices, with wifi/bt coex;
this got trigger too often, disable for now until finding better
trigger point.

Also extend the firmware reload timer much longer for BT coex to make sure
there are will be no mistake to reload firmware too fast and too often.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 +++++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 22676d9..9d43098 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -796,7 +796,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
@@ -835,7 +835,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
@@ -876,7 +876,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
@@ -915,7 +915,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
@@ -956,7 +956,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
@@ -995,7 +995,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1921307..72eda7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2646,10 +2646,14 @@ static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
 						"queue %d, not read %d time\n",
 						q->id,
 						q->repeat_same_read_ptr);
-				mod_timer(&priv->monitor_recover, jiffies +
-					msecs_to_jiffies(IWL_ONE_HUNDRED_MSECS));
+				if (!priv->cfg->advanced_bt_coexist) {
+					mod_timer(&priv->monitor_recover,
+						jiffies + msecs_to_jiffies(
+						IWL_ONE_HUNDRED_MSECS));
+					return 1;
+				}
 			}
-			return 1;
+			return 0;
 		} else {
 			q->last_read_ptr = q->read_ptr;
 			q->repeat_same_read_ptr = 0;
-- 
1.7.0.4

