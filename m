Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0BSGDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: indicate calib version for 6050 series
Date: Thu, 18 Feb 2010 22:03:05 -0800
Message-Id: <1266559387-19637-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Indicate calibration version to uCode

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   79 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    2 +-
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 782e23a..c4844ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -70,6 +70,14 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
+/* Indicate calibration version to uCode. */
+static void iwl6050_set_calib_version(struct iwl_priv *priv)
+{
+	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
+		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+}
+
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
@@ -96,6 +104,8 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* else do nothing, uCode configured */
+	if (priv->cfg->ops->lib->temp_ops.set_calib_version)
+		priv->cfg->ops->lib->temp_ops.set_calib_version(priv);
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -277,6 +287,71 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
+static struct iwl_lib_ops iwl6050_lib = {
+	.set_hw_params = iwl6000_hw_set_hw_params,
+	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwl5000_txq_set_sched,
+	.txq_agg_enable = iwl5000_txq_agg_enable,
+	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl_hw_txq_free_tfd,
+	.txq_init = iwl_hw_tx_queue_init,
+	.rx_handler_setup = iwl5000_rx_handler_setup,
+	.setup_deferred_work = iwl5000_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.load_ucode = iwl5000_load_ucode,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
+	.dump_fh = iwl_dump_fh,
+	.init_alive_start = iwl5000_init_alive_start,
+	.alive_notify = iwl5000_alive_notify,
+	.send_tx_power = iwl5000_send_tx_power,
+	.update_chain_flags = iwl_update_chain_flags,
+	.set_channel_switch = iwl6000_hw_channel_switch,
+	.apm_ops = {
+		.init = iwl_apm_init,
+		.stop = iwl_apm_stop,
+		.config = iwl6000_nic_config,
+		.set_pwr_src = iwl_set_pwr_src,
+	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_5000_REG_BAND_1_CHANNELS,
+			EEPROM_5000_REG_BAND_2_CHANNELS,
+			EEPROM_5000_REG_BAND_3_CHANNELS,
+			EEPROM_5000_REG_BAND_4_CHANNELS,
+			EEPROM_5000_REG_BAND_5_CHANNELS,
+			EEPROM_5000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_5000_REG_BAND_52_HT40_CHANNELS
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.calib_version	= iwl5000_eeprom_calib_version,
+		.query_addr = iwl5000_eeprom_query_addr,
+		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+	},
+	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
+	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl5000_temperature,
+		.set_ct_kill = iwl6000_set_ct_threshold,
+		.set_calib_version = iwl6050_set_calib_version,
+	 },
+	.add_bcast_station = iwl_add_bcast_station,
+};
+
+static const struct iwl_ops iwl6050_ops = {
+	.ucode = &iwl5000_ucode,
+	.lib = &iwl6050_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl5000_hcmd_utils,
+	.led = &iwlagn_led_ops,
+};
+
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
@@ -380,7 +455,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -412,7 +487,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6347d4b..3df7933 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -117,6 +117,7 @@ struct iwl_apm_ops {
 struct iwl_temp_ops {
 	void (*temperature)(struct iwl_priv *priv);
 	void (*set_ct_kill)(struct iwl_priv *priv);
+	void (*set_calib_version)(struct iwl_priv *priv);
 };
 
 struct iwl_ucode_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 1e00720..808b714 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -369,7 +369,7 @@
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_3x3_HYB	    (0x00000000)
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_HYB	    (0x00000001)
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA	    (0x00000002)
-
+#define CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6	(0x00000004)
 
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
-- 
1.6.3.3

