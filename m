Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0I2A4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlwifi: add iwl_nic_ops structure to iwl_ops
Date: Tue, 28 Sep 2010 17:56:55 -0700
Message-Id: <1285721818-10281-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

iwlwifi driver supports multiple devices. Since some device needs
special configuration we create a new iwl_nic_ops structure which is
configurable per device. Currently there is only one function pointer
inside this structure: additional_nic_config().

The iwl_nic_ops structure is added to the top level in struct iwl_ops,
making it easier to change per device. Duplication of the iwl_lib_ops
structure is no longer needed.

With this new ops the previous function pointer set_calib_version is
no longer needed since it is just a per device nic configuration.

As part of the code restructuring, a bug is addressed. Indication of
calib version to uCode is only needed for 6050 devices, however,
current implementation set calib version for all 6000 devices for
which DC calib is needed. To fix this, create iwl6050_ops for 6050
devices and only populate iwl_nic_ops in this structure.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   35 ++++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-core.h |    7 +++++-
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9f43f27..8256034 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -83,11 +83,10 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
-/* Indicate calibration version to uCode. */
-static void iwl6000_set_calib_version(struct iwl_priv *priv)
+static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
-	if (priv->cfg->need_dc_calib &&
-	    (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6))
+	/* Indicate calibration version to uCode. */
+	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
@@ -117,9 +116,11 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		iwl_write32(priv, CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
-	/* else do nothing, uCode configured */
-	if (priv->cfg->ops->lib->temp_ops.set_calib_version)
-		priv->cfg->ops->lib->temp_ops.set_calib_version(priv);
+	/* do additional nic configuration if needed */
+	if (priv->cfg->ops->nic &&
+		priv->cfg->ops->nic->additional_nic_config) {
+			priv->cfg->ops->nic->additional_nic_config(priv);
+	}
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -320,7 +321,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
-		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
@@ -396,7 +396,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
-		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.update_bcast_stations = iwl_update_bcast_stations,
@@ -419,6 +418,10 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 	}
 };
 
+static struct iwl_nic_ops iwl6050_nic_ops = {
+	.additional_nic_config = &iwl6050_additional_nic_config,
+};
+
 static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
@@ -426,6 +429,14 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
+static const struct iwl_ops iwl6050_ops = {
+	.lib = &iwl6000_lib,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
+	.led = &iwlagn_led_ops,
+	.nic = &iwl6050_nic_ops,
+};
+
 static const struct iwl_ops iwl6000g2b_ops = {
 	.lib = &iwl6000g2b_lib,
 	.hcmd = &iwlagn_bt_hcmd,
@@ -909,7 +920,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
@@ -947,7 +958,7 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
@@ -985,7 +996,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f0302bf..5daa189 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -137,7 +137,6 @@ struct iwl_debugfs_ops {
 struct iwl_temp_ops {
 	void (*temperature)(struct iwl_priv *priv);
 	void (*set_ct_kill)(struct iwl_priv *priv);
-	void (*set_calib_version)(struct iwl_priv *priv);
 };
 
 struct iwl_tt_ops {
@@ -233,11 +232,17 @@ struct iwl_led_ops {
 	int (*off)(struct iwl_priv *priv);
 };
 
+/* NIC specific ops */
+struct iwl_nic_ops {
+	void (*additional_nic_config)(struct iwl_priv *priv);
+};
+
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
 	const struct iwl_hcmd_ops *hcmd;
 	const struct iwl_hcmd_utils_ops *utils;
 	const struct iwl_led_ops *led;
+	const struct iwl_nic_ops *nic;
 };
 
 struct iwl_mod_params {
-- 
1.7.0.4

