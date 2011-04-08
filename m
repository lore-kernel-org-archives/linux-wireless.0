Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab1DHPuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/16] iwlagn: sensitivity and chain noise done by driver
Date: Fri,  8 Apr 2011 08:30:34 -0700
Message-Id: <1302276636-12802-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_agn driver should perform both sensitivity and chain noise calib.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    6 ------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    6 ------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   16 ++++++----------
 6 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5a72810..d1d7852 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -245,8 +245,6 @@ static struct iwl_base_params iwl1000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 };
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 9daf888..805b039 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -354,8 +354,6 @@ static struct iwl_base_params iwl2000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
 
@@ -376,8 +374,6 @@ static struct iwl_base_params iwl2030_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8106423..357137f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -471,8 +471,6 @@ static struct iwl_base_params iwl5000_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 };
 static struct iwl_ht_params iwl5000_ht_params = {
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7f0715e..8847b21 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -443,8 +443,6 @@ static struct iwl_base_params iwl6000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
 
@@ -464,8 +462,6 @@ static struct iwl_base_params iwl6050_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
 static struct iwl_base_params iwl6000_g2_base_params = {
@@ -484,8 +480,6 @@ static struct iwl_base_params iwl6000_g2_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 	.shadow_reg_enable = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 98dc544..57763c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -251,10 +251,6 @@ struct iwl_mod_params {
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @ucode_tracing: support ucode continuous tracing
- * @sensitivity_calib_by_driver: driver has the capability to perform
- *	sensitivity calibration operation
- * @chain_noise_calib_by_driver: driver has the capability to perform
- *	chain noise calibration operation
  * @shadow_reg_enable: HW shadhow register bit
  */
 struct iwl_base_params {
@@ -277,8 +273,6 @@ struct iwl_base_params {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool ucode_tracing;
-	const bool sensitivity_calib_by_driver;
-	const bool chain_noise_calib_by_driver;
 	const bool shadow_reg_enable;
 };
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 9b1f962..c02f069 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1747,10 +1747,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
 
-	if (priv->cfg->base_params->sensitivity_calib_by_driver)
-		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-	if (priv->cfg->base_params->chain_noise_calib_by_driver)
-		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
 	if (iwl_bt_statistics(priv))
@@ -1761,12 +1759,10 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
-	if (priv->cfg->base_params->sensitivity_calib_by_driver)
-		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
-				 &priv->disable_sens_cal);
-	if (priv->cfg->base_params->chain_noise_calib_by_driver)
-		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
-				 &priv->disable_chain_noise_cal);
+	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
+			 &priv->disable_sens_cal);
+	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
+			 &priv->disable_chain_noise_cal);
 	return 0;
 
 err:
-- 
1.7.0.4

