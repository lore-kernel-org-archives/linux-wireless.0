Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab0JFPXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/6] iwlagn: reduce redundant parameter definitions
Date: Wed,  6 Oct 2010 08:23:09 -0700
Message-Id: <1286378593-7509-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

move paramater definitions to a device paramater structure only
leaving the device name, which antennas are used and what firmware
file to use in the iwl_cfg structure.  this will not completely
remove the redundancies but greatly reduce them for devices that
only vary by name or antennas.  the parameters that are more
likely to change within a given device family are left in iwl_cfg.
also separate bt param structure added to help reduce more.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c        |  121 ++----
 drivers/net/wireless/iwlwifi/iwl-3945.c        |   43 +--
 drivers/net/wireless/iwlwifi/iwl-4965.c        |   47 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |  191 +++------
 drivers/net/wireless/iwlwifi/iwl-6000.c        |  523 ++++++------------------
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   40 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |   11 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   33 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   43 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c        |   95 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h        |  129 ++++---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |   58 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   12 +-
 drivers/net/wireless/iwlwifi/iwl-led.c         |    6 +-
 drivers/net/wireless/iwlwifi/iwl-power.c       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c    |   17 +-
 24 files changed, 565 insertions(+), 887 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 19dbef0..134f545 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -126,13 +126,13 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->num_of_queues =
+		priv->cfg->base_params->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
+			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
@@ -250,29 +250,16 @@ static const struct iwl_ops iwl1000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-struct iwl_cfg iwl1000_bgn_cfg = {
-	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
-	.fw_name_pre = IWL1000_FW_PRE,
-	.ucode_api_max = IWL1000_UCODE_API_MAX,
-	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl1000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
+static struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.set_l0s = true,
 	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
-	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
@@ -283,6 +270,26 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 };
+static struct iwl_ht_params iwl1000_ht_params = {
+	.ht_greenfield_support = true,
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
+};
+
+struct iwl_cfg iwl1000_bgn_cfg = {
+	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
+	.fw_name_pre = IWL1000_FW_PRE,
+	.ucode_api_max = IWL1000_UCODE_API_MAX,
+	.ucode_api_min = IWL1000_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
+	.ops = &iwl1000_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl1000_base_params,
+	.ht_params = &iwl1000_ht_params,
+};
 
 struct iwl_cfg iwl1000_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BG",
@@ -290,30 +297,13 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl1000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl1000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
-	.shadow_ram_support = false,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 128,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl1000_base_params,
 };
 
 struct iwl_cfg iwl100_bgn_cfg = {
@@ -322,32 +312,14 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl1000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl1000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
-	.shadow_ram_support = false,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 128,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl1000_base_params,
+	.ht_params = &iwl1000_ht_params,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
@@ -356,30 +328,13 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl1000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl1000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
-	.shadow_ram_support = false,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 128,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl1000_base_params,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 5d09686..cfdff54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -406,7 +406,7 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
 
-	if (priv->cfg->plcp_delta_threshold ==
+	if (priv->cfg->base_params->plcp_delta_threshold ==
 	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
 		return rc;
@@ -432,7 +432,7 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 
 		if ((combined_plcp_delta > 0) &&
 			((combined_plcp_delta * 100) / plcp_msec) >
-			priv->cfg->plcp_delta_threshold) {
+			priv->cfg->base_params->plcp_delta_threshold) {
 			/*
 			 * if plcp_err exceed the threshold, the following
 			 * data is printed in csv format:
@@ -444,7 +444,7 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
 			 */
 			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
 				"%u, %d, %u mSecs\n",
-				priv->cfg->plcp_delta_threshold,
+				priv->cfg->base_params->plcp_delta_threshold,
 				le32_to_cpu(current_stat.rx.ofdm.plcp_err),
 				combined_plcp_delta, plcp_msec);
 			/*
@@ -2421,7 +2421,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	/* Assign number of Usable TX queues */
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 
 	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
 	priv->hw_params.rx_page_order = get_order(IWL_RX_BUF_SIZE_3K);
@@ -2722,22 +2722,12 @@ static const struct iwl_ops iwl3945_ops = {
 	.led = &iwl3945_led_ops,
 };
 
-static struct iwl_cfg iwl3945_bg_cfg = {
-	.name = "3945BG",
-	.fw_name_pre = IWL3945_FW_PRE,
-	.ucode_api_max = IWL3945_UCODE_API_MAX,
-	.ucode_api_min = IWL3945_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
+static struct iwl_base_params iwl3945_base_params = {
 	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
-	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
-	.ops = &iwl3945_ops,
-	.num_of_queues = IWL39_NUM_QUEUES,
-	.mod_params = &iwl3945_mod_params,
 	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
 	.set_l0s = false,
 	.use_bsm = true,
 	.use_isr_legacy = true,
-	.ht_greenfield_support = false,
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
@@ -2746,25 +2736,28 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.tx_power_by_driver = true,
 };
 
+static struct iwl_cfg iwl3945_bg_cfg = {
+	.name = "3945BG",
+	.fw_name_pre = IWL3945_FW_PRE,
+	.ucode_api_max = IWL3945_UCODE_API_MAX,
+	.ucode_api_min = IWL3945_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
+	.ops = &iwl3945_ops,
+	.mod_params = &iwl3945_mod_params,
+	.base_params = &iwl3945_base_params,
+};
+
 static struct iwl_cfg iwl3945_abg_cfg = {
 	.name = "3945ABG",
 	.fw_name_pre = IWL3945_FW_PRE,
 	.ucode_api_max = IWL3945_UCODE_API_MAX,
 	.ucode_api_min = IWL3945_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.eeprom_size = IWL3945_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_3945_EEPROM_VERSION,
 	.ops = &iwl3945_ops,
-	.num_of_queues = IWL39_NUM_QUEUES,
 	.mod_params = &iwl3945_mod_params,
-	.use_isr_legacy = true,
-	.ht_greenfield_support = false,
-	.led_compensation = 64,
-	.broken_powersave = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.tx_power_by_driver = true,
+	.base_params = &iwl3945_base_params,
 };
 
 DEFINE_PCI_DEVICE_TABLE(iwl3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 943a9c7..834c2f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -647,13 +647,13 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWL49_NUM_QUEUES)
-		priv->cfg->num_of_queues =
+		priv->cfg->base_params->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
+			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwl4965_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
@@ -1724,13 +1724,13 @@ static int iwl4965_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 				   u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
+	    (IWL49_FIRST_AMPDU_QUEUE +
+		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
+			priv->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -1792,13 +1792,13 @@ static int iwl4965_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	int ret;
 
 	if ((IWL49_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL49_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
+	    (IWL49_FIRST_AMPDU_QUEUE +
+		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWL49_FIRST_AMPDU_QUEUE,
 			IWL49_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
+			priv->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -2302,26 +2302,14 @@ static const struct iwl_ops iwl4965_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-struct iwl_cfg iwl4965_agn_cfg = {
-	.name = "Intel(R) Wireless WiFi Link 4965AGN",
-	.fw_name_pre = IWL4965_FW_PRE,
-	.ucode_api_max = IWL4965_UCODE_API_MAX,
-	.ucode_api_min = IWL4965_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+static struct iwl_base_params iwl4965_base_params = {
 	.eeprom_size = IWL4965_EEPROM_IMG_SIZE,
-	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
-	.ops = &iwl4965_ops,
 	.num_of_queues = IWL49_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
-	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = true,
 	.use_isr_legacy = true,
-	.ht_greenfield_support = false,
 	.broken_powersave = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
@@ -2333,6 +2321,21 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+};
+
+struct iwl_cfg iwl4965_agn_cfg = {
+	.name = "Intel(R) Wireless WiFi Link 4965AGN",
+	.fw_name_pre = IWL4965_FW_PRE,
+	.ucode_api_max = IWL4965_UCODE_API_MAX,
+	.ucode_api_min = IWL4965_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_ABC,
+	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
+	.ops = &iwl4965_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl4965_base_params,
 	/*
 	 * Force use of chains B and C for scan RX on 5 GHz band
 	 * because the device has off-channel reception on chain A.
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 21b4b23..1b25ad6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -170,13 +170,13 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->num_of_queues =
+		priv->cfg->base_params->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
+			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
@@ -217,13 +217,13 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->num_of_queues =
+		priv->cfg->base_params->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
+			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
@@ -504,27 +504,14 @@ static const struct iwl_ops iwl5150_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-struct iwl_cfg iwl5300_agn_cfg = {
-	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
-	.fw_name_pre = IWL5000_FW_PRE,
-	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+static struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.set_l0s = true,
 	.use_bsm = false,
-	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
@@ -534,6 +521,26 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
 };
+static struct iwl_ht_params iwl5000_ht_params = {
+	.ht_greenfield_support = true,
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
+};
+
+struct iwl_cfg iwl5300_agn_cfg = {
+	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
+	.fw_name_pre = IWL5000_FW_PRE,
+	.ucode_api_max = IWL5000_UCODE_API_MAX,
+	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.ops = &iwl5000_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl5000_base_params,
+	.ht_params = &iwl5000_ht_params,
+};
 
 struct iwl_cfg iwl5100_bgn_cfg = {
 	.name = "Intel(R) WiFi Link 5100 BGN",
@@ -541,29 +548,14 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
+	.ht_params = &iwl5000_ht_params,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -572,27 +564,13 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl5000_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -601,29 +579,14 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
+	.ht_params = &iwl5000_ht_params,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -632,29 +595,14 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
+	.ht_params = &iwl5000_ht_params,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -663,29 +611,14 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5150_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5150_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
+	.ht_params = &iwl5000_ht_params,
 	.need_dc_calib = true,
 };
 
@@ -695,27 +628,13 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl5150_ops,
-	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl5150_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
-	.set_l0s = true,
-	.use_bsm = false,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl5000_base_params,
 	.need_dc_calib = true,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4d45932..5866ad8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -162,13 +162,13 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
 	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->num_of_queues =
+		priv->cfg->base_params->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.max_txq_num = priv->cfg->base_params->num_of_queues;
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
+			priv->cfg->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWLAGN_STATION_COUNT;
@@ -466,30 +466,16 @@ static const struct iwl_ops iwl6000g2b_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-struct iwl_cfg iwl6000g2a_2agn_cfg = {
-	.name = "6000 Series 2x2 AGN Gen2a",
-	.fw_name_pre = IWL6000G2A_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+static struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
 	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.supports_idle = true,
 	.adv_thermal_throttle = true,
@@ -501,29 +487,16 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
-	.need_dc_calib = true,
 };
 
-struct iwl_cfg iwl6000g2a_2abg_cfg = {
-	.name = "6000 Series 2x2 ABG Gen2a",
-	.fw_name_pre = IWL6000G2A_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
+static struct iwl_base_params iwl6050_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
 	.set_l0s = true,
 	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -531,11 +504,57 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.adv_thermal_throttle = true,
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
+	.chain_noise_scale = 1500,
 	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 512,
+	.max_event_log_size = 1024,
+	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+};
+
+static struct iwl_ht_params iwl6000_ht_params = {
+	.ht_greenfield_support = true,
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
+};
+
+static struct iwl_bt_params iwl6000_bt_params = {
+	.bt_statistics = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.advanced_bt_coexist = true,
+	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
+};
+
+struct iwl_cfg iwl6000g2a_2agn_cfg = {
+	.name = "6000 Series 2x2 AGN Gen2a",
+	.fw_name_pre = IWL6000G2A_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.ops = &iwl6000_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl6000_base_params,
+	.ht_params = &iwl6000_ht_params,
+	.need_dc_calib = true,
+};
+
+struct iwl_cfg iwl6000g2a_2abg_cfg = {
+	.name = "6000 Series 2x2 ABG Gen2a",
+	.fw_name_pre = IWL6000G2A_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.ops = &iwl6000_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
 };
 
@@ -545,32 +564,13 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
 	.need_dc_calib = true,
 };
 
@@ -580,41 +580,18 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
+	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -623,39 +600,17 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -664,41 +619,18 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
+	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -707,39 +639,17 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -748,41 +658,18 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
+	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -791,39 +678,17 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl6000g2b_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000g2b_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
-	.max_event_log_size = 512,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
 	.need_dc_calib = true,
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.advanced_bt_coexist = true,
-	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 /*
@@ -835,35 +700,15 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
+	.base_params = &iwl6000_base_params,
+	.ht_params = &iwl6000_ht_params,
 	.pa_type = IWL_PA_INTERNAL,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -872,33 +717,14 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
+	.base_params = &iwl6000_base_params,
 	.pa_type = IWL_PA_INTERNAL,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -907,33 +733,14 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_G,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
+	.base_params = &iwl6000_base_params,
 	.pa_type = IWL_PA_INTERNAL,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -942,35 +749,14 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6050_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.ops = &iwl6000_ops,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6050_base_params,
+	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 };
 
@@ -980,35 +766,14 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6050g2_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6050g2_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6050_base_params,
+	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
 };
 
@@ -1018,33 +783,13 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6050_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6050_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
-	.shadow_ram_support = true,
-	.led_compensation = 51,
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6050_base_params,
 	.need_dc_calib = true,
 };
 
@@ -1054,35 +799,15 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.num_of_queues = IWLAGN_NUM_QUEUES,
-	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
+	.ops = &iwl6000_ops,
 	.mod_params = &iwlagn_mod_params,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
-	.pll_cfg_val = 0,
-	.set_l0s = true,
-	.use_bsm = false,
-	.pa_type = IWL_PA_SYSTEM,
-	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
-	.shadow_ram_support = true,
-	.ht_greenfield_support = true,
-	.led_compensation = 51,
-	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
-	.supports_idle = true,
-	.adv_thermal_throttle = true,
-	.support_ct_kill_exit = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
-	.max_event_log_size = 1024,
-	.ucode_tracing = true,
-	.sensitivity_calib_by_driver = true,
-	.chain_noise_calib_by_driver = true,
+	.base_params = &iwl6000_base_params,
+	.ht_params = &iwl6000_ht_params,
+	.need_dc_calib = true,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 84ad629..4c5ab78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -631,7 +631,8 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		rx_info = &(((struct iwl_bt_notif_statistics *)resp)->
 			      rx.general.common);
 		ofdm = &(((struct iwl_bt_notif_statistics *)resp)->rx.ofdm);
@@ -786,7 +787,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		rx_info = &(((struct iwl_bt_notif_statistics *)stat_resp)->
 			      rx.general.common);
 	} else {
@@ -801,7 +803,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 
 	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
 	rxon_chnum = le16_to_cpu(ctx->staging.channel);
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		stat_band24 = !!(((struct iwl_bt_notif_statistics *)
 				 stat_resp)->flag &
 				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
@@ -861,16 +864,17 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	/* If this is the "chain_noise_num_beacons", determine:
 	 * 1)  Disconnected antennas (using signal strengths)
 	 * 2)  Differential gain (using silence noise) to balance receivers */
-	if (data->beacon_count != priv->cfg->chain_noise_num_beacons)
+	if (data->beacon_count !=
+		priv->cfg->base_params->chain_noise_num_beacons)
 		return;
 
 	/* Analyze signal for disconnected antenna */
-	average_sig[0] =
-		(data->chain_signal_a) / priv->cfg->chain_noise_num_beacons;
-	average_sig[1] =
-		(data->chain_signal_b) / priv->cfg->chain_noise_num_beacons;
-	average_sig[2] =
-		(data->chain_signal_c) / priv->cfg->chain_noise_num_beacons;
+	average_sig[0] = data->chain_signal_a /
+			 priv->cfg->base_params->chain_noise_num_beacons;
+	average_sig[1] = data->chain_signal_b /
+			 priv->cfg->base_params->chain_noise_num_beacons;
+	average_sig[2] = data->chain_signal_c /
+			 priv->cfg->base_params->chain_noise_num_beacons;
 
 	if (average_sig[0] >= average_sig[1]) {
 		max_average_sig = average_sig[0];
@@ -920,7 +924,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	 * To be safe, simply mask out any chains that we know
 	 * are not on the device.
 	 */
-	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		active_chains &= first_antenna(priv->hw_params.valid_rx_ant);
 	} else
@@ -967,12 +973,12 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 			active_chains);
 
 	/* Analyze noise for rx balance */
-	average_noise[0] =
-		((data->chain_noise_a) / priv->cfg->chain_noise_num_beacons);
-	average_noise[1] =
-		((data->chain_noise_b) / priv->cfg->chain_noise_num_beacons);
-	average_noise[2] =
-		((data->chain_noise_c) / priv->cfg->chain_noise_num_beacons);
+	average_noise[0] = data->chain_noise_a /
+			   priv->cfg->base_params->chain_noise_num_beacons;
+	average_noise[1] = data->chain_noise_b /
+			   priv->cfg->base_params->chain_noise_num_beacons;
+	average_noise[2] = data->chain_noise_c /
+			   priv->cfg->base_params->chain_noise_num_beacons;
 
 	for (i = 0; i < NUM_RX_CHAINS; i++) {
 		if (!(data->disconn_array[i]) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 5391b46..a358d43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -39,7 +39,8 @@ static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 	int p = 0;
 	u32 flag;
 
-	if (priv->cfg->bt_statistics)
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics)
 		flag = le32_to_cpu(priv->_agn.statistics_bt.flag);
 	else
 		flag = le32_to_cpu(priv->_agn.statistics.flag);
@@ -88,7 +89,8 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		ofdm = &priv->_agn.statistics_bt.rx.ofdm;
 		cck = &priv->_agn.statistics_bt.rx.cck;
 		general = &priv->_agn.statistics_bt.rx.general.common;
@@ -534,7 +536,8 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		tx = &priv->_agn.statistics_bt.tx;
 		accum_tx = &priv->_agn.accum_statistics_bt.tx;
 		delta_tx = &priv->_agn.delta_statistics_bt.tx;
@@ -734,7 +737,8 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		general = &priv->_agn.statistics_bt.general.common;
 		dbg = &priv->_agn.statistics_bt.general.common.dbg;
 		div = &priv->_agn.statistics_bt.general.common.div;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index d86902b..9ca6c91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -137,7 +137,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 			continue;
 		}
 
-		delta_g = (priv->cfg->chain_noise_scale *
+		delta_g = (priv->cfg->base_params->chain_noise_scale *
 			((s32)average_noise[default_chain] -
 			(s32)average_noise[i])) / 1500;
 
@@ -222,7 +222,8 @@ static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
 		return;
 	}
 
-	if (priv->cfg->use_rts_for_aggregation &&
+	if (priv->cfg->ht_params &&
+	    priv->cfg->ht_params->use_rts_for_aggregation &&
 	    info->flags & IEEE80211_TX_CTL_AMPDU) {
 		*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index c92b2c0..a5dbfea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -59,7 +59,7 @@ void iwl_free_isr_ict(struct iwl_priv *priv)
 int iwl_alloc_isr_ict(struct iwl_priv *priv)
 {
 
-	if (priv->cfg->use_isr_legacy)
+	if (priv->cfg->base_params->use_isr_legacy)
 		return 0;
 	/* allocate shrared data table */
 	priv->_agn.ict_tbl_vir =
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 299fd9d..29ed604 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -422,7 +422,8 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		 * notification again.
 		 */
 		if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
-		    priv->cfg->advanced_bt_coexist) {
+		    priv->cfg->bt_params &&
+		    priv->cfg->bt_params->advanced_bt_coexist) {
 			IWL_WARN(priv, "receive reply tx with bt_kill\n");
 		}
 		iwlagn_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
@@ -589,7 +590,7 @@ const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
 	u32 address = eeprom_indirect_address(priv, offset);
-	BUG_ON(address >= priv->cfg->eeprom_size);
+	BUG_ON(address >= priv->cfg->base_params->eeprom_size);
 	return &priv->eeprom[address];
 }
 
@@ -637,7 +638,7 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
 
-	if (!priv->cfg->use_isr_legacy)
+	if (!priv->cfg->base_params->use_isr_legacy)
 		rb_timeout = RX_RB_TIMEOUT;
 
 	if (priv->cfg->mod_params->amsdu_size_8K)
@@ -1424,7 +1425,8 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		 * Internal scans are passive, so we can indiscriminately set
 		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
 		 */
-		if (priv->cfg->advanced_bt_coexist)
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->advanced_bt_coexist)
 			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
 		scan->good_CRC_th = IWL_GOOD_CRC_TH_DISABLED;
 		break;
@@ -1463,10 +1465,12 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (priv->cfg->scan_tx_antennas[band])
 		scan_tx_antennas = priv->cfg->scan_tx_antennas[band];
 
-	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
-		scan_tx_antennas =
-			first_antenna(priv->cfg->scan_tx_antennas[band]);
+		scan_tx_antennas = first_antenna(
+			priv->cfg->scan_tx_antennas[band]);
 	}
 
 	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
@@ -1487,7 +1491,9 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 		rx_ant = first_antenna(active_chains);
 	}
-	if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		rx_ant = first_antenna(rx_ant);
 	}
@@ -1777,7 +1783,10 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
 			sizeof(bt_cmd.bt3_lookup_table));
 
-	bt_cmd.prio_boost = priv->cfg->bt_prio_boost;
+	if (priv->cfg->bt_params)
+		bt_cmd.prio_boost = priv->cfg->bt_params->bt_prio_boost;
+	else
+		bt_cmd.prio_boost = 0;
 	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
 	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
 	bt_cmd.valid = priv->bt_valid;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 57629fb..f865685 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2939,11 +2939,14 @@ static void rs_fill_link_cmd(struct iwl_priv *priv,
 	 * overwrite if needed, pass aggregation time limit
 	 * to uCode in uSec
 	 */
-	if (priv && priv->cfg->agg_time_limit &&
-	    priv->cfg->agg_time_limit >= LINK_QUAL_AGG_TIME_LIMIT_MIN &&
-	    priv->cfg->agg_time_limit <= LINK_QUAL_AGG_TIME_LIMIT_MAX)
+	if (priv && priv->cfg->bt_params &&
+	    priv->cfg->bt_params->agg_time_limit &&
+	    priv->cfg->bt_params->agg_time_limit >=
+		LINK_QUAL_AGG_TIME_LIMIT_MIN &&
+	    priv->cfg->bt_params->agg_time_limit <=
+		 LINK_QUAL_AGG_TIME_LIMIT_MAX)
 		lq_cmd->agg_params.agg_time_limit =
-			cpu_to_le16(priv->cfg->agg_time_limit);
+			cpu_to_le16(priv->cfg->bt_params->agg_time_limit);
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 9490ece..1e08eb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -73,7 +73,8 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 	int bcn_silence_a, bcn_silence_b, bcn_silence_c;
 	int last_rx_noise;
 
-	if (priv->cfg->bt_statistics)
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics)
 		rx_info = &(priv->_agn.statistics_bt.rx.general.common);
 	else
 		rx_info = &(priv->_agn.statistics.rx.general);
@@ -124,7 +125,8 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	struct statistics_general_common *general, *accum_general;
 	struct statistics_tx *tx, *accum_tx;
 
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		prev_stats = (__le32 *)&priv->_agn.statistics_bt;
 		accum_stats = (u32 *)&priv->_agn.accum_statistics_bt;
 		size = sizeof(struct iwl_bt_notif_statistics);
@@ -183,7 +185,7 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
 
-	if (priv->cfg->plcp_delta_threshold ==
+	if (priv->cfg->base_params->plcp_delta_threshold ==
 	    IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE) {
 		IWL_DEBUG_RADIO(priv, "plcp_err check disabled\n");
 		return rc;
@@ -205,7 +207,8 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 		struct statistics_rx_phy *ofdm;
 		struct statistics_rx_ht_phy *ofdm_ht;
 
-		if (priv->cfg->bt_statistics) {
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->bt_statistics) {
 			ofdm = &pkt->u.stats_bt.rx.ofdm;
 			ofdm_ht = &pkt->u.stats_bt.rx.ofdm_ht;
 			combined_plcp_delta =
@@ -229,7 +232,7 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 
 		if ((combined_plcp_delta > 0) &&
 		    ((combined_plcp_delta * 100) / plcp_msec) >
-			priv->cfg->plcp_delta_threshold) {
+			priv->cfg->base_params->plcp_delta_threshold) {
 			/*
 			 * if plcp_err exceed the threshold,
 			 * the following data is printed in csv format:
@@ -242,13 +245,13 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 			 *    plcp_msec
 			 */
 			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
-				    "%u, %u, %u, %u, %d, %u mSecs\n",
-				    priv->cfg->plcp_delta_threshold,
-				    le32_to_cpu(ofdm->plcp_err),
-				    le32_to_cpu(ofdm->plcp_err),
-				    le32_to_cpu(ofdm_ht->plcp_err),
-				    le32_to_cpu(ofdm_ht->plcp_err),
-				    combined_plcp_delta, plcp_msec);
+				"%u, %u, %u, %u, %d, %u mSecs\n",
+				priv->cfg->base_params->plcp_delta_threshold,
+				le32_to_cpu(ofdm->plcp_err),
+				le32_to_cpu(ofdm->plcp_err),
+				le32_to_cpu(ofdm_ht->plcp_err),
+				le32_to_cpu(ofdm_ht->plcp_err),
+				combined_plcp_delta, plcp_msec);
 
 			rc = false;
 		}
@@ -262,7 +265,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
-	if (priv->cfg->bt_statistics) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics) {
 		IWL_DEBUG_RX(priv,
 			     "Statistics notification received (%d vs %d).\n",
 			     (int)sizeof(struct iwl_bt_notif_statistics),
@@ -300,7 +304,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 	iwl_recover_from_statistics(priv, pkt);
 
-	if (priv->cfg->bt_statistics)
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->bt_statistics)
 		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
 			sizeof(priv->_agn.statistics_bt));
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 07b2c6c..0c6c4d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -114,7 +114,7 @@ static bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
 	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
 	bool within_margin = false;
 
-	if (priv->cfg->temperature_kelvin)
+	if (priv->cfg->base_params->temperature_kelvin)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
 	if (!priv->thermal_throttle.advanced_tt)
@@ -591,7 +591,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (priv->cfg->temperature_kelvin)
+	if (priv->cfg->base_params->temperature_kelvin)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
 	if (!priv->thermal_throttle.advanced_tt)
@@ -640,7 +640,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
 	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
 
-	if (priv->cfg->adv_thermal_throttle) {
+	if (priv->cfg->base_params->adv_thermal_throttle) {
 		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
 		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
 					 IWL_TI_STATE_MAX, GFP_KERNEL);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 5950184..77753b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -224,13 +224,13 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	int ret;
 
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
+	    (IWLAGN_FIRST_AMPDU_QUEUE +
+		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
+			priv->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -286,13 +286,13 @@ int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 			   u16 ssn_idx, u8 tx_fifo)
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
-	     <= txq_id)) {
+	    (IWLAGN_FIRST_AMPDU_QUEUE +
+		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
 		IWL_ERR(priv,
 			"queue number out of range: %d, must be %d to %d\n",
 			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
 			IWLAGN_FIRST_AMPDU_QUEUE +
-			priv->cfg->num_of_ampdu_queues - 1);
+			priv->cfg->base_params->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
 
@@ -350,7 +350,8 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 	if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
 	else if (info->band == IEEE80211_BAND_2GHZ &&
-		 priv->cfg->advanced_bt_coexist &&
+		 priv->cfg->bt_params &&
+		 priv->cfg->bt_params->advanced_bt_coexist &&
 		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
 		 ieee80211_is_reassoc_req(fc) ||
 		 skb->protocol == cpu_to_be16(ETH_P_PAE)))
@@ -444,7 +445,9 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	 if (priv->cfg->advanced_bt_coexist && priv->bt_full_concurrent) {
+	 if (priv->cfg->bt_params &&
+	     priv->cfg->bt_params->advanced_bt_coexist &&
+	     priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 				first_antenna(priv->hw_params.valid_tx_ant));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 8bfb049..e1dd762 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -307,7 +307,8 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	if (priv->cfg->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/*
 		 * Tell uCode we are ready to perform calibration
 		 * need to perform this before any calibration
@@ -330,7 +331,7 @@ static int iwlagn_send_wimax_coex(struct iwl_priv *priv)
 {
 	struct iwl_wimax_coex_cmd coex_cmd;
 
-	if (priv->cfg->support_wimax_coexist) {
+	if (priv->cfg->base_params->support_wimax_coexist) {
 		/* UnMask wake up src at associated sleep */
 		coex_cmd.flags = COEX_FLAGS_ASSOC_WA_UNMASK_MSK;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e7dc8b9..080121d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2256,13 +2256,15 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (pieces.init_evtlog_size)
 		priv->_agn.init_evtlog_size = (pieces.init_evtlog_size - 16)/12;
 	else
-		priv->_agn.init_evtlog_size = priv->cfg->max_event_log_size;
+		priv->_agn.init_evtlog_size =
+			priv->cfg->base_params->max_event_log_size;
 	priv->_agn.init_errlog_ptr = pieces.init_errlog_ptr;
 	priv->_agn.inst_evtlog_ptr = pieces.inst_evtlog_ptr;
 	if (pieces.inst_evtlog_size)
 		priv->_agn.inst_evtlog_size = (pieces.inst_evtlog_size - 16)/12;
 	else
-		priv->_agn.inst_evtlog_size = priv->cfg->max_event_log_size;
+		priv->_agn.inst_evtlog_size =
+			priv->cfg->base_params->max_event_log_size;
 	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
 
 	if (ucode_capa.pan) {
@@ -2732,7 +2734,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
 
-	if (priv->cfg->support_ct_kill_exit) {
+	if (priv->cfg->base_params->support_ct_kill_exit) {
 		adv_cmd.critical_temperature_enter =
 			cpu_to_le32(priv->hw_params.ct_kill_threshold);
 		adv_cmd.critical_temperature_exit =
@@ -2776,9 +2778,7 @@ static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
 
 	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
 	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
-	calib_cfg_cmd.ucd_calib_cfg.once.start = cfg;
-	calib_cfg_cmd.ucd_calib_cfg.once.send_res = 0;
-	calib_cfg_cmd.ucd_calib_cfg.flags = 0;
+	calib_cfg_cmd.ucd_calib_cfg.once.start = cpu_to_le32(cfg);
 
 	return iwl_send_cmd(priv, &cmd);
 }
@@ -2831,13 +2831,15 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		/* Enable timer to monitor the driver queues */
 		mod_timer(&priv->monitor_recover,
 			jiffies +
-			msecs_to_jiffies(priv->cfg->monitor_recover_period));
+			msecs_to_jiffies(
+			  priv->cfg->base_params->monitor_recover_period));
 	}
 
 	if (iwl_is_rfkill(priv))
 		return;
 
-	if (priv->cfg->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
@@ -2877,7 +2879,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
-	if (!priv->cfg->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    !priv->cfg->bt_params->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
 		priv->cfg->ops->hcmd->send_bt_config(priv);
 	}
@@ -2930,7 +2933,11 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	/* reset BT coex data */
 	priv->bt_status = 0;
-	priv->bt_traffic_load = priv->cfg->bt_init_traffic_load;
+	if (priv->cfg->bt_params)
+		priv->bt_traffic_load =
+			 priv->cfg->bt_params->bt_init_traffic_load;
+	else
+		priv->bt_traffic_load = 0;
 	priv->bt_sco_active = false;
 	priv->bt_full_concurrent = false;
 	priv->bt_ci_compliance = 0;
@@ -3224,7 +3231,8 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		if (priv->cfg->bt_statistics) {
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->bt_statistics) {
 			iwl_chain_noise_calibration(priv,
 					(void *)&priv->_agn.statistics_bt);
 			iwl_sensitivity_calibration(priv,
@@ -3423,7 +3431,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_NEED_DTIM_PERIOD |
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
-	if (!priv->cfg->broken_powersave)
+	if (!priv->cfg->base_params->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
@@ -3748,7 +3756,8 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			ret = 0;
-		if (priv->cfg->use_rts_for_aggregation) {
+		if (priv->cfg->ht_params &&
+		    priv->cfg->ht_params->use_rts_for_aggregation) {
 			struct iwl_station_priv *sta_priv =
 				(void *) sta->drv_priv;
 			/*
@@ -3762,7 +3771,8 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		}
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		if (priv->cfg->use_rts_for_aggregation) {
+		if (priv->cfg->ht_params &&
+		    priv->cfg->ht_params->use_rts_for_aggregation) {
 			struct iwl_station_priv *sta_priv =
 				(void *) sta->drv_priv;
 
@@ -4080,7 +4090,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 			priv->cfg->ops->lib->recover_from_tx_stall;
 	}
 
-	if (!priv->cfg->use_isr_legacy)
+	if (!priv->cfg->base_params->use_isr_legacy)
 		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 			iwl_irq_tasklet, (unsigned long)priv);
 	else
@@ -4165,7 +4175,8 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	iwl_init_scan_params(priv);
 
 	/* init bt coex */
-	if (priv->cfg->advanced_bt_coexist) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b7adcf8..95cbc55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -232,7 +232,8 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 
 	ht_info->ht_supported = true;
 
-	if (priv->cfg->ht_greenfield_support)
+	if (priv->cfg->ht_params &&
+	    priv->cfg->ht_params->ht_greenfield_support)
 		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
 	ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
 	max_bit_rate = MAX_BIT_RATE_20_MHZ;
@@ -247,11 +248,11 @@ static void iwlcore_init_ht_hw_capab(const struct iwl_priv *priv,
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = CFG_HT_RX_AMPDU_FACTOR_DEF;
-	if (priv->cfg->ampdu_factor)
-		ht_info->ampdu_factor = priv->cfg->ampdu_factor;
+	if (priv->cfg->bt_params && priv->cfg->bt_params->ampdu_factor)
+		ht_info->ampdu_factor = priv->cfg->bt_params->ampdu_factor;
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
-	if (priv->cfg->ampdu_density)
-		ht_info->ampdu_density = priv->cfg->ampdu_density;
+	if (priv->cfg->bt_params && priv->cfg->bt_params->ampdu_density)
+		ht_info->ampdu_density = priv->cfg->bt_params->ampdu_density;
 
 	ht_info->mcs.rx_mask[0] = 0xFF;
 	if (rx_chains_num >= 2)
@@ -850,8 +851,10 @@ EXPORT_SYMBOL(iwl_set_rxon_ht);
  */
 static int iwl_get_active_rx_chain_count(struct iwl_priv *priv)
 {
-	if (priv->cfg->advanced_bt_coexist && (priv->bt_full_concurrent ||
-	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    (priv->bt_full_concurrent ||
+	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
 		 * only use chain 'A' in bt high traffic load or
 		 * full concurrency mode
@@ -919,8 +922,10 @@ void iwl_set_rxon_chain(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	else
 		active_chains = priv->hw_params.valid_rx_ant;
 
-	if (priv->cfg->advanced_bt_coexist && (priv->bt_full_concurrent ||
-	    priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    (priv->bt_full_concurrent ||
+	     priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH)) {
 		/*
 		 * only use chain 'A' in bt high traffic load or
 		 * full concurrency mode
@@ -1362,7 +1367,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 * If not (unlikely), enable L0S, so there is at least some
 	 *    power savings, even without L1.
 	 */
-	if (priv->cfg->set_l0s) {
+	if (priv->cfg->base_params->set_l0s) {
 		lctl = iwl_pcie_link_ctl(priv);
 		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 					PCI_CFG_LINK_CTRL_VAL_L1_EN) {
@@ -1379,8 +1384,9 @@ int iwl_apm_init(struct iwl_priv *priv)
 	}
 
 	/* Configure analog phase-lock-loop before activating to D0A */
-	if (priv->cfg->pll_cfg_val)
-		iwl_set_bit(priv, CSR_ANA_PLL_CFG, priv->cfg->pll_cfg_val);
+	if (priv->cfg->base_params->pll_cfg_val)
+		iwl_set_bit(priv, CSR_ANA_PLL_CFG,
+			    priv->cfg->base_params->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -1411,7 +1417,7 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 * do not disable clocks.  This preserves any hardware bits already
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
-	if (priv->cfg->use_bsm)
+	if (priv->cfg->base_params->use_bsm)
 		iwl_write_prph(priv, APMG_CLK_EN_REG,
 			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
 	else
@@ -2054,7 +2060,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out_err;
 	}
 
-	if (priv->cfg->advanced_bt_coexist &&
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		/*
 		 * pretend to have high BT traffic as long as we
@@ -2317,7 +2324,8 @@ int iwl_alloc_txq_mem(struct iwl_priv *priv)
 {
 	if (!priv->txq)
 		priv->txq = kzalloc(
-			sizeof(struct iwl_tx_queue) * priv->cfg->num_of_queues,
+			sizeof(struct iwl_tx_queue) *
+				priv->cfg->base_params->num_of_queues,
 			GFP_KERNEL);
 	if (!priv->txq) {
 		IWL_ERR(priv, "Not enough memory for txq\n");
@@ -2828,33 +2836,34 @@ static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
 	txq = &priv->txq[cnt];
 	q = &txq->q;
 	/* queue is empty, skip */
-	if (q->read_ptr != q->write_ptr) {
-		if (q->read_ptr == q->last_read_ptr) {
-			/* a queue has not been read from last time */
-			if (q->repeat_same_read_ptr > MAX_REPEAT) {
-				IWL_ERR(priv,
-					"queue %d stuck %d time. Fw reload.\n",
-					q->id, q->repeat_same_read_ptr);
-				q->repeat_same_read_ptr = 0;
-				iwl_force_reset(priv, IWL_FW_RESET, false);
-			} else {
-				q->repeat_same_read_ptr++;
-				IWL_DEBUG_RADIO(priv,
-						"queue %d, not read %d time\n",
-						q->id,
-						q->repeat_same_read_ptr);
-				if (!priv->cfg->advanced_bt_coexist) {
-					mod_timer(&priv->monitor_recover,
-						jiffies + msecs_to_jiffies(
-						IWL_ONE_HUNDRED_MSECS));
-					return 1;
-				}
-			}
-			return 0;
-		} else {
-			q->last_read_ptr = q->read_ptr;
+	if (q->read_ptr == q->write_ptr)
+		return 0;
+
+	if (q->read_ptr == q->last_read_ptr) {
+		/* a queue has not been read from last time */
+		if (q->repeat_same_read_ptr > MAX_REPEAT) {
+			IWL_ERR(priv,
+				"queue %d stuck %d time. Fw reload.\n",
+				q->id, q->repeat_same_read_ptr);
 			q->repeat_same_read_ptr = 0;
+			iwl_force_reset(priv, IWL_FW_RESET, false);
+		} else {
+			q->repeat_same_read_ptr++;
+			IWL_DEBUG_RADIO(priv,
+					"queue %d, not read %d time\n",
+					q->id,
+					q->repeat_same_read_ptr);
+			if (priv->cfg->bt_params &&
+			    !priv->cfg->bt_params->advanced_bt_coexist) {
+				mod_timer(&priv->monitor_recover,
+					jiffies + msecs_to_jiffies(
+					IWL_ONE_HUNDRED_MSECS));
+				return 1;
+			}
 		}
+	} else {
+		q->last_read_ptr = q->read_ptr;
+		q->repeat_same_read_ptr = 0;
 	}
 	return 0;
 }
@@ -2881,13 +2890,13 @@ void iwl_bg_monitor_recover(unsigned long data)
 				return;
 		}
 	}
-	if (priv->cfg->monitor_recover_period) {
+	if (priv->cfg->base_params->monitor_recover_period) {
 		/*
 		 * Reschedule the timer to occur in
-		 * priv->cfg->monitor_recover_period
+		 * priv->cfg->base_params->monitor_recover_period
 		 */
 		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
-			  priv->cfg->monitor_recover_period));
+			  priv->cfg->base_params->monitor_recover_period));
 	}
 }
 EXPORT_SYMBOL(iwl_bg_monitor_recover);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5daa189..6228b1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -255,20 +255,12 @@ struct iwl_mod_params {
 	int restart_fw;		/* def: 1 = restart firmware */
 };
 
-/**
- * struct iwl_cfg
- * @fw_name_pre: Firmware filename prefix. The api version and extension
- * 	(.ucode) will be added to filename before loading from disk. The
- * 	filename is constructed as fw_name_pre<api>.ucode.
- * @ucode_api_max: Highest version of uCode API supported by driver.
- * @ucode_api_min: Lowest version of uCode API supported by driver.
- * @pa_type: used by 6000 series only to identify the type of Power Amplifier
+/*
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
  * @led_compensation: compensate on the led on/off time per HW according
  *	to the deviation to achieve the desired led frequency.
  *	The detail algorithm is described in iwl-led.c
- * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
  * @adv_thermal_throttle: support advance thermal throttle
  * @support_ct_kill_exit: support ct kill exit condition
@@ -286,15 +278,73 @@ struct iwl_mod_params {
  *	sensitivity calibration operation
  * @chain_noise_calib_by_driver: driver has the capability to perform
  *	chain noise calibration operation
- * @scan_antennas: available antenna for scan operation
+*/
+struct iwl_base_params {
+	int eeprom_size;
+	int num_of_queues;	/* def: HW dependent */
+	int num_of_ampdu_queues;/* def: HW dependent */
+	/* for iwl_apm_init() */
+	u32 pll_cfg_val;
+	bool set_l0s;
+	bool use_bsm;
+
+	bool use_isr_legacy;
+	const u16 max_ll_items;
+	const bool shadow_ram_support;
+	u16 led_compensation;
+	const bool broken_powersave;
+	int chain_noise_num_beacons;
+	const bool supports_idle;
+	bool adv_thermal_throttle;
+	bool support_ct_kill_exit;
+	const bool support_wimax_coexist;
+	u8 plcp_delta_threshold;
+	s32 chain_noise_scale;
+	/* timer period for monitor the driver queues */
+	u32 monitor_recover_period;
+	bool temperature_kelvin;
+	u32 max_event_log_size;
+	const bool tx_power_by_driver;
+	const bool ucode_tracing;
+	const bool sensitivity_calib_by_driver;
+	const bool chain_noise_calib_by_driver;
+};
+/*
  * @advanced_bt_coexist: support advanced bt coexist
  * @bt_init_traffic_load: specify initial bt traffic load
  * @bt_prio_boost: default bt priority boost value
- * @need_dc_calib: need to perform init dc calibration
  * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
  * @ampdu_factor: Maximum A-MPDU length factor
  * @ampdu_density: Minimum A-MPDU spacing
+*/
+struct iwl_bt_params {
+	bool advanced_bt_coexist;
+	u8 bt_init_traffic_load;
+	u8 bt_prio_boost;
+	const bool bt_statistics;
+	u16 agg_time_limit;
+	u8 ampdu_factor;
+	u8 ampdu_density;
+};
+/*
+ * @use_rts_for_aggregation: use rts/cts protection for HT traffic
+*/
+struct iwl_ht_params {
+	const bool ht_greenfield_support; /* if used set to true */
+	bool use_rts_for_aggregation;
+};
+
+/**
+ * struct iwl_cfg
+ * @fw_name_pre: Firmware filename prefix. The api version and extension
+ *	(.ucode) will be added to filename before loading from disk. The
+ *	filename is constructed as fw_name_pre<api>.ucode.
+ * @ucode_api_max: Highest version of uCode API supported by driver.
+ * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @pa_type: used by 6000 series only to identify the type of Power Amplifier
+ * @need_dc_calib: need to perform init dc calibration
+ * @scan_antennas: available antenna for scan operation
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -305,9 +355,9 @@ struct iwl_mod_params {
  *
  * For example,
  * if (IWL_UCODE_API(priv->ucode_ver) >= 2) {
- * 	Driver interacts with Firmware API version >= 2.
+ *	Driver interacts with Firmware API version >= 2.
  * } else {
- * 	Driver interacts with Firmware API version 1.
+ *	Driver interacts with Firmware API version 1.
  * }
  *
  * The ideal usage of this infrastructure is to treat a new ucode API
@@ -318,59 +368,28 @@ struct iwl_mod_params {
  *
  */
 struct iwl_cfg {
+	/* params specific to an individual device within a device family */
 	const char *name;
 	const char *fw_name_pre;
 	const unsigned int ucode_api_max;
 	const unsigned int ucode_api_min;
+	u8   valid_tx_ant;
+	u8   valid_rx_ant;
 	unsigned int sku;
-	int eeprom_size;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
-	int num_of_queues;	/* def: HW dependent */
-	int num_of_ampdu_queues;/* def: HW dependent */
 	const struct iwl_ops *ops;
+	/* module based parameters which can be set from modprobe cmd */
 	const struct iwl_mod_params *mod_params;
-	u8   valid_tx_ant;
-	u8   valid_rx_ant;
-
-	/* for iwl_apm_init() */
-	u32 pll_cfg_val;
-	bool set_l0s;
-	bool use_bsm;
-
-	bool use_isr_legacy;
-	enum iwl_pa_type pa_type;
-	const u16 max_ll_items;
-	const bool shadow_ram_support;
-	const bool ht_greenfield_support;
-	u16 led_compensation;
-	const bool broken_powersave;
-	bool use_rts_for_aggregation;
-	int chain_noise_num_beacons;
-	const bool supports_idle;
-	bool adv_thermal_throttle;
-	bool support_ct_kill_exit;
-	const bool support_wimax_coexist;
-	u8 plcp_delta_threshold;
-	s32 chain_noise_scale;
-	/* timer period for monitor the driver queues */
-	u32 monitor_recover_period;
-	bool temperature_kelvin;
-	u32 max_event_log_size;
-	const bool tx_power_by_driver;
-	const bool ucode_tracing;
-	const bool sensitivity_calib_by_driver;
-	const bool chain_noise_calib_by_driver;
+	/* params not likely to change within a device family */
+	struct iwl_base_params *base_params;
+	/* params likely to change within a device family */
+	struct iwl_ht_params *ht_params;
+	struct iwl_bt_params *bt_params;
+	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
+	const bool need_dc_calib;	  /* if used set to true */
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
-	bool advanced_bt_coexist;
-	u8 bt_init_traffic_load;
-	u8 bt_prio_boost;
-	const bool need_dc_calib;
-	const bool bt_statistics;
-	u16 agg_time_limit;
-	u8 ampdu_factor;
-	u8 ampdu_density;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 265ad01..fc34031 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -356,7 +356,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	const u8 *ptr;
 	char *buf;
 	u16 eeprom_ver;
-	size_t eeprom_len = priv->cfg->eeprom_size;
+	size_t eeprom_len = priv->cfg->base_params->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
 	if (eeprom_len % 16) {
@@ -872,7 +872,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(priv->cfg->num_of_queues * 32 * 8) + 400;
+		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
@@ -971,7 +971,8 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 64 * priv->cfg->num_of_queues;
+	const size_t bufsz = sizeof(char) * 64 *
+				priv->cfg->base_params->num_of_queues;
 
 	if (!priv->txq) {
 		IWL_ERR(priv, "txq not ready\n");
@@ -1415,7 +1416,7 @@ static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
-			priv->cfg->plcp_delta_threshold);
+			priv->cfg->base_params->plcp_delta_threshold);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
@@ -1437,10 +1438,10 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 		return -EINVAL;
 	if ((plcp < IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
 		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
-		priv->cfg->plcp_delta_threshold =
+		priv->cfg->base_params->plcp_delta_threshold =
 			IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE;
 	else
-		priv->cfg->plcp_delta_threshold = plcp;
+		priv->cfg->base_params->plcp_delta_threshold = plcp;
 	return count;
 }
 
@@ -1550,13 +1551,14 @@ static ssize_t iwl_dbgfs_monitor_period_write(struct file *file,
 	if (sscanf(buf, "%d", &period) != 1)
 		return -EINVAL;
 	if (period < 0 || period > IWL_MAX_MONITORING_PERIOD)
-		priv->cfg->monitor_recover_period = IWL_DEF_MONITORING_PERIOD;
+		priv->cfg->base_params->monitor_recover_period =
+			IWL_DEF_MONITORING_PERIOD;
 	else
-		priv->cfg->monitor_recover_period = period;
+		priv->cfg->base_params->monitor_recover_period = period;
 
-	if (priv->cfg->monitor_recover_period)
+	if (priv->cfg->base_params->monitor_recover_period)
 		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
-			  priv->cfg->monitor_recover_period));
+			  priv->cfg->base_params->monitor_recover_period));
 	else
 		del_timer_sync(&priv->monitor_recover);
 	return count;
@@ -1614,9 +1616,14 @@ static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
 	char buf[40];
 	const size_t bufsz = sizeof(buf);
 
-	pos += scnprintf(buf + pos, bufsz - pos, "use %s for aggregation\n",
-			 (priv->cfg->use_rts_for_aggregation) ? "rts/cts" :
-			 "cts-to-self");
+	if (priv->cfg->ht_params)
+		pos += scnprintf(buf + pos, bufsz - pos,
+			 "use %s for aggregation\n",
+			 (priv->cfg->ht_params->use_rts_for_aggregation) ?
+				"rts/cts" : "cts-to-self");
+	else
+		pos += scnprintf(buf + pos, bufsz - pos, "N/A");
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
@@ -1629,6 +1636,9 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	int buf_size;
 	int rts;
 
+	if (!priv->cfg->ht_params)
+		return -EINVAL;
+
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
@@ -1636,9 +1646,9 @@ static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
 	if (sscanf(buf, "%d", &rts) != 1)
 		return -EINVAL;
 	if (rts)
-		priv->cfg->use_rts_for_aggregation = true;
+		priv->cfg->ht_params->use_rts_for_aggregation = true;
 	else
-		priv->cfg->use_rts_for_aggregation = false;
+		priv->cfg->ht_params->use_rts_for_aggregation = false;
 	return count;
 }
 
@@ -1716,7 +1726,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(led, dir_data, S_IRUSR);
-	if (!priv->cfg->broken_powersave) {
+	if (!priv->cfg->base_params->broken_powersave) {
 		DEBUGFS_ADD_FILE(sleep_level_override, dir_data,
 				 S_IWUSR | S_IRUSR);
 		DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
@@ -1743,27 +1753,27 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
 
-	if (priv->cfg->sensitivity_calib_by_driver)
+	if (priv->cfg->base_params->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-	if (priv->cfg->chain_noise_calib_by_driver)
+	if (priv->cfg->base_params->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	if (priv->cfg->ucode_tracing)
+	if (priv->cfg->base_params->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
-	if (priv->cfg->bt_statistics)
+	if (priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics)
 		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(monitor_period, dir_debug, S_IWUSR);
-	if (priv->cfg->advanced_bt_coexist)
+	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
-	if (priv->cfg->sensitivity_calib_by_driver)
+	if (priv->cfg->base_params->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &priv->disable_sens_cal);
-	if (priv->cfg->chain_noise_calib_by_driver)
+	if (priv->cfg->base_params->chain_noise_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
 				 &priv->disable_chain_noise_cal);
-	if (priv->cfg->tx_power_by_driver)
+	if (priv->cfg->base_params->tx_power_by_driver)
 		DEBUGFS_ADD_BOOL(disable_tx_power, dir_rf,
 				&priv->disable_tx_power_cal);
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a45d02e..88f4a80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(iwlcore_eeprom_release_semaphore);
 
 const u8 *iwlcore_eeprom_query_addr(const struct iwl_priv *priv, size_t offset)
 {
-	BUG_ON(offset >= priv->cfg->eeprom_size);
+	BUG_ON(offset >= priv->cfg->base_params->eeprom_size);
 	return &priv->eeprom[offset];
 }
 EXPORT_SYMBOL(iwlcore_eeprom_query_addr);
@@ -364,7 +364,7 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 		 * CSR auto clock gate disable bit -
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
-		if (priv->cfg->shadow_ram_support)
+		if (priv->cfg->base_params->shadow_ram_support)
 			iwl_set_bit(priv, CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
@@ -484,7 +484,7 @@ static int iwl_find_otp_image(struct iwl_priv *priv,
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks <= priv->cfg->max_ll_items);
+	} while (usedblocks <= priv->cfg->base_params->max_ll_items);
 
 	/* OTP has no valid blocks */
 	IWL_DEBUG_INFO(priv, "OTP has no valid blocks\n");
@@ -512,8 +512,8 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
-	IWL_DEBUG_INFO(priv, "NVM size = %d\n", priv->cfg->eeprom_size);
-	sz = priv->cfg->eeprom_size;
+	sz = priv->cfg->base_params->eeprom_size;
+	IWL_DEBUG_INFO(priv, "NVM size = %d\n", sz);
 	priv->eeprom = kzalloc(sz, GFP_KERNEL);
 	if (!priv->eeprom) {
 		ret = -ENOMEM;
@@ -554,7 +554,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
-		if (!priv->cfg->shadow_ram_support) {
+		if (!priv->cfg->base_params->shadow_ram_support) {
 			if (iwl_find_otp_image(priv, &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index db5bfcb..86c2b6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -108,13 +108,13 @@ static int iwl_led_pattern(struct iwl_priv *priv, unsigned int idx)
 	BUG_ON(idx > IWL_MAX_BLINK_TBL);
 
 	IWL_DEBUG_LED(priv, "Led blink time compensation= %u\n",
-			priv->cfg->led_compensation);
+			priv->cfg->base_params->led_compensation);
 	led_cmd.on =
 		iwl_blink_compensation(priv, blink_tbl[idx].on_time,
-					priv->cfg->led_compensation);
+				priv->cfg->base_params->led_compensation);
 	led_cmd.off =
 		iwl_blink_compensation(priv, blink_tbl[idx].off_time,
-					priv->cfg->led_compensation);
+				priv->cfg->base_params->led_compensation);
 
 	return priv->cfg->ops->led->cmd(priv, &led_cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 63c0ab4..49d7788 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -278,9 +278,9 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->cfg->broken_powersave)
+	if (priv->cfg->base_params->broken_powersave)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
-	else if (priv->cfg->supports_idle &&
+	else if (priv->cfg->base_params->supports_idle &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
 	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index c54c200..eaae49e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -259,7 +259,8 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	queue_work(priv->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
-	    priv->cfg->advanced_bt_coexist &&
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
 	    priv->bt_status != scan_notif->bt_status) {
 		if (scan_notif->bt_status) {
 			/* BT on */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8b6aa3d..43db5f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1581,16 +1581,16 @@ int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
 
-	if (capacity > priv->cfg->max_event_log_size) {
+	if (capacity > priv->cfg->base_params->max_event_log_size) {
 		IWL_ERR(priv, "Log capacity %d is bogus, limit to %d entries\n",
-			capacity, priv->cfg->max_event_log_size);
-		capacity = priv->cfg->max_event_log_size;
+			capacity, priv->cfg->base_params->max_event_log_size);
+		capacity = priv->cfg->base_params->max_event_log_size;
 	}
 
-	if (next_entry > priv->cfg->max_event_log_size) {
+	if (next_entry > priv->cfg->base_params->max_event_log_size) {
 		IWL_ERR(priv, "Log write index %d is bogus, limit to %d\n",
-			next_entry, priv->cfg->max_event_log_size);
-		next_entry = priv->cfg->max_event_log_size;
+			next_entry, priv->cfg->base_params->max_event_log_size);
+		next_entry = priv->cfg->base_params->max_event_log_size;
 	}
 
 	size = num_wraps ? capacity : next_entry;
@@ -2519,7 +2519,8 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 		/* Enable timer to monitor the driver queues */
 		mod_timer(&priv->monitor_recover,
 			jiffies +
-			msecs_to_jiffies(priv->cfg->monitor_recover_period));
+			msecs_to_jiffies(
+			  priv->cfg->base_params->monitor_recover_period));
 	}
 
 	if (iwl_is_rfkill(priv))
@@ -3881,7 +3882,7 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_SPECTRUM_MGMT;
 
-	if (!priv->cfg->broken_powersave)
+	if (!priv->cfg->base_params->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
-- 
1.7.0.4

