Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab2DJAu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/11] iwlwifi: dynamically determine lib_ops
Date: Mon,  9 Apr 2012 17:47:01 -0700
Message-Id: <1334018821-30416-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025033_043216_C61AA3BF)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Having the pointer to lib_ops in the config
makes it impossible to split the driver into
different modules. Determine the ops based on
the device family enumeration to get rid of
the direct pointer.

Also move all the opmode specific code from
the iwl-[1256]000.c files into a new file
iwl-agn-devices.c so that the former only
have configuration data now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c     |  112 +-----------
 drivers/net/wireless/iwlwifi/iwl-2000.c     |  116 +------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |  268 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |  219 +----------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   40 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   10 +
 drivers/net/wireless/iwlwifi/iwl-config.h   |    3 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |   15 --
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   16 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 +-
 13 files changed, 81 insertions(+), 736 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index c7c4a99..f2cd678 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -7,7 +7,7 @@ iwlwifi-objs		+= iwl-agn-tt.o iwl-agn-sta.o iwl-agn-rx.o
 
 iwlwifi-objs		+= iwl-core.o iwl-eeprom.o iwl-power.o
 iwlwifi-objs		+= iwl-scan.o iwl-led.o
-iwlwifi-objs		+= iwl-agn-rxon.o
+iwlwifi-objs		+= iwl-agn-rxon.o iwl-agn-devices.o
 iwlwifi-objs		+= iwl-5000.o
 iwlwifi-objs		+= iwl-6000.o
 iwlwifi-objs		+= iwl-1000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 66f86c8..e900607 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -24,26 +24,11 @@
  *
  *****************************************************************************/
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
 #include <linux/stringify.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-agn-hw.h"
-#include "iwl-shared.h"
+#include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-prph.h"
+#include "iwl-dev.h" /* still needed */
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
@@ -64,97 +49,6 @@
 #define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE __stringify(api) ".ucode"
 
 
-/*
- * For 1000, use advance thermal throttling critical temperature threshold,
- * but legacy thermal management implementation for now.
- * This is for the reason of 1000 uCode using advance thermal throttling API
- * but not implement ct_kill_exit based on ct_kill exit temperature
- * so the thermal throttling will still based on legacy thermal throttling
- * management.
- * The code here need to be modified once 1000 uCode has the advanced thermal
- * throttling algorithm in place
- */
-static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
-{
-	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
-}
-
-/* NIC configuration for 1000 series */
-static void iwl1000_nic_config(struct iwl_priv *priv)
-{
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
-
-	/* Setting digital SVR for 1000 card to 1.32V */
-	/* locking is acquired in iwl_set_bits_mask_prph() function */
-	iwl_set_bits_mask_prph(trans(priv), APMG_DIGITAL_SVR_REG,
-				APMG_SVR_DIGITAL_VOLTAGE_1_32,
-				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
-}
-
-static const struct iwl_sensitivity_ranges iwl1000_sensitivity = {
-	.min_nrg_cck = 95,
-	.auto_corr_min_ofdm = 90,
-	.auto_corr_min_ofdm_mrc = 170,
-	.auto_corr_min_ofdm_x1 = 120,
-	.auto_corr_min_ofdm_mrc_x1 = 240,
-
-	.auto_corr_max_ofdm = 120,
-	.auto_corr_max_ofdm_mrc = 210,
-	.auto_corr_max_ofdm_x1 = 155,
-	.auto_corr_max_ofdm_mrc_x1 = 290,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 200,
-	.auto_corr_min_cck_mrc = 170,
-	.auto_corr_max_cck_mrc = 400,
-	.nrg_th_cck = 95,
-	.nrg_th_ofdm = 95,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
-	.nrg_th_cca = 62,
-};
-
-static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
-	iwl1000_set_ct_threshold(priv);
-
-	/* Set initial sensitivity parameters */
-	priv->hw_params.sens = &iwl1000_sensitivity;
-}
-
-static struct iwl_lib_ops iwl1000_lib = {
-	.set_hw_params = iwl1000_hw_set_hw_params,
-	.nic_config = iwl1000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-	},
-	.temperature = iwlagn_temperature,
-};
-
 static const struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
@@ -185,7 +79,6 @@ static const struct iwl_ht_params iwl1000_ht_params = {
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
-	.lib = &iwl1000_lib,					\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -210,7 +103,6 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
-	.lib = &iwl1000_lib,					\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.rx_with_siso_diversity = true
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index cedec43..3d4a36c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -24,25 +24,11 @@
  *
  *****************************************************************************/
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
 #include <linux/stringify.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-agn-hw.h"
-#include "iwl-shared.h"
+#include "iwl-config.h"
 #include "iwl-cfg.h"
+#include "iwl-dev.h" /* still needed */
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
@@ -74,100 +60,6 @@
 #define IWL135_FW_PRE "iwlwifi-135-"
 #define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE __stringify(api) ".ucode"
 
-static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
-{
-	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
-}
-
-/* NIC configuration for 2000 series */
-static void iwl2000_nic_config(struct iwl_priv *priv)
-{
-	iwl_rf_config(priv);
-
-	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-		    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
-}
-
-static const struct iwl_sensitivity_ranges iwl2000_sensitivity = {
-	.min_nrg_cck = 97,
-	.auto_corr_min_ofdm = 80,
-	.auto_corr_min_ofdm_mrc = 128,
-	.auto_corr_min_ofdm_x1 = 105,
-	.auto_corr_min_ofdm_mrc_x1 = 192,
-
-	.auto_corr_max_ofdm = 145,
-	.auto_corr_max_ofdm_mrc = 232,
-	.auto_corr_max_ofdm_x1 = 110,
-	.auto_corr_max_ofdm_mrc_x1 = 232,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 175,
-	.auto_corr_min_cck_mrc = 160,
-	.auto_corr_max_cck_mrc = 310,
-	.nrg_th_cck = 97,
-	.nrg_th_ofdm = 100,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
-	.nrg_th_cca = 62,
-};
-
-static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
-	iwl2000_set_ct_threshold(priv);
-
-	/* Set initial sensitivity parameters */
-	priv->hw_params.sens = &iwl2000_sensitivity;
-}
-
-static struct iwl_lib_ops iwl2000_lib = {
-	.set_hw_params = iwl2000_hw_set_hw_params,
-	.nic_config = iwl2000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-		.enhanced_txpower = true,
-	},
-	.temperature = iwlagn_temperature,
-};
-
-static struct iwl_lib_ops iwl2030_lib = {
-	.set_hw_params = iwl2000_hw_set_hw_params,
-	.nic_config = iwl2000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REGULATORY_BAND_NO_HT40,
-		},
-		.enhanced_txpower = true,
-	},
-	.temperature = iwlagn_temperature,
-};
-
 static const struct iwl_base_params iwl2000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -228,7 +120,6 @@ static const struct iwl_bt_params iwl2030_bt_params = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
@@ -256,7 +147,6 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_temp_offset_calib = true,				\
@@ -280,7 +170,6 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
 	.need_temp_offset_calib = true,				\
 	.temp_offset_v2 = true,					\
@@ -310,7 +199,6 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_temp_offset_calib = true,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 55294a2..ffa9ac5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -24,28 +24,11 @@
  *
  *****************************************************************************/
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/sched.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
 #include <linux/stringify.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-agn-hw.h"
-#include "iwl-trans.h"
-#include "iwl-shared.h"
+#include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-prph.h"
+#include "iwl-dev.h" /* still needed */
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
@@ -61,250 +44,6 @@
 #define IWL5150_FW_PRE "iwlwifi-5150-"
 #define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE __stringify(api) ".ucode"
 
-/* NIC configuration for 5000 series */
-static void iwl5000_nic_config(struct iwl_priv *priv)
-{
-	iwl_rf_config(priv);
-
-	/* W/A : NIC is stuck in a reset state after Early PCIe power off
-	 * (PCIe power is lost before PERST# is asserted),
-	 * causing ME FW to lose ownership and not being able to obtain it back.
-	 */
-	iwl_set_bits_mask_prph(trans(priv), APMG_PS_CTRL_REG,
-				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
-				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
-}
-
-static const struct iwl_sensitivity_ranges iwl5000_sensitivity = {
-	.min_nrg_cck = 100,
-	.auto_corr_min_ofdm = 90,
-	.auto_corr_min_ofdm_mrc = 170,
-	.auto_corr_min_ofdm_x1 = 105,
-	.auto_corr_min_ofdm_mrc_x1 = 220,
-
-	.auto_corr_max_ofdm = 120,
-	.auto_corr_max_ofdm_mrc = 210,
-	.auto_corr_max_ofdm_x1 = 120,
-	.auto_corr_max_ofdm_mrc_x1 = 240,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 200,
-	.auto_corr_min_cck_mrc = 200,
-	.auto_corr_max_cck_mrc = 400,
-	.nrg_th_cck = 100,
-	.nrg_th_ofdm = 100,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
-	.nrg_th_cca = 62,
-};
-
-static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
-	.min_nrg_cck = 95,
-	.auto_corr_min_ofdm = 90,
-	.auto_corr_min_ofdm_mrc = 170,
-	.auto_corr_min_ofdm_x1 = 105,
-	.auto_corr_min_ofdm_mrc_x1 = 220,
-
-	.auto_corr_max_ofdm = 120,
-	.auto_corr_max_ofdm_mrc = 210,
-	/* max = min for performance bug in 5150 DSP */
-	.auto_corr_max_ofdm_x1 = 105,
-	.auto_corr_max_ofdm_mrc_x1 = 220,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 200,
-	.auto_corr_min_cck_mrc = 170,
-	.auto_corr_max_cck_mrc = 400,
-	.nrg_th_cck = 95,
-	.nrg_th_ofdm = 95,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 390,
-	.nrg_th_cca = 62,
-};
-
-#define IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF	(-5)
-
-static s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
-{
-	u16 temperature, voltage;
-	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(priv,
-				EEPROM_KELVIN_TEMPERATURE);
-
-	temperature = le16_to_cpu(temp_calib[0]);
-	voltage = le16_to_cpu(temp_calib[1]);
-
-	/* offset = temp - volt / coeff */
-	return (s32)(temperature - voltage / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
-}
-
-static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
-{
-	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
-	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
-			iwl_temp_calib_to_offset(priv);
-
-	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
-}
-
-static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
-{
-	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
-}
-
-static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	priv->hw_params.rx_chains_num =
-		num_of_ant(priv->hw_params.valid_rx_ant);
-
-	iwl5000_set_ct_threshold(priv);
-
-	/* Set initial sensitivity parameters */
-	priv->hw_params.sens = &iwl5000_sensitivity;
-}
-
-static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	priv->hw_params.rx_chains_num =
-		num_of_ant(priv->hw_params.valid_rx_ant);
-
-	iwl5150_set_ct_threshold(priv);
-
-	/* Set initial sensitivity parameters */
-	priv->hw_params.sens = &iwl5150_sensitivity;
-}
-
-static void iwl5150_temperature(struct iwl_priv *priv)
-{
-	u32 vt = 0;
-	s32 offset =  iwl_temp_calib_to_offset(priv);
-
-	vt = le32_to_cpu(priv->statistics.common.temperature);
-	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
-	/* now vt hold the temperature in Kelvin */
-	priv->temperature = KELVIN_TO_CELSIUS(vt);
-	iwl_tt_handler(priv);
-}
-
-static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
-				     struct ieee80211_channel_switch *ch_switch)
-{
-	/*
-	 * MULTI-FIXME
-	 * See iwlagn_mac_channel_switch.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl5000_channel_switch_cmd cmd;
-	const struct iwl_channel_info *ch_info;
-	u32 switch_time_in_usec, ucode_switch_time;
-	u16 ch;
-	u32 tsf_low;
-	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = ctx->vif;
-	struct iwl_host_cmd hcmd = {
-		.id = REPLY_CHANNEL_SWITCH,
-		.len = { sizeof(cmd), },
-		.flags = CMD_SYNC,
-		.data = { &cmd, },
-	};
-
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ch_switch->channel->hw_value;
-	IWL_DEBUG_11H(priv, "channel switch from %d to %d\n",
-		      ctx->active.channel, ch);
-	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
-	switch_count = ch_switch->count;
-	tsf_low = ch_switch->timestamp & 0x0ffffffff;
-	/*
-	 * calculate the ucode channel switch time
-	 * adding TSF as one of the factor for when to switch
-	 */
-	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
-		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
-		    beacon_interval)) {
-			switch_count -= (priv->ucode_beacon_time -
-				tsf_low) / beacon_interval;
-		} else
-			switch_count = 0;
-	}
-	if (switch_count <= 1)
-		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
-	else {
-		switch_time_in_usec =
-			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
-		ucode_switch_time = iwl_usecs_to_beacons(priv,
-							 switch_time_in_usec,
-							 beacon_interval);
-		cmd.switch_time = iwl_add_beacon_time(priv,
-						      priv->ucode_beacon_time,
-						      ucode_switch_time,
-						      beacon_interval);
-	}
-	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
-		      cmd.switch_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, ch);
-	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
-	else {
-		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			ctx->active.channel, ch);
-		return -EFAULT;
-	}
-
-	return iwl_dvm_send_cmd(priv, &hcmd);
-}
-
-static struct iwl_lib_ops iwl5000_lib = {
-	.set_hw_params = iwl5000_hw_set_hw_params,
-	.set_channel_switch = iwl5000_hw_channel_switch,
-	.nic_config = iwl5000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-	},
-	.temperature = iwlagn_temperature,
-};
-
-static struct iwl_lib_ops iwl5150_lib = {
-	.set_hw_params = iwl5150_hw_set_hw_params,
-	.set_channel_switch = iwl5000_hw_channel_switch,
-	.nic_config = iwl5000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-	},
-	.temperature = iwl5150_temperature,
-};
-
 static const struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -330,7 +69,6 @@ static const struct iwl_ht_params iwl5000_ht_params = {
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
-	.lib = &iwl5000_lib,					\
 	.base_params = &iwl5000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -376,7 +114,6 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.lib = &iwl5000_lib,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
@@ -392,7 +129,6 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
-	.lib = &iwl5150_lib,					\
 	.base_params = &iwl5000_base_params,			\
 	.no_xtal_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f124ec6..00da252 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -24,26 +24,11 @@
  *
  *****************************************************************************/
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
 #include <linux/stringify.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-agn.h"
-#include "iwl-agn-hw.h"
-#include "iwl-trans.h"
-#include "iwl-shared.h"
+#include "iwl-config.h"
 #include "iwl-cfg.h"
+#include "iwl-dev.h" /* still needed */
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 6
@@ -71,200 +56,6 @@
 #define IWL6030_FW_PRE "iwlwifi-6000g2b-"
 #define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE __stringify(api) ".ucode"
 
-static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
-{
-	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
-}
-
-/* NIC configuration for 6000 series */
-static void iwl6000_nic_config(struct iwl_priv *priv)
-{
-	iwl_rf_config(priv);
-
-	switch (cfg(priv)->device_family) {
-	case IWL_DEVICE_FAMILY_6005:
-	case IWL_DEVICE_FAMILY_6030:
-	case IWL_DEVICE_FAMILY_6000:
-		break;
-	case IWL_DEVICE_FAMILY_6000i:
-		/* 2x2 IPA phy type */
-		iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
-			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
-		break;
-	case IWL_DEVICE_FAMILY_6050:
-		/* Indicate calibration version to uCode. */
-		if (iwl_eeprom_calib_version(priv) >= 6)
-			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-		break;
-	case IWL_DEVICE_FAMILY_6150:
-		/* Indicate calibration version to uCode. */
-		if (iwl_eeprom_calib_version(priv) >= 6)
-			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-			    CSR_GP_DRIVER_REG_BIT_6050_1x2);
-		break;
-	default:
-		WARN_ON(1);
-	}
-}
-
-static const struct iwl_sensitivity_ranges iwl6000_sensitivity = {
-	.min_nrg_cck = 110,
-	.auto_corr_min_ofdm = 80,
-	.auto_corr_min_ofdm_mrc = 128,
-	.auto_corr_min_ofdm_x1 = 105,
-	.auto_corr_min_ofdm_mrc_x1 = 192,
-
-	.auto_corr_max_ofdm = 145,
-	.auto_corr_max_ofdm_mrc = 232,
-	.auto_corr_max_ofdm_x1 = 110,
-	.auto_corr_max_ofdm_mrc_x1 = 232,
-
-	.auto_corr_min_cck = 125,
-	.auto_corr_max_cck = 175,
-	.auto_corr_min_cck_mrc = 160,
-	.auto_corr_max_cck_mrc = 310,
-	.nrg_th_cck = 110,
-	.nrg_th_ofdm = 110,
-
-	.barker_corr_th_min = 190,
-	.barker_corr_th_min_mrc = 336,
-	.nrg_th_cca = 62,
-};
-
-static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
-{
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-
-	priv->hw_params.tx_chains_num =
-		num_of_ant(priv->hw_params.valid_tx_ant);
-	if (cfg(priv)->rx_with_siso_diversity)
-		priv->hw_params.rx_chains_num = 1;
-	else
-		priv->hw_params.rx_chains_num =
-			num_of_ant(priv->hw_params.valid_rx_ant);
-
-	iwl6000_set_ct_threshold(priv);
-
-	/* Set initial sensitivity parameters */
-	priv->hw_params.sens = &iwl6000_sensitivity;
-
-}
-
-static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
-				     struct ieee80211_channel_switch *ch_switch)
-{
-	/*
-	 * MULTI-FIXME
-	 * See iwlagn_mac_channel_switch.
-	 */
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwl6000_channel_switch_cmd cmd;
-	const struct iwl_channel_info *ch_info;
-	u32 switch_time_in_usec, ucode_switch_time;
-	u16 ch;
-	u32 tsf_low;
-	u8 switch_count;
-	u16 beacon_interval = le16_to_cpu(ctx->timing.beacon_interval);
-	struct ieee80211_vif *vif = ctx->vif;
-	struct iwl_host_cmd hcmd = {
-		.id = REPLY_CHANNEL_SWITCH,
-		.len = { sizeof(cmd), },
-		.flags = CMD_SYNC,
-		.data = { &cmd, },
-	};
-
-	cmd.band = priv->band == IEEE80211_BAND_2GHZ;
-	ch = ch_switch->channel->hw_value;
-	IWL_DEBUG_11H(priv, "channel switch from %u to %u\n",
-		      ctx->active.channel, ch);
-	cmd.channel = cpu_to_le16(ch);
-	cmd.rxon_flags = ctx->staging.flags;
-	cmd.rxon_filter_flags = ctx->staging.filter_flags;
-	switch_count = ch_switch->count;
-	tsf_low = ch_switch->timestamp & 0x0ffffffff;
-	/*
-	 * calculate the ucode channel switch time
-	 * adding TSF as one of the factor for when to switch
-	 */
-	if ((priv->ucode_beacon_time > tsf_low) && beacon_interval) {
-		if (switch_count > ((priv->ucode_beacon_time - tsf_low) /
-		    beacon_interval)) {
-			switch_count -= (priv->ucode_beacon_time -
-				tsf_low) / beacon_interval;
-		} else
-			switch_count = 0;
-	}
-	if (switch_count <= 1)
-		cmd.switch_time = cpu_to_le32(priv->ucode_beacon_time);
-	else {
-		switch_time_in_usec =
-			vif->bss_conf.beacon_int * switch_count * TIME_UNIT;
-		ucode_switch_time = iwl_usecs_to_beacons(priv,
-							 switch_time_in_usec,
-							 beacon_interval);
-		cmd.switch_time = iwl_add_beacon_time(priv,
-						      priv->ucode_beacon_time,
-						      ucode_switch_time,
-						      beacon_interval);
-	}
-	IWL_DEBUG_11H(priv, "uCode time for the switch is 0x%x\n",
-		      cmd.switch_time);
-	ch_info = iwl_get_channel_info(priv, priv->band, ch);
-	if (ch_info)
-		cmd.expect_beacon = is_channel_radar(ch_info);
-	else {
-		IWL_ERR(priv, "invalid channel switch from %u to %u\n",
-			ctx->active.channel, ch);
-		return -EFAULT;
-	}
-
-	return iwl_dvm_send_cmd(priv, &hcmd);
-}
-
-static struct iwl_lib_ops iwl6000_lib = {
-	.set_hw_params = iwl6000_hw_set_hw_params,
-	.set_channel_switch = iwl6000_hw_channel_switch,
-	.nic_config = iwl6000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-		.enhanced_txpower = true,
-	},
-	.temperature = iwlagn_temperature,
-};
-
-static struct iwl_lib_ops iwl6030_lib = {
-	.set_hw_params = iwl6000_hw_set_hw_params,
-	.set_channel_switch = iwl6000_hw_channel_switch,
-	.nic_config = iwl6000_nic_config,
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-		.enhanced_txpower = true,
-	},
-	.temperature = iwlagn_temperature,
-};
-
 static const struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -337,7 +128,6 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
-	.lib = &iwl6000_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
 	.need_temp_offset_calib = true,				\
 	.led_mode = IWL_LED_RF_STATE
@@ -392,7 +182,6 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
-	.lib = &iwl6030_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
 	.need_temp_offset_calib = true,				\
@@ -466,7 +255,6 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
-	.lib = &iwl6000_lib,					\
 	.base_params = &iwl6000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -495,7 +283,6 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
-	.lib = &iwl6000_lib,					\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -520,7 +307,6 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.device_family = IWL_DEVICE_FAMILY_6150,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
-	.lib = &iwl6000_lib,					\
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -549,7 +335,6 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.max_data_size = IWL60_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.lib = &iwl6000_lib,
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.led_mode = IWL_LED_BLINK,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index eb7ecb5..3bc86b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -520,8 +520,8 @@ static int iwlagn_rx_statistics(struct iwl_priv *priv,
 		iwlagn_rx_calc_noise(priv);
 		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
-	if (cfg(priv)->lib->temperature && change)
-		cfg(priv)->lib->temperature(priv);
+	if (priv->lib->temperature && change)
+		priv->lib->temperature(priv);
 
 	spin_unlock(&priv->statistics.lock);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ab996f9..65b3fc2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1391,7 +1391,7 @@ static void iwl_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	/* Device-specific setup */
-	cfg(priv)->lib->set_hw_params(priv);
+	priv->lib->set_hw_params(priv);
 }
 
 
@@ -1468,6 +1468,42 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv->shrd = trans->shrd;
 	priv->fw = fw;
 
+	switch (cfg(priv)->device_family) {
+	case IWL_DEVICE_FAMILY_1000:
+	case IWL_DEVICE_FAMILY_100:
+		priv->lib = &iwl1000_lib;
+		break;
+	case IWL_DEVICE_FAMILY_2000:
+	case IWL_DEVICE_FAMILY_105:
+		priv->lib = &iwl2000_lib;
+		break;
+	case IWL_DEVICE_FAMILY_2030:
+	case IWL_DEVICE_FAMILY_135:
+		priv->lib = &iwl2030_lib;
+		break;
+	case IWL_DEVICE_FAMILY_5000:
+		priv->lib = &iwl5000_lib;
+		break;
+	case IWL_DEVICE_FAMILY_5150:
+		priv->lib = &iwl5150_lib;
+		break;
+	case IWL_DEVICE_FAMILY_6000:
+	case IWL_DEVICE_FAMILY_6005:
+	case IWL_DEVICE_FAMILY_6000i:
+	case IWL_DEVICE_FAMILY_6050:
+	case IWL_DEVICE_FAMILY_6150:
+		priv->lib = &iwl6000_lib;
+		break;
+	case IWL_DEVICE_FAMILY_6030:
+		priv->lib = &iwl6030_lib;
+		break;
+	default:
+		break;
+	}
+
+	if (WARN_ON(!priv->lib))
+		goto out_free_traffic_mem;
+
 	/*
 	 * Populate the state variables that the transport layer needs
 	 * to know about.
@@ -2109,7 +2145,7 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 
-	cfg(priv)->lib->nic_config(priv);
+	priv->lib->nic_config(priv);
 }
 
 static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, int queue)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 17b82e5..6ebb3f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -71,6 +71,16 @@
 /* AUX (TX during scan dwell) queue */
 #define IWL_AUX_QUEUE		10
 
+/* device operations */
+extern struct iwl_lib_ops iwl1000_lib;
+extern struct iwl_lib_ops iwl2000_lib;
+extern struct iwl_lib_ops iwl2030_lib;
+extern struct iwl_lib_ops iwl5000_lib;
+extern struct iwl_lib_ops iwl5150_lib;
+extern struct iwl_lib_ops iwl6000_lib;
+extern struct iwl_lib_ops iwl6030_lib;
+
+
 
 struct iwl_ucode_capabilities;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index bdf2a77..47bfd5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -66,8 +66,6 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-struct iwl_lib_ops;
-
 
 enum iwl_device_family {
 	IWL_DEVICE_FAMILY_UNDEFINED,
@@ -212,7 +210,6 @@ struct iwl_cfg {
 	u8   valid_rx_ant;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
-	const struct iwl_lib_ops *lib;
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 999a806..96a2f8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -74,21 +74,6 @@ struct iwl_cmd;
 
 #define TIME_UNIT		1024
 
-struct iwl_lib_ops {
-	/* set hw dependent parameters */
-	void (*set_hw_params)(struct iwl_priv *priv);
-	int (*set_channel_switch)(struct iwl_priv *priv,
-				  struct ieee80211_channel_switch *ch_switch);
-	/* device specific configuration */
-	void (*nic_config)(struct iwl_priv *priv);
-
-	/* eeprom operations (as defined in iwl-eeprom.h) */
-	struct iwl_eeprom_ops eeprom_ops;
-
-	/* temperature */
-	void (*temperature)(struct iwl_priv *priv);
-};
-
 /***************************
  *   L i b                 *
  ***************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4a24e86..2c41423 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -704,6 +704,21 @@ struct iwl_hw_params {
 	const struct iwl_sensitivity_ranges *sens;
 };
 
+struct iwl_lib_ops {
+	/* set hw dependent parameters */
+	void (*set_hw_params)(struct iwl_priv *priv);
+	int (*set_channel_switch)(struct iwl_priv *priv,
+				  struct ieee80211_channel_switch *ch_switch);
+	/* device specific configuration */
+	void (*nic_config)(struct iwl_priv *priv);
+
+	/* eeprom operations (as defined in iwl-eeprom.h) */
+	struct iwl_eeprom_ops eeprom_ops;
+
+	/* temperature */
+	void (*temperature)(struct iwl_priv *priv);
+};
+
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 struct iwl_testmode_trace {
 	u32 buff_size;
@@ -740,6 +755,7 @@ struct iwl_priv {
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
 	const struct iwl_fw *fw;
+	const struct iwl_lib_ops *lib;
 	unsigned long status;
 
 	spinlock_t sta_lock;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 1db98d6..a004431 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -836,7 +836,7 @@ static void iwl_init_band_reference(struct iwl_priv *priv,
 			const struct iwl_eeprom_channel **eeprom_ch_info,
 			const u8 **eeprom_ch_index)
 {
-	u32 offset = cfg(priv)->lib->
+	u32 offset = priv->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
@@ -1043,9 +1043,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	}
 
 	/* Check if we do have HT40 channels */
-	if (cfg(priv)->lib->eeprom_ops.regulatory_bands[5] ==
+	if (priv->lib->eeprom_ops.regulatory_bands[5] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    cfg(priv)->lib->eeprom_ops.regulatory_bands[6] ==
+	    priv->lib->eeprom_ops.regulatory_bands[6] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
@@ -1081,7 +1081,7 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	 * driver need to process addition information
 	 * to determine the max channel tx power limits
 	 */
-	if (cfg(priv)->lib->eeprom_ops.enhanced_txpower)
+	if (priv->lib->eeprom_ops.enhanced_txpower)
 		iwl_eeprom_enhanced_txpower(priv);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index e084a4b..9dff92d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -866,7 +866,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	if (!cfg(priv)->lib->set_channel_switch)
+	if (!priv->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -902,7 +902,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 	priv->switch_channel = cpu_to_le16(ch);
-	if (cfg(priv)->lib->set_channel_switch(priv, ch_switch)) {
+	if (priv->lib->set_channel_switch(priv, ch_switch)) {
 		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 		priv->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
-- 
1.7.0.4

