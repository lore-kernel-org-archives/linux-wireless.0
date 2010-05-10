Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab0EJW2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/47] iwlwifi: use .cfg to enable/disable continuous ucode trace
Date: Mon, 10 May 2010 15:27:38 -0700
Message-Id: <1273530498-11876-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of checking device type for enable/disable continuous ucode
trace function; put it in .cfg for better control and more
flexibilities.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 ++-
 6 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index fb59af2..f9f8a56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -260,6 +260,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 128,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -289,6 +290,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 128,
+	.ucode_tracing = true,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 460aea3..a756fd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2263,7 +2263,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
-
+	.ucode_tracing = true,
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 115d3ea..c32db49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -466,6 +466,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -494,6 +495,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -520,6 +522,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -548,6 +551,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -576,6 +580,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -604,6 +609,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -630,6 +636,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f057087..7cd45fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -442,6 +442,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.ucode_tracing = true,
 };
 
 /*
@@ -479,6 +480,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -511,6 +513,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -543,6 +546,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -577,6 +581,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.chain_noise_scale = 1500,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -609,6 +614,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.chain_noise_scale = 1500,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -643,6 +649,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 60d26e4..5034dc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -320,6 +320,7 @@ struct iwl_cfg {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool tx_power_by_driver;
+	const bool ucode_tracing;
 	u8 scan_antennas[IEEE80211_NUM_BANDS];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0faadf3..59355fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1640,8 +1640,9 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	}
+	if (priv->cfg->ucode_tracing)
+		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf, &priv->disable_sens_cal);
-- 
1.6.3.3

