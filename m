Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2BCAQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 19:16:53 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/28] iwlwifi: give trans to all the read / write functions
Date: Thu,  2 Feb 2012 15:08:59 -0800
Message-Id: <1328224159-18134-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120203_011753_286198_65B033F0)
In-Reply-To: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1328224159-18134-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

>From now on, the transport layer in charge of providing access to the
device. So change all the driver to give a pointer to the transport
to all the low level functions that actually access the device.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   42 +++---
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    3 -
 drivers/net/wireless/iwlwifi/iwl-core.c           |   28 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   61 ++++----
 drivers/net/wireless/iwlwifi/iwl-io.c             |  193 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-io.h             |   63 +++----
 drivers/net/wireless/iwlwifi/iwl-led.c            |    9 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |   27 ++--
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |   16 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    8 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   82 +++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   46 +++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |  144 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    2 +
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |   37 ++--
 24 files changed, 405 insertions(+), 406 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index cc04cce..f7a555b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -84,13 +84,13 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
-	iwl_set_bits_mask_prph(bus(priv), APMG_DIGITAL_SVR_REG,
+	iwl_set_bits_mask_prph(trans(priv), APMG_DIGITAL_SVR_REG,
 				APMG_SVR_DIGITAL_VOLTAGE_1_32,
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 00db092..8760034 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -87,7 +87,7 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 	iwl_rf_config(priv);
 
 	if (cfg(priv)->iq_invert)
-		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
+		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 47fd98b..5245a14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -73,7 +73,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	iwl_set_bits_mask_prph(bus(priv), APMG_PS_CTRL_REG,
+	iwl_set_bits_mask_prph(trans(priv), APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ab62c01..464b887 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -82,7 +82,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
 	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
-		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
+		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
 
@@ -90,9 +90,9 @@ static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
 	if (iwl_eeprom_calib_version(priv->shrd) >= 6)
-		iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
+		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-	iwl_set_bit(bus(priv), CSR_GP_DRIVER_REG,
+	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
 		    CSR_GP_DRIVER_REG_BIT_6050_1x2);
 }
 
@@ -104,7 +104,7 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 	/* no locking required for register write */
 	if (cfg(priv)->pa_type == IWL_PA_INTERNAL) {
 		/* 2x2 IPA phy type */
-		iwl_write32(bus(priv), CSR_GP_DRIVER_REG,
+		iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* do additional nic configuration if needed */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index f127f91..a14ddab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -628,16 +628,16 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     CT_CARD_DISABLED)) {
 
-		iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
+		iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		iwl_write_direct32(bus(priv), HBUS_TARG_MBX_C,
+		iwl_write_direct32(trans(priv), HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			iwl_write_direct32(bus(priv), HBUS_TARG_MBX_C,
+			iwl_write_direct32(trans(priv), HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
 		if (flags & CT_CARD_DISABLED)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 56c6def..c728ed7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -178,19 +178,19 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 
 	if (tt->state == IWL_TI_CT_KILL) {
 		if (priv->thermal_throttle.ct_kill_toggle) {
-			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = false;
 		} else {
-			iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
-		iwl_read32(bus(priv), CSR_UCODE_DRV_GP1);
-		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
-		if (!iwl_grab_nic_access(bus(priv)))
-			iwl_release_nic_access(bus(priv));
-		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
+		iwl_read32(trans(priv), CSR_UCODE_DRV_GP1);
+		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
+		if (!iwl_grab_nic_access(trans(priv)))
+			iwl_release_nic_access(trans(priv));
+		spin_unlock_irqrestore(&trans(priv)->reg_lock, flags);
 
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1a4ba9d..f797915 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -328,14 +328,14 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&bus(priv)->reg_lock, reg_flags);
-	if (iwl_grab_nic_access(bus(priv))) {
-		spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
+	spin_lock_irqsave(&trans(priv)->reg_lock, reg_flags);
+	if (iwl_grab_nic_access(trans(priv))) {
+		spin_unlock_irqrestore(&trans(priv)->reg_lock, reg_flags);
 		return;
 	}
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/*
@@ -352,19 +352,19 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	 * place event id # at far right for easier visual parsing.
 	 */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			trace_iwlwifi_dev_ucode_cont_event(priv, 0, time, ev);
 		} else {
-			data = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
 			trace_iwlwifi_dev_ucode_cont_event(priv, time,
 							   data, ev);
 		}
 	}
 	/* Allow device to power down */
-	iwl_release_nic_access(bus(priv));
-	spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
+	iwl_release_nic_access(trans(priv));
+	spin_unlock_irqrestore(&trans(priv)->reg_lock, reg_flags);
 }
 
 static void iwl_continuous_event_trace(struct iwl_priv *priv)
@@ -383,7 +383,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 
 	base = priv->shrd->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		iwl_read_targ_mem_words(bus(priv), base, &read, sizeof(read));
+		iwl_read_targ_mem_words(trans(priv), base, &read, sizeof(read));
 
 		capacity = read.capacity;
 		mode = read.mode;
@@ -583,7 +583,7 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 		       priv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, priv->firmware_name,
-				       bus(priv)->dev,
+				       trans(priv)->dev,
 				       GFP_KERNEL, priv, iwl_ucode_callback);
 }
 
@@ -1158,7 +1158,7 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	int ret = 0;
 
 	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->shrd->lock, flags);
 	priv->thermal_throttle.ct_kill_toggle = false;
@@ -1693,7 +1693,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 
 static u32 iwl_hw_detect(struct iwl_priv *priv)
 {
-	return iwl_read32(bus(priv), CSR_HW_REV);
+	return iwl_read32(trans(priv), CSR_HW_REV);
 }
 
 /* Size of one Rx buffer in host DRAM */
@@ -1727,32 +1727,32 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 
 static void iwl_debug_config(struct iwl_priv *priv)
 {
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEBUG "
+	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEBUG "
 #ifdef CONFIG_IWLWIFI_DEBUG
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEBUGFS "
+	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEBUGFS "
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
+	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
 
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
+	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_P2P "
+	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_P2P "
 #ifdef CONFIG_IWLWIFI_P2P
 		"enabled\n");
 #else
@@ -1810,7 +1810,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
-	spin_lock_init(&bus(priv)->reg_lock);
+	spin_lock_init(&trans(priv)->reg_lock);
 	spin_lock_init(&priv->shrd->lock);
 
 	/*
@@ -1818,7 +1818,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	 * strange state ... like being left stranded by a primary kernel
 	 * and this is now the kdump kernel trying to start up
 	 */
-	iwl_write32(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/***********************
 	 * 3. Read REV register
@@ -1903,7 +1903,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	iwl_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(bus(priv),
+	if (iwl_read32(trans(priv),
 			CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
 	else
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 981f7b7..ce1a9cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -142,15 +142,12 @@ struct iwl_bus_ops {
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  *	NB: for the time being this needs to be set by the upper layer since
  *	it allocates the shared data
- * @reg_lock - protect hw register access
  */
 struct iwl_bus {
 	struct device *dev;
 	const struct iwl_bus_ops *ops;
 	struct iwl_shared *shrd;
 
-	spinlock_t reg_lock;
-
 	/* pointer to bus specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char bus_specific[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7d6eef9..c9022c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -888,9 +888,9 @@ static int iwl_apm_stop_master(struct iwl_priv *priv)
 	int ret = 0;
 
 	/* stop device's busmaster DMA activity */
-	iwl_set_bit(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	iwl_set_bit(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = iwl_poll_bit(bus(priv), CSR_RESET,
+	ret = iwl_poll_bit(trans(priv), CSR_RESET,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret)
@@ -911,7 +911,7 @@ void iwl_apm_stop(struct iwl_priv *priv)
 	iwl_apm_stop_master(priv);
 
 	/* Reset the entire device */
-	iwl_set_bit(bus(priv), CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	iwl_set_bit(trans(priv), CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
 
@@ -919,7 +919,8 @@ void iwl_apm_stop(struct iwl_priv *priv)
 	 * Clear "initialization complete" bit to move adapter from
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
-	iwl_clear_bit(bus(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_clear_bit(trans(priv), CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 }
 
 
@@ -939,45 +940,46 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 */
 
 	/* Disable L0S exit timer (platform NMI Work/Around) */
-	iwl_set_bit(bus(priv), CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(trans(priv), CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER);
 
 	/*
 	 * Disable L0s without affecting L1;
 	 *  don't wait for ICH L0s (ICH bug W/A)
 	 */
-	iwl_set_bit(bus(priv), CSR_GIO_CHICKEN_BITS,
+	iwl_set_bit(trans(priv), CSR_GIO_CHICKEN_BITS,
 			  CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
 	/* Set FH wait threshold to maximum (HW error during stress W/A) */
-	iwl_set_bit(bus(priv), CSR_DBG_HPET_MEM_REG, CSR_DBG_HPET_MEM_REG_VAL);
+	iwl_set_bit(trans(priv), CSR_DBG_HPET_MEM_REG,
+		    CSR_DBG_HPET_MEM_REG_VAL);
 
 	/*
 	 * Enable HAP INTA (interrupt from management bus) to
 	 * wake device's PCI Express link L1a -> L0s
 	 */
-	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_BIT_HAP_WAKE_L1A);
 
 	bus_apm_config(bus(priv));
 
 	/* Configure analog phase-lock-loop before activating to D0A */
 	if (cfg(priv)->base_params->pll_cfg_val)
-		iwl_set_bit(bus(priv), CSR_ANA_PLL_CFG,
+		iwl_set_bit(trans(priv), CSR_ANA_PLL_CFG,
 			    cfg(priv)->base_params->pll_cfg_val);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
 	 * D0U* --> D0A* (powered-up active) state.
 	 */
-	iwl_set_bit(bus(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	iwl_set_bit(trans(priv), CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/*
 	 * Wait for clock stabilization; once stabilized, access to
 	 * device-internal resources is supported, e.g. iwl_write_prph()
 	 * and accesses to uCode SRAM.
 	 */
-	ret = iwl_poll_bit(bus(priv), CSR_GP_CNTRL,
+	ret = iwl_poll_bit(trans(priv), CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
@@ -992,11 +994,11 @@ int iwl_apm_init(struct iwl_priv *priv)
 	 * do not disable clocks.  This preserves any hardware bits already
 	 * set by default in "CLK_CTRL_REG" after reset.
 	 */
-	iwl_write_prph(bus(priv), APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	iwl_write_prph(trans(priv), APMG_CLK_EN_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(20);
 
 	/* Disable L1-Active */
-	iwl_set_bits_prph(bus(priv), APMG_PCIDEV_STT_REG,
+	iwl_set_bits_prph(trans(priv), APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
 	set_bit(STATUS_DEVICE_ENABLED, &priv->shrd->status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 63f2911..e74bfb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -300,7 +300,7 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
-	iwl_write32(bus(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+	iwl_write32(trans(priv), CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
 extern bool bt_siso_mode;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 978a1d4..136de6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -263,7 +263,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	sram = priv->dbgfs_sram_offset & ~0x3;
 
 	/* read the first u32 from sram */
-	val = iwl_read_targ_mem(bus(priv), sram);
+	val = iwl_read_targ_mem(trans(priv), sram);
 
 	for (; len; len--) {
 		/* put the address at the start of every line */
@@ -282,7 +282,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		if (++offset == 4) {
 			sram += 4;
 			offset = 0;
-			val = iwl_read_targ_mem(bus(priv), sram);
+			val = iwl_read_targ_mem(trans(priv), sram);
 		}
 
 		/* put in extra spaces and split lines for human readability */
@@ -2055,7 +2055,7 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	u32 pwrsave_status;
 
-	pwrsave_status = iwl_read32(bus(priv), CSR_GP_CNTRL) &
+	pwrsave_status = iwl_read32(trans(priv), CSR_GP_CNTRL) &
 			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ce214e0..d1fd1cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -156,16 +156,16 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
 
 	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
 		/* Request semaphore */
-		iwl_set_bit(bus, CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = iwl_poll_bit(bus, CSR_HW_IF_CONFIG_REG,
+		ret = iwl_poll_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
 		if (ret >= 0) {
-			IWL_DEBUG_EEPROM(bus,
+			IWL_DEBUG_EEPROM(trans(bus),
 				"Acquired semaphore after %d tries.\n",
 				count+1);
 			return ret;
@@ -177,14 +177,15 @@ static int iwl_eeprom_acquire_semaphore(struct iwl_bus *bus)
 
 static void iwl_eeprom_release_semaphore(struct iwl_bus *bus)
 {
-	iwl_clear_bit(bus, CSR_HW_IF_CONFIG_REG,
+	iwl_clear_bit(trans(bus), CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 }
 
 static int iwl_eeprom_verify_signature(struct iwl_trans *trans)
 {
-	u32 gp = iwl_read32(bus(trans), CSR_EEPROM_GP) & CSR_EEPROM_GP_VALID_MSK;
+	u32 gp = iwl_read32(trans, CSR_EEPROM_GP) &
+			   CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
 	IWL_DEBUG_EEPROM(trans, "EEPROM signature=0x%08x\n", gp);
@@ -305,13 +306,13 @@ void iwl_eeprom_get_mac(const struct iwl_shared *shrd, u8 *mac)
 
 static void iwl_set_otp_access(struct iwl_bus *bus, enum iwl_access_mode mode)
 {
-	iwl_read32(bus, CSR_OTP_GP_REG);
+	iwl_read32(trans(bus), CSR_OTP_GP_REG);
 
 	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
-		iwl_clear_bit(bus, CSR_OTP_GP_REG,
+		iwl_clear_bit(trans(bus), CSR_OTP_GP_REG,
 			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 	else
-		iwl_set_bit(bus, CSR_OTP_GP_REG,
+		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
@@ -332,7 +333,7 @@ static int iwl_get_nvm_type(struct iwl_bus *bus, u32 hw_rev)
 		nvm_type = NVM_DEVICE_TYPE_EEPROM;
 		break;
 	default:
-		otpgp = iwl_read32(bus, CSR_OTP_GP_REG);
+		otpgp = iwl_read32(trans(bus), CSR_OTP_GP_REG);
 		if (otpgp & CSR_OTP_GP_REG_DEVICE_SELECT)
 			nvm_type = NVM_DEVICE_TYPE_OTP;
 		else
@@ -347,22 +348,22 @@ static int iwl_init_otp_access(struct iwl_bus *bus)
 	int ret;
 
 	/* Enable 40MHz radio clock */
-	iwl_write32(bus, CSR_GP_CNTRL,
-		    iwl_read32(bus, CSR_GP_CNTRL) |
+	iwl_write32(trans(bus), CSR_GP_CNTRL,
+		    iwl_read32(trans(bus), CSR_GP_CNTRL) |
 		    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	/* wait for clock to be ready */
-	ret = iwl_poll_bit(bus, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(trans(bus), CSR_GP_CNTRL,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 				 25000);
 	if (ret < 0)
 		IWL_ERR(bus, "Time out access OTP\n");
 	else {
-		iwl_set_bits_prph(bus, APMG_PS_CTRL_REG,
+		iwl_set_bits_prph(trans(bus), APMG_PS_CTRL_REG,
 				  APMG_PS_CTRL_VAL_RESET_REQ);
 		udelay(5);
-		iwl_clear_bits_prph(bus, APMG_PS_CTRL_REG,
+		iwl_clear_bits_prph(trans(bus), APMG_PS_CTRL_REG,
 				    APMG_PS_CTRL_VAL_RESET_REQ);
 
 		/*
@@ -370,7 +371,7 @@ static int iwl_init_otp_access(struct iwl_bus *bus)
 		 * this is only applicable for HW with OTP shadow RAM
 		 */
 		if (cfg(bus)->base_params->shadow_ram_support)
-			iwl_set_bit(bus, CSR_DBG_LINK_PWR_MGMT_REG,
+			iwl_set_bit(trans(bus), CSR_DBG_LINK_PWR_MGMT_REG,
 				CSR_RESET_LINK_PWR_MGMT_DISABLED);
 	}
 	return ret;
@@ -382,9 +383,9 @@ static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
 	u32 r;
 	u32 otpgp;
 
-	iwl_write32(bus, CSR_EEPROM_REG,
+	iwl_write32(trans(bus), CSR_EEPROM_REG,
 		    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
-	ret = iwl_poll_bit(bus, CSR_EEPROM_REG,
+	ret = iwl_poll_bit(trans(bus), CSR_EEPROM_REG,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 CSR_EEPROM_REG_READ_VALID_MSK,
 				 IWL_EEPROM_ACCESS_TIMEOUT);
@@ -392,13 +393,13 @@ static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
 		IWL_ERR(bus, "Time out reading OTP[%d]\n", addr);
 		return ret;
 	}
-	r = iwl_read32(bus, CSR_EEPROM_REG);
+	r = iwl_read32(trans(bus), CSR_EEPROM_REG);
 	/* check for ECC errors: */
-	otpgp = iwl_read32(bus, CSR_OTP_GP_REG);
+	otpgp = iwl_read32(trans(bus), CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
 		/* set the uncorrectable OTP ECC bit for acknowledgement */
-		iwl_set_bit(bus, CSR_OTP_GP_REG,
+		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
 			CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		IWL_ERR(bus, "Uncorrectable OTP ECC error, abort OTP read\n");
 		return -EINVAL;
@@ -406,7 +407,7 @@ static int iwl_read_otp_word(struct iwl_bus *bus, u16 addr, __le16 *eeprom_data)
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
 		/* set the correctable OTP ECC bit for acknowledgement */
-		iwl_set_bit(bus, CSR_OTP_GP_REG,
+		iwl_set_bit(trans(bus), CSR_OTP_GP_REG,
 				CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
 		IWL_ERR(bus, "Correctable OTP ECC error, continue read\n");
 	}
@@ -656,7 +657,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
 	struct iwl_shared *shrd = priv->shrd;
 	__le16 *e;
-	u32 gp = iwl_read32(bus(priv), CSR_EEPROM_GP);
+	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
@@ -699,11 +700,11 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 			ret = -ENOENT;
 			goto done;
 		}
-		iwl_write32(bus(priv), CSR_EEPROM_GP,
-			    iwl_read32(bus(priv), CSR_EEPROM_GP) &
+		iwl_write32(trans(priv), CSR_EEPROM_GP,
+			    iwl_read32(trans(priv), CSR_EEPROM_GP) &
 			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(bus(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(trans(priv), CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
@@ -728,10 +729,10 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(bus(priv), CSR_EEPROM_REG,
+			iwl_write32(trans(priv), CSR_EEPROM_REG,
 				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bit(bus(priv), CSR_EEPROM_REG,
+			ret = iwl_poll_bit(trans(priv), CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
@@ -739,7 +740,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 				IWL_ERR(priv, "Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = iwl_read32(bus(priv), CSR_EEPROM_REG);
+			r = iwl_read32(trans(priv), CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
@@ -1068,7 +1069,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
 			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
@@ -1080,7 +1081,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 		WARN_ON(1);
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(bus(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 83fdff3..e2e3b5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -34,41 +34,41 @@
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
-static inline void __iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask)
+static inline void __iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
-	iwl_write32(bus, reg, iwl_read32(bus, reg) | mask);
+	iwl_write32(trans, reg, iwl_read32(trans, reg) | mask);
 }
 
-static inline void __iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask)
+static inline void __iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
-	iwl_write32(bus, reg, iwl_read32(bus, reg) & ~mask);
+	iwl_write32(trans, reg, iwl_read32(trans, reg) & ~mask);
 }
 
-void iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask)
+void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	__iwl_set_bit(bus, reg, mask);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	__iwl_set_bit(trans, reg, mask);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-void iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask)
+void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	__iwl_clear_bit(bus, reg, mask);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	__iwl_clear_bit(trans, reg, mask);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-int iwl_poll_bit(struct iwl_bus *bus, u32 addr,
+int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout)
 {
 	int t = 0;
 
 	do {
-		if ((iwl_read32(bus, addr) & mask) == (bits & mask))
+		if ((iwl_read32(trans, addr) & mask) == (bits & mask))
 			return t;
 		udelay(IWL_POLL_INTERVAL);
 		t += IWL_POLL_INTERVAL;
@@ -77,14 +77,15 @@ int iwl_poll_bit(struct iwl_bus *bus, u32 addr,
 	return -ETIMEDOUT;
 }
 
-int iwl_grab_nic_access_silent(struct iwl_bus *bus)
+int iwl_grab_nic_access_silent(struct iwl_trans *trans)
 {
 	int ret;
 
-	lockdep_assert_held(&bus->reg_lock);
+	lockdep_assert_held(&trans->reg_lock);
 
 	/* this bit wakes up the NIC */
-	__iwl_set_bit(bus, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	__iwl_set_bit(trans, CSR_GP_CNTRL,
+		      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/*
 	 * These bits say the device is running, and should keep running for
@@ -105,70 +106,70 @@ int iwl_grab_nic_access_silent(struct iwl_bus *bus)
 	 * 5000 series and later (including 1000 series) have non-volatile SRAM,
 	 * and do not save/restore SRAM when power cycling.
 	 */
-	ret = iwl_poll_bit(bus, CSR_GP_CNTRL,
+	ret = iwl_poll_bit(trans, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
-		iwl_write32(bus, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
+		iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
 
 	return 0;
 }
 
-int iwl_grab_nic_access(struct iwl_bus *bus)
+int iwl_grab_nic_access(struct iwl_trans *trans)
 {
-	int ret = iwl_grab_nic_access_silent(bus);
+	int ret = iwl_grab_nic_access_silent(trans);
 	if (ret) {
-		u32 val = iwl_read32(bus, CSR_GP_CNTRL);
-		IWL_ERR(bus,
+		u32 val = iwl_read32(trans, CSR_GP_CNTRL);
+		IWL_ERR(trans,
 			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
 	}
 
 	return ret;
 }
 
-void iwl_release_nic_access(struct iwl_bus *bus)
+void iwl_release_nic_access(struct iwl_trans *trans)
 {
-	lockdep_assert_held(&bus->reg_lock);
-	__iwl_clear_bit(bus, CSR_GP_CNTRL,
+	lockdep_assert_held(&trans->reg_lock);
+	__iwl_clear_bit(trans, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 }
 
-u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg)
+u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg)
 {
 	u32 value;
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	value = iwl_read32(bus, reg);
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
+	value = iwl_read32(trans, reg);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return value;
 }
 
-void iwl_write_direct32(struct iwl_bus *bus, u32 reg, u32 value)
+void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
-		iwl_write32(bus, reg, value);
-		iwl_release_nic_access(bus);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	if (!iwl_grab_nic_access(trans)) {
+		iwl_write32(trans, reg, value);
+		iwl_release_nic_access(trans);
 	}
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
+int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout)
 {
 	int t = 0;
 
 	do {
-		if ((iwl_read_direct32(bus, addr) & mask) == mask)
+		if ((iwl_read_direct32(trans, addr) & mask) == mask)
 			return t;
 		udelay(IWL_POLL_INTERVAL);
 		t += IWL_POLL_INTERVAL;
@@ -177,135 +178,135 @@ int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
 	return -ETIMEDOUT;
 }
 
-static inline u32 __iwl_read_prph(struct iwl_bus *bus, u32 reg)
+static inline u32 __iwl_read_prph(struct iwl_trans *trans, u32 reg)
 {
-	iwl_write32(bus, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	iwl_write32(trans, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
 	rmb();
-	return iwl_read32(bus, HBUS_TARG_PRPH_RDAT);
+	return iwl_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
-static inline void __iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val)
+static inline void __iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 {
-	iwl_write32(bus, HBUS_TARG_PRPH_WADDR,
+	iwl_write32(trans, HBUS_TARG_PRPH_WADDR,
 		    ((addr & 0x0000FFFF) | (3 << 24)));
 	wmb();
-	iwl_write32(bus, HBUS_TARG_PRPH_WDAT, val);
+	iwl_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-u32 iwl_read_prph(struct iwl_bus *bus, u32 reg)
+u32 iwl_read_prph(struct iwl_trans *trans, u32 reg)
 {
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	val = __iwl_read_prph(bus, reg);
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
+	val = __iwl_read_prph(trans, reg);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 	return val;
 }
 
-void iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val)
+void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
-		__iwl_write_prph(bus, addr, val);
-		iwl_release_nic_access(bus);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	if (!iwl_grab_nic_access(trans)) {
+		__iwl_write_prph(trans, addr, val);
+		iwl_release_nic_access(trans);
 	}
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-void iwl_set_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
+void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	__iwl_write_prph(bus, reg, __iwl_read_prph(bus, reg) | mask);
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
+	__iwl_write_prph(trans, reg, __iwl_read_prph(trans, reg) | mask);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-void iwl_set_bits_mask_prph(struct iwl_bus *bus, u32 reg,
+void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 			    u32 bits, u32 mask)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	__iwl_write_prph(bus, reg,
-			 (__iwl_read_prph(bus, reg) & mask) | bits);
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
+	__iwl_write_prph(trans, reg,
+			 (__iwl_read_prph(trans, reg) & mask) | bits);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-void iwl_clear_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask)
+void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask)
 {
 	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
-	val = __iwl_read_prph(bus, reg);
-	__iwl_write_prph(bus, reg, (val & ~mask));
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
+	val = __iwl_read_prph(trans, reg);
+	__iwl_write_prph(trans, reg, (val & ~mask));
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
+void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 			      void *buf, int words)
 {
 	unsigned long flags;
 	int offs;
 	u32 *vals = buf;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	iwl_grab_nic_access(bus);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	iwl_grab_nic_access(trans);
 
-	iwl_write32(bus, HBUS_TARG_MEM_RADDR, addr);
+	iwl_write32(trans, HBUS_TARG_MEM_RADDR, addr);
 	rmb();
 
 	for (offs = 0; offs < words; offs++)
-		vals[offs] = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
+		vals[offs] = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 
-	iwl_release_nic_access(bus);
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 }
 
-u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr)
+u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
 {
 	u32 value;
 
-	_iwl_read_targ_mem_words(bus, addr, &value, 1);
+	_iwl_read_targ_mem_words(trans, addr, &value, 1);
 
 	return value;
 }
 
-int _iwl_write_targ_mem_words(struct iwl_bus *bus, u32 addr,
+int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 				void *buf, int words)
 {
 	unsigned long flags;
 	int offs, result = 0;
 	u32 *vals = buf;
 
-	spin_lock_irqsave(&bus->reg_lock, flags);
-	if (!iwl_grab_nic_access(bus)) {
-		iwl_write32(bus, HBUS_TARG_MEM_WADDR, addr);
+	spin_lock_irqsave(&trans->reg_lock, flags);
+	if (!iwl_grab_nic_access(trans)) {
+		iwl_write32(trans, HBUS_TARG_MEM_WADDR, addr);
 		wmb();
 
 		for (offs = 0; offs < words; offs++)
-			iwl_write32(bus, HBUS_TARG_MEM_WDAT, vals[offs]);
-		iwl_release_nic_access(bus);
+			iwl_write32(trans, HBUS_TARG_MEM_WDAT, vals[offs]);
+		iwl_release_nic_access(trans);
 	} else
 		result = -EBUSY;
-	spin_unlock_irqrestore(&bus->reg_lock, flags);
+	spin_unlock_irqrestore(&trans->reg_lock, flags);
 
 	return result;
 }
 
-int iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val)
+int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val)
 {
-	return _iwl_write_targ_mem_words(bus, addr, &val, 1);
+	return _iwl_write_targ_mem_words(trans, addr, &val, 1);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index b8e00cd..782486f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -31,68 +31,63 @@
 
 #include "iwl-devtrace.h"
 #include "iwl-shared.h"
-/* TODO: remove when not needed any more */
-#include "iwl-bus.h"
 #include "iwl-trans.h"
 
-static inline void iwl_write8(struct iwl_bus *bus, u32 ofs, u8 val)
+static inline void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val)
 {
-	/* TODO: get trans instead of bus */
-	trace_iwlwifi_dev_iowrite8(priv(bus), ofs, val);
-	iwl_trans_write8(trans(bus), ofs, val);
+	trace_iwlwifi_dev_iowrite8(priv(trans), ofs, val);
+	iwl_trans_write8(trans, ofs, val);
 }
 
-static inline void iwl_write32(struct iwl_bus *bus, u32 ofs, u32 val)
+static inline void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 {
-	/* TODO: get trans instead of bus */
-	trace_iwlwifi_dev_iowrite32(priv(bus), ofs, val);
-	iwl_trans_write32(trans(bus), ofs, val);
+	trace_iwlwifi_dev_iowrite32(priv(trans), ofs, val);
+	iwl_trans_write32(trans, ofs, val);
 }
 
-static inline u32 iwl_read32(struct iwl_bus *bus, u32 ofs)
+static inline u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 {
-	/* TODO: get trans instead of bus */
-	u32 val = iwl_trans_read32(trans(bus), ofs);
-	trace_iwlwifi_dev_ioread32(priv(bus), ofs, val);
+	u32 val = iwl_trans_read32(trans, ofs);
+	trace_iwlwifi_dev_ioread32(priv(trans), ofs, val);
 	return val;
 }
 
-void iwl_set_bit(struct iwl_bus *bus, u32 reg, u32 mask);
-void iwl_clear_bit(struct iwl_bus *bus, u32 reg, u32 mask);
+void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask);
+void iwl_clear_bit(struct iwl_trans *trans, u32 reg, u32 mask);
 
-int iwl_poll_bit(struct iwl_bus *bus, u32 addr,
+int iwl_poll_bit(struct iwl_trans *trans, u32 addr,
 		 u32 bits, u32 mask, int timeout);
-int iwl_poll_direct_bit(struct iwl_bus *bus, u32 addr, u32 mask,
+int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout);
 
-int iwl_grab_nic_access_silent(struct iwl_bus *bus);
-int iwl_grab_nic_access(struct iwl_bus *bus);
-void iwl_release_nic_access(struct iwl_bus *bus);
+int iwl_grab_nic_access_silent(struct iwl_trans *trans);
+int iwl_grab_nic_access(struct iwl_trans *trans);
+void iwl_release_nic_access(struct iwl_trans *trans);
 
-u32 iwl_read_direct32(struct iwl_bus *bus, u32 reg);
-void iwl_write_direct32(struct iwl_bus *bus, u32 reg, u32 value);
+u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
+void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
-u32 iwl_read_prph(struct iwl_bus *bus, u32 reg);
-void iwl_write_prph(struct iwl_bus *bus, u32 addr, u32 val);
-void iwl_set_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask);
-void iwl_set_bits_mask_prph(struct iwl_bus *bus, u32 reg,
+u32 iwl_read_prph(struct iwl_trans *trans, u32 reg);
+void iwl_write_prph(struct iwl_trans *trans, u32 addr, u32 val);
+void iwl_set_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
+void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 reg,
 			    u32 bits, u32 mask);
-void iwl_clear_bits_prph(struct iwl_bus *bus, u32 reg, u32 mask);
+void iwl_clear_bits_prph(struct iwl_trans *trans, u32 reg, u32 mask);
 
-void _iwl_read_targ_mem_words(struct iwl_bus *bus, u32 addr,
+void _iwl_read_targ_mem_words(struct iwl_trans *trans, u32 addr,
 			      void *buf, int words);
 
-#define iwl_read_targ_mem_words(bus, addr, buf, bufsize)	\
+#define iwl_read_targ_mem_words(trans, addr, buf, bufsize)	\
 	do {							\
 		BUILD_BUG_ON((bufsize) % sizeof(u32));		\
-		_iwl_read_targ_mem_words(bus, addr, buf,	\
+		_iwl_read_targ_mem_words(trans, addr, buf,	\
 					 (bufsize) / sizeof(u32));\
 	} while (0)
 
-int _iwl_write_targ_mem_words(struct iwl_bus *bus, u32 addr,
+int _iwl_write_targ_mem_words(struct iwl_trans *trans, u32 addr,
 			      void *buf, int words);
 
-u32 iwl_read_targ_mem(struct iwl_bus *bus, u32 addr);
-int iwl_write_targ_mem(struct iwl_bus *bus, u32 addr, u32 val);
+u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr);
+int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val);
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 8761438..5c7741f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -71,7 +71,7 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 /* Set led register off */
 void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	iwl_write32(bus(priv), CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	iwl_write32(trans(priv), CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 }
 
 /*
@@ -107,9 +107,10 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	};
 	u32 reg;
 
-	reg = iwl_read32(bus(priv), CSR_LED_REG);
+	reg = iwl_read32(trans(priv), CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(bus(priv), CSR_LED_REG, reg & CSR_LED_BSM_CTRL_MSK);
+		iwl_write32(trans(priv), CSR_LED_REG,
+			    reg & CSR_LED_BSM_CTRL_MSK);
 
 	return iwl_trans_send_cmd(trans(priv), &cmd);
 }
@@ -206,7 +207,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 		break;
 	}
 
-	ret = led_classdev_register(bus(priv)->dev, &priv->led);
+	ret = led_classdev_register(trans(priv)->dev, &priv->led);
 	if (ret) {
 		kfree(priv->led.name);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 965d047..b911837 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -196,7 +196,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_IBSS_RSN;
 
 	if (trans(priv)->ucode_wowlan.code.len &&
-	    device_can_wakeup(bus(priv)->dev)) {
+	    device_can_wakeup(trans(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
 					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
@@ -347,7 +347,7 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	/* User space software may expect getting rfkill changes
 	 * even if interface is down */
-	iwl_write32(bus(priv), CSR_INT, 0xFFFFFFFF);
+	iwl_write32(trans(priv), CSR_INT, 0xFFFFFFFF);
 	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
@@ -405,10 +405,10 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto error;
 
-	device_set_wakeup_enable(bus(priv)->dev, true);
+	device_set_wakeup_enable(trans(priv)->dev, true);
 
 	/* Now let the ucode operate on its own */
-	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_SET,
+	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	goto out;
@@ -436,19 +436,19 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
-	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	base = priv->shrd->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&bus(priv)->reg_lock, flags);
-		ret = iwl_grab_nic_access_silent(bus(priv));
+		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
+		ret = iwl_grab_nic_access_silent(trans(priv));
 		if (ret == 0) {
-			iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, base);
-			status = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
-			iwl_release_nic_access(bus(priv));
+			iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, base);
+			status = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+			iwl_release_nic_access(trans(priv));
 		}
-		spin_unlock_irqrestore(&bus(priv)->reg_lock, flags);
+		spin_unlock_irqrestore(&trans(priv)->reg_lock, flags);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
@@ -460,7 +460,8 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
-					bus(priv), 0x800000, priv->wowlan_sram,
+					trans(priv), 0x800000,
+					priv->wowlan_sram,
 					trans->ucode_wowlan.data.len / 4);
 		}
 #endif
@@ -471,7 +472,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	priv->shrd->wowlan = false;
 
-	device_set_wakeup_enable(bus(priv)->dev, false);
+	device_set_wakeup_enable(trans(priv)->dev, false);
 
 	iwlagn_prepare_restart(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index ab46233..7bab819 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -121,12 +121,12 @@ static void iwl_pci_apm_config(struct iwl_bus *bus)
 	if ((lctl & PCI_CFG_LINK_CTRL_VAL_L1_EN) ==
 				PCI_CFG_LINK_CTRL_VAL_L1_EN) {
 		/* L1-ASPM enabled; disable(!) L0S */
-		iwl_set_bit(bus, CSR_GIO_REG,
+		iwl_set_bit(trans(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Enabled; Disabling L0S\n");
 	} else {
 		/* L1-ASPM disabled; enable(!) L0S */
-		iwl_clear_bit(bus, CSR_GIO_REG,
+		iwl_clear_bit(trans(bus), CSR_GIO_REG,
 				CSR_GIO_REG_VAL_L0S_ENABLED);
 		dev_printk(KERN_INFO, bus->dev, "L1 Disabled; Enabling L0S\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index a56a77b..922d841 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -208,7 +208,7 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 	if (priv->testmode_trace.trace_enabled) {
 		if (priv->testmode_trace.cpu_addr &&
 		    priv->testmode_trace.dma_addr)
-			dma_free_coherent(bus(priv)->dev,
+			dma_free_coherent(trans(priv)->dev,
 					priv->testmode_trace.total_size,
 					priv->testmode_trace.cpu_addr,
 					priv->testmode_trace.dma_addr);
@@ -302,7 +302,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
-		val32 = iwl_read_direct32(bus(priv), ofs);
+		val32 = iwl_read_direct32(trans(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -324,7 +324,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
 			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write_direct32(bus(priv), ofs, val32);
+			iwl_write_direct32(trans(priv), ofs, val32);
 		}
 		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
@@ -334,11 +334,11 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
 			IWL_INFO(priv, "8bit value to write 0x%x\n", val8);
-			iwl_write8(bus(priv), ofs, val8);
+			iwl_write8(trans(priv), ofs, val8);
 		}
 		break;
 	case IWL_TM_CMD_APP2DEV_INDIRECT_REG_READ32:
-		val32 = iwl_read_prph(bus(priv), ofs);
+		val32 = iwl_read_prph(trans(priv), ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -360,7 +360,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
 			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write_prph(bus(priv), ofs, val32);
+			iwl_write_prph(trans(priv), ofs, val32);
 		}
 		break;
 	default:
@@ -615,7 +615,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct iwl_priv *priv = hw->priv;
 	struct sk_buff *skb;
 	int status = 0;
-	struct device *dev = bus(priv)->dev;
+	struct device *dev = trans(priv)->dev;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
@@ -814,7 +814,7 @@ static int iwl_testmode_sram(struct ieee80211_hw *hw, struct nlattr **tb)
 		IWL_ERR(priv, "Error allocating memory\n");
 		return -ENOMEM;
 	}
-	_iwl_read_targ_mem_words(bus(priv), ofs,
+	_iwl_read_targ_mem_words(trans(priv), ofs,
 					priv->testmode_sram.buff_addr,
 					priv->testmode_sram.buff_size / 4);
 	priv->testmode_sram.num_chunks =
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 47d27bd..555175f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -317,12 +317,12 @@ static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
 
 	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* acknowledge/clear/reset any interrupts still pending
 	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(bus(trans), CSR_INT, 0xffffffff);
-	iwl_write32(bus(trans), CSR_FH_INT_STATUS, 0xffffffff);
+	iwl_write32(trans, CSR_INT, 0xffffffff);
+	iwl_write32(trans, CSR_FH_INT_STATUS, 0xffffffff);
 	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
 }
 
@@ -333,7 +333,7 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 
 	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
 	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
-	iwl_write32(bus(trans), CSR_INT_MASK, trans_pcie->inta_mask);
+	iwl_write32(trans, CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index b94c953..ebea243 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -144,30 +144,30 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 		/* shadow register enabled */
 		/* Device expects a multiple of 8 */
 		q->write_actual = (q->write & ~0x7);
-		iwl_write32(bus(trans), FH_RSCSR_CHNL0_WPTR, q->write_actual);
+		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, q->write_actual);
 	} else {
 		/* If power-saving is in use, make sure device is awake */
 		if (test_bit(STATUS_POWER_PMI, &trans->shrd->status)) {
-			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 				IWL_DEBUG_INFO(trans,
 					"Rx queue requesting wakeup,"
 					" GP1 = 0x%x\n", reg);
-				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
+				iwl_set_bit(trans, CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				goto exit_unlock;
 			}
 
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
 					q->write_actual);
 
 		/* Else device is assumed to be awake */
 		} else {
 			/* Device expects a multiple of 8 */
 			q->write_actual = (q->write & ~0x7);
-			iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_WPTR,
+			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
 				q->write_actual);
 		}
 	}
@@ -312,7 +312,7 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
-		rxb->page_dma = dma_map_page(bus(trans)->dev, page, 0,
+		rxb->page_dma = dma_map_page(trans->dev, page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
@@ -418,7 +418,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 		rxq->queue[i] = NULL;
 
-		dma_unmap_page(bus(trans)->dev, rxb->page_dma,
+		dma_unmap_page(trans->dev, rxb->page_dma,
 			       PAGE_SIZE << hw_params(trans).rx_page_order,
 			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
@@ -489,7 +489,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		 * rx_free list for reuse later. */
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			rxb->page_dma = dma_map_page(bus(trans)->dev, rxb->page,
+			rxb->page_dma = dma_map_page(trans->dev, rxb->page,
 				0, PAGE_SIZE <<
 				    hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
@@ -616,7 +616,7 @@ static void iwl_dump_nic_error_log(struct iwl_trans *trans)
 		return;
 	}
 
-	iwl_read_targ_mem_words(bus(priv), base, &table, sizeof(table));
+	iwl_read_targ_mem_words(trans(priv), base, &table, sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -677,9 +677,9 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 	struct iwl_priv *priv = priv(trans);
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (cfg(priv)->internal_wimax_coex &&
-	    (!(iwl_read_prph(bus(trans), APMG_CLK_CTRL_REG) &
+	    (!(iwl_read_prph(trans, APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
-	     (iwl_read_prph(bus(trans), APMG_PS_CTRL_REG) &
+	     (iwl_read_prph(trans, APMG_PS_CTRL_REG) &
 			APMG_PS_CTRL_VAL_RESET_REQ))) {
 		/*
 		 * Keep the restart process from trying to send host
@@ -745,18 +745,18 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&bus(trans)->reg_lock, reg_flags);
-	iwl_grab_nic_access(bus(trans));
+	spin_lock_irqsave(&trans->reg_lock, reg_flags);
+	iwl_grab_nic_access(trans);
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(bus(trans), HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(trans, HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			if (bufsz) {
@@ -770,7 +770,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 					time, ev);
 			}
 		} else {
-			data = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 			if (bufsz) {
 				pos += scnprintf(*buf + pos, bufsz - pos,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
@@ -785,8 +785,8 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	}
 
 	/* Allow device to power down */
-	iwl_release_nic_access(bus(trans));
-	spin_unlock_irqrestore(&bus(trans)->reg_lock, reg_flags);
+	iwl_release_nic_access(trans);
+	spin_unlock_irqrestore(&trans->reg_lock, reg_flags);
 	return pos;
 }
 
@@ -863,10 +863,10 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	}
 
 	/* event log header */
-	capacity = iwl_read_targ_mem(bus(trans), base);
-	mode = iwl_read_targ_mem(bus(trans), base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(bus(trans), base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(bus(trans), base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(trans, base);
+	mode = iwl_read_targ_mem(trans, base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(trans, base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(trans, base + (3 * sizeof(u32)));
 
 	if (capacity > logsize) {
 		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
@@ -962,7 +962,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(bus(trans), CSR_INT,
+	iwl_write32(trans, CSR_INT,
 		trans_pcie->inta | ~trans_pcie->inta_mask);
 
 	inta = trans_pcie->inta;
@@ -970,7 +970,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
 		/* just for debug */
-		inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);
+		inta_mask = iwl_read32(trans, CSR_INT_MASK);
 		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
 				inta, inta_mask);
 	}
@@ -1018,7 +1018,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
+		if (!(iwl_read32(trans, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
@@ -1082,12 +1082,12 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(bus(trans), CSR_FH_INT_STATUS,
+			iwl_write32(trans, CSR_FH_INT_STATUS,
 					CSR_FH_INT_RX_MASK);
 		}
 		if (inta & CSR_INT_BIT_RX_PERIODIC) {
 			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(bus(trans),
+			iwl_write32(trans,
 				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
 		}
 		/* Sending RX interrupt require many steps to be done in the
@@ -1102,7 +1102,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		 */
 
 		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
+		iwl_write8(trans, CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
 #ifdef CONFIG_IWLWIFI_IDI
 		iwl_amfh_rx_handler();
@@ -1117,7 +1117,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		 * to extend the periodic interrupt; one-shot is enough.
 		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(bus(trans), CSR_INT_PERIODIC_REG,
+			iwl_write8(trans, CSR_INT_PERIODIC_REG,
 				    CSR_INT_PERIODIC_ENA);
 
 		isr_stats->rx++;
@@ -1125,7 +1125,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(bus(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		iwl_write32(trans, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
 		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
@@ -1175,7 +1175,7 @@ void iwl_free_isr_ict(struct iwl_trans *trans)
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	if (trans_pcie->ict_tbl) {
-		dma_free_coherent(bus(trans)->dev, ICT_SIZE,
+		dma_free_coherent(trans->dev, ICT_SIZE,
 				  trans_pcie->ict_tbl,
 				  trans_pcie->ict_tbl_dma);
 		trans_pcie->ict_tbl = NULL;
@@ -1195,7 +1195,7 @@ int iwl_alloc_isr_ict(struct iwl_trans *trans)
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->ict_tbl =
-		dma_alloc_coherent(bus(trans)->dev, ICT_SIZE,
+		dma_alloc_coherent(trans->dev, ICT_SIZE,
 				   &trans_pcie->ict_tbl_dma,
 				   GFP_KERNEL);
 	if (!trans_pcie->ict_tbl)
@@ -1246,10 +1246,10 @@ void iwl_reset_ict(struct iwl_trans *trans)
 
 	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%x\n", val);
 
-	iwl_write32(bus(trans), CSR_DRAM_INT_TBL_REG, val);
+	iwl_write32(trans, CSR_DRAM_INT_TBL_REG, val);
 	trans_pcie->use_ict = true;
 	trans_pcie->ict_index = 0;
-	iwl_write32(bus(trans), CSR_INT, trans_pcie->inta_mask);
+	iwl_write32(trans, CSR_INT, trans_pcie->inta_mask);
 	iwl_enable_interrupts(trans);
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 }
@@ -1289,11 +1289,11 @@ static irqreturn_t iwl_isr(int irq, void *data)
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(bus(trans), CSR_INT);
+	inta = iwl_read32(trans, CSR_INT);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
@@ -1312,7 +1312,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
-		inta_fh = iwl_read32(bus(trans), CSR_FH_INT_STATUS);
+		inta_fh = iwl_read32(trans, CSR_FH_INT_STATUS);
 		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
 	}
@@ -1378,8 +1378,8 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(bus(trans), CSR_INT_MASK);  /* just for debug */
-	iwl_write32(bus(trans), CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(trans, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(trans, CSR_INT_MASK, 0x00000000);
 
 
 	/* Ignore interrupt if there's nothing in NIC to service.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 30814b5..5e095ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -100,7 +100,7 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 
 	if (hw_params(trans).shadow_reg_enable) {
 		/* shadow register enabled */
-		iwl_write32(bus(trans), HBUS_TARG_WRPTR,
+		iwl_write32(trans, HBUS_TARG_WRPTR,
 			    txq->q.write_ptr | (txq_id << 8));
 	} else {
 		/* if we're trying to save power */
@@ -108,18 +108,18 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 			/* wake up nic if it's powered down ...
 			 * uCode will wake up, and interrupt us again, so next
 			 * time we'll skip this part. */
-			reg = iwl_read32(bus(trans), CSR_UCODE_DRV_GP1);
+			reg = iwl_read32(trans, CSR_UCODE_DRV_GP1);
 
 			if (reg & CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP) {
 				IWL_DEBUG_INFO(trans,
 					"Tx queue %d requesting wakeup,"
 					" GP1 = 0x%x\n", txq_id, reg);
-				iwl_set_bit(bus(trans), CSR_GP_CNTRL,
+				iwl_set_bit(trans, CSR_GP_CNTRL,
 					CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 				return;
 			}
 
-			iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
+			iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
 
 		/*
@@ -128,7 +128,7 @@ void iwl_txq_update_write_ptr(struct iwl_trans *trans, struct iwl_tx_queue *txq)
 		 * trying to tx (during RFKILL, we're not trying to tx).
 		 */
 		} else
-			iwl_write32(bus(trans), HBUS_TARG_WRPTR,
+			iwl_write32(trans, HBUS_TARG_WRPTR,
 				    txq->q.write_ptr | (txq_id << 8));
 	}
 	txq->need_update = 0;
@@ -190,14 +190,14 @@ static void iwlagn_unmap_tfd(struct iwl_trans *trans, struct iwl_cmd_meta *meta,
 
 	/* Unmap tx_cmd */
 	if (num_tbs)
-		dma_unmap_single(bus(trans)->dev,
+		dma_unmap_single(trans->dev,
 				dma_unmap_addr(meta, mapping),
 				dma_unmap_len(meta, len),
 				DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
-		dma_unmap_single(bus(trans)->dev, iwl_tfd_tb_get_addr(tfd, i),
+		dma_unmap_single(trans->dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
@@ -383,14 +383,14 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
 	tbl_dw_addr = trans_pcie->scd_base_addr +
 			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
-	tbl_dw = iwl_read_targ_mem(bus(trans), tbl_dw_addr);
+	tbl_dw = iwl_read_targ_mem(trans, tbl_dw_addr);
 
 	if (txq_id & 0x1)
 		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
 	else
 		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
 
-	iwl_write_targ_mem(bus(trans), tbl_dw_addr, tbl_dw);
+	iwl_write_targ_mem(trans, tbl_dw_addr, tbl_dw);
 
 	return 0;
 }
@@ -399,7 +399,7 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(bus(trans),
+	iwl_write_prph(trans,
 		SCD_QUEUE_STATUS_BITS(txq_id),
 		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
@@ -409,9 +409,9 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 				int txq_id, u32 index)
 {
 	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d", txq_id, index & 0xff);
-	iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR,
+	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
@@ -423,7 +423,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 	int active =
 		test_bit(txq_id, &trans_pcie->txq_ctx_active_msk) ? 1 : 0;
 
-	iwl_write_prph(bus(trans), SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -498,10 +498,10 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(bus(trans), SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(bus(trans), SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(trans, SCD_AGGR_SEL, (1<<txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -510,7 +510,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 	iwl_trans_set_wr_ptrs(trans, txq_id, ssn);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((frame_limit <<
@@ -520,7 +520,7 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(trans, SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
@@ -584,7 +584,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
 
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
-	iwl_clear_bits_prph(bus(trans), SCD_AGGR_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, (1 << txq_id));
 
 	trans_pcie->agg_txq[sta_id][tid] = 0;
 	trans_pcie->txq[txq_id].q.read_ptr = 0;
@@ -592,7 +592,7 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans, int sta_id, int tid)
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
 
-	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(trans, SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(trans_pcie, txq_id);
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id], 0, 0);
 	return 0;
@@ -725,9 +725,9 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
 			q->write_ptr, idx, trans->shrd->cmd_queue);
 
-	phys_addr = dma_map_single(bus(trans)->dev, &out_cmd->hdr, copy_size,
+	phys_addr = dma_map_single(trans->dev, &out_cmd->hdr, copy_size,
 				DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
+	if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
 	}
@@ -748,10 +748,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-		phys_addr = dma_map_single(bus(trans)->dev,
+		phys_addr = dma_map_single(trans->dev,
 					   (void *)cmd->data[i],
 					   cmd->len[i], DMA_BIDIRECTIONAL);
-		if (dma_mapping_error(bus(trans)->dev, phys_addr)) {
+		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],
 					 DMA_BIDIRECTIONAL);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 80f5318..a1ee2e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -80,7 +80,7 @@ static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rx_queue *rxq = &trans_pcie->rxq;
-	struct device *dev = bus(trans)->dev;
+	struct device *dev = trans->dev;
 
 	memset(&trans_pcie->rxq, 0, sizeof(trans_pcie->rxq));
 
@@ -124,7 +124,7 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(bus(trans)->dev, rxq->pool[i].page_dma,
+			dma_unmap_page(trans->dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
 			__free_pages(rxq->pool[i].page,
@@ -148,17 +148,17 @@ static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
 
 	/* Stop Rx DMA */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
 	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+	iwl_write_direct32(trans, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
 			   (u32)(rxq->bd_dma >> 8));
 
 	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(bus(trans), FH_RSCSR_CHNL0_STTS_WPTR_REG,
+	iwl_write_direct32(trans, FH_RSCSR_CHNL0_STTS_WPTR_REG,
 			   rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
@@ -169,7 +169,7 @@ static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 	 * RB timeout 0x10
 	 * 256 RBDs
 	 */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG,
+	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG,
 			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
 			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
 			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
@@ -179,7 +179,7 @@ static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(bus(trans), CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
 }
 
 static int iwl_rx_init(struct iwl_trans *trans)
@@ -244,13 +244,13 @@ static void iwl_trans_pcie_rx_free(struct iwl_trans *trans)
 	iwl_trans_rxq_free_rx_bufs(trans);
 	spin_unlock_irqrestore(&rxq->lock, flags);
 
-	dma_free_coherent(bus(trans)->dev, sizeof(__le32) * RX_QUEUE_SIZE,
+	dma_free_coherent(trans->dev, sizeof(__le32) * RX_QUEUE_SIZE,
 			  rxq->bd, rxq->bd_dma);
 	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
 	rxq->bd = NULL;
 
 	if (rxq->rb_stts)
-		dma_free_coherent(bus(trans)->dev,
+		dma_free_coherent(trans->dev,
 				  sizeof(struct iwl_rb_status),
 				  rxq->rb_stts, rxq->rb_stts_dma);
 	else
@@ -263,8 +263,8 @@ static int iwl_trans_rx_stop(struct iwl_trans *trans)
 {
 
 	/* stop Rx DMA */
-	iwl_write_direct32(bus(trans), FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	return iwl_poll_direct_bit(bus(trans), FH_MEM_RSSR_RX_STATUS_REG,
+	iwl_write_direct32(trans, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	return iwl_poll_direct_bit(trans, FH_MEM_RSSR_RX_STATUS_REG,
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 }
 
@@ -274,7 +274,7 @@ static inline int iwlagn_alloc_dma_ptr(struct iwl_trans *trans,
 	if (WARN_ON(ptr->addr))
 		return -EINVAL;
 
-	ptr->addr = dma_alloc_coherent(bus(trans)->dev, size,
+	ptr->addr = dma_alloc_coherent(trans->dev, size,
 				       &ptr->dma, GFP_KERNEL);
 	if (!ptr->addr)
 		return -ENOMEM;
@@ -288,7 +288,7 @@ static inline void iwlagn_free_dma_ptr(struct iwl_trans *trans,
 	if (unlikely(!ptr->addr))
 		return;
 
-	dma_free_coherent(bus(trans)->dev, ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(trans->dev, ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
@@ -335,7 +335,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = dma_alloc_coherent(bus(trans)->dev, tfd_sz,
+	txq->tfds = dma_alloc_coherent(trans->dev, tfd_sz,
 				       &txq->q.dma_addr, GFP_KERNEL);
 	if (!txq->tfds) {
 		IWL_ERR(trans, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
@@ -391,7 +391,7 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
 	 * given Tx queue, and enable the DMA channel used for that queue.
 	 * Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(bus(trans), FH_MEM_CBBC_QUEUE(txq_id),
+	iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(txq_id),
 			     txq->q.dma_addr >> 8);
 
 	return 0;
@@ -445,7 +445,7 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
-	struct device *dev = bus(trans)->dev;
+	struct device *dev = trans->dev;
 	int i;
 	if (WARN_ON(!txq))
 		return;
@@ -586,10 +586,10 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
-	iwl_write_prph(bus(trans), SCD_TXFACT, 0);
+	iwl_write_prph(trans, SCD_TXFACT, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(bus(trans), FH_KW_MEM_ADDR_REG,
+	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
 			   trans_pcie->kw.dma >> 4);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -621,12 +621,12 @@ static void iwl_set_pwr_vmain(struct iwl_trans *trans)
  * to set power to V_AUX, do:
 
 		if (pci_pme_capable(priv->pci_dev, PCI_D3cold))
-			iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
+			iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
 					       APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					       ~APMG_PS_CTRL_MSK_PWR_SRC);
  */
 
-	iwl_set_bits_mask_prph(bus(trans), APMG_PS_CTRL_REG,
+	iwl_set_bits_mask_prph(trans, APMG_PS_CTRL_REG,
 			       APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			       ~APMG_PS_CTRL_MSK_PWR_SRC);
 }
@@ -640,7 +640,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 	iwl_apm_init(priv(trans));
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(bus(trans), CSR_INT_COALESCING,
+	iwl_write8(trans, CSR_INT_COALESCING,
 		IWL_HOST_INT_CALIB_TIMEOUT_DEF);
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -660,7 +660,7 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	if (hw_params(trans).shadow_reg_enable) {
 		/* enable shadow regs in HW */
-		iwl_set_bit(bus(trans), CSR_MAC_SHADOW_REG_CTRL,
+		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
 			0x800FFFFF);
 	}
 
@@ -676,11 +676,11 @@ static int iwl_set_hw_ready(struct iwl_trans *trans)
 {
 	int ret;
 
-	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
-	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				HW_READY_TIMEOUT);
@@ -701,10 +701,10 @@ static int iwl_trans_pcie_prepare_card_hw(struct iwl_trans *trans)
 		return 0;
 
 	/* If HW is not ready, prepare the conditions to check again */
-	iwl_set_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 			CSR_HW_IF_CONFIG_REG_PREPARE);
 
-	ret = iwl_poll_bit(bus(trans), CSR_HW_IF_CONFIG_REG,
+	ret = iwl_poll_bit(trans, CSR_HW_IF_CONFIG_REG,
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
@@ -794,7 +794,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	}
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(bus(trans), CSR_GP_CNTRL) &
+	if (iwl_read32(trans, CSR_GP_CNTRL) &
 			CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 	else
@@ -806,7 +806,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 		return -ERFKILL;
 	}
 
-	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 
 	ret = iwl_nic_init(trans);
 	if (ret) {
@@ -815,17 +815,17 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	}
 
 	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
 	/* clear (again), then enable host interrupts */
-	iwl_write32(bus(trans), CSR_INT, 0xFFFFFFFF);
+	iwl_write32(trans, CSR_INT, 0xFFFFFFFF);
 	iwl_enable_interrupts(trans);
 
 	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(bus(trans), CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	return 0;
 }
@@ -836,7 +836,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
  */
 static void iwl_trans_txq_set_sched(struct iwl_trans *trans, u32 mask)
 {
-	iwl_write_prph(bus(trans), SCD_TXFACT, mask);
+	iwl_write_prph(trans, SCD_TXFACT, mask);
 }
 
 static void iwl_tx_start(struct iwl_trans *trans)
@@ -852,46 +852,46 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	trans_pcie->scd_base_addr =
-		iwl_read_prph(bus(trans), SCD_SRAM_BASE_ADDR);
+		iwl_read_prph(trans, SCD_SRAM_BASE_ADDR);
 	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
 	/* reset conext data memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
+		iwl_write_targ_mem(trans, a, 0);
 	/* reset tx status memory */
 	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
 		a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
+		iwl_write_targ_mem(trans, a, 0);
 	for (; a < trans_pcie->scd_base_addr +
 	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(trans).max_txq_num);
 	       a += 4)
-		iwl_write_targ_mem(bus(trans), a, 0);
+		iwl_write_targ_mem(trans, a, 0);
 
-	iwl_write_prph(bus(trans), SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(bus(trans), FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+		iwl_write_direct32(trans, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
 
 	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(bus(trans), FH_TX_CHICKEN_BITS_REG,
+	reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
-	iwl_write_prph(bus(trans), SCD_QUEUECHAIN_SEL,
+	iwl_write_prph(trans, SCD_QUEUECHAIN_SEL,
 		SCD_QUEUECHAIN_SEL_ALL(trans));
-	iwl_write_prph(bus(trans), SCD_AGGR_SEL, 0);
+	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
 	for (i = 0; i < hw_params(trans).max_txq_num; i++) {
-		iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+		iwl_write_prph(trans, SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(trans, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
+		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i) +
 				sizeof(u32),
 				((SCD_WIN_SIZE <<
@@ -902,7 +902,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	iwl_write_prph(bus(trans), SCD_INTERRUPT_MASK,
+	iwl_write_prph(trans, SCD_INTERRUPT_MASK,
 			IWL_MASK(0, hw_params(trans).max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
@@ -948,7 +948,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	/* Enable L1-Active */
-	iwl_clear_bits_prph(bus(trans), APMG_PCIDEV_STT_REG,
+	iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 }
 
@@ -974,14 +974,14 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
-		iwl_write_direct32(bus(trans),
+		iwl_write_direct32(trans,
 				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(bus(trans), FH_TSSR_TX_STATUS_REG,
+		if (iwl_poll_direct_bit(trans, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
 				    1000))
 			IWL_ERR(trans, "Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
-			    iwl_read_direct32(bus(trans),
+			    iwl_read_direct32(trans,
 					      FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -1024,13 +1024,13 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 		iwl_trans_rx_stop(trans);
 #endif
 		/* Power-down device's busmaster DMA clocks */
-		iwl_write_prph(bus(trans), APMG_CLK_DIS_REG,
+		iwl_write_prph(trans, APMG_CLK_DIS_REG,
 			       APMG_CLK_VAL_DMA_CLK_RQT);
 		udelay(5);
 	}
 
 	/* Make sure (redundant) we've released our request to stay awake */
-	iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
+	iwl_clear_bit(trans, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 
 	/* Stop the device, and put it in low power state */
@@ -1048,7 +1048,7 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	tasklet_kill(&trans_pcie->irq_tasklet);
 
 	/* stop and reset the on-board processor */
-	iwl_write32(bus(trans), CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 }
 
 static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
@@ -1145,10 +1145,10 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = dma_map_single(bus(trans)->dev,
+	txcmd_phys = dma_map_single(trans->dev,
 				    &dev_cmd->hdr, firstlen,
 				    DMA_BIDIRECTIONAL);
-	if (unlikely(dma_mapping_error(bus(trans)->dev, txcmd_phys)))
+	if (unlikely(dma_mapping_error(trans->dev, txcmd_phys)))
 		return -1;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
@@ -1164,10 +1164,10 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	 * if any (802.11 null frames have no payload). */
 	secondlen = skb->len - hdr_len;
 	if (secondlen > 0) {
-		phys_addr = dma_map_single(bus(trans)->dev, skb->data + hdr_len,
+		phys_addr = dma_map_single(trans->dev, skb->data + hdr_len,
 					   secondlen, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(bus(trans)->dev, phys_addr))) {
-			dma_unmap_single(bus(trans)->dev,
+		if (unlikely(dma_mapping_error(trans->dev, phys_addr))) {
+			dma_unmap_single(trans->dev,
 					 dma_unmap_addr(out_meta, mapping),
 					 dma_unmap_len(out_meta, len),
 					 DMA_BIDIRECTIONAL);
@@ -1185,7 +1185,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 				offsetof(struct iwl_tx_cmd, scratch);
 
 	/* take back ownership of DMA buffer to enable update */
-	dma_sync_single_for_cpu(bus(trans)->dev, txcmd_phys, firstlen,
+	dma_sync_single_for_cpu(trans->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
@@ -1199,7 +1199,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_trans_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
-	dma_sync_single_for_device(bus(trans)->dev, txcmd_phys, firstlen,
+	dma_sync_single_for_device(trans->dev, txcmd_phys, firstlen,
 			DMA_BIDIRECTIONAL);
 
 	trace_iwlwifi_dev_tx(priv(trans),
@@ -1232,7 +1232,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 static void iwl_trans_pcie_kick_nic(struct iwl_trans *trans)
 {
 	/* Remove all resets to allow NIC to operate */
-	iwl_write32(bus(trans), CSR_RESET, 0);
+	iwl_write32(trans, CSR_RESET, 0);
 }
 
 static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
@@ -1355,7 +1355,7 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 		iwl_apm_stop(priv(trans));
 	} else {
 		iwl_disable_interrupts(trans);
-		iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
+		iwl_clear_bit(trans, CSR_GP_CNTRL,
 			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	}
 
@@ -1368,7 +1368,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 
 	iwl_enable_interrupts(trans);
 
-	if (!(iwl_read32(bus(trans), CSR_GP_CNTRL) &
+	if (!(iwl_read32(trans, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 		hw_rfkill = true;
 
@@ -1464,9 +1464,9 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 		IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
 			q->read_ptr, q->write_ptr);
 		IWL_ERR(trans, "Current HW read_ptr %d write_ptr %d\n",
-			iwl_read_prph(bus(trans), SCD_QUEUE_RDPTR(cnt))
+			iwl_read_prph(trans, SCD_QUEUE_RDPTR(cnt))
 				& (TFD_QUEUE_SIZE_MAX - 1),
-			iwl_read_prph(bus(trans), SCD_QUEUE_WRPTR(cnt)));
+			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
 		return 1;
 	}
 
@@ -1520,7 +1520,7 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 			pos += scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(bus(trans), fh_tbl[i]));
+				iwl_read_direct32(trans, fh_tbl[i]));
 		}
 		return pos;
 	}
@@ -1529,7 +1529,7 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
 	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
 		IWL_ERR(trans, "  %34s: 0X%08x\n",
 			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(bus(trans), fh_tbl[i]));
+			iwl_read_direct32(trans, fh_tbl[i]));
 	}
 	return 0;
 }
@@ -1599,7 +1599,7 @@ void iwl_dump_csr(struct iwl_trans *trans)
 	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
 		IWL_ERR(trans, "  %25s: 0X%08x\n",
 			get_csr_string(csr_tbl[i]),
-			iwl_read32(bus(trans), csr_tbl[i]));
+			iwl_read32(trans, csr_tbl[i]));
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0a3727d..dec935a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -234,6 +234,7 @@ struct iwl_calib_result {
  * @ops - pointer to iwl_trans_ops
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @hcmd_lock: protects HCMD
+ * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @irq - the irq number for the device
  * @ucode_write_complete: indicates that the ucode has been copied.
@@ -247,6 +248,7 @@ struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_shared *shrd;
 	spinlock_t hcmd_lock;
+	spinlock_t reg_lock;
 
 	struct device *dev;
 	unsigned int irq;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 0d7f207..5de8b5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -126,42 +126,41 @@ int iwl_alloc_fw_desc(struct iwl_bus *bus, struct fw_desc *desc,
 static int iwl_load_section(struct iwl_trans *trans, const char *name,
 				struct fw_desc *image, u32 dst_addr)
 {
-	struct iwl_bus *bus = bus(trans);
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
 	int ret;
 
 	trans->ucode_write_complete = 0;
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE);
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_SRVC_CHNL_SRAM_ADDR_REG(FH_SRVC_CHNL), dst_addr);
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_TFDIB_CTRL0_REG(FH_SRVC_CHNL),
 		phy_addr & FH_MEM_TFDIB_DRAM_ADDR_LSB_MSK);
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
 		(iwl_get_dma_hi_addr(phy_addr)
 			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_NUM |
 		1 << FH_TCSR_CHNL_TX_BUF_STS_REG_POS_TB_IDX |
 		FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID);
 
-	iwl_write_direct32(bus,
+	iwl_write_direct32(trans,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE	|
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
-	IWL_DEBUG_FW(bus, "%s uCode section being loaded...\n", name);
+	IWL_DEBUG_FW(trans, "%s uCode section being loaded...\n", name);
 	ret = wait_event_timeout(trans->shrd->wait_command_queue,
 				 trans->ucode_write_complete, 5 * HZ);
 	if (!ret) {
@@ -470,7 +469,7 @@ static int iwl_alive_notify(struct iwl_trans *trans)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_bus *bus,
+static int iwl_verify_inst_sparse(struct iwl_trans *trans,
 				      struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -478,15 +477,15 @@ static int iwl_verify_inst_sparse(struct iwl_bus *bus,
 	u32 val;
 	u32 i;
 
-	IWL_DEBUG_FW(bus, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(trans, "ucode inst image size is %u\n", len);
 
 	for (i = 0; i < len; i += 100, image += 100/sizeof(u32)) {
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_direct32(bus, HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(trans, HBUS_TARG_MEM_RADDR,
 			i + IWLAGN_RTC_INST_LOWER_BOUND);
-		val = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -494,7 +493,7 @@ static int iwl_verify_inst_sparse(struct iwl_bus *bus,
 	return 0;
 }
 
-static void iwl_print_mismatch_inst(struct iwl_bus *bus,
+static void iwl_print_mismatch_inst(struct iwl_trans *trans,
 				    struct fw_desc *fw_desc)
 {
 	__le32 *image = (__le32 *)fw_desc->v_addr;
@@ -503,18 +502,18 @@ static void iwl_print_mismatch_inst(struct iwl_bus *bus,
 	u32 offs;
 	int errors = 0;
 
-	IWL_DEBUG_FW(bus, "ucode inst image size is %u\n", len);
+	IWL_DEBUG_FW(trans, "ucode inst image size is %u\n", len);
 
-	iwl_write_direct32(bus, HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(trans, HBUS_TARG_MEM_RADDR,
 			   IWLAGN_RTC_INST_LOWER_BOUND);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(bus, HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(trans, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
-			IWL_ERR(bus, "uCode INST section at "
+			IWL_ERR(trans, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
 				offs, val, le32_to_cpu(*image));
 			errors++;
@@ -536,14 +535,14 @@ static int iwl_verify_ucode(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
-	if (!iwl_verify_inst_sparse(bus(trans), &img->code)) {
+	if (!iwl_verify_inst_sparse(trans, &img->code)) {
 		IWL_DEBUG_FW(trans, "uCode is good in inst SRAM\n");
 		return 0;
 	}
 
 	IWL_ERR(trans, "UCODE IMAGE IN INSTRUCTION SRAM NOT VALID!!\n");
 
-	iwl_print_mismatch_inst(bus(trans), &img->code);
+	iwl_print_mismatch_inst(trans, &img->code);
 	return -EIO;
 }
 
-- 
1.7.0.4

