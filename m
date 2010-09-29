Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0I2A4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: set CSR register for 6050g2 devices
Date: Tue, 28 Sep 2010 17:56:56 -0700
Message-Id: <1285721818-10281-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

For 6050g2 devices driver needs to set a special bit to CSR register
so that uCode can do things correctly in calibration routines.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   24 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    3 ++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8256034..83a5262 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -91,6 +91,16 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
 
+static void iwl6050g2_additional_nic_config(struct iwl_priv *priv)
+{
+	/* Indicate calibration version to uCode. */
+	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
+		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+	iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+		    CSR_GP_DRIVER_REG_BIT_6050_1x2);
+}
+
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
@@ -422,6 +432,10 @@ static struct iwl_nic_ops iwl6050_nic_ops = {
 	.additional_nic_config = &iwl6050_additional_nic_config,
 };
 
+static struct iwl_nic_ops iwl6050g2_nic_ops = {
+	.additional_nic_config = &iwl6050g2_additional_nic_config,
+};
+
 static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
@@ -437,6 +451,14 @@ static const struct iwl_ops iwl6050_ops = {
 	.nic = &iwl6050_nic_ops,
 };
 
+static const struct iwl_ops iwl6050g2_ops = {
+	.lib = &iwl6000_lib,
+	.hcmd = &iwlagn_hcmd,
+	.utils = &iwlagn_hcmd_utils,
+	.led = &iwlagn_led_ops,
+	.nic = &iwl6050g2_nic_ops,
+};
+
 static const struct iwl_ops iwl6000g2b_ops = {
 	.lib = &iwl6000g2b_lib,
 	.hcmd = &iwlagn_bt_hcmd,
@@ -958,7 +980,7 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6050_ops,
+	.ops = &iwl6050g2_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index ecf98e7..2aa15ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -371,7 +371,8 @@
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_3x3_HYB	    (0x00000000)
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_HYB	    (0x00000001)
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA	    (0x00000002)
-#define CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6	(0x00000004)
+#define CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6	    (0x00000004)
+#define CSR_GP_DRIVER_REG_BIT_6050_1x2		    (0x00000008)
 
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
-- 
1.7.0.4

