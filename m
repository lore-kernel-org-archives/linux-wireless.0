Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZJWUme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/18] iwlwifi: consolidate apm_init() functions
Date: Fri, 23 Oct 2009 13:42:21 -0700
Message-Id: <1256330556-20997-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Consolidate most iwlXXXX_apm_init() functions into single iwl_apm_init().
Keep iwl3945_apm_init(), but leverage iwl_apm_init() for most functionality.
Update 4965 init sequence to follow most recent factory recommendations.

Add following members to struct iwl_cfg to guide the init sequence:
pll_cfg_val (replaces needs_pll_cfg), set_l0s, use_bsm

Move L0S enable/disable from nic_config() functions to iwl_apm_init().
This satisifies the "FIXME: put here L1A -L0S w/a" notice, and complies
with factory-recommended sequence.

Add debug info message in iwl_apm_init(), and symmetrical message
in iwl_apm_stop().

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   10 ++-
 drivers/net/wireless/iwlwifi/iwl-3945.c |   56 ++-------------
 drivers/net/wireless/iwlwifi/iwl-4965.c |   56 +--------------
 drivers/net/wireless/iwlwifi/iwl-5000.c |   86 ++++++------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   42 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-core.c |  114 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    8 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 -
 8 files changed, 190 insertions(+), 183 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index a00f947..3da5913 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -110,7 +110,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
-		.init =	iwl5000_apm_init,
+		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl1000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -163,7 +163,9 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = false,
+	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
@@ -186,7 +188,9 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = false,
+	.use_bsm = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
 	.ht_greenfield_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9f18b4c..7142aa5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1013,55 +1013,15 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 	return rc;
 }
 
+
 /*
- * Start up NIC's basic functionality after it has been reset
- * (e.g. after platform boot, or shutdown via iwl3945_apm_stop())
+ * Start up 3945's basic functionality after it has been reset
+ * (e.g. after platform boot, or shutdown via iwl_apm_stop())
  * NOTE:  This does not load uCode nor start the embedded processor
  */
 static int iwl3945_apm_init(struct iwl_priv *priv)
 {
-	int ret;
-
-	/* Configure chip clock phase-lock-loop */
-	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
-
-	/*
-	 * Disable L0S exit timer (platform NMI Work/Around)
-	 * (does this do anything on 3945, or just 4965 and beyond?)
-	 */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	/* Disable L0s without affecting L1; don't wait for ICH (L0s bug W/A) */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
-
-	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
-
-	/*
-	 * Set "initialization complete" bit to move adapter from
-	 * D0U* --> D0A* (powered-up active) state.
-	 */
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/*
-	 * Wait for clock stabilization; once stabilized, access to
-	 * device-internal resources is supported, e.g. iwl_write_prph()
-	 * and accesses to uCode SRAM.
-	 */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		goto out;
-	}
-
-	/* Enable DMA and BSM clocks, wait for them to stabilize */
-	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
-						APMG_CLK_VAL_BSM_CLK_RQT);
-	udelay(20);
+	int ret = iwl_apm_init(priv);
 
 	/* Clear APMG (NIC's internal power management) interrupts */
 	iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
@@ -1072,11 +1032,6 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 	udelay(5);
 	iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG, APMG_PS_CTRL_VAL_RESET_REQ);
 
-	/* Disable L1-Active */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-out:
 	return ret;
 }
 
@@ -2876,6 +2831,9 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ops = &iwl3945_ops,
 	.num_of_queues = IWL39_NUM_QUEUES,
 	.mod_params = &iwl3945_mod_params,
+	.pll_cfg_val = CSR39_ANA_PLL_CFG_VAL,
+	.set_l0s = false,
+	.use_bsm = true,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1a622aa..32d5f3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -317,64 +317,13 @@ static void iwl4965_txq_set_sched(struct iwl_priv *priv, u32 mask)
 	iwl_write_prph(priv, IWL49_SCD_TXFACT, mask);
 }
 
-static int iwl4965_apm_init(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
-
-	/* set "initialization complete" bit to move adapter
-	 * D0U* --> D0A* state */
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		goto out;
-	}
-
-	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_CTRL_REG, APMG_CLK_VAL_DMA_CLK_RQT |
-						APMG_CLK_VAL_BSM_CLK_RQT);
-
-	udelay(20);
-
-	/* disable L1-Active */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-out:
-	return ret;
-}
-
-
 static void iwl4965_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
-	u16 lctl;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	lctl = iwl_pcie_link_ctl(priv);
-
-	/* HW bug W/A - negligible power consumption */
-	/* L1-ASPM is enabled by BIOS */
-	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* L1-ASPM enabled: disable L0S  */
-		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-	else
-		/* L1-ASPM disabled: enable L0S */
-		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
 	/* write radio config values to register */
@@ -2223,7 +2172,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.apm_ops = {
-		.init = iwl4965_apm_init,
+		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl4965_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -2276,6 +2225,9 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.num_of_queues = IWL49_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl4965_mod_params,
+	.pll_cfg_val = 0,
+	.set_l0s = true,
+	.use_bsm = true,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
 	.broken_powersave = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index afa88a3..a6e347b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -72,72 +72,14 @@ static const u16 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_HCCA_2
 };
 
-int iwl5000_apm_init(struct iwl_priv *priv)
-{
-	int ret = 0;
-
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
-
-	/* disable L0s without affecting L1 :don't wait for ICH L0s bug W/A) */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
-		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
-
-	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
-
-	/* enable HAP INTA to move device L1a -> L0s */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
-
-	if (priv->cfg->need_pll_cfg)
-		iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR50_ANA_PLL_CFG_VAL);
-
-	/* set "initialization complete" bit to move adapter
-	 * D0U* --> D0A* state */
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	/* wait for clock stabilization */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
-			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
-	if (ret < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		return ret;
-	}
-
-	/* enable DMA */
-	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
-
-	udelay(20);
-
-	/* disable L1-Active */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
-
-	return ret;
-}
-
 /* NIC configuration for 5000 series */
 void iwl5000_nic_config(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	u16 radio_cfg;
-	u16 lctl;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	lctl = iwl_pcie_link_ctl(priv);
-
-	/* HW bug W/A */
-	/* L1-ASPM is enabled by BIOS */
-	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) == PCI_CFG_LINK_CTRL_VAL_L1_EN)
-		/* L1-APSM enabled: disable L0S  */
-		iwl_set_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-	else
-		/* L1-ASPM disabled: enable L0S */
-		iwl_clear_bit(priv, CSR_GIO_REG, CSR_GIO_REG_VAL_L0S_ENABLED);
-
 	radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
 
 	/* write radio config values to register */
@@ -1488,7 +1430,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
-		.init =	iwl5000_apm_init,
+		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -1539,7 +1481,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
-		.init =	iwl5000_apm_init,
+		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl5000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -1607,7 +1549,9 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -1628,7 +1572,9 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -1649,7 +1595,9 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -1670,7 +1618,9 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -1691,7 +1641,9 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
@@ -1712,7 +1664,9 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b531813..5211872 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -193,7 +193,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.send_tx_power = iwl5000_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
-		.init =	iwl5000_apm_init,
+		.init = iwl_apm_init,
 		.stop = iwl_apm_stop,
 		.config = iwl6000_nic_config,
 		.set_pwr_src = iwl_set_pwr_src,
@@ -266,7 +266,9 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -292,7 +294,9 @@ struct iwl_cfg iwl6000h_2abg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -317,7 +321,9 @@ struct iwl_cfg iwl6000h_2bg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_HYBRID,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -345,7 +351,9 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -371,7 +379,9 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -396,7 +406,9 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_INTERNAL,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -421,7 +433,9 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
@@ -447,7 +461,9 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
@@ -472,7 +488,9 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
@@ -498,7 +516,9 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
-	.need_pll_cfg = false,
+	.pll_cfg_val = 0,
+	.set_l0s = false,
+	.use_bsm = false,
 	.pa_type = IWL_PA_SYSTEM,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7ce8663..1d7248c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1369,6 +1369,8 @@ void iwl_apm_stop(struct iwl_priv *priv)
 {
 	unsigned long flags;
 
+	IWL_DEBUG_INFO(priv, "Stop card, put in low power state\n");
+
 	iwl_apm_stop_master(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1382,6 +1384,118 @@ void iwl_apm_stop(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_apm_stop);
 
+
+/*
+ * Start up NIC's basic functionality after it has been reset
+ * (e.g. after platform boot, or shutdown via iwl_apm_stop())
+ * NOTE:  This does not load uCode nor start the embedded processor
+ */
+int iwl_apm_init(struct iwl_priv *priv)
+{
+	int ret = 0;
+	u16 lctl;
+
+	IWL_DEBUG_INFO(priv, "Init card's basic functions\n");
+
+	/*
+	 * Use "set_bit" below rather than "write", to preserve any hardware
+	 * bits already set by default after reset.
+	 */
+
+	/* Disable L0S exit timer (platform NMI Work/Around) */
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
+
+	/*
+	 * Disable L0s without affecting L1;
+	 *  don't wait for ICH L0s (ICH bug W/A)
+	 */
+	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
+
+	/* Set FH wait threshold to maximum (HW error during stress W/A) */
+	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+
+	/*
+	 * Enable HAP INTA (interrupt from management bus) to
+	 * wake device's PCI Express link L1a -> L0s
+	 * NOTE:  This is no-op for 3945 (non-existant bit)
+	 */
+	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
+
+	/*
+	 * HW bug W/A - costs negligible power consumption ...
+	 * Check if BIOS (or OS) enabled L1-ASPM on this device
+	 */
+	if (priv->cfg->set_l0s) {
+		lctl = iwl_pcie_link_ctl(priv);
+		if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
+					PCI_CFG_LINK_CTRL_VAL_L1_EN) {
+			/* L1-ASPM enabled; disable(!) L0S  */
+			iwl_set_bit(priv, CSR_GIO_REG,
+					CSR_GIO_REG_VAL_L0S_ENABLED);
+			IWL_DEBUG_POWER(priv, "L1 Enabled; Disabling L0S\n");
+		} else {
+			/* L1-ASPM disabled; enable(!) L0S */
+			iwl_clear_bit(priv, CSR_GIO_REG,
+					CSR_GIO_REG_VAL_L0S_ENABLED);
+			IWL_DEBUG_POWER(priv, "L1 Disabled; Enabling L0S\n");
+		}
+	}
+
+	/* Configure analog phase-lock-loop before activating to D0A */
+	if (priv->cfg->pll_cfg_val)
+		iwl_set_bit(priv, CSR_ANA_PLL_CFG, priv->cfg->pll_cfg_val);
+
+	/*
+	 * Set "initialization complete" bit to move adapter from
+	 * D0U* --> D0A* (powered-up active) state.
+	 */
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+
+	/*
+	 * Wait for clock stabilization; once stabilized, access to
+	 * device-internal resources is supported, e.g. iwl_write_prph()
+	 * and accesses to uCode SRAM.
+	 */
+	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
+			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
+	if (ret < 0) {
+		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
+		goto out;
+	}
+
+	/*
+	 * Enable DMA and BSM (if used) clocks, wait for them to stabilize.
+	 * BSM (Boostrap State Machine) is only in 3945 and 4965;
+	 * later devices (i.e. 5000 and later) have non-volatile SRAM,
+	 * and don't need BSM to restore data after power-saving sleep.
+	 *
+	 * Write to "CLK_EN_REG"; "1" bits enable clocks, while "0" bits
+	 * do not disable clocks.  This preserves any hardware bits already
+	 * set by default in "CLK_CTRL_REG" after reset.
+	 */
+	if (priv->cfg->use_bsm)
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
+			APMG_CLK_VAL_DMA_CLK_RQT | APMG_CLK_VAL_BSM_CLK_RQT);
+	else
+		iwl_write_prph(priv, APMG_CLK_EN_REG,
+			APMG_CLK_VAL_DMA_CLK_RQT);
+	udelay(20);
+
+	/* Disable L1-Active */
+	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL(iwl_apm_init);
+
+
+
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a2a580d..a2d526a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -262,7 +262,12 @@ struct iwl_cfg {
 	const struct iwl_mod_params *mod_params;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
-	bool need_pll_cfg;
+
+	/* for iwl_apm_init() */
+	u32 pll_cfg_val;
+	bool set_l0s;
+	bool use_bsm;
+
 	bool use_isr_legacy;
 	enum iwl_pa_type pa_type;
 	const u16 max_ll_items;
@@ -663,6 +668,7 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_stop_master(struct iwl_priv *priv);
+int iwl_apm_init(struct iwl_priv *priv);
 
 void iwl_setup_rxon_timing(struct iwl_priv *priv);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6ba082d..1378654 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -85,7 +85,6 @@ extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 				    __le32 *tx_flags);
 extern int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp);
-extern int iwl5000_apm_init(struct iwl_priv *priv);
 extern void iwl5000_nic_config(struct iwl_priv *priv);
 extern u16 iwl5000_eeprom_calib_version(struct iwl_priv *priv);
 extern const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
-- 
1.5.6.3

