Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1GUP0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/25] iwlagn: remove "disable otp refresh" W/A
Date: Thu, 21 Jul 2011 07:50:27 -0700
Message-Id: <1311259828-8415-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172702_462927_F906A996)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the "disable otp refresh" work-around, not needed anymore.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 00480e4..0e13f0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -85,9 +85,6 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 	if (priv->cfg->iq_invert)
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
-
-	if (priv->cfg->disable_otp_refresh)
-		iwl_write_prph(priv, APMG_ANALOG_SVR_REG, 0x80000010);
 }
 
 static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
@@ -267,8 +264,7 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.iq_invert = true,					\
-	.disable_otp_refresh = true				\
+	.iq_invert = true					\
 
 struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "2000 Series 2x2 BGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c2d58df..3e6bb73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -212,7 +212,6 @@ struct iwl_ht_params {
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
  * @iq_invert: I/Q inversion
- * @disable_otp_refresh: disable OTP refresh current limit
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -258,7 +257,6 @@ struct iwl_cfg {
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
 	const bool iq_invert;
-	const bool disable_otp_refresh;
 };
 
 /***************************
-- 
1.7.0.4

