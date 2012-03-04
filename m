Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2CDUnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 015/101] iwlwifi: make config const
Date: Sun,  4 Mar 2012 11:28:29 -0800
Message-Id: <1330889395-533-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214648_766898_9C6F3EC4)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Writing to the global config structures
is always wrong. To protect against such
mistakes in the future, mark them const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-2000.c   |   12 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   49 +++++++++--------
 drivers/net/wireless/iwlwifi/iwl-cfg.h    |   82 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-drv.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |    4 +-
 11 files changed, 90 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 22eb062..2199a0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -196,13 +196,13 @@ static struct iwl_ht_params iwl1000_ht_params = {
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
-struct iwl_cfg iwl1000_bgn_cfg = {
+const struct iwl_cfg iwl1000_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
 	IWL_DEVICE_1000,
 	.ht_params = &iwl1000_ht_params,
 };
 
-struct iwl_cfg iwl1000_bg_cfg = {
+const struct iwl_cfg iwl1000_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BG",
 	IWL_DEVICE_1000,
 };
@@ -221,13 +221,13 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.rx_with_siso_diversity = true
 
-struct iwl_cfg iwl100_bgn_cfg = {
+const struct iwl_cfg iwl100_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 100 BGN",
 	IWL_DEVICE_100,
 	.ht_params = &iwl1000_ht_params,
 };
 
-struct iwl_cfg iwl100_bg_cfg = {
+const struct iwl_cfg iwl100_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 100 BG",
 	IWL_DEVICE_100,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 43d17a4..1ba0207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -248,13 +248,13 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl2000_2bgn_cfg = {
+const struct iwl_cfg iwl2000_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2200 BGN",
 	IWL_DEVICE_2000,
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl2000_2bgn_d_cfg = {
+const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2200D BGN",
 	IWL_DEVICE_2000,
 	.ht_params = &iwl2000_ht_params,
@@ -278,7 +278,7 @@ struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.adv_pm = true,						\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl2030_2bgn_cfg = {
+const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 2230 BGN",
 	IWL_DEVICE_2030,
 	.ht_params = &iwl2000_ht_params,
@@ -302,13 +302,13 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl105_bgn_cfg = {
+const struct iwl_cfg iwl105_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 105 BGN",
 	IWL_DEVICE_105,
 	.ht_params = &iwl2000_ht_params,
 };
 
-struct iwl_cfg iwl105_bgn_d_cfg = {
+const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 105D BGN",
 	IWL_DEVICE_105,
 	.ht_params = &iwl2000_ht_params,
@@ -333,7 +333,7 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.rx_with_siso_diversity = true,				\
 	.iq_invert = true					\
 
-struct iwl_cfg iwl135_bgn_cfg = {
+const struct iwl_cfg iwl135_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 135 BGN",
 	IWL_DEVICE_135,
 	.ht_params = &iwl2000_ht_params,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8cdc4a3..dff75a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -349,7 +349,7 @@ static struct iwl_ht_params iwl5000_ht_params = {
 	.base_params = &iwl5000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
-struct iwl_cfg iwl5300_agn_cfg = {
+const struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
 	IWL_DEVICE_5000,
 	/* at least EEPROM 0x11A has wrong info */
@@ -358,7 +358,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 };
 
-struct iwl_cfg iwl5100_bgn_cfg = {
+const struct iwl_cfg iwl5100_bgn_cfg = {
 	.name = "Intel(R) WiFi Link 5100 BGN",
 	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
@@ -366,14 +366,14 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 };
 
-struct iwl_cfg iwl5100_abg_cfg = {
+const struct iwl_cfg iwl5100_abg_cfg = {
 	.name = "Intel(R) WiFi Link 5100 ABG",
 	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
 };
 
-struct iwl_cfg iwl5100_agn_cfg = {
+const struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "Intel(R) WiFi Link 5100 AGN",
 	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
@@ -381,7 +381,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.ht_params = &iwl5000_ht_params,
 };
 
-struct iwl_cfg iwl5350_agn_cfg = {
+const struct iwl_cfg iwl5350_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5350 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
@@ -411,14 +411,14 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
-struct iwl_cfg iwl5150_agn_cfg = {
+const struct iwl_cfg iwl5150_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5150 AGN",
 	IWL_DEVICE_5150,
 	.ht_params = &iwl5000_ht_params,
 
 };
 
-struct iwl_cfg iwl5150_abg_cfg = {
+const struct iwl_cfg iwl5150_abg_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5150 ABG",
 	IWL_DEVICE_5150,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 720e8e6..ef89663 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -354,40 +354,41 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE
 
-struct iwl_cfg iwl6005_2agn_cfg = {
+const struct iwl_cfg iwl6005_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 AGN",
 	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6005_2abg_cfg = {
+const struct iwl_cfg iwl6005_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 ABG",
 	IWL_DEVICE_6005,
 };
 
-struct iwl_cfg iwl6005_2bg_cfg = {
+const struct iwl_cfg iwl6005_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 BG",
 	IWL_DEVICE_6005,
 };
 
-struct iwl_cfg iwl6005_2agn_sff_cfg = {
+const struct iwl_cfg iwl6005_2agn_sff_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205S AGN",
 	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6005_2agn_d_cfg = {
+const struct iwl_cfg iwl6005_2agn_d_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205D AGN",
 	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6005_2agn_mow1_cfg = {
+const struct iwl_cfg iwl6005_2agn_mow1_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6206 AGN",
 	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
 };
-struct iwl_cfg iwl6005_2agn_mow2_cfg = {
+
+const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6207 AGN",
 	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
@@ -409,53 +410,53 @@ struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true						\
 
-struct iwl_cfg iwl6030_2agn_cfg = {
+const struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6030_2abg_cfg = {
+const struct iwl_cfg iwl6030_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 ABG",
 	IWL_DEVICE_6030,
 };
 
-struct iwl_cfg iwl6030_2bgn_cfg = {
+const struct iwl_cfg iwl6030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6030_2bg_cfg = {
+const struct iwl_cfg iwl6030_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BG",
 	IWL_DEVICE_6030,
 };
 
-struct iwl_cfg iwl6035_2agn_cfg = {
+const struct iwl_cfg iwl6035_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6235 AGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl1030_bgn_cfg = {
+const struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl1030_bg_cfg = {
+const struct iwl_cfg iwl1030_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BG",
 	IWL_DEVICE_6030,
 };
 
-struct iwl_cfg iwl130_bgn_cfg = {
+const struct iwl_cfg iwl130_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 130 BGN",
 	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
 	.rx_with_siso_diversity = true,
 };
 
-struct iwl_cfg iwl130_bg_cfg = {
+const struct iwl_cfg iwl130_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 130 BG",
 	IWL_DEVICE_6030,
 	.rx_with_siso_diversity = true,
@@ -480,18 +481,18 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.pa_type = IWL_PA_INTERNAL,				\
 	.led_mode = IWL_LED_BLINK
 
-struct iwl_cfg iwl6000i_2agn_cfg = {
+const struct iwl_cfg iwl6000i_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
 	IWL_DEVICE_6000i,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6000i_2abg_cfg = {
+const struct iwl_cfg iwl6000i_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 ABG",
 	IWL_DEVICE_6000i,
 };
 
-struct iwl_cfg iwl6000i_2bg_cfg = {
+const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 BG",
 	IWL_DEVICE_6000i,
 };
@@ -512,13 +513,13 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
-struct iwl_cfg iwl6050_2agn_cfg = {
+const struct iwl_cfg iwl6050_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN",
 	IWL_DEVICE_6050,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6050_2abg_cfg = {
+const struct iwl_cfg iwl6050_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 ABG",
 	IWL_DEVICE_6050,
 };
@@ -537,18 +538,18 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.led_mode = IWL_LED_BLINK,				\
 	.internal_wimax_coex = true
 
-struct iwl_cfg iwl6150_bgn_cfg = {
+const struct iwl_cfg iwl6150_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BGN",
 	IWL_DEVICE_6150,
 	.ht_params = &iwl6000_ht_params,
 };
 
-struct iwl_cfg iwl6150_bg_cfg = {
+const struct iwl_cfg iwl6150_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N + WiMAX 6150 BG",
 	IWL_DEVICE_6150,
 };
 
-struct iwl_cfg iwl6000_3agn_cfg = {
+const struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index 1ad14bb..8215231 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -68,46 +68,46 @@
  * This file declares the config structures for all devices.
  */
 
-extern struct iwl_cfg iwl5300_agn_cfg;
-extern struct iwl_cfg iwl5100_agn_cfg;
-extern struct iwl_cfg iwl5350_agn_cfg;
-extern struct iwl_cfg iwl5100_bgn_cfg;
-extern struct iwl_cfg iwl5100_abg_cfg;
-extern struct iwl_cfg iwl5150_agn_cfg;
-extern struct iwl_cfg iwl5150_abg_cfg;
-extern struct iwl_cfg iwl6005_2agn_cfg;
-extern struct iwl_cfg iwl6005_2abg_cfg;
-extern struct iwl_cfg iwl6005_2bg_cfg;
-extern struct iwl_cfg iwl6005_2agn_sff_cfg;
-extern struct iwl_cfg iwl6005_2agn_d_cfg;
-extern struct iwl_cfg iwl6005_2agn_mow1_cfg;
-extern struct iwl_cfg iwl6005_2agn_mow2_cfg;
-extern struct iwl_cfg iwl1030_bgn_cfg;
-extern struct iwl_cfg iwl1030_bg_cfg;
-extern struct iwl_cfg iwl6030_2agn_cfg;
-extern struct iwl_cfg iwl6030_2abg_cfg;
-extern struct iwl_cfg iwl6030_2bgn_cfg;
-extern struct iwl_cfg iwl6030_2bg_cfg;
-extern struct iwl_cfg iwl6000i_2agn_cfg;
-extern struct iwl_cfg iwl6000i_2abg_cfg;
-extern struct iwl_cfg iwl6000i_2bg_cfg;
-extern struct iwl_cfg iwl6000_3agn_cfg;
-extern struct iwl_cfg iwl6050_2agn_cfg;
-extern struct iwl_cfg iwl6050_2abg_cfg;
-extern struct iwl_cfg iwl6150_bgn_cfg;
-extern struct iwl_cfg iwl6150_bg_cfg;
-extern struct iwl_cfg iwl1000_bgn_cfg;
-extern struct iwl_cfg iwl1000_bg_cfg;
-extern struct iwl_cfg iwl100_bgn_cfg;
-extern struct iwl_cfg iwl100_bg_cfg;
-extern struct iwl_cfg iwl130_bgn_cfg;
-extern struct iwl_cfg iwl130_bg_cfg;
-extern struct iwl_cfg iwl2000_2bgn_cfg;
-extern struct iwl_cfg iwl2000_2bgn_d_cfg;
-extern struct iwl_cfg iwl2030_2bgn_cfg;
-extern struct iwl_cfg iwl6035_2agn_cfg;
-extern struct iwl_cfg iwl105_bgn_cfg;
-extern struct iwl_cfg iwl105_bgn_d_cfg;
-extern struct iwl_cfg iwl135_bgn_cfg;
+extern const struct iwl_cfg iwl5300_agn_cfg;
+extern const struct iwl_cfg iwl5100_agn_cfg;
+extern const struct iwl_cfg iwl5350_agn_cfg;
+extern const struct iwl_cfg iwl5100_bgn_cfg;
+extern const struct iwl_cfg iwl5100_abg_cfg;
+extern const struct iwl_cfg iwl5150_agn_cfg;
+extern const struct iwl_cfg iwl5150_abg_cfg;
+extern const struct iwl_cfg iwl6005_2agn_cfg;
+extern const struct iwl_cfg iwl6005_2abg_cfg;
+extern const struct iwl_cfg iwl6005_2bg_cfg;
+extern const struct iwl_cfg iwl6005_2agn_sff_cfg;
+extern const struct iwl_cfg iwl6005_2agn_d_cfg;
+extern const struct iwl_cfg iwl6005_2agn_mow1_cfg;
+extern const struct iwl_cfg iwl6005_2agn_mow2_cfg;
+extern const struct iwl_cfg iwl1030_bgn_cfg;
+extern const struct iwl_cfg iwl1030_bg_cfg;
+extern const struct iwl_cfg iwl6030_2agn_cfg;
+extern const struct iwl_cfg iwl6030_2abg_cfg;
+extern const struct iwl_cfg iwl6030_2bgn_cfg;
+extern const struct iwl_cfg iwl6030_2bg_cfg;
+extern const struct iwl_cfg iwl6000i_2agn_cfg;
+extern const struct iwl_cfg iwl6000i_2abg_cfg;
+extern const struct iwl_cfg iwl6000i_2bg_cfg;
+extern const struct iwl_cfg iwl6000_3agn_cfg;
+extern const struct iwl_cfg iwl6050_2agn_cfg;
+extern const struct iwl_cfg iwl6050_2abg_cfg;
+extern const struct iwl_cfg iwl6150_bgn_cfg;
+extern const struct iwl_cfg iwl6150_bg_cfg;
+extern const struct iwl_cfg iwl1000_bgn_cfg;
+extern const struct iwl_cfg iwl1000_bg_cfg;
+extern const struct iwl_cfg iwl100_bgn_cfg;
+extern const struct iwl_cfg iwl100_bg_cfg;
+extern const struct iwl_cfg iwl130_bgn_cfg;
+extern const struct iwl_cfg iwl130_bg_cfg;
+extern const struct iwl_cfg iwl2000_2bgn_cfg;
+extern const struct iwl_cfg iwl2000_2bgn_d_cfg;
+extern const struct iwl_cfg iwl2030_2bgn_cfg;
+extern const struct iwl_cfg iwl6035_2agn_cfg;
+extern const struct iwl_cfg iwl105_bgn_cfg;
+extern const struct iwl_cfg iwl105_bgn_d_cfg;
+extern const struct iwl_cfg iwl135_bgn_cfg;
 
 #endif /* __iwl_pci_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 8ff5256..76fc440 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -68,7 +68,7 @@
 #include "iwl-op-mode.h"
 
 int iwl_drv_start(struct iwl_shared *shrd,
-		  struct iwl_trans *trans, struct iwl_cfg *cfg)
+		  struct iwl_trans *trans, const struct iwl_cfg *cfg)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 90534a2..3b771c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -105,7 +105,7 @@
  * function.
  */
 int iwl_drv_start(struct iwl_shared *shrd,
-		  struct iwl_trans *trans, struct iwl_cfg *cfg);
+		  struct iwl_trans *trans, const struct iwl_cfg *cfg);
 
 /**
  * iwl_drv_stop - stop the drv
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 6915b33..f965ee3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -512,7 +512,7 @@ static int iwl_find_otp_image(struct iwl_trans *trans,
  * iwl_get_max_txpower_avg - get the highest tx power from all chains.
  *     find the highest tx power from all chains for the channel
  */
-static s8 iwl_get_max_txpower_avg(struct iwl_cfg *cfg,
+static s8 iwl_get_max_txpower_avg(const struct iwl_cfg *cfg,
 		struct iwl_eeprom_enhanced_txpwr *enhanced_txpower,
 		int element, s8 *max_txpower_in_half_dbm)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 06e0041..d109b0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -263,7 +263,7 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
 	struct iwl_shared *shrd;
 	struct iwl_trans *iwl_trans;
 	int err;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 11184f1..4efc9e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -374,7 +374,7 @@ struct iwl_shared {
 	bool wowlan;
 	u8 valid_contexts;
 
-	struct iwl_cfg *cfg;
+	const struct iwl_cfg *cfg;
 	struct iwl_priv *priv;
 	struct iwl_trans *trans;
 	struct iwl_nic *nic;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index b16efc0..206a61c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -692,7 +692,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
 
 int __must_check iwl_request_firmware(struct iwl_nic *nic, bool first)
 {
-	struct iwl_cfg *cfg = cfg(nic);
+	const struct iwl_cfg *cfg = cfg(nic);
 	const char *name_pre = cfg->fw_name_pre;
 	char tag[8];
 
@@ -1045,7 +1045,7 @@ static int iwl_parse_tlv_firmware(struct iwl_nic *nic,
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 {
 	struct iwl_nic *nic = context;
-	struct iwl_cfg *cfg = cfg(nic);
+	const struct iwl_cfg *cfg = cfg(nic);
 	struct iwl_fw *fw = &nic->fw;
 	struct iwl_ucode_header *ucode;
 	int err;
-- 
1.7.0.4

