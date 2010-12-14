Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15781 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387Ab0LNARL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:11 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/14] iwlwifi: do not reload fw if WiMAX own the RF
Date: Mon, 13 Dec 2010 16:09:30 -0800
Message-Id: <1292285372-11373-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For WiFi/WiMAX combo devices, if WiMAX own the RF, WiFi driver
try to access RF and fail. This is the W/A to To avoid WiFi keep
reloading firmware and try to access RF again.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.c |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h |    2 +-
 5 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8435e5a..34af9e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -593,6 +593,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
+	.internal_wimax_coex = true,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -608,6 +609,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_BLINK,
+	.internal_wimax_coex = true,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -622,6 +624,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.base_params = &iwl5000_base_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_BLINK,
+	.internal_wimax_coex = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8a78924..fe5f6d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -782,6 +782,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_BLINK,
+	.internal_wimax_coex = true,
 };
 
 struct iwl_cfg iwl6150_bgn_cfg = {
@@ -797,6 +798,7 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_RF_STATE,
+	.internal_wimax_coex = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -811,6 +813,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.base_params = &iwl6050_base_params,
 	.need_dc_calib = true,
 	.led_mode = IWL_LED_BLINK,
+	.internal_wimax_coex = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d62b925..06cdc60 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -957,6 +957,22 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
+	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
+	if (priv->cfg->internal_wimax_coex &&
+	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
+			APMS_CLK_VAL_MRB_FUNC_MODE) ||
+	     (iwl_read_prph(priv, APMG_PS_CTRL_REG) &
+			APMG_PS_CTRL_VAL_RESET_REQ))) {
+		wake_up_interruptible(&priv->wait_command_queue);
+		/*
+		 *Keep the restart process from trying to send host
+		 * commands by clearing the INIT status bit
+		 */
+		clear_bit(STATUS_READY, &priv->status);
+		IWL_ERR(priv, "RF is used by WiMAX\n");
+		return;
+	}
+
 	IWL_ERR(priv, "Loaded firmware version: %s\n",
 		priv->hw->wiphy->fw_version);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d0b86f5..f80685a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -365,6 +365,7 @@ struct iwl_ht_params {
  * @led_mode: 0=blinking, 1=On(RF On)/Off(RF Off)
  * @adv_pm: advance power management
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
+ * @internal_wimax_coex: internal wifi/wimax combo device
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -414,6 +415,7 @@ struct iwl_cfg {
 	enum iwl_led_mode led_mode;
 	const bool adv_pm;
 	const bool rx_with_siso_diversity;
+	const bool internal_wimax_coex;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 5469655..86f5123 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -83,10 +83,10 @@
 #define APMG_DIGITAL_SVR_REG		(APMG_BASE + 0x0058)
 #define APMG_ANALOG_SVR_REG		(APMG_BASE + 0x006C)
 
+#define APMS_CLK_VAL_MRB_FUNC_MODE	(0x00000001)
 #define APMG_CLK_VAL_DMA_CLK_RQT	(0x00000200)
 #define APMG_CLK_VAL_BSM_CLK_RQT	(0x00000800)
 
-
 #define APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS	(0x00400000)
 #define APMG_PS_CTRL_VAL_RESET_REQ		(0x04000000)
 #define APMG_PS_CTRL_MSK_PWR_SRC		(0x03000000)
-- 
1.7.0.4

