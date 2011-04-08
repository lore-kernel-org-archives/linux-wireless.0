Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1DHPuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/16] iwlagn: PAPD read for 2000 series devices
Date: Fri,  8 Apr 2011 08:30:25 -0700
Message-Id: <1302276636-12802-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 2000 series NICs, disable OTP refresh in order to read correct
PAPD table from high OTP block

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    5 ++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index e73ac80..86d7ffd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -98,6 +98,8 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 
+	if (priv->cfg->disable_otp_refresh)
+		iwl_write_prph(priv, APMG_ANALOG_SVR_REG, 0x80000010);
 }
 
 static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
@@ -409,7 +411,8 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.iq_invert = true					\
+	.iq_invert = true,					\
+	.disable_otp_refresh = true				\
 
 struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "2000 Series 2x2 BGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 43d4c92..10a6f85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -331,6 +331,7 @@ struct iwl_ht_params {
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
  * @iq_invert: I/Q inversion
+ * @disable_otp_refresh: disable OTP refresh current limit
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -381,6 +382,7 @@ struct iwl_cfg {
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
 	const bool iq_invert;
+	const bool disable_otp_refresh;
 };
 
 /***************************
-- 
1.7.0.4

