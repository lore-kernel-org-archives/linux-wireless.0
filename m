Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab0EJW2Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/47] iwlwifi: remove device type checking for tx power in debugfs
Date: Mon, 10 May 2010 15:27:37 -0700
Message-Id: <1273530498-11876-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of checking device type for enable/disable tx power control,
move it to .cfg for better control and more flexibilities.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 +--
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3faa78c..3607813 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1714,6 +1714,11 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 	int ref_temp;
 	int temperature = priv->temperature;
 
+	if (priv->disable_tx_power_cal ||
+	    test_bit(STATUS_SCANNING, &priv->status)) {
+		/* do not perform tx power calibration */
+		return 0;
+	}
 	/* set up new Tx power info for each and every channel, 2.4 and 5.x */
 	for (i = 0; i < priv->channel_count; i++) {
 		ch_info = &priv->channel_info[i];
@@ -2842,6 +2847,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.tx_power_by_driver = true,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2862,6 +2868,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.tx_power_by_driver = true,
 };
 
 DEFINE_PCI_DEVICE_TABLE(iwl3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 136c290..460aea3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2262,6 +2262,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
+	.tx_power_by_driver = true,
 
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7deed86..60d26e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -319,6 +319,7 @@ struct iwl_cfg {
 	u32 monitor_recover_period;
 	bool temperature_kelvin;
 	u32 max_event_log_size;
+	const bool tx_power_by_driver;
 	u8 scan_antennas[IEEE80211_NUM_BANDS];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b071e1b..0faadf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1647,8 +1647,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 			 &priv->disable_chain_noise_cal);
-	if (((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965) ||
-	    ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_3945))
+	if (priv->cfg->tx_power_by_driver)
 		DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf,
 				&priv->disable_tx_power_cal);
 	return 0;
-- 
1.6.3.3

