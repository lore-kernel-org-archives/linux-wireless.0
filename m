Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1HMSSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 42/60] iwlagn: all function iwl-io.c receive iwl_bus
Date: Sat, 13 Aug 2011 10:38:18 -0700
Message-Id: <1313257116-2697-43-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_202009_143199_7C06EB6C)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Which means that iwl-io.c doesn't need to include iwl-dev.h any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   59 ++++---
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |   27 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    3 -
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   58 +++---
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.c             |  192 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-io.h             |   61 +++----
 drivers/net/wireless/iwlwifi/iwl-led.c            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |   72 ++++----
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   34 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  113 +++++++------
 24 files changed, 363 insertions(+), 351 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 13dc94b..0364940 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -86,13 +86,13 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
-	iwl_set_bits_mask_prph(priv, APMG_DIGITAL_SVR_REG,
+	iwl_set_bits_mask_prph(bus(priv), APMG_DIGITAL_SVR_REG,
 				APMG_SVR_DIGITAL_VOLTAGE_1_32,
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index ee7cce8..57107be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -90,7 +90,7 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 	iwl_rf_config(priv);
 
 	if (priv->cfg->iq_invert)
-		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d6a7f26..bd64c67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -76,7 +76,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+	iwl_set_bits_mask_prph(bus(priv), APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ab5d3c5..dcd1c3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -84,7 +84,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
 	if (iwlagn_eeprom_calib_version(priv) >= 6)
-		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
 
@@ -92,9 +92,9 @@ static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
 	if (iwlagn_eeprom_calib_version(priv) >= 6)
-		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-	iwl_set_bit(priv, CSR_GP_DRIVER_REG,
+	iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
 		    CSR_GP_DRIVER_REG_BIT_6050_1x2);
 }
 
@@ -106,7 +106,7 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 	/* no locking required for register write */
 	if (priv->cfg->pa_type == IWL_PA_INTERNAL) {
 		/* 2x2 IPA phy type */
-		iwl_write32(priv, CSR_GP_DRIVER_REG,
+		iwl_write32(bus(priv), CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* do additional nic configuration if needed */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 1a39aaf..495f936 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -181,19 +181,19 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 
 	if (tt->state == IWL_TI_CT_KILL) {
 		if (priv->thermal_throttle.ct_kill_toggle) {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = false;
 		} else {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
-		iwl_read32(priv, CSR_UCODE_DRV_GP1);
-		spin_lock_irqsave(&priv->reg_lock, flags);
-		if (!iwl_grab_nic_access(priv))
-			iwl_release_nic_access(priv);
-		spin_unlock_irqrestore(&priv->reg_lock, flags);
+		iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
+		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
+		if (!iwl_grab_nic_access(bus(priv)))
+			iwl_release_nic_access(bus(priv));
+		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
 
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 033f595..02b00d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -85,29 +85,29 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 
 	priv->ucode_write_complete = 0;
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
 		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
 		(iwl_get_dma_hi_addr(phy_addr)
 			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
 		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
 
-	iwl_write_direct32(priv,
+	iwl_write_direct32(bus(priv),
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
@@ -384,9 +384,9 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv,
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(bus(priv), HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
-		val = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -405,14 +405,14 @@ static void iwl_print_mismatch_inst(struct iwl_priv *priv,
 
 	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
-	iwl_write_direct32(priv, HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(bus(priv), HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERR(priv, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2a8ea45..dd306fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -330,14 +330,14 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	if (iwl_grab_nic_access(priv)) {
-		spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	spin_lock_irqsave(&bus(priv)->reg_lock, reg_flags);
+	if (iwl_grab_nic_access(bus(priv))) {
+		spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
 		return;
 	}
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/*
@@ -345,20 +345,20 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	 * place event id # at far right for easier visual parsing.
 	 */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			trace_iwlwifi_dev_ucode_cont_event(priv,
 							0, time, ev);
 		} else {
-			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 			trace_iwlwifi_dev_ucode_cont_event(priv,
 						time, data, ev);
 		}
 	}
 	/* Allow device to power down */
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	iwl_release_nic_access(bus(priv));
+	spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
 }
 
 static void iwl_continuous_event_trace(struct iwl_priv *priv)
@@ -371,10 +371,12 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		capacity = iwl_read_targ_mem(priv, base);
-		num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
-		mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
-		next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
+		capacity = iwl_read_targ_mem(bus(priv), base);
+		num_wraps = iwl_read_targ_mem(bus(priv),
+						base + (2 * sizeof(u32)));
+		mode = iwl_read_targ_mem(bus(priv), base + (1 * sizeof(u32)));
+		next_entry = iwl_read_targ_mem(bus(priv),
+						base + (3 * sizeof(u32)));
 	} else
 		return;
 
@@ -1317,7 +1319,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	int ret = 0;
 
 	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
@@ -1935,7 +1937,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	/* User space software may expect getting rfkill changes
 	 * even if interface is down */
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(bus(priv), CSR_INT, 0xFFFFFFFF);
 	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -2327,7 +2329,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	device_set_wakeup_enable(priv->bus->dev, true);
 
 	/* Now let the ucode operate on its own */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	goto out;
@@ -2353,19 +2355,19 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	mutex_lock(&priv->shrd->mutex);
 
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&priv->reg_lock, flags);
-		ret = iwl_grab_nic_access_silent(priv);
+		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
+		ret = iwl_grab_nic_access_silent(bus(priv));
 		if (ret == 0) {
-			iwl_write32(priv, HBUS_TARG_MEM_RADDR, base);
-			status = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-			iwl_release_nic_access(priv);
+			iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, base);
+			status = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+			iwl_release_nic_access(bus(priv));
 		}
-		spin_unlock_irqrestore(&priv->reg_lock, flags);
+		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
@@ -2376,7 +2378,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
-					priv, 0x800000, priv->wowlan_sram,
+					bus(priv), 0x800000, priv->wowlan_sram,
 					priv->ucode_wowlan.data.len / 4);
 		}
 #endif
@@ -3250,7 +3252,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	return iwl_read32(priv, CSR_HW_REV);
+	return iwl_read32(bus(priv), CSR_HW_REV);
 }
 
 /* Size of one Rx buffer in host DRAM */
@@ -3350,7 +3352,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
-	spin_lock_init(&priv->reg_lock);
+	spin_lock_init(&bus(priv)->reg_lock);
 	spin_lock_init(&priv->shrd->lock);
 
 	/*
@@ -3358,7 +3360,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	 * strange state ... like being left stranded by a primary kernel
 	 * and this is now the kdump kernel trying to start up
 	 */
-	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/***********************
 	 * 3. Read REV register
@@ -3439,7 +3441,8 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+	if (iwl_read32(bus(priv),
+			CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
 		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index e1cb65c..83aed46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -66,6 +66,7 @@
 /*This file includes the declaration that are exported from the bus layer */
 
 #include <linux/types.h>
+#include <linux/spinlock.h>
 
 struct iwl_shared;
 struct iwl_bus;
@@ -96,6 +97,7 @@ struct iwl_bus_ops {
  * @ops - pointer to iwl_bus_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @irq - the irq number for the device
+ * @reg_lock - protect hw register access
  */
 struct iwl_bus {
 	/* Common data to all buses */
@@ -104,6 +106,7 @@ struct iwl_bus {
 	struct iwl_shared *shrd;
 
 	unsigned int irq;
+	spinlock_t reg_lock;
 
 	/* pointer to bus specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 048c8e2..411edc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -907,9 +907,10 @@ static int iwl_apm_stop_master(struct iwl_priv *priv)
 	int ret = 0;
 
 	/* stop device's busmaster DMA activity */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	iwl_set_bit(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
+	ret = iwl_poll_bit(bus(priv), CSR_RESET,
+			CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret)
 		IWL_WARN(priv, "Master Disable Timed Out, 100 usec\n");
@@ -929,7 +930,7 @@ void iwl_apm_stop(struct iwl_priv *priv)
 	iwl_apm_stop_master(priv);
 
 	/* Reset the entire device */
-	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
 
@@ -937,7 +938,7 @@ void iwl_apm_stop(struct iwl_priv *priv)
 	 * Clear "initialization complete" bit to move adapter from
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
-	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_clear_bit(bus(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
 
 
@@ -957,45 +958,45 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 */
 
 	/* Disable L0S exit timer (platform NMI Work/Around) */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(bus(priv), CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	/*
 	 * Disable L0s without affecting L1;
 	 *  don't wait for ICH L0s (ICH bug W/A)
 	 */
-	iwl_set_bit(priv, CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(bus(priv), CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(priv, CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+	iwl_set_bit(bus(priv), CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
 
 	/*
 	 * Enable HAP INTA (interrupt from management bus) to
 	 * wake device's PCI Express link L1a -> L0s
 	 */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
 	bus_apm_config(priv->bus);
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (priv->cfg->base_params->pll_cfg_val)
-		iwl_set_bit(priv, CSR_ANA_PLL_CFG,
+		iwl_set_bit(bus(priv), CSR_ANA_PLL_CFG,
 			    priv->cfg->base_params->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
 	 * D0U* --> D0A* (powered-up active) state.
 	 */
-	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_set_bit(bus(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/*
 	 * Wait for clock stabilization; once stabilized, access to
 	 * device-internal resources is supported, e.g. iwl_write_prph()
 	 * and accesses to uCode SRAM.
 	 */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(bus(priv), CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
@@ -1010,11 +1011,11 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 * do not disable clocks.  This preserves any hardware bits already
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
-	iwl_write_prph(priv, APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	iwl_write_prph(bus(priv), APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(20);
 
 	/* Disable L1-Active */
-	iwl_set_bits_prph(priv, APMG_PCIDEV_STT_REG,
+	iwl_set_bits_prph(bus(priv), APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 	set_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a12b8d4..a01beb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -254,7 +254,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	sram = priv->dbgfs_sram_offset & ~0x3;
 
 	/* read the first u32 from sram */
-	val = iwl_read_targ_mem(priv, sram);
+	val = iwl_read_targ_mem(bus(priv), sram);
 
 	for (; len; len--) {
 		/* put the address at the start of every line */
@@ -273,7 +273,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		if (++offset == 4) {
 			sram += 4;
 			offset = 0;
-			val = iwl_read_targ_mem(priv, sram);
+			val = iwl_read_targ_mem(bus(priv), sram);
 		}
 
 		/* put in extra spaces and split lines for human readability */
@@ -1954,7 +1954,7 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	u32 pwrsave_status;
 
-	pwrsave_status = iwl_read32(priv, CSR_GP_CNTRL) &
+	pwrsave_status = iwl_read32(bus(priv), CSR_GP_CNTRL) &
 			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bb8a161..10e8431 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1171,9 +1171,6 @@ struct iwl_priv {
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
 
-	/* spinlock */
-	spinlock_t reg_lock;	/* protect hw register access */
-
 	/*TODO: remove these pointers - use bus(priv) instead */
 	struct iwl_bus *bus;	/* bus specific data */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 2c84ba9..8a51c5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -29,6 +29,8 @@
 
 #include <linux/tracepoint.h>
 
+struct iwl_priv;
+
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index c790f7f..80ee65b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -155,11 +155,11 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
 
 	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
+		ret = iwl_poll_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
@@ -176,14 +176,14 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_priv *priv)
 
 static void iwl_eeprom_release_semaphore(struct iwl_priv *priv)
 {
-	iwl_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_clear_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 }
 
 static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 {
-	u32 gp = iwl_read32(priv, CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	u32 gp = iwl_read32(bus(priv), CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
 	IWL_DEBUG_EEPROM(priv, "EEPROM signature=0x%08x\n", gp);
@@ -216,13 +216,13 @@ static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 
 static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 {
-	iwl_read32(priv, CSR_OTP_GP_REG);
+	iwl_read32(bus(priv), CSR_OTP_GP_REG);
 
 	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
-		iwl_clear_bit(priv, CSR_OTP_GP_REG,
+		iwl_clear_bit(bus(priv), CSR_OTP_GP_REG,
 			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 	else
-		iwl_set_bit(priv, CSR_OTP_GP_REG,
+		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
@@ -243,7 +243,7 @@ static int iwl_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
 		nvm_type = NVM_DEVICE_TYPE_EEPROM;
 		break;
 	default:
-		otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+		otpgp = iwl_read32(bus(priv), CSR_OTP_GP_REG);
 		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
 			nvm_type = NVM_DEVICE_TYPE_OTP;
 		else
@@ -258,22 +258,22 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 	int ret;
 
 	/* Enable 40MHz radio clock */
-	iwl_write32(priv, CSR_GP_CNTRL,
-		    iwl_read32(priv, CSR_GP_CNTRL) |
+	iwl_write32(bus(priv), CSR_GP_CNTRL,
+		    iwl_read32(bus(priv), CSR_GP_CNTRL) |
 		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(bus(priv), CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 25000);
 	if (ret < 0)
 		IWL_ERR(priv, "Time out access OTP\n");
 	else {
-		iwl_set_bits_prph(priv, APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(bus(priv), APMG_PS_CTRL_REG,
 				  APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_prph(priv, APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(bus(priv), APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
 
 		/*
@@ -281,7 +281,7 @@ static int iwl_init_otp_access(struct iwl_priv *priv)
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
 		if (priv->cfg->base_params->shadow_ram_support)
-			iwl_set_bit(priv, CSR_DBG_LINK_PWR_MGMT_REG,
+			iwl_set_bit(bus(priv), CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
 	return ret;
@@ -293,9 +293,9 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_dat
 	u32 r;
 	u32 otpgp;
 
-	iwl_write32(priv, CSR_EEPROM_REG,
+	iwl_write32(bus(priv), CSR_EEPROM_REG,
 		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
+	ret = iwl_poll_bit(bus(priv), CSR_EEPROM_REG,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 IWL_EEPROM_ACCESS_TIMEOUT);
@@ -303,13 +303,13 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_dat
 		IWL_ERR(priv, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = iwl_read32(priv, CSR_EEPROM_REG);
+	r = iwl_read32(bus(priv), CSR_EEPROM_REG);
 	/* check for ECC errors: */
-	otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
+	otpgp = iwl_read32(bus(priv), CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgement */
-		iwl_set_bit(priv, CSR_OTP_GP_REG,
+		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
 			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		IWL_ERR(priv, "Uncorrectable OTP ECC error, abort OTP read\n");
 		return -EINVAL;
@@ -317,7 +317,7 @@ static int iwl_read_otp_word(struct iwl_priv *priv, u16 addr, __le16 *eeprom_dat
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
 		/* set the correctable OTP ECC bit for acknowledgement */
-		iwl_set_bit(priv, CSR_OTP_GP_REG,
+		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
 				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
 		IWL_ERR(priv, "Correctable OTP ECC error, continue read\n");
 	}
@@ -424,7 +424,7 @@ u16 iwl_eeprom_query16(const struct iwl_priv *priv, size_t offset)
 int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
 	__le16 *e;
-	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
+	u32 gp = iwl_read32(bus(priv), CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
@@ -469,11 +469,11 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			ret = -ENOENT;
 			goto done;
 		}
-		iwl_write32(priv, CSR_EEPROM_GP,
-			    iwl_read32(priv, CSR_EEPROM_GP) &
+		iwl_write32(bus(priv), CSR_EEPROM_GP,
+			    iwl_read32(bus(priv), CSR_EEPROM_GP) &
 			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(priv, CSR_OTP_GP_REG,
+		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
@@ -498,10 +498,10 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(priv, CSR_EEPROM_REG,
+			iwl_write32(bus(priv), CSR_EEPROM_REG,
 				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bit(priv, CSR_EEPROM_REG,
+			ret = iwl_poll_bit(bus(priv), CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
@@ -509,7 +509,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 				IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = iwl_read32(priv, CSR_EEPROM_REG);
+			r = iwl_read32(bus(priv), CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
@@ -838,7 +838,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
@@ -850,7 +850,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 		WARN_ON(1);
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index f744fdc..8ca624d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -141,7 +141,7 @@ static inline void iwl_wake_any_queue(struct iwl_priv *priv,
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
-	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	iwl_write32(bus(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index aa4a906..3ffa8e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -25,46 +25,50 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
+#include <linux/delay.h>
+#include <linux/device.h>
 
 #include "iwl-io.h"
+#include"iwl-csr.h"
+#include "iwl-debug.h"
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
-static inline void __iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void __iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask)
 {
-	iwl_write32(priv, reg, iwl_read32(priv, reg) | mask);
+	iwl_write32(bus, reg, iwl_read32(bus, reg) | mask);
 }
 
-static inline void __iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+static inline void __iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask)
 {
-	iwl_write32(priv, reg, iwl_read32(priv, reg) & ~mask);
+	iwl_write32(bus, reg, iwl_read32(bus, reg) & ~mask);
 }
 
-void iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+void iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	__iwl_set_bit(priv, reg, mask);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	__iwl_set_bit(bus, reg, mask);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-void iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+void iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	__iwl_clear_bit(priv, reg, mask);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	__iwl_clear_bit(bus, reg, mask);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+int iwl_poll_bit(struct iwl_bus *bus, u32 addr,
 		 u32 bits, u32 mask, int timeout)
 {
 	int t = 0;
 
 	do {
-		if ((iwl_read32(priv, addr) & mask) == (bits & mask))
+		if ((iwl_read32(bus, addr) & mask) == (bits & mask))
 			return t;
 		udelay(IWL_POLL_INTERVAL);
 		t += IWL_POLL_INTERVAL;
@@ -73,14 +77,14 @@ int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 	return -ETIMEDOUT;
 }
 
-int iwl_grab_nic_access_silent(struct iwl_priv *priv)
+int iwl_grab_nic_access_silent(struct iwl_bus *bus)
 {
 	int ret;
 
-	lockdep_assert_held(&priv->reg_lock);
+	lockdep_assert_held(&bus->reg_lock);
 
 	/* this bit wakes up the NIC */
-	__iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	__iwl_set_bit(bus, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/*
 	 * These bits say the device is running, and should keep running for
@@ -101,70 +105,70 @@ int iwl_grab_nic_access_silent(struct iwl_priv *priv)
 	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
 	 * and do not save/restore SRAM when power cycling.
 	 */
-	ret = iwl_poll_bit(priv, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(bus, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
-		iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
+		iwl_write32(bus, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
 
 	return 0;
 }
 
-int iwl_grab_nic_access(struct iwl_priv *priv)
+int iwl_grab_nic_access(struct iwl_bus *bus)
 {
-	int ret = iwl_grab_nic_access_silent(priv);
+	int ret = iwl_grab_nic_access_silent(bus);
 	if (ret) {
-		u32 val = iwl_read32(priv, CSR_GP_CNTRL);
-		IWL_ERR(priv,
+		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
+		IWL_ERR(bus,
 			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
 	}
 
 	return ret;
 }
 
-void iwl_release_nic_access(struct iwl_priv *priv)
+void iwl_release_nic_access(struct iwl_bus *bus)
 {
-	lockdep_assert_held(&priv->reg_lock);
-	__iwl_clear_bit(priv, CSR_GP_CNTRL,
+	lockdep_assert_held(&bus->reg_lock);
+	__iwl_clear_bit(bus, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 
-u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg)
+u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg)
 {
 	u32 value;
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
-	value = iwl_read32(priv, reg);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
+	value = iwl_read32(bus(bus), reg);
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 
 	return value;
 }
 
-void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value)
+void iwl_write_direct32(struct iwl_bus *bus, u32 reg, u32 value)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	if (!iwl_grab_nic_access(priv)) {
-		iwl_write32(priv, reg, value);
-		iwl_release_nic_access(priv);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	if (!iwl_grab_nic_access(bus)) {
+		iwl_write32(bus, reg, value);
+		iwl_release_nic_access(bus);
 	}
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
+int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
 			int timeout)
 {
 	int t = 0;
 
 	do {
-		if ((iwl_read_direct32(priv, addr) & mask) == mask)
+		if ((iwl_read_direct32(bus, addr) & mask) == mask)
 			return t;
 		udelay(IWL_POLL_INTERVAL);
 		t += IWL_POLL_INTERVAL;
@@ -173,122 +177,122 @@ int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
 	return -ETIMEDOUT;
 }
 
-static inline u32 __iwl_read_prph(struct iwl_priv *priv, u32 reg)
+static inline u32 __iwl_read_prph(struct iwl_bus *bus, u32 reg)
 {
-	iwl_write32(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	iwl_write32(bus, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	rmb();
-	return iwl_read32(priv, HBUS_TARG_PRPH_RDAT);
+	return iwl_read32(bus, HBUS_TARG_PRPH_RDAT);
 }
 
-static inline void __iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
+static inline void __iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val)
 {
-	iwl_write32(priv, HBUS_TARG_PRPH_WADDR,
+	iwl_write32(bus, HBUS_TARG_PRPH_WADDR,
 		    ((addr & 0x0000FFFF) | (3 << 24)));
 	wmb();
-	iwl_write32(priv, HBUS_TARG_PRPH_WDAT, val);
+	iwl_write32(bus, HBUS_TARG_PRPH_WDAT, val);
 }
 
-u32 iwl_read_prph(struct iwl_priv *priv, u32 reg)
+u32 iwl_read_prph(struct iwl_bus *bus, u32 reg)
 {
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
-	val = __iwl_read_prph(priv, reg);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
+	val = __iwl_read_prph(bus, reg);
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 	return val;
 }
 
-void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val)
+void iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	if (!iwl_grab_nic_access(priv)) {
-		__iwl_write_prph(priv, addr, val);
-		iwl_release_nic_access(priv);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	if (!iwl_grab_nic_access(bus)) {
+		__iwl_write_prph(bus, addr, val);
+		iwl_release_nic_access(bus);
 	}
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
+void iwl_set_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
-	__iwl_write_prph(priv, reg, __iwl_read_prph(priv, reg) | mask);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
+	__iwl_write_prph(bus, reg, __iwl_read_prph(bus, reg) | mask);
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
+void iwl_set_bits_mask_prph(struct iwl_bus *bus, u32 reg,
 			    u32 bits, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
-	__iwl_write_prph(priv, reg,
-			 (__iwl_read_prph(priv, reg) & mask) | bits);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
+	__iwl_write_prph(bus, reg,
+			 (__iwl_read_prph(bus, reg) & mask) | bits);
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask)
+void iwl_clear_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
 {
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
-	val = __iwl_read_prph(priv, reg);
-	__iwl_write_prph(priv, reg, (val & ~mask));
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
+	val = __iwl_read_prph(bus, reg);
+	__iwl_write_prph(bus, reg, (val & ~mask));
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-void _iwl_read_targ_mem_words(struct iwl_priv *priv, u32 addr,
+void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
 			      void *buf, int words)
 {
 	unsigned long flags;
 	int offs;
 	u32 *vals = buf;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	iwl_grab_nic_access(priv);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	iwl_grab_nic_access(bus);
 
-	iwl_write32(priv, HBUS_TARG_MEM_RADDR, addr);
+	iwl_write32(bus, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
 
 	for (offs = 0; offs < words; offs++)
-		vals[offs] = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		vals[offs] = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
 
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	iwl_release_nic_access(bus);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
 
-u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr)
+u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr)
 {
 	u32 value;
 
-	_iwl_read_targ_mem_words(priv, addr, &value, 1);
+	_iwl_read_targ_mem_words(bus, addr, &value, 1);
 
 	return value;
 }
 
-void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val)
+void iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	if (!iwl_grab_nic_access(priv)) {
-		iwl_write32(priv, HBUS_TARG_MEM_WADDR, addr);
+	spin_lock_irqsave(&bus->reg_lock, flags);
+	if (!iwl_grab_nic_access(bus)) {
+		iwl_write32(bus, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
-		iwl_write32(priv, HBUS_TARG_MEM_WDAT, val);
-		iwl_release_nic_access(priv);
+		iwl_write32(bus, HBUS_TARG_MEM_WDAT, val);
+		iwl_release_nic_access(bus);
 	}
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
+	spin_unlock_irqrestore(&bus->reg_lock, flags);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 19a0931..ced2cbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -29,65 +29,62 @@
 #ifndef __iwl_io_h__
 #define __iwl_io_h__
 
-#include <linux/io.h>
-
-#include "iwl-dev.h"
-#include "iwl-debug.h"
 #include "iwl-devtrace.h"
+#include "iwl-shared.h"
 #include "iwl-bus.h"
 
-static inline void iwl_write8(struct iwl_priv *priv, u32 ofs, u8 val)
+static inline void iwl_write8(struct iwl_bus *bus, u32 ofs, u8 val)
 {
-	trace_iwlwifi_dev_iowrite8(priv, ofs, val);
-	bus_write8(priv->bus, ofs, val);
+	trace_iwlwifi_dev_iowrite8(priv(bus), ofs, val);
+	bus_write8(bus, ofs, val);
 }
 
-static inline void iwl_write32(struct iwl_priv *priv, u32 ofs, u32 val)
+static inline void iwl_write32(struct iwl_bus *bus, u32 ofs, u32 val)
 {
-	trace_iwlwifi_dev_iowrite32(priv, ofs, val);
-	bus_write32(priv->bus, ofs, val);
+	trace_iwlwifi_dev_iowrite32(priv(bus), ofs, val);
+	bus_write32(bus, ofs, val);
 }
 
-static inline u32 iwl_read32(struct iwl_priv *priv, u32 ofs)
+static inline u32 iwl_read32(struct iwl_bus *bus, u32 ofs)
 {
-	u32 val = bus_read32(priv->bus, ofs);
-	trace_iwlwifi_dev_ioread32(priv, ofs, val);
+	u32 val = bus_read32(bus, ofs);
+	trace_iwlwifi_dev_ioread32(priv(bus), ofs, val);
 	return val;
 }
 
-void iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask);
-void iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask);
+void iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask);
+void iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask);
 
-int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+int iwl_poll_bit(struct iwl_bus *bus, u32 addr,
 		 u32 bits, u32 mask, int timeout);
-int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
+int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
 			int timeout);
 
-int iwl_grab_nic_access_silent(struct iwl_priv *priv);
-int iwl_grab_nic_access(struct iwl_priv *priv);
-void iwl_release_nic_access(struct iwl_priv *priv);
+int iwl_grab_nic_access_silent(struct iwl_bus *bus);
+int iwl_grab_nic_access(struct iwl_bus *bus);
+void iwl_release_nic_access(struct iwl_bus *bus);
 
-u32 iwl_read_direct32(struct iwl_priv *priv, u32 reg);
-void iwl_write_direct32(struct iwl_priv *priv, u32 reg, u32 value);
+u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg);
+void iwl_write_direct32(struct iwl_bus *bus, u32 reg, u32 value);
 
 
-u32 iwl_read_prph(struct iwl_priv *priv, u32 reg);
-void iwl_write_prph(struct iwl_priv *priv, u32 addr, u32 val);
-void iwl_set_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask);
-void iwl_set_bits_mask_prph(struct iwl_priv *priv, u32 reg,
+u32 iwl_read_prph(struct iwl_bus *bus, u32 reg);
+void iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val);
+void iwl_set_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask);
+void iwl_set_bits_mask_prph(struct iwl_bus *bus, u32 reg,
 			    u32 bits, u32 mask);
-void iwl_clear_bits_prph(struct iwl_priv *priv, u32 reg, u32 mask);
+void iwl_clear_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask);
 
-void _iwl_read_targ_mem_words(struct iwl_priv *priv, u32 addr,
+void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
 			      void *buf, int words);
 
-#define iwl_read_targ_mem_words(priv, addr, buf, bufsize)	\
+#define iwl_read_targ_mem_words(bus, addr, buf, bufsize)	\
 	do {							\
 		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
-		_iwl_read_targ_mem_words(priv, addr, buf,	\
+		_iwl_read_targ_mem_words(bus, addr, buf,	\
 					 (bufsize) / sizeof(u32));\
 	} while (0)
 
-u32 iwl_read_targ_mem(struct iwl_priv *priv, u32 addr);
-void iwl_write_targ_mem(struct iwl_priv *priv, u32 addr, u32 val);
+u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr);
+void iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 76ee2d7..c78470d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -72,7 +72,7 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 /* Set led register off */
 void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	iwl_write32(bus(priv), CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 }
 
 /*
@@ -109,9 +109,9 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	};
 	u32 reg;
 
-	reg = iwl_read32(priv, CSR_LED_REG);
+	reg = iwl_read32(bus(priv), CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(priv, CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+		iwl_write32(bus(priv), CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
 
 	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 191c16a..17f3fb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -124,12 +124,12 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 		/* L1-ASPM enabled; disable(!) L0S */
-		iwl_set_bit(priv(bus), CSR_GIO_REG,
+		iwl_set_bit(bus, CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Enabled; Disabling L0S\n");
 	} else {
 		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(priv(bus), CSR_GIO_REG,
+		iwl_clear_bit(bus, CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Disabled; Enabling L0S\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d7c7c93..2c6659c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -531,16 +531,16 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     CT_CARD_DISABLED)) {
 
-		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+		iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		iwl_write_direct32(priv, HBUS_TARG_MBX_C,
+		iwl_write_direct32(bus(priv), HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
+			iwl_write_direct32(bus(priv), HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
 		if (flags & CT_CARD_DISABLED)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 15c9be8..b53d77b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -276,7 +276,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_REG_READ32:
-		val32 = iwl_read32(priv, ofs);
+		val32 = iwl_read32(bus(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -298,7 +298,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
 			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write32(priv, ofs, val32);
+			iwl_write32(bus(priv), ofs, val32);
 		}
 		break;
 	case IWL_TM_CMD_APP2DEV_REG_WRITE8:
@@ -308,7 +308,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
 			IWL_INFO(priv, "8bit value to write 0x%x\n", val8);
-			iwl_write8(priv, ofs, val8);
+			iwl_write8(bus(priv), ofs, val8);
 		}
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index b77b0f7..bd6e640 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -200,12 +200,12 @@ static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(priv(trans), CSR_INT, 0xffffffff);
-	iwl_write32(priv(trans), CSR_FH_INT_STATUS, 0xffffffff);
+	iwl_write32(bus(trans), CSR_INT, 0xffffffff);
+	iwl_write32(bus(trans), CSR_FH_INT_STATUS, 0xffffffff);
 	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
 }
 
@@ -216,7 +216,7 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 
 	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
-	iwl_write32(priv(trans), CSR_INT_MASK, trans_pcie->inta_mask);
+	iwl_write32(bus(trans), CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 7f8ac2e..5cff771 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -143,30 +143,30 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		iwl_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write_actual);
+		iwl_write32(bus(priv), FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
 		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
-			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 				IWL_DEBUG_INFO(trans,
 					"Rx queue requesting wakeup,"
 					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(priv, CSR_GP_CNTRL,
+				iwl_set_bit(bus(priv), CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				goto exit_unlock;
 			}
 
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(bus(priv), FH_RSCSR_CHNL0_WPTR,
 					q->write_actual);
 
 		/* Else device is assumed to be awake */
 		} else {
 			/* Device expects a multiple of 8 */
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(bus(priv), FH_RSCSR_CHNL0_WPTR,
 				q->write_actual);
 		}
 	}
@@ -591,7 +591,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 		return;
 	}
 
-	iwl_read_targ_mem_words(priv, base, &table, sizeof(table));
+	iwl_read_targ_mem_words(bus(priv), base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -637,9 +637,9 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	struct iwl_priv *priv = priv(trans);
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (priv->cfg->internal_wimax_coex &&
-	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
+	    (!(iwl_read_prph(bus(trans), APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
-	     (iwl_read_prph(priv, APMG_PS_CTRL_REG) &
+	     (iwl_read_prph(bus(trans), APMG_PS_CTRL_REG) &
 			APMG_PS_CTRL_VAL_RESET_REQ))) {
 		/*
 		 * Keep the restart process from trying to send host
@@ -706,18 +706,18 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&priv->reg_lock, reg_flags);
-	iwl_grab_nic_access(priv);
+	spin_lock_irqsave(&bus(priv)->reg_lock, reg_flags);
+	iwl_grab_nic_access(bus(priv));
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(priv, HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			if (bufsz) {
@@ -731,7 +731,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 					time, ev);
 			}
 		} else {
-			data = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
 			if (bufsz) {
 				pos += scnprintf(*buf + pos, bufsz - pos,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
@@ -746,8 +746,8 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	}
 
 	/* Allow device to power down */
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
+	iwl_release_nic_access(bus(priv));
+	spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
 	return pos;
 }
 
@@ -824,10 +824,10 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	}
 
 	/* event log header */
-	capacity = iwl_read_targ_mem(priv, base);
-	mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(priv, base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(bus(priv), base);
+	mode = iwl_read_targ_mem(bus(priv), base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(bus(priv), base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(bus(priv), base + (3 * sizeof(u32)));
 
 	if (capacity > logsize) {
 		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
@@ -927,7 +927,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(priv(trans), CSR_INT,
+	iwl_write32(bus(trans), CSR_INT,
 		trans_pcie->inta | ~trans_pcie->inta_mask);
 
 	inta = trans_pcie->inta;
@@ -935,7 +935,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
 		/* just for debug */
-		inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);
+		inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
 				inta, inta_mask);
 	}
@@ -983,7 +983,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(iwl_read32(priv(trans), CSR_GP_CNTRL) &
+		if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
@@ -1048,12 +1048,12 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(priv(trans), CSR_FH_INT_STATUS,
+			iwl_write32(bus(trans), CSR_FH_INT_STATUS,
 					CSR_FH_INT_RX_MASK);
 		}
 		if (inta & CSR_INT_BIT_RX_PERIODIC) {
 			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(priv(trans),
+			iwl_write32(bus(trans),
 				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
 		}
 		/* Sending RX interrupt require many steps to be done in the
@@ -1068,7 +1068,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		 */
 
 		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(priv(trans), CSR_INT_PERIODIC_REG,
+		iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
 		iwl_rx_handle(trans);
 
@@ -1080,7 +1080,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		 * to extend the periodic interrupt; one-shot is enough.
 		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(priv(trans), CSR_INT_PERIODIC_REG,
+			iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
 				    CSR_INT_PERIODIC_ENA);
 
 		isr_stats->rx++;
@@ -1088,7 +1088,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(priv(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		iwl_write32(bus(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
 		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
@@ -1216,10 +1216,10 @@ int iwl_reset_ict(struct iwl_trans *trans)
 			val,
 			(unsigned long long)trans_pcie->aligned_ict_tbl_dma);
 
-	iwl_write32(priv(trans), CSR_DRAM_INT_TBL_REG, val);
+	iwl_write32(bus(trans), CSR_DRAM_INT_TBL_REG, val);
 	trans_pcie->use_ict = true;
 	trans_pcie->ict_index = 0;
-	iwl_write32(priv(trans), CSR_INT, trans_pcie->inta_mask);
+	iwl_write32(bus(trans), CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
@@ -1259,11 +1259,11 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv(trans), CSR_INT);
+	inta = iwl_read32(bus(trans), CSR_INT);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
@@ -1282,7 +1282,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
-		inta_fh = iwl_read32(priv(trans), CSR_FH_INT_STATUS);
+		inta_fh = iwl_read32(bus(trans), CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
 	}
@@ -1345,8 +1345,8 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
 
 
 	/* Ignore interrupt if there's nothing in NIC to service.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index a706993..7ca54eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -96,7 +96,7 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 
 	if (priv->cfg->base_params->shadow_reg_enable) {
 		/* shadow register enabled */
-		iwl_write32(priv, HBUS_TARG_WRPTR,
+		iwl_write32(bus(priv), HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
 		/* if we're trying to save power */
@@ -104,18 +104,18 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
-			reg = iwl_read32(priv, CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 				IWL_DEBUG_INFO(priv,
 					"Tx queue %d requesting wakeup,"
 					" GP1 = 0x%x\n", txq_id, reg);
-				iwl_set_bit(priv, CSR_GP_CNTRL,
+				iwl_set_bit(bus(priv), CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				return;
 			}
 
-			iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+			iwl_write_direct32(bus(priv), HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
 
 		/*
@@ -124,7 +124,7 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		 * trying to tx (during RFKILL, we're not trying to tx).
 		 */
 		} else
-			iwl_write32(priv, HBUS_TARG_WRPTR,
+			iwl_write32(bus(priv), HBUS_TARG_WRPTR,
 				    txq->q.write_ptr | (txq_id << 8));
 	}
 	txq->need_update = 0;
@@ -374,14 +374,14 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
 	tbl_dw_addr = trans_pcie->scd_base_addr +
 			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl_read_targ_mem(priv(trans), tbl_dw_addr);
+	tbl_dw = iwl_read_targ_mem(bus(trans), tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl_write_targ_mem(priv(trans), tbl_dw_addr, tbl_dw);
+	iwl_write_targ_mem(bus(trans), tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
@@ -390,7 +390,7 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(priv(trans),
+	iwl_write_prph(bus(trans),
 		SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
@@ -399,9 +399,9 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 				int txq_id, u32 index)
 {
-	iwl_write_direct32(priv(trans), HBUS_TARG_WRPTR,
+	iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv(trans), SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
@@ -411,7 +411,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
 
-	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(bus(priv), SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -459,10 +459,10 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(bus(priv), SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(priv, SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(bus(priv), SCD_AGGR_SEL, (1<<txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -471,7 +471,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
+	iwl_write_targ_mem(bus(priv), trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((frame_limit <<
@@ -481,7 +481,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(bus(priv), SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
@@ -509,14 +509,14 @@ int iwl_trans_pcie_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
-	iwl_clear_bits_prph(priv, SCD_AGGR_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(bus(priv), SCD_AGGR_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
-	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(bus(priv), SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 95c9e87..b95e713 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -144,6 +144,7 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
+	struct iwl_trans *trans = trans(priv);
 
 	rb_timeout = RX_RB_TIMEOUT;
 
@@ -153,17 +154,17 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 
 	/* Stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
 	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_BASE_REG,
 			   (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			   rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
@@ -174,7 +175,7 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
@@ -184,7 +185,7 @@ static void iwl_trans_rx_hw_init(struct iwl_priv *priv,
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+	iwl_write8(bus(trans), CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 }
 
 static int iwl_rx_init(struct iwl_trans *trans)
@@ -268,8 +269,8 @@ static int iwl_trans_rx_stop(struct iwl_trans *trans)
 {
 
 	/* stop Rx DMA */
-	iwl_write_direct32(priv(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	return iwl_poll_direct_bit(priv(trans), FH_MEM_RSSR_RX_STATUS_REG,
+	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	return iwl_poll_direct_bit(bus(trans), FH_MEM_RSSR_RX_STATUS_REG,
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 }
 
@@ -397,7 +398,7 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
 	 * given Tx queue, and enable the DMA channel used for that queue.
 	 * Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv(trans), FH_MEM_CBBC_QUEUE(txq_id),
+	iwl_write_direct32(bus(trans), FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	return 0;
@@ -579,10 +580,11 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
-	iwl_write_prph(priv, SCD_TXFACT, 0);
+	iwl_write_prph(bus(trans), SCD_TXFACT, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, trans_pcie->kw.dma >> 4);
+	iwl_write_direct32(bus(trans), FH_KW_MEM_ADDR_REG,
+			   trans_pcie->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
@@ -608,17 +610,18 @@ error:
 
 static void iwl_set_pwr_vmain(struct iwl_priv *priv)
 {
+	struct iwl_trans *trans = trans(priv);
 /*
  * (for documentation purposes)
  * to set power to V_AUX, do:
 
 		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
 					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					       ~APMG_PS_CTRL_MSK_PWR_SRC);
  */
 
-	iwl_set_bits_mask_prph(priv, APMG_PS_CTRL_REG,
+	iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
 			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
@@ -633,7 +636,8 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	iwl_apm_init(priv);
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
+	iwl_write8(bus(trans), CSR_INT_COALESCING,
+		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
@@ -650,7 +654,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	if (priv->cfg->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
-		iwl_set_bit(priv, CSR_MAC_SHADOW_REG_CTRL,
+		iwl_set_bit(bus(trans), CSR_MAC_SHADOW_REG_CTRL,
 			0x800FFFFF);
 	}
 
@@ -666,11 +670,11 @@ static int iwl_set_hw_ready(struct iwl_trans *trans)
 {
 	int ret;
 
-	iwl_set_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
-	ret = iwl_poll_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				HW_READY_TIMEOUT);
@@ -691,10 +695,10 @@ static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
 		return 0;
 
 	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
 			CSR_HW_IF_CONFIG_REG_PREPARE);
 
-	ret = iwl_poll_bit(priv(trans), CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
@@ -722,7 +726,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(priv, CSR_GP_CNTRL) &
+	if (iwl_read32(bus(trans), CSR_GP_CNTRL) &
 			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 	else
@@ -734,7 +738,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 		return -ERFKILL;
 	}
 
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
 
 	ret = iwl_nic_init(trans);
 	if (ret) {
@@ -743,17 +747,17 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
 	iwl_enable_interrupts(trans);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	return 0;
 }
@@ -764,7 +768,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
  */
 static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 {
-	iwl_write_prph(priv(trans), SCD_TXFACT, mask);
+	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
 }
 
 #define IWL_AC_UNSET -1
@@ -814,46 +818,47 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
-	trans_pcie->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
+	trans_pcie->scd_base_addr =
+		iwl_read_prph(bus(trans), SCD_SRAM_BASE_ADDR);
 	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
 	/* reset conext data memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(bus(trans), a, 0);
 	/* reset tx status memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(bus(trans), a, 0);
 	for (; a < trans_pcie->scd_base_addr +
 	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(priv).max_txq_num);
 	       a += 4)
-		iwl_write_targ_mem(priv, a, 0);
+		iwl_write_targ_mem(bus(trans), a, 0);
 
-	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
+	reg_val = iwl_read_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
-	iwl_write_prph(priv, SCD_QUEUECHAIN_SEL,
+	iwl_write_prph(bus(trans), SCD_QUEUECHAIN_SEL,
 		SCD_QUEUECHAIN_SEL_ALL(priv));
-	iwl_write_prph(priv, SCD_AGGR_SEL, 0);
+	iwl_write_prph(bus(trans), SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
 	for (i = 0; i < hw_params(priv).max_txq_num; i++) {
-		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
+		iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
+		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i) +
 				sizeof(u32),
 				((SCD_WIN_SIZE <<
@@ -864,7 +869,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
+	iwl_write_prph(bus(trans), SCD_INTERRUPT_MASK,
 			IWL_MASK(0, hw_params(trans).max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
@@ -910,7 +915,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	/* Enable L1-Active */
-	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
+	iwl_clear_bits_prph(bus(trans), APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
@@ -930,14 +935,14 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write_direct32(priv(trans),
+		iwl_write_direct32(bus(trans),
 				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(priv(trans), FH_TSSR_TX_STATUS_REG,
+		if (iwl_poll_direct_bit(bus(trans), FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
 			IWL_ERR(trans, "Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(priv(trans),
+			    iwl_read_direct32(bus(trans),
 					      FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -957,7 +962,7 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 {
 	/* stop and reset the on-board processor */
-	iwl_write32(priv(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(bus(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
 	iwl_trans_disable_sync_irq(trans);
@@ -977,13 +982,13 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 		iwl_trans_rx_stop(trans);
 
 		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(priv(trans), APMG_CLK_DIS_REG,
+		iwl_write_prph(bus(trans), APMG_CLK_DIS_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
 		udelay(5);
 	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(priv(trans), CSR_GP_CNTRL,
+	iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
@@ -1148,7 +1153,7 @@ static int iwl_trans_pcie_tx(struct iwl_priv *priv, struct sk_buff *skb,
 static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv(trans), CSR_RESET, 0);
+	iwl_write32(bus(trans), CSR_RESET, 0);
 }
 
 static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
@@ -1253,7 +1258,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 
 	iwl_enable_interrupts(trans);
 
-	if (!(iwl_read32(priv(trans), CSR_GP_CNTRL) &
+	if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 		hw_rfkill = true;
 
@@ -1712,7 +1717,7 @@ void iwl_dump_csr(struct iwl_trans *trans)
 	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
 		IWL_ERR(trans, "  %25s: 0X%08x\n",
 			get_csr_string(csr_tbl[i]),
-			iwl_read32(priv(trans), csr_tbl[i]));
+			iwl_read32(bus(trans), csr_tbl[i]));
 	}
 }
 
@@ -1784,7 +1789,7 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 			pos += scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(priv(trans), fh_tbl[i]));
+				iwl_read_direct32(bus(trans), fh_tbl[i]));
 		}
 		return pos;
 	}
@@ -1793,7 +1798,7 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
 		IWL_ERR(trans, "  %34s: 0X%08x\n",
 			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(priv(trans), fh_tbl[i]));
+			iwl_read_direct32(bus(trans), fh_tbl[i]));
 	}
 	return 0;
 }
-- 
1.7.0.4

