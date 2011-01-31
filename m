Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab1AaVxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:18 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/11] iwlagn: add IQ inversion support for 2000 series devices
Date: Mon, 31 Jan 2011 13:40:39 -0800
Message-Id: <1296510047-24576-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The I/Q swapping is extremely important and should be dealt with extra care.
It will affects OFDM and CCK differently.

For 6000/6005/6030 series devices, the I/Q were swapped, and for 2000 series
devices, it is in non-swapped status (but its swapped with respected to 6000/6005/6030).
so the CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER register need to be set to support
the correct behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    2 ++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 3c9e1b5..ac5996f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -97,6 +97,10 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
+	if (priv->cfg->iq_invert)
+		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
+
 }
 
 static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
@@ -428,7 +432,8 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
-	.led_mode = IWL_LED_RF_STATE				\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.iq_invert = true					\
 
 struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "2000 Series 2x2 BGN",
@@ -454,7 +459,8 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.adv_pm = true						\
+	.adv_pm = true,						\
+	.iq_invert = true					\
 
 struct iwl_cfg iwl2030_2bgn_cfg = {
 	.name = "2000 Series 2x2 BGN/BT",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c83fcc6..b57e739 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -364,6 +364,7 @@ struct iwl_ht_params {
  * @adv_pm: advance power management
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
+ * @iq_invert: I/Q inversion
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -413,6 +414,7 @@ struct iwl_cfg {
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
+	const bool iq_invert;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 6c2b2df..f52bc04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -382,6 +382,8 @@
 #define CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6	    (0x00000004)
 #define CSR_GP_DRIVER_REG_BIT_6050_1x2		    (0x00000008)
 
+#define CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER	    (0x00000080)
+
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
-- 
1.7.0.4

