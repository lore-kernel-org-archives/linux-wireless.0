Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab0EJW2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/47] iwlwifi: use cfg to configure calibration operation
Date: Mon, 10 May 2010 15:27:39 -0700
Message-Id: <1273530498-11876-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

sensitivity calibration and chain noise calibration are not available
for all the devices; use .cfg to configure the availability of those
calibration functions

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   14 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   14 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   13 ++++++++-----
 6 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index f9f8a56..4d360d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -261,6 +261,8 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -291,6 +293,8 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a756fd4..6b0ae74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2264,6 +2264,8 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c32db49..8ed616e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -467,6 +467,8 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -496,6 +498,8 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -523,6 +527,8 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -552,6 +558,8 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -581,6 +589,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -610,6 +620,8 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -637,6 +649,8 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7cd45fe..b69fa36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -443,6 +443,8 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 /*
@@ -481,6 +483,8 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -514,6 +518,8 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -547,6 +553,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -582,6 +590,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -615,6 +625,8 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -650,6 +662,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
+	.sensitivity_calib_by_driver = true,
+	.chain_noise_calib_by_driver = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5034dc0..88c6412 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -321,6 +321,8 @@ struct iwl_cfg {
 	u32 max_event_log_size;
 	const bool tx_power_by_driver;
 	const bool ucode_tracing;
+	const bool sensitivity_calib_by_driver;
+	const bool chain_noise_calib_by_driver;
 	u8 scan_antennas[IEEE80211_NUM_BANDS];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 59355fa..df34c31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1637,17 +1637,20 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
 
-	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
+	if (priv->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
+	if (priv->cfg->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	}
 	if (priv->cfg->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf, &priv->disable_sens_cal);
-	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
-			 &priv->disable_chain_noise_cal);
+	if (priv->cfg->sensitivity_calib_by_driver)
+		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
+				 &priv->disable_sens_cal);
+	if (priv->cfg->chain_noise_calib_by_driver)
+		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
+				 &priv->disable_chain_noise_cal);
 	if (priv->cfg->tx_power_by_driver)
 		DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf,
 				&priv->disable_tx_power_cal);
-- 
1.6.3.3

