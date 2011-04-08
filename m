Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab1DHPuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:15 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/16] iwlagn: tx power calib always done in firmware
Date: Fri,  8 Apr 2011 08:30:33 -0700
Message-Id: <1302276636-12802-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the config flag for tx power calib

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h    |    3 ---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 ---
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 -
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index cccf747..bc5dfe2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -495,8 +495,10 @@ void iwlagn_rx_handler_setup(struct iwl_priv *priv)
 
 void iwlagn_setup_deferred_work(struct iwl_priv *priv)
 {
-	/* in agn, the tx power calibration is done in uCode */
-	priv->disable_tx_power_cal = 1;
+	/*
+	 * nothing need to be done here anymore
+	 * still keep for future use if needed
+	 */
 }
 
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a0530d0..98dc544 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -250,8 +250,6 @@ struct iwl_mod_params {
  * @wd_timeout: TX queues watchdog timeout
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
- * @tx_power_by_driver: tx power calibration performed by driver
- *	instead of uCode
  * @ucode_tracing: support ucode continuous tracing
  * @sensitivity_calib_by_driver: driver has the capability to perform
  *	sensitivity calibration operation
@@ -278,7 +276,6 @@ struct iwl_base_params {
 	unsigned int wd_timeout;
 	bool temperature_kelvin;
 	u32 max_event_log_size;
-	const bool tx_power_by_driver;
 	const bool ucode_tracing;
 	const bool sensitivity_calib_by_driver;
 	const bool chain_noise_calib_by_driver;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 2c58980..9b1f962 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1767,9 +1767,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	if (priv->cfg->base_params->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 				 &priv->disable_chain_noise_cal);
-	if (priv->cfg->base_params->tx_power_by_driver)
-		DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf,
-				&priv->disable_tx_power_cal);
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 14f7d8f..7fe68f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1489,7 +1489,6 @@ struct iwl_priv {
 	struct work_struct txpower_work;
 	u32 disable_sens_cal;
 	u32 disable_chain_noise_cal;
-	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
-- 
1.7.0.4

