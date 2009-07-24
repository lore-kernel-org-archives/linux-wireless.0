Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbZGXSNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/14] iwlwifi: critical temperature enter/exit condition
Date: Fri, 24 Jul 2009 11:13:01 -0700
Message-Id: <1248459194-10239-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If advance thermal throttling is used the driver need to pass both
"enter" and "exit" temperature to uCode.

Using different critical temperature threshold for legacy and advance
thermal throttling management based on the type of thermal throttling
method is used except 1000.
For 1000, it use advance thermal throttling critical temperature
threshold, but with legacy thermal management implementation until ucode
has the necessary implementations in place.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |   76 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   44 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |   59 ++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   22 +++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   34 ++++++++++++-
 7 files changed, 217 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a899be9..80a2818 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -55,13 +55,87 @@
 #define _IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
 #define IWL1000_MODULE_FIRMWARE(api) _IWL1000_MODULE_FIRMWARE(api)
 
+
+/*
+ * For 1000, use advance thermal throttling critical temperature threshold,
+ * but legacy thermal management implementation for now.
+ * This is for the reason of 1000 uCode using advance thermal throttling API
+ * but not implement ct_kill_exit based on ct_kill exit temperature
+ * so the thermal throttling will still based on legacy thermal throttling
+ * management.
+ * The code here need to be modified once 1000 uCode has the advanced thermal
+ * throttling algorithm in place
+ */
+static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
+{
+	/* want Celsius */
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
+	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+}
+
+static struct iwl_lib_ops iwl1000_lib = {
+	.set_hw_params = iwl5000_hw_set_hw_params,
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
+	.init_alive_start = iwl5000_init_alive_start,
+	.alive_notify = iwl5000_alive_notify,
+	.send_tx_power = iwl5000_send_tx_power,
+	.update_chain_flags = iwl_update_chain_flags,
+	.apm_ops = {
+		.init =	iwl5000_apm_init,
+		.reset = iwl5000_apm_reset,
+		.stop = iwl5000_apm_stop,
+		.config = iwl5000_nic_config,
+		.set_pwr_src = iwl_set_pwr_src,
+	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_5000_REG_BAND_1_CHANNELS,
+			EEPROM_5000_REG_BAND_2_CHANNELS,
+			EEPROM_5000_REG_BAND_3_CHANNELS,
+			EEPROM_5000_REG_BAND_4_CHANNELS,
+			EEPROM_5000_REG_BAND_5_CHANNELS,
+			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
+			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.calib_version	= iwl5000_eeprom_calib_version,
+		.query_addr = iwl5000_eeprom_query_addr,
+	},
+	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
+	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl5000_temperature,
+		.set_ct_kill = iwl1000_set_ct_threshold,
+	 },
+};
+
+static struct iwl_ops iwl1000_ops = {
+	.lib = &iwl1000_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl5000_hcmd_utils,
+};
+
 struct iwl_cfg iwl1000_bgn_cfg = {
 	.name = "1000 Series BGN",
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl1000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c30a1b9..23925bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -776,7 +776,8 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 static void iwl4965_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Kelvin */
-	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+	priv->hw_params.ct_kill_threshold =
+		CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 702db07..076acb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -91,7 +91,7 @@ static int iwl5000_apm_stop_master(struct iwl_priv *priv)
 }
 
 
-static int iwl5000_apm_init(struct iwl_priv *priv)
+int iwl5000_apm_init(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -137,7 +137,7 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 }
 
 /* FIXME: this is identical to 4965 */
-static void iwl5000_apm_stop(struct iwl_priv *priv)
+void iwl5000_apm_stop(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
@@ -156,7 +156,7 @@ static void iwl5000_apm_stop(struct iwl_priv *priv)
 }
 
 
-static int iwl5000_apm_reset(struct iwl_priv *priv)
+int iwl5000_apm_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -198,7 +198,7 @@ out:
 }
 
 
-static void iwl5000_nic_config(struct iwl_priv *priv)
+void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
@@ -290,7 +290,7 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 	return (address & ADDRESS_MSK) + (offset << 1);
 }
 
-static u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
+u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv)
 {
 	struct iwl_eeprom_calib_hdr {
 		u8 version;
@@ -436,7 +436,7 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 	.nrg_th_ofdm = 95,
 };
 
-static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
+const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
 	u32 address = eeprom_indirect_address(priv, offset);
@@ -447,7 +447,7 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
 	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
-	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD) -
+	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD_LEGACY) -
 			iwl_temp_calib_to_offset(priv);
 
 	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
@@ -456,7 +456,7 @@ static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
-	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD_LEGACY;
 }
 
 /*
@@ -631,7 +631,7 @@ static int iwl5000_load_given_ucode(struct iwl_priv *priv,
 	return ret;
 }
 
-static int iwl5000_load_ucode(struct iwl_priv *priv)
+int iwl5000_load_ucode(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -658,7 +658,7 @@ static int iwl5000_load_ucode(struct iwl_priv *priv)
 	return ret;
 }
 
-static void iwl5000_init_alive_start(struct iwl_priv *priv)
+void iwl5000_init_alive_start(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -734,7 +734,7 @@ static int iwl5000_send_wimax_coex(struct iwl_priv *priv)
 				sizeof(coex_cmd), &coex_cmd);
 }
 
-static int iwl5000_alive_notify(struct iwl_priv *priv)
+int iwl5000_alive_notify(struct iwl_priv *priv)
 {
 	u32 a;
 	unsigned long flags;
@@ -821,7 +821,7 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
+int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
@@ -892,7 +892,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 /**
  * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
-static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
@@ -932,7 +932,7 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
 
-static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq)
 {
 	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
@@ -987,7 +987,7 @@ static void iwl5000_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
 		(1 << IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 				  int tx_fifo, int sta_id, int tid, u16 ssn_idx)
 {
 	unsigned long flags;
@@ -1048,7 +1048,7 @@ static int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	return 0;
 }
 
-static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
@@ -1091,7 +1091,7 @@ u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
  * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
  * must be called under priv->lock and mac access
  */
-static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
+void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
 	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
 }
@@ -1312,13 +1312,13 @@ u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 	return len;
 }
 
-static void iwl5000_setup_deferred_work(struct iwl_priv *priv)
+void iwl5000_setup_deferred_work(struct iwl_priv *priv)
 {
 	/* in 5000 the tx power calibration is done in uCode */
 	priv->disable_tx_power_cal = 1;
 }
 
-static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
+void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* init calibration handlers */
 	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
@@ -1329,7 +1329,7 @@ static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 }
 
 
-static int iwl5000_hw_valid_rtc_data_addr(u32 addr)
+int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWL50_RTC_DATA_LOWER_BOUND) &&
 		(addr < IWL50_RTC_DATA_UPPER_BOUND);
@@ -1381,7 +1381,7 @@ static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
 
 	return ret;
 }
-static int  iwl5000_send_tx_power(struct iwl_priv *priv)
+int  iwl5000_send_tx_power(struct iwl_priv *priv)
 {
 	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
 	u8 tx_ant_cfg_cmd;
@@ -1401,7 +1401,7 @@ static int  iwl5000_send_tx_power(struct iwl_priv *priv)
 				       NULL);
 }
 
-static void iwl5000_temperature(struct iwl_priv *priv)
+void iwl5000_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from statistics (in Celsius) */
 	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 26c5d4a..59ff735 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -61,6 +61,63 @@
 #define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
 #define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
 
+static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
+{
+	/* want Celsius */
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
+}
+
+static struct iwl_lib_ops iwl6000_lib = {
+	.set_hw_params = iwl5000_hw_set_hw_params,
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
+	.init_alive_start = iwl5000_init_alive_start,
+	.alive_notify = iwl5000_alive_notify,
+	.send_tx_power = iwl5000_send_tx_power,
+	.update_chain_flags = iwl_update_chain_flags,
+	.apm_ops = {
+		.init =	iwl5000_apm_init,
+		.reset = iwl5000_apm_reset,
+		.stop = iwl5000_apm_stop,
+		.config = iwl5000_nic_config,
+		.set_pwr_src = iwl_set_pwr_src,
+	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_5000_REG_BAND_1_CHANNELS,
+			EEPROM_5000_REG_BAND_2_CHANNELS,
+			EEPROM_5000_REG_BAND_3_CHANNELS,
+			EEPROM_5000_REG_BAND_4_CHANNELS,
+			EEPROM_5000_REG_BAND_5_CHANNELS,
+			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
+			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.calib_version	= iwl5000_eeprom_calib_version,
+		.query_addr = iwl5000_eeprom_query_addr,
+	},
+	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
+	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl5000_temperature,
+		.set_ct_kill = iwl6000_set_ct_threshold,
+	 },
+};
+
 static struct iwl_hcmd_utils_ops iwl6000_hcmd_utils = {
 	.get_hcmd_size = iwl5000_get_hcmd_size,
 	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
@@ -70,7 +127,7 @@ static struct iwl_hcmd_utils_ops iwl6000_hcmd_utils = {
 
 static struct iwl_ops iwl6000_ops = {
 	.ucode = &iwl5000_ucode,
-	.lib = &iwl5000_lib,
+	.lib = &iwl6000_lib,
 	.hcmd = &iwl5000_hcmd,
 	.utils = &iwl6000_hcmd_utils,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ebb2fbc..39ede57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2413,6 +2413,13 @@ struct iwl_ct_kill_config {
 	__le32   critical_temperature_R;
 }  __attribute__ ((packed));
 
+/* 1000, and 6x00 */
+struct iwl_ct_kill_throttling_config {
+	__le32   critical_temperature_exit;
+	__le32   reserved;
+	__le32   critical_temperature_enter;
+}  __attribute__ ((packed));
+
 /******************************************************************************
  * (8)
  * Scan Commands, Responses, Notifications:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6aea026..5ef3c37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2224,6 +2224,7 @@ EXPORT_SYMBOL(iwl_verify_ucode);
 void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl_ct_kill_config cmd;
+	struct iwl_ct_kill_throttling_config adv_cmd;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2232,9 +2233,26 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	cmd.critical_temperature_R =
-		cpu_to_le32(priv->hw_params.ct_kill_threshold);
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_1000:
+	case CSR_HW_REV_TYPE_6x00:
+	case CSR_HW_REV_TYPE_6x50:
+		adv_cmd.critical_temperature_enter =
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+		adv_cmd.critical_temperature_exit =
+			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
+
+		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+				       sizeof(adv_cmd), &adv_cmd);
+		break;
+	default:
+		cmd.critical_temperature_R =
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 
+		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+				       sizeof(cmd), &cmd);
+		break;
+	}
 	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 			       sizeof(cmd), &cmd);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0751891..cddf173 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -63,6 +63,8 @@ extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 
+struct iwl_tx_queue;
+
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
 extern struct iwl_ops iwl5000_ops;
@@ -79,9 +81,37 @@ extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 				    __le32 *tx_flags);
 extern int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp);
+extern int iwl5000_apm_init(struct iwl_priv *priv);
+extern void iwl5000_apm_stop(struct iwl_priv *priv);
+extern int iwl5000_apm_reset(struct iwl_priv *priv);
+extern void iwl5000_nic_config(struct iwl_priv *priv);
+extern u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv);
+extern const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
+				    size_t offset);
+extern void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					    struct iwl_tx_queue *txq,
+					    u16 byte_cnt);
+extern void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+				    struct iwl_tx_queue *txq);
+extern int iwl5000_load_ucode(struct iwl_priv *priv);
+extern void iwl5000_init_alive_start(struct iwl_priv *priv);
+extern int iwl5000_alive_notify(struct iwl_priv *priv);
+extern int iwl5000_hw_set_hw_params(struct iwl_priv *priv);
+extern int iwl5000_txq_agg_enable(struct iwl_priv *priv, int txq_id,
+			   int tx_fifo, int sta_id, int tid, u16 ssn_idx);
+extern int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+			    u16 ssn_idx, u8 tx_fifo);
+extern void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask);
+extern void iwl5000_setup_deferred_work(struct iwl_priv *priv);
+extern void iwl5000_rx_handler_setup(struct iwl_priv *priv);
+extern int iwl5000_hw_valid_rtc_data_addr(u32 addr);
+extern int iwl5000_send_tx_power(struct iwl_priv *priv);
+extern void iwl5000_temperature(struct iwl_priv *priv);
 
 /* CT-KILL constants */
-#define CT_KILL_THRESHOLD	110 /* in Celsius */
+#define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
+#define CT_KILL_THRESHOLD	   114 /* in Celsius */
+#define CT_KILL_EXIT_THRESHOLD     95  /* in Celsius */
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
@@ -630,6 +660,8 @@ struct iwl_hw_params {
 	u32 max_data_size;
 	u32 max_bsm_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
+	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
+				    /* for 1000, 6000 series and up */
 	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 };
-- 
1.5.6.3

