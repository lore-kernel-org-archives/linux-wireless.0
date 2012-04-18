Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2DROpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/15] iwlwifi: op_mode holds its pointer to the transport
Date: Wed, 18 Apr 2012 07:41:04 -0700
Message-Id: <1334760077-5714-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_164557_066728_F4F82AEC)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of using the shared area that we be killed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c |   16 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |   10 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   70 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |   32 ++++++------
 drivers/net/wireless/iwlwifi/iwl-led.c         |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-mac80211.c    |   34 ++++++------
 drivers/net/wireless/iwlwifi/iwl-power.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c    |   18 +++---
 drivers/net/wireless/iwlwifi/iwl-ucode.c       |   14 +++---
 15 files changed, 123 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
index 08718ca..ae4a216 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-devices.c
@@ -60,13 +60,13 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
-	iwl_set_bits_mask_prph(trans(priv), APMG_DIGITAL_SVR_REG,
+	iwl_set_bits_mask_prph(priv->trans, APMG_DIGITAL_SVR_REG,
 				APMG_SVR_DIGITAL_VOLTAGE_1_32,
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
@@ -222,7 +222,7 @@ static void iwl2000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+	iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 		    CSR_GP_DRIVER_REG_BIT_RADIO_IQ_INVER);
 }
 
@@ -318,7 +318,7 @@ static void iwl5000_nic_config(struct iwl_priv *priv)
 	 * (PCIe power is lost before PERST# is asserted),
 	 * causing ME FW to lose ownership and not being able to obtain it back.
 	 */
-	iwl_set_bits_mask_prph(trans(priv), APMG_PS_CTRL_REG,
+	iwl_set_bits_mask_prph(priv->trans, APMG_PS_CTRL_REG,
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 }
@@ -580,21 +580,21 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		break;
 	case IWL_DEVICE_FAMILY_6000i:
 		/* 2x2 IPA phy type */
-		iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
+		iwl_write32(priv->trans, CSR_GP_DRIVER_REG,
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 		break;
 	case IWL_DEVICE_FAMILY_6050:
 		/* Indicate calibration version to uCode. */
 		if (iwl_eeprom_calib_version(priv) >= 6)
-			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 		break;
 	case IWL_DEVICE_FAMILY_6150:
 		/* Indicate calibration version to uCode. */
 		if (iwl_eeprom_calib_version(priv) >= 6)
-			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+			iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+		iwl_set_bit(priv->trans, CSR_GP_DRIVER_REG,
 			    CSR_GP_DRIVER_REG_BIT_6050_1x2);
 		break;
 	default:
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4e0c248..ab36344 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -189,7 +189,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 		goto done;
 	}
 	IWL_DEBUG_INFO(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(trans(priv));
+	iwl_trans_wait_tx_queue_empty(priv->trans);
 done:
 	ieee80211_wake_queues(priv->hw);
 	mutex_unlock(&priv->mutex);
@@ -1132,7 +1132,7 @@ int iwlagn_suspend(struct iwl_priv *priv, struct cfg80211_wowlan *wowlan)
 	memcpy(&rxon, &ctx->active, sizeof(rxon));
 
 	priv->ucode_loaded = false;
-	iwl_trans_stop_device(trans(priv));
+	iwl_trans_stop_device(priv->trans);
 
 	priv->wowlan = true;
 
@@ -1260,7 +1260,7 @@ int iwl_dvm_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	return iwl_trans_send_cmd(trans(priv), cmd);
+	return iwl_trans_send_cmd(priv->trans, cmd);
 }
 
 int iwl_dvm_send_cmd_pdu(struct iwl_priv *priv, u8 id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index db6c90f..e321a29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -604,16 +604,16 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 	if (flags & (SW_CARD_DISABLED | HW_CARD_DISABLED |
 		     CT_CARD_DISABLED)) {
 
-		iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
+		iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
 			    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 
-		iwl_write_direct32(trans(priv), HBUS_TARG_MBX_C,
+		iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 
 		if (!(flags & RXON_CARD_DISABLED)) {
-			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-			iwl_write_direct32(trans(priv), HBUS_TARG_MBX_C,
+			iwl_write_direct32(priv->trans, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
 		}
 		if (flags & CT_CARD_DISABLED)
@@ -636,7 +636,7 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
-		wake_up(&trans(priv)->wait_command_queue);
+		wake_up(&priv->trans->wait_command_queue);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index baaf5ba..18276db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -179,19 +179,19 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 
 	if (tt->state == IWL_TI_CT_KILL) {
 		if (priv->thermal_throttle.ct_kill_toggle) {
-			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
+			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = false;
 		} else {
-			iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_SET,
+			iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 			priv->thermal_throttle.ct_kill_toggle = true;
 		}
-		iwl_read32(trans(priv), CSR_UCODE_DRV_GP1);
-		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
-		if (likely(iwl_grab_nic_access(trans(priv))))
-			iwl_release_nic_access(trans(priv));
-		spin_unlock_irqrestore(&trans(priv)->reg_lock, flags);
+		iwl_read32(priv->trans, CSR_UCODE_DRV_GP1);
+		spin_lock_irqsave(&priv->trans->reg_lock, flags);
+		if (likely(iwl_grab_nic_access(priv->trans)))
+			iwl_release_nic_access(priv->trans);
+		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ad21b5d..f6041ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -467,7 +467,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		txq_id = ctx->ac_to_queue[skb_get_queue_mapping(skb)];
 
-	if (iwl_trans_tx(trans(priv), skb, dev_cmd, txq_id))
+	if (iwl_trans_tx(priv->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc) &&
@@ -581,7 +581,7 @@ turn_off:
 	spin_unlock_bh(&priv->sta_lock);
 
 	if (test_bit(txq_id, priv->agg_q_alloc)) {
-		iwl_trans_tx_agg_disable(trans(priv), txq_id);
+		iwl_trans_tx_agg_disable(priv->trans, txq_id);
 		iwlagn_dealloc_agg_txq(priv, txq_id);
 	}
 
@@ -665,7 +665,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	fifo = ctx->ac_to_fifo[tid_to_ac[tid]];
 
-	iwl_trans_tx_agg_setup(trans(priv), q, fifo,
+	iwl_trans_tx_agg_setup(priv->trans, q, fifo,
 			       sta_priv->sta_id, tid,
 			       buf_size, ssn);
 
@@ -732,7 +732,7 @@ static void iwlagn_check_ratid_empty(struct iwl_priv *priv, int sta_id, u8 tid)
 			IWL_DEBUG_TX_QUEUES(priv,
 				"Can continue DELBA flow ssn = next_recl ="
 				" %d", tid_data->next_reclaimed);
-			iwl_trans_tx_agg_disable(trans(priv),
+			iwl_trans_tx_agg_disable(priv->trans,
 						 tid_data->agg.txq_id);
 			iwlagn_dealloc_agg_txq(priv, tid_data->agg.txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
@@ -1092,7 +1092,7 @@ static int iwl_reclaim(struct iwl_priv *priv, int sta_id, int tid,
 		return 1;
 	}
 
-	iwl_trans_reclaim(trans(priv), txq_id, ssn, skbs);
+	iwl_trans_reclaim(priv->trans, txq_id, ssn, skbs);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7db3986..81c1cd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -348,14 +348,14 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 		ptr = base + (4 * sizeof(u32)) + (start_idx * 3 * sizeof(u32));
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&trans(priv)->reg_lock, reg_flags);
-	if (unlikely(!iwl_grab_nic_access(trans(priv)))) {
-		spin_unlock_irqrestore(&trans(priv)->reg_lock, reg_flags);
+	spin_lock_irqsave(&priv->trans->reg_lock, reg_flags);
+	if (unlikely(!iwl_grab_nic_access(priv->trans))) {
+		spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
 		return;
 	}
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, ptr);
 
 	/*
 	 * Refuse to read more than would have fit into the log from
@@ -371,20 +371,20 @@ static void iwl_print_cont_event_trace(struct iwl_priv *priv, u32 base,
 	 * place event id # at far right for easier visual parsing.
 	 */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			trace_iwlwifi_dev_ucode_cont_event(
-					trans(priv)->dev, 0, time, ev);
+					priv->trans->dev, 0, time, ev);
 		} else {
-			data = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 			trace_iwlwifi_dev_ucode_cont_event(
-					trans(priv)->dev, time, data, ev);
+					priv->trans->dev, time, data, ev);
 		}
 	}
 	/* Allow device to power down */
-	iwl_release_nic_access(trans(priv));
-	spin_unlock_irqrestore(&trans(priv)->reg_lock, reg_flags);
+	iwl_release_nic_access(priv->trans);
+	spin_unlock_irqrestore(&priv->trans->reg_lock, reg_flags);
 }
 
 static void iwl_continuous_event_trace(struct iwl_priv *priv)
@@ -403,8 +403,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 
 	base = priv->device_pointers.log_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		iwl_read_targ_mem_words(trans(priv), base, &read, sizeof(read));
-
+		iwl_read_targ_mem_words(priv->trans, base, &read, sizeof(read));
 		capacity = read.capacity;
 		mode = read.mode;
 		num_wraps = read.wrap_counter;
@@ -444,7 +443,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 		else
 			priv->event_log.wraps_once_count++;
 
-		trace_iwlwifi_dev_ucode_wrap_event(trans(priv)->dev,
+		trace_iwlwifi_dev_ucode_wrap_event(priv->trans->dev,
 				num_wraps - priv->event_log.num_wraps,
 				next_entry, priv->event_log.next_entry);
 
@@ -670,7 +669,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	struct iwl_ct_kill_throttling_config adv_cmd;
 	int ret = 0;
 
-	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 
 	priv->thermal_throttle.ct_kill_toggle = false;
@@ -949,7 +948,7 @@ void iwl_down(struct iwl_priv *priv)
 		ieee80211_stop_queues(priv->hw);
 
 	priv->ucode_loaded = false;
-	iwl_trans_stop_device(trans(priv));
+	iwl_trans_stop_device(priv->trans);
 
 	/* Clear out all status bits but a few that are stable across reset */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
@@ -1325,7 +1324,7 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	     priv->hw_params.sku & EEPROM_SKU_CAP_BAND_52GHZ) {
 		IWL_INFO(priv, "Incorrectly detected BG card as ABG. "
 			"Please send your %s to maintainer.\n",
-			trans(priv)->hw_id_str);
+			priv->trans->hw_id_str);
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
@@ -1441,32 +1440,32 @@ void iwl_set_hw_params(struct iwl_priv *priv)
 
 void iwl_debug_config(struct iwl_priv *priv)
 {
-	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEBUG "
+	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEBUG "
 #ifdef CONFIG_IWLWIFI_DEBUG
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEBUGFS "
+	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEBUGFS "
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
+	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
 #ifdef CONFIG_IWLWIFI_DEVICE_TRACING
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
 
-	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
+	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_DEVICE_TESTMODE "
 #ifdef CONFIG_IWLWIFI_DEVICE_TESTMODE
 		"enabled\n");
 #else
 		"disabled\n");
 #endif
-	dev_printk(KERN_INFO, trans(priv)->dev, "CONFIG_IWLWIFI_P2P "
+	dev_printk(KERN_INFO, priv->trans->dev, "CONFIG_IWLWIFI_P2P "
 #ifdef CONFIG_IWLWIFI_P2P
 		"enabled\n");
 #else
@@ -1509,6 +1508,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	op_mode->ops = &iwl_dvm_ops;
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
+	priv->trans = trans;
 	priv->fw = fw;
 
 	switch (cfg(priv)->device_family) {
@@ -1587,11 +1587,11 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	}
 
 	/* Configure transport layer */
-	iwl_trans_configure(trans(priv), &trans_cfg);
+	iwl_trans_configure(priv->trans, &trans_cfg);
 
 	/* At this point both hw and priv are allocated. */
 
-	SET_IEEE80211_DEV(priv->hw, trans(priv)->dev);
+	SET_IEEE80211_DEV(priv->hw, priv->trans->dev);
 
 	/* show what debugging capabilities we have */
 	iwl_debug_config(priv);
@@ -1615,25 +1615,25 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
-	spin_lock_init(&trans(priv)->reg_lock);
+	spin_lock_init(&priv->trans->reg_lock);
 	spin_lock_init(&priv->statistics.lock);
 
 	/***********************
 	 * 2. Read REV register
 	 ***********************/
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
-		cfg(priv)->name, trans(priv)->hw_rev);
+		cfg(priv)->name, priv->trans->hw_rev);
 
-	if (iwl_trans_start_hw(trans(priv)))
+	if (iwl_trans_start_hw(priv->trans))
 		goto out_free_traffic_mem;
 
 	/* Read the EEPROM */
-	if (iwl_eeprom_init(priv, trans(priv)->hw_rev)) {
+	if (iwl_eeprom_init(priv, priv->trans->hw_rev)) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_traffic_mem;
 	}
 	/* Reset chip to save power until we load uCode during "up". */
-	iwl_trans_stop_hw(trans(priv));
+	iwl_trans_stop_hw(priv->trans);
 
 	if (iwl_eeprom_check_version(priv))
 		goto out_free_eeprom;
@@ -1676,7 +1676,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		n_q_to_ac = ARRAY_SIZE(iwlagn_bss_queue_to_ac);
 
 		/* Configure transport layer again*/
-		iwl_trans_configure(trans(priv), &trans_cfg);
+		iwl_trans_configure(priv->trans, &trans_cfg);
 	}
 
 	/*******************
@@ -1768,7 +1768,7 @@ void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 
 	/*This will stop the queues, move the device to low power state */
 	priv->ucode_loaded = false;
-	iwl_trans_stop_device(trans(priv));
+	iwl_trans_stop_device(priv->trans);
 
 	iwl_eeprom_free(priv);
 
@@ -1860,7 +1860,7 @@ static const char *desc_lookup(u32 num)
 
 static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 {
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 	u32 base;
 	struct iwl_error_event_table table;
 
@@ -1950,7 +1950,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	u32 ev, time, data; /* event log data */
 	unsigned long reg_flags;
 
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 
 	if (num_events == 0)
 		return pos;
@@ -2068,7 +2068,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	u32 logsize;
 	int pos = 0;
 	size_t bufsz = 0;
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 
 	base = priv->device_pointers.log_event_table;
 	if (priv->cur_ucode == IWL_UCODE_INIT) {
@@ -2184,7 +2184,7 @@ static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->status);
 
-	wake_up(&trans(priv)->wait_command_queue);
+	wake_up(&priv->trans->wait_command_queue);
 
 	if (!ondemand) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 20100c7..e4c0a94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -472,7 +472,7 @@ static inline void iwl_dvm_set_pmi(struct iwl_priv *priv, bool state)
 		set_bit(STATUS_POWER_PMI, &priv->status);
 	else
 		clear_bit(STATUS_POWER_PMI, &priv->status);
-	iwl_trans_set_pmi(trans(priv), state);
+	iwl_trans_set_pmi(priv->trans, state);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 32834a7..a1d155a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -259,7 +259,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	sram = priv->dbgfs_sram_offset & ~0x3;
 
 	/* read the first u32 from sram */
-	val = iwl_read_targ_mem(trans(priv), sram);
+	val = iwl_read_targ_mem(priv->trans, sram);
 
 	for (; len; len--) {
 		/* put the address at the start of every line */
@@ -278,7 +278,7 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 		if (++offset == 4) {
 			sram += 4;
 			offset = 0;
-			val = iwl_read_targ_mem(trans(priv), sram);
+			val = iwl_read_targ_mem(priv->trans, sram);
 		}
 
 		/* put in extra spaces and split lines for human readability */
@@ -2071,7 +2071,7 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	u32 pwrsave_status;
 
-	pwrsave_status = iwl_read32(trans(priv), CSR_GP_CNTRL) &
+	pwrsave_status = iwl_read32(priv->trans, CSR_GP_CNTRL) &
 			CSR_GP_REG_POWER_SAVE_STATUS_MSK;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "Power Save Status: ");
@@ -2594,7 +2594,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	/* Calibrations disabled/enabled status*/
 	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IRUSR);
 
-	if (iwl_trans_dbgfs_register(trans(priv), dir_debug))
+	if (iwl_trans_dbgfs_register(priv->trans, dir_debug))
 		goto err;
 	return 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c235a1e..faf54c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -760,6 +760,7 @@ struct iwl_priv {
 
 	/*data shared among all the driver's layers */
 	struct iwl_shared *shrd;
+	struct iwl_trans *trans;
 	const struct iwl_fw *fw;
 	const struct iwl_lib_ops *lib;
 	unsigned long status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a004431..622a8f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -189,7 +189,7 @@ static void iwl_eeprom_release_semaphore(struct iwl_trans *trans)
 
 static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 {
-	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP) &
+	u32 gp = iwl_read32(priv->trans, CSR_EEPROM_GP) &
 			   CSR_EEPROM_GP_VALID_MSK;
 	int ret = 0;
 
@@ -719,14 +719,14 @@ static void iwl_eeprom_enhanced_txpower(struct iwl_priv *priv)
 int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 {
 	__le16 *e;
-	u32 gp = iwl_read32(trans(priv), CSR_EEPROM_GP);
+	u32 gp = iwl_read32(priv->trans, CSR_EEPROM_GP);
 	int sz;
 	int ret;
 	u16 addr;
 	u16 validblockaddr = 0;
 	u16 cache_addr = 0;
 
-	priv->nvm_device_type = iwl_get_nvm_type(trans(priv), hw_rev);
+	priv->nvm_device_type = iwl_get_nvm_type(priv->trans, hw_rev);
 	if (priv->nvm_device_type == -ENOENT)
 		return -ENOENT;
 	/* allocate eeprom */
@@ -747,7 +747,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = iwl_eeprom_acquire_semaphore(trans(priv));
+	ret = iwl_eeprom_acquire_semaphore(priv->trans);
 	if (ret < 0) {
 		IWL_ERR(priv, "Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -756,22 +756,22 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
 
-		ret = iwl_init_otp_access(trans(priv));
+		ret = iwl_init_otp_access(priv->trans);
 		if (ret) {
 			IWL_ERR(priv, "Failed to initialize OTP access.\n");
 			ret = -ENOENT;
 			goto done;
 		}
-		iwl_write32(trans(priv), CSR_EEPROM_GP,
-			    iwl_read32(trans(priv), CSR_EEPROM_GP) &
+		iwl_write32(priv->trans, CSR_EEPROM_GP,
+			    iwl_read32(priv->trans, CSR_EEPROM_GP) &
 			    ~CSR_EEPROM_GP_IF_OWNER_MSK);
 
-		iwl_set_bit(trans(priv), CSR_OTP_GP_REG,
+		iwl_set_bit(priv->trans, CSR_OTP_GP_REG,
 			     CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK |
 			     CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		/* traversing the linked list if no shadow ram supported */
 		if (!cfg(priv)->base_params->shadow_ram_support) {
-			if (iwl_find_otp_image(trans(priv), &validblockaddr)) {
+			if (iwl_find_otp_image(priv->trans, &validblockaddr)) {
 				ret = -ENOENT;
 				goto done;
 			}
@@ -780,7 +780,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		     addr += sizeof(u16)) {
 			__le16 eeprom_data;
 
-			ret = iwl_read_otp_word(trans(priv), addr,
+			ret = iwl_read_otp_word(priv->trans, addr,
 						&eeprom_data);
 			if (ret)
 				goto done;
@@ -792,10 +792,10 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
 			u32 r;
 
-			iwl_write32(trans(priv), CSR_EEPROM_REG,
+			iwl_write32(priv->trans, CSR_EEPROM_REG,
 				    CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-			ret = iwl_poll_bit(trans(priv), CSR_EEPROM_REG,
+			ret = iwl_poll_bit(priv->trans, CSR_EEPROM_REG,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  CSR_EEPROM_REG_READ_VALID_MSK,
 						  IWL_EEPROM_ACCESS_TIMEOUT);
@@ -804,7 +804,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 					"Time out reading EEPROM[%d]\n", addr);
 				goto done;
 			}
-			r = iwl_read32(trans(priv), CSR_EEPROM_REG);
+			r = iwl_read32(priv->trans, CSR_EEPROM_REG);
 			e[addr / 2] = cpu_to_le16(r >> 16);
 		}
 	}
@@ -816,7 +816,7 @@ int iwl_eeprom_init(struct iwl_priv *priv, u32 hw_rev)
 
 	ret = 0;
 done:
-	iwl_eeprom_release_semaphore(trans(priv));
+	iwl_eeprom_release_semaphore(priv->trans);
 
 err:
 	if (ret)
@@ -1132,7 +1132,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 
 	/* write radio config values to register */
 	if (EEPROM_RF_CFG_TYPE_MSK(radio_cfg) <= EEPROM_RF_CONFIG_TYPE_MAX) {
-		iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
+		iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
 			    EEPROM_RF_CFG_TYPE_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_STEP_MSK(radio_cfg) |
 			    EEPROM_RF_CFG_DASH_MSK(radio_cfg));
@@ -1144,7 +1144,7 @@ void iwl_rf_config(struct iwl_priv *priv)
 		WARN_ON(1);
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(trans(priv), CSR_HW_IF_CONFIG_REG,
+	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
 		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
 		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 1993a2b..18e6a36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -71,7 +71,7 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 /* Set led register off */
 void iwlagn_led_enable(struct iwl_priv *priv)
 {
-	iwl_write32(trans(priv), CSR_LED_REG, CSR_LED_REG_TRUN_ON);
+	iwl_write32(priv->trans, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
 }
 
 /*
@@ -107,9 +107,9 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 	};
 	u32 reg;
 
-	reg = iwl_read32(trans(priv), CSR_LED_REG);
+	reg = iwl_read32(priv->trans, CSR_LED_REG);
 	if (reg != (reg & CSR_LED_BSM_CTRL_MSK))
-		iwl_write32(trans(priv), CSR_LED_REG,
+		iwl_write32(priv->trans, CSR_LED_REG,
 			    reg & CSR_LED_BSM_CTRL_MSK);
 
 	return iwl_dvm_send_cmd(priv, &cmd);
@@ -207,7 +207,7 @@ void iwl_leds_init(struct iwl_priv *priv)
 		break;
 	}
 
-	ret = led_classdev_register(trans(priv)->dev, &priv->led);
+	ret = led_classdev_register(priv->trans->dev, &priv->led);
 	if (ret) {
 		kfree(priv->led.name);
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 3f82ff4..20388ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -198,8 +198,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_IBSS_RSN;
 
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
-	    trans(priv)->ops->wowlan_suspend &&
-	    device_can_wakeup(trans(priv)->dev)) {
+	    priv->trans->ops->wowlan_suspend &&
+	    device_can_wakeup(priv->trans->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
 					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
@@ -237,7 +237,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->bands[IEEE80211_BAND_5GHZ];
 
-	hw->wiphy->hw_version = trans(priv)->hw_id;
+	hw->wiphy->hw_version = priv->trans->hw_id;
 
 	iwl_leds_init(priv);
 
@@ -356,7 +356,7 @@ void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	 * even if interface is down, trans->down will leave the RF
 	 * kill interrupt enabled
 	 */
-	iwl_trans_stop_hw(trans(priv));
+	iwl_trans_stop_hw(priv->trans);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -412,9 +412,9 @@ int iwlagn_mac_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	if (ret)
 		goto error;
 
-	device_set_wakeup_enable(trans(priv)->dev, true);
+	device_set_wakeup_enable(priv->trans->dev, true);
 
-	iwl_trans_wowlan_suspend(trans(priv));
+	iwl_trans_wowlan_suspend(priv->trans);
 
 	goto out;
 
@@ -441,19 +441,19 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
 
-	iwl_write32(trans(priv), CSR_UCODE_DRV_GP1_CLR,
+	iwl_write32(priv->trans, CSR_UCODE_DRV_GP1_CLR,
 			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
 
 	base = priv->device_pointers.error_event_table;
 	if (iwlagn_hw_valid_rtc_data_addr(base)) {
-		spin_lock_irqsave(&trans(priv)->reg_lock, flags);
-		ret = iwl_grab_nic_access_silent(trans(priv));
+		spin_lock_irqsave(&priv->trans->reg_lock, flags);
+		ret = iwl_grab_nic_access_silent(priv->trans);
 		if (likely(ret == 0)) {
-			iwl_write32(trans(priv), HBUS_TARG_MEM_RADDR, base);
-			status = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
-			iwl_release_nic_access(trans(priv));
+			iwl_write32(priv->trans, HBUS_TARG_MEM_RADDR, base);
+			status = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
+			iwl_release_nic_access(priv->trans);
 		}
-		spin_unlock_irqrestore(&trans(priv)->reg_lock, flags);
+		spin_unlock_irqrestore(&priv->trans->reg_lock, flags);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
@@ -468,7 +468,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 			if (priv->wowlan_sram)
 				_iwl_read_targ_mem_words(
-				      trans(priv), 0x800000,
+				      priv->trans, 0x800000,
 				      priv->wowlan_sram,
 				      img->sec[IWL_UCODE_SECTION_DATA].len / 4);
 		}
@@ -480,7 +480,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 	priv->wowlan = false;
 
-	device_set_wakeup_enable(trans(priv)->dev, false);
+	device_set_wakeup_enable(priv->trans->dev, false);
 
 	iwlagn_prepare_restart(priv);
 
@@ -654,7 +654,7 @@ int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (!trans(priv)->ops->tx_agg_setup)
+		if (!priv->trans->ops->tx_agg_setup)
 			break;
 		if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
 			break;
@@ -1006,7 +1006,7 @@ void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 		}
 	}
 	IWL_DEBUG_MAC80211(priv, "wait transmit/flush all frames\n");
-	iwl_trans_wait_tx_queue_empty(trans(priv));
+	iwl_trans_wait_tx_queue_empty(priv->trans);
 done:
 	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 174a0f7..2c6f3b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -378,7 +378,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
-	priv->power_data.bus_pm = trans(priv)->pm_support;
+	priv->power_data.bus_pm = priv->trans->pm_support;
 
 	priv->power_data.debug_sleep_level_override = -1;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index c8e89ca..0c516d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -218,7 +218,7 @@ static void iwl_trace_cleanup(struct iwl_priv *priv)
 	if (priv->testmode_trace.trace_enabled) {
 		if (priv->testmode_trace.cpu_addr &&
 		    priv->testmode_trace.dma_addr)
-			dma_free_coherent(trans(priv)->dev,
+			dma_free_coherent(priv->trans->dev,
 					priv->testmode_trace.total_size,
 					priv->testmode_trace.cpu_addr,
 					priv->testmode_trace.dma_addr);
@@ -371,7 +371,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 
 	switch (cmd) {
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_READ32:
-		val32 = iwl_read_direct32(trans(priv), ofs);
+		val32 = iwl_read_direct32(priv->trans, ofs);
 		IWL_INFO(priv, "32bit value to read 0x%x\n", val32);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -391,7 +391,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val32 = nla_get_u32(tb[IWL_TM_ATTR_REG_VALUE32]);
 			IWL_INFO(priv, "32bit value to write 0x%x\n", val32);
-			iwl_write_direct32(trans(priv), ofs, val32);
+			iwl_write_direct32(priv->trans, ofs, val32);
 		}
 		break;
 	case IWL_TM_CMD_APP2DEV_DIRECT_REG_WRITE8:
@@ -401,7 +401,7 @@ static int iwl_testmode_reg(struct ieee80211_hw *hw, struct nlattr **tb)
 		} else {
 			val8 = nla_get_u8(tb[IWL_TM_ATTR_REG_VALUE8]);
 			IWL_INFO(priv, "8bit value to write 0x%x\n", val8);
-			iwl_write8(trans(priv), ofs, val8);
+			iwl_write8(priv->trans, ofs, val8);
 		}
 		break;
 	default:
@@ -464,7 +464,7 @@ cfg_init_calib_error:
 static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 	struct sk_buff *skb;
 	unsigned char *rsp_data_ptr = NULL;
 	int status = 0, rsp_data_len = 0;
@@ -577,7 +577,7 @@ static int iwl_testmode_driver(struct ieee80211_hw *hw, struct nlattr **tb)
 		break;
 
 	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
-		devid = trans(priv)->hw_id;
+		devid = priv->trans->hw_id;
 		IWL_INFO(priv, "hw version: 0x%x\n", devid);
 
 		skb = cfg80211_testmode_alloc_reply_skb(hw->wiphy, 20);
@@ -642,7 +642,7 @@ static int iwl_testmode_trace(struct ieee80211_hw *hw, struct nlattr **tb)
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct sk_buff *skb;
 	int status = 0;
-	struct device *dev = trans(priv)->dev;
+	struct device *dev = priv->trans->dev;
 
 	switch (nla_get_u32(tb[IWL_TM_ATTR_COMMAND])) {
 	case IWL_TM_CMD_APP2DEV_BEGIN_TRACE:
@@ -782,7 +782,7 @@ static int iwl_testmode_ownership(struct ieee80211_hw *hw, struct nlattr **tb)
 
 static int iwl_testmode_indirect_read(struct iwl_priv *priv, u32 addr, u32 size)
 {
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 	unsigned long flags;
 	int i;
 
@@ -822,7 +822,7 @@ static int iwl_testmode_indirect_read(struct iwl_priv *priv, u32 addr, u32 size)
 static int iwl_testmode_indirect_write(struct iwl_priv *priv, u32 addr,
 	u32 size, unsigned char *buf)
 {
-	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans *trans = priv->trans;
 	u32 val, i;
 	unsigned long flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 5391719..4056d1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -244,7 +244,7 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 {
 	int ret;
 
-	iwl_trans_fw_alive(trans(priv));
+	iwl_trans_fw_alive(priv->trans);
 
 	priv->passive_no_rx = false;
 	priv->transport_queue_stop = 0;
@@ -282,9 +282,9 @@ static int iwl_verify_sec_sparse(struct iwl_priv *priv,
 		/* read data comes through single port, auto-incr addr */
 		/* NOTE: Use the debugless read so we don't flood kernel log
 		 * if IWL_DL_IO is set */
-		iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
+		iwl_write_direct32(priv->trans, HBUS_TARG_MEM_RADDR,
 			i + fw_desc->offset);
-		val = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image))
 			return -EIO;
 	}
@@ -303,14 +303,14 @@ static void iwl_print_mismatch_sec(struct iwl_priv *priv,
 
 	IWL_DEBUG_FW(priv, "ucode inst image size is %u\n", len);
 
-	iwl_write_direct32(trans(priv), HBUS_TARG_MEM_RADDR,
+	iwl_write_direct32(priv->trans, HBUS_TARG_MEM_RADDR,
 				fw_desc->offset);
 
 	for (offs = 0;
 	     offs < len && errors < 20;
 	     offs += sizeof(u32), image++) {
 		/* read data comes through single port, auto-incr addr */
-		val = iwl_read32(trans(priv), HBUS_TARG_MEM_RDAT);
+		val = iwl_read32(priv->trans, HBUS_TARG_MEM_RDAT);
 		if (val != le32_to_cpu(*image)) {
 			IWL_ERR(priv, "uCode INST section at "
 				"offset 0x%x, is 0x%x, s/b 0x%x\n",
@@ -402,7 +402,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 				   alive_cmd, ARRAY_SIZE(alive_cmd),
 				   iwl_alive_fn, &alive_data);
 
-	ret = iwl_trans_start_fw(trans(priv), fw);
+	ret = iwl_trans_start_fw(priv->trans, fw);
 	if (ret) {
 		priv->cur_ucode = old_type;
 		iwl_remove_notification(&priv->notif_wait, &alive_wait);
@@ -526,7 +526,7 @@ int iwl_run_init_ucode(struct iwl_priv *priv)
 	iwl_remove_notification(&priv->notif_wait, &calib_wait);
  out:
 	/* Whatever happened, stop the device */
-	iwl_trans_stop_device(trans(priv));
+	iwl_trans_stop_device(priv->trans);
 	priv->ucode_loaded = false;
 
 	return ret;
-- 
1.7.0.4

