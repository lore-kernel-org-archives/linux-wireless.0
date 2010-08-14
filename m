Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0HNPlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 11:41:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlwifi: use long monitor timer to avoid un-necessary reload
Date: Sat, 14 Aug 2010 08:45:51 -0700
Message-Id: <1281800751-20784-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1281800751-20784-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 5000 and 6000g2b series of devices, use long monitor timer to check
stuck tx queues.

.6000g2b series device, it is WiFi/BT combo device, there are some cases,
tx queues are not move for a period of time because the WiFi/BT coex.

.5000 series device, it is being reported firmware got reload more
often than necessary, so extend the timer to avoid un-necessary reload.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-6000.c |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cd9f9fc..0cbefa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -510,7 +510,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -541,7 +541,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -570,7 +570,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -601,7 +601,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -632,7 +632,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b6468e9..cee06b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -496,7 +496,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -532,7 +532,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -570,7 +570,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -606,7 +606,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -644,7 +644,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
@@ -680,7 +680,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
-- 
1.7.0.4

