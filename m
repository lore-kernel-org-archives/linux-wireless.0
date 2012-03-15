Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161425Ab2COU2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/26] iwlwifi: remove iq_invert config param
Date: Thu, 15 Mar 2012 13:26:49 -0700
Message-Id: <1331843226-29860-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212850_190567_E89E8541)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is used only by 2000 class devices, but
they all use it so remove the configuration
parameter and hard-code the programming.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c   |   17 ++++++-----------
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5635b9e..5b898db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -86,9 +86,8 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	if (cfg(priv)->iq_invert)
-		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
+	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+		    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
 static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
@@ -234,8 +233,7 @@ static const struct iwl_bt_params iwl2030_bt_params = {
 	.base_params = &iwl2000_base_params,			\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
-	.led_mode = IWL_LED_RF_STATE,				\
-	.iq_invert = true					\
+	.led_mode = IWL_LED_RF_STATE
 
 const struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2200 BGN",
@@ -264,8 +262,7 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.adv_pm = true,						\
-	.iq_invert = true					\
+	.adv_pm = true
 
 const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2230 BGN",
@@ -288,8 +285,7 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
-	.rx_with_siso_diversity = true,				\
-	.iq_invert = true					\
+	.rx_with_siso_diversity = true
 
 const struct iwl_cfg iwl105_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 105 BGN",
@@ -319,8 +315,7 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
-	.rx_with_siso_diversity = true,				\
-	.iq_invert = true					\
+	.rx_with_siso_diversity = true
 
 const struct iwl_cfg iwl135_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 135 BGN",
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 18ef286..229c4b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -302,7 +302,6 @@ struct iwl_ht_params {
  * @adv_pm: advance power management
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
- * @iq_invert: I/Q inversion
  * @temp_offset_v2: support v2 of temperature offset calibration
  *
  * We enable the driver to be backward compatible wrt. hardware features.
@@ -336,7 +335,6 @@ struct iwl_cfg {
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
-	const bool iq_invert;
 	const bool temp_offset_v2;
 };
 
-- 
1.7.0.4

