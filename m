Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab1HZGxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/60] iwlagn: move ISR related data to transport layer
Date: Thu, 25 Aug 2011 23:10:53 -0700
Message-Id: <1314339092-20797-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085515_748497_012F4965)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the ISR is entirely in the transport layer, its data should be in the pcie
specific region.
Change sync_irq to first disable and then synchronize the IRQ.
iwl_isr and iwl_isr_ict now receive iwl_trans.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   12 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   21 --
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   45 +++-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |  333 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   50 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   13 +-
 7 files changed, 255 insertions(+), 232 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 660abed..ca6bb7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3627,7 +3627,6 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
-	priv->inta_mask = CSR_INI_SET_MASK;
 
 	/* is antenna coupling more than 35dB ? */
 	priv->bt_ant_couple_ok =
@@ -3771,8 +3770,6 @@ out:
 
 void __devexit iwl_remove(struct iwl_priv * priv)
 {
-	unsigned long flags;
-
 	wait_for_completion(&priv->firmware_loading_complete);
 
 	IWL_DEBUG_INFO(priv, "*** UNLOAD DRIVER ***\n");
@@ -3801,13 +3798,8 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_tt_exit(priv);
 
 	/* make sure we flush any pending irq or
-	 * tasklet for the driver
-	 */
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
-
-	iwl_trans_sync_irq(trans(priv));
+	 * tasklet for the driver */
+	iwl_trans_disable_sync_irq(trans(priv));
 
 	iwl_dealloc_ucode(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8a8fc74..40a01c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1259,6 +1259,7 @@ struct iwl_priv {
 	struct traffic_stats rx_stats;
 
 	/* counts interrupts */
+	/* TODO: move to the transport layer */
 	struct isr_statistics isr_stats;
 
 	struct iwl_power_mgr power_data;
@@ -1315,14 +1316,6 @@ struct iwl_priv {
 	} accum_stats, delta_stats, max_delta_stats;
 #endif
 
-	/* INT ICT Table */
-	__le32 *ict_tbl;
-	void *ict_tbl_vir;
-	dma_addr_t ict_tbl_dma;
-	dma_addr_t aligned_ict_tbl_dma;
-	int ict_index;
-	u32 inta;
-	bool use_ict;
 	/*
 	 * reporting the number of tids has AGG on. 0 means
 	 * no AGGREGATION
@@ -1379,8 +1372,6 @@ struct iwl_priv {
 	struct iwl_rxon_context *cur_rssi_ctx;
 	bool bt_is_sco;
 
-	u32 inta_mask;
-
 	struct work_struct restart;
 	struct work_struct scan_completed;
 	struct work_struct abort_scan;
@@ -1398,8 +1389,6 @@ struct iwl_priv {
 	struct work_struct bt_full_concurrency;
 	struct work_struct bt_runtime_config;
 
-	struct tasklet_struct irq_tasklet;
-
 	struct delayed_work scan_check;
 
 	/* TX Power */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index d053ed7..09ed7af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -132,33 +132,12 @@ static inline void iwl_wake_any_queue(struct iwl_priv *priv,
 
 #define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
 
-static inline void iwl_disable_interrupts(struct iwl_priv *priv)
-{
-	clear_bit(STATUS_INT_ENABLED, &priv->shrd->status);
-
-	/* disable interrupts from uCode/NIC to host */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-	/* acknowledge/clear/reset any interrupts still pending
-	 * from uCode or flow handler (Rx/Tx DMA) */
-	iwl_write32(priv, CSR_INT, 0xffffffff);
-	iwl_write32(priv, CSR_FH_INT_STATUS, 0xffffffff);
-	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
-}
-
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
 	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
 }
 
-static inline void iwl_enable_interrupts(struct iwl_priv *priv)
-{
-	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
-	set_bit(STATUS_INT_ENABLED, &priv->shrd->status);
-	iwl_write32(priv, CSR_INT_MASK, priv->inta_mask);
-}
-
 /**
  * iwl_beacon_time_mask_low - mask of lower 32 bit of beacon time
  * @priv -- pointer to iwl_priv data structure
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 1d80515..7e2f954 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -78,6 +78,18 @@ struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
 	struct work_struct rx_replenish;
 	struct iwl_trans *trans;
+
+	/* INT ICT Table */
+	__le32 *ict_tbl;
+	void *ict_tbl_vir;
+	dma_addr_t ict_tbl_dma;
+	dma_addr_t aligned_ict_tbl_dma;
+	int ict_index;
+	u32 inta;
+	bool use_ict;
+	struct tasklet_struct irq_tasklet;
+
+	u32 inta_mask;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
@@ -87,7 +99,7 @@ struct iwl_trans_pcie {
 * RX
 ******************************************************/
 void iwl_bg_rx_replenish(struct work_struct *data);
-void iwl_irq_tasklet(struct iwl_priv *priv);
+void iwl_irq_tasklet(struct iwl_trans *trans);
 void iwlagn_rx_replenish(struct iwl_trans *trans);
 void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 			struct iwl_rx_queue *q);
@@ -96,12 +108,11 @@ void iwl_rx_queue_update_write_ptr(struct iwl_trans *trans,
 * ICT
 ******************************************************/
 int iwl_reset_ict(struct iwl_priv *priv);
-void iwl_disable_ict(struct iwl_priv *priv);
-int iwl_alloc_isr_ict(struct iwl_priv *priv);
-void iwl_free_isr_ict(struct iwl_priv *priv);
+void iwl_disable_ict(struct iwl_trans *trans);
+int iwl_alloc_isr_ict(struct iwl_trans *trans);
+void iwl_free_isr_ict(struct iwl_trans *trans);
 irqreturn_t iwl_isr_ict(int irq, void *data);
 
-
 /*****************************************************
 * TX / HCMD
 ******************************************************/
@@ -130,4 +141,28 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 						int frame_limit);
 
+static inline void iwl_disable_interrupts(struct iwl_trans *trans)
+{
+	clear_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+
+	/* disable interrupts from uCode/NIC to host */
+	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
+
+	/* acknowledge/clear/reset any interrupts still pending
+	 * from uCode or flow handler (Rx/Tx DMA) */
+	iwl_write32(priv(trans), CSR_INT, 0xffffffff);
+	iwl_write32(priv(trans), CSR_FH_INT_STATUS, 0xffffffff);
+	IWL_DEBUG_ISR(trans, "Disabled interrupts\n");
+}
+
+static inline void iwl_enable_interrupts(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	IWL_DEBUG_ISR(trans, "Enabling interrupts\n");
+	set_bit(STATUS_INT_ENABLED, &trans->shrd->status);
+	iwl_write32(priv(trans), CSR_INT_MASK, trans_pcie->inta_mask);
+}
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index fb06acf..15e2645 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -497,7 +497,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 }
 
 /* tasklet for iwlagn interrupt */
-void iwl_irq_tasklet(struct iwl_priv *priv)
+void iwl_irq_tasklet(struct iwl_trans *trans)
 {
 	u32 inta = 0;
 	u32 handled = 0;
@@ -507,7 +507,10 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	u32 inta_mask;
 #endif
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Ack/clear/reset pending uCode interrupts.
 	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
@@ -520,33 +523,34 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	 * hardware bugs here by ACKing all the possible interrupts so that
 	 * interrupt coalescing can still be achieved.
 	 */
-	iwl_write32(priv, CSR_INT, priv->inta | ~priv->inta_mask);
+	iwl_write32(priv(trans), CSR_INT,
+		trans_pcie->inta | ~trans_pcie->inta_mask);
 
-	inta = priv->inta;
+	inta = trans_pcie->inta;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & IWL_DL_ISR) {
+	if (iwl_get_debug_level(trans->shrd) & IWL_DL_ISR) {
 		/* just for debug */
-		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x\n ",
+		inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);
+		IWL_DEBUG_ISR(trans, "inta 0x%08x, enabled 0x%08x\n ",
 				inta, inta_mask);
 	}
 #endif
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
-	/* saved interrupt in inta variable now we can reset priv->inta */
-	priv->inta = 0;
+	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
+	trans_pcie->inta = 0;
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
+		IWL_ERR(trans, "Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
-		iwl_disable_interrupts(priv);
+		iwl_disable_interrupts(trans);
 
-		priv->isr_stats.hw++;
-		iwl_irq_handle_error(priv);
+		priv(trans)->isr_stats.hw++;
+		iwl_irq_handle_error(priv(trans));
 
 		handled |= CSR_INT_BIT_HW_ERR;
 
@@ -554,18 +558,18 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & (IWL_DL_ISR)) {
+	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
 		if (inta & CSR_INT_BIT_SCD) {
-			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
+			IWL_DEBUG_ISR(trans, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
-			priv->isr_stats.sch++;
+			priv(trans)->isr_stats.sch++;
 		}
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE) {
-			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
-			priv->isr_stats.alive++;
+			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
+			priv(trans)->isr_stats.alive++;
 		}
 	}
 #endif
@@ -575,27 +579,29 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* HW RF KILL switch toggled */
 	if (inta & CSR_INT_BIT_RF_KILL) {
 		int hw_rf_kill = 0;
-		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
+		if (!(iwl_read32(priv(trans), CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
 			hw_rf_kill = 1;
 
-		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
+		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
-		priv->isr_stats.rfkill++;
+		priv(trans)->isr_stats.rfkill++;
 
 		/* driver only loads ucode once setting the interface up.
 		 * the driver allows loading the ucode even if the radio
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(STATUS_ALIVE, &priv->shrd->status)) {
+		if (!test_bit(STATUS_ALIVE, &trans->shrd->status)) {
 			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
+				set_bit(STATUS_RF_KILL_HW,
+					&trans->shrd->status);
 			else
 				clear_bit(STATUS_RF_KILL_HW,
-					  &priv->shrd->status);
-			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
+					  &trans->shrd->status);
+			wiphy_rfkill_set_hw_state(priv(trans)->hw->wiphy,
+						  hw_rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -603,30 +609,29 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERR(priv, "Microcode CT kill error detected.\n");
-		priv->isr_stats.ctkill++;
+		IWL_ERR(trans, "Microcode CT kill error detected.\n");
+		priv(trans)->isr_stats.ctkill++;
 		handled |= CSR_INT_BIT_CT_KILL;
 	}
 
 	/* Error detected by uCode */
 	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERR(priv, "Microcode SW error detected. "
+		IWL_ERR(trans, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
-		priv->isr_stats.sw++;
-		iwl_irq_handle_error(priv);
+		priv(trans)->isr_stats.sw++;
+		iwl_irq_handle_error(priv(trans));
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
 
 	/* uCode wakes up after power-down sleep */
 	if (inta & CSR_INT_BIT_WAKEUP) {
-		struct iwl_trans_pcie *trans_pcie =
-			IWL_TRANS_GET_PCIE_TRANS(trans(priv));
-		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(trans(priv), &trans_pcie->rxq);
-		for (i = 0; i < hw_params(priv).max_txq_num; i++)
-			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
+		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
+		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
+		for (i = 0; i < hw_params(trans).max_txq_num; i++)
+			iwl_txq_update_write_ptr(priv(trans),
+						 &priv(trans)->txq[i]);
 
-		priv->isr_stats.wakeup++;
+		priv(trans)->isr_stats.wakeup++;
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
@@ -636,15 +641,16 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX |
 			CSR_INT_BIT_RX_PERIODIC)) {
-		IWL_DEBUG_ISR(priv, "Rx interrupt\n");
+		IWL_DEBUG_ISR(trans, "Rx interrupt\n");
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 			handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-			iwl_write32(priv, CSR_FH_INT_STATUS,
+			iwl_write32(priv(trans), CSR_FH_INT_STATUS,
 					CSR_FH_INT_RX_MASK);
 		}
 		if (inta & CSR_INT_BIT_RX_PERIODIC) {
 			handled |= CSR_INT_BIT_RX_PERIODIC;
-			iwl_write32(priv, CSR_INT, CSR_INT_BIT_RX_PERIODIC);
+			iwl_write32(priv(trans),
+				CSR_INT, CSR_INT_BIT_RX_PERIODIC);
 		}
 		/* Sending RX interrupt require many steps to be done in the
 		 * the device:
@@ -658,9 +664,9 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 		 */
 
 		/* Disable periodic interrupt; we use it as just a one-shot. */
-		iwl_write8(priv, CSR_INT_PERIODIC_REG,
+		iwl_write8(priv(trans), CSR_INT_PERIODIC_REG,
 			    CSR_INT_PERIODIC_DIS);
-		iwl_rx_handle(trans(priv));
+		iwl_rx_handle(trans);
 
 		/*
 		 * Enable periodic interrupt in 8 msec only if we received
@@ -670,40 +676,40 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 		 * to extend the periodic interrupt; one-shot is enough.
 		 */
 		if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX))
-			iwl_write8(priv, CSR_INT_PERIODIC_REG,
+			iwl_write8(priv(trans), CSR_INT_PERIODIC_REG,
 				    CSR_INT_PERIODIC_ENA);
 
-		priv->isr_stats.rx++;
+		priv(trans)->isr_stats.rx++;
 	}
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
-		iwl_write32(priv, CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
-		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
-		priv->isr_stats.tx++;
+		iwl_write32(priv(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
+		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
+		priv(trans)->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
-		priv->ucode_write_complete = 1;
-		wake_up_interruptible(&priv->wait_command_queue);
+		priv(trans)->ucode_write_complete = 1;
+		wake_up_interruptible(&priv(trans)->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
-		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
-		priv->isr_stats.unhandled++;
+		IWL_ERR(trans, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		priv(trans)->isr_stats.unhandled++;
 	}
 
-	if (inta & ~(priv->inta_mask)) {
-		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~priv->inta_mask);
+	if (inta & ~(trans_pcie->inta_mask)) {
+		IWL_WARN(trans, "Disabled INTA bits 0x%08x were pending\n",
+			 inta & ~trans_pcie->inta_mask);
 	}
 
 	/* Re-enable all interrupts */
 	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status))
-		iwl_enable_interrupts(priv);
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status))
+		iwl_enable_interrupts(trans);
 	/* Re-enable RF_KILL if it occurred */
 	else if (handled & CSR_INT_BIT_RF_KILL)
-		iwl_enable_rfkill_int(priv);
+		iwl_enable_rfkill_int(priv(trans));
 }
 
 /******************************************************************************
@@ -714,18 +720,21 @@ void iwl_irq_tasklet(struct iwl_priv *priv)
 #define ICT_COUNT (PAGE_SIZE/sizeof(u32))
 
 /* Free dram table */
-void iwl_free_isr_ict(struct iwl_priv *priv)
+void iwl_free_isr_ict(struct iwl_trans *trans)
 {
-	if (priv->ict_tbl_vir) {
-		dma_free_coherent(priv->bus->dev,
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	if (trans_pcie->ict_tbl_vir) {
+		dma_free_coherent(bus(trans)->dev,
 				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				  priv->ict_tbl_vir,
-				  priv->ict_tbl_dma);
-		priv->ict_tbl_vir = NULL;
-		memset(&priv->ict_tbl_dma, 0,
-			sizeof(priv->ict_tbl_dma));
-		memset(&priv->aligned_ict_tbl_dma, 0,
-			sizeof(priv->aligned_ict_tbl_dma));
+				  trans_pcie->ict_tbl_vir,
+				  trans_pcie->ict_tbl_dma);
+		trans_pcie->ict_tbl_vir = NULL;
+		memset(&trans_pcie->ict_tbl_dma, 0,
+			sizeof(trans_pcie->ict_tbl_dma));
+		memset(&trans_pcie->aligned_ict_tbl_dma, 0,
+			sizeof(trans_pcie->aligned_ict_tbl_dma));
 	}
 }
 
@@ -733,43 +742,45 @@ void iwl_free_isr_ict(struct iwl_priv *priv)
 /* allocate dram shared table it is a PAGE_SIZE aligned
  * also reset all data related to ICT table interrupt.
  */
-int iwl_alloc_isr_ict(struct iwl_priv *priv)
+int iwl_alloc_isr_ict(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* allocate shrared data table */
-	priv->ict_tbl_vir =
-		dma_alloc_coherent(priv->bus->dev,
+	trans_pcie->ict_tbl_vir =
+		dma_alloc_coherent(bus(trans)->dev,
 				   (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				   &priv->ict_tbl_dma, GFP_KERNEL);
-	if (!priv->ict_tbl_vir)
+				   &trans_pcie->ict_tbl_dma, GFP_KERNEL);
+	if (!trans_pcie->ict_tbl_vir)
 		return -ENOMEM;
 
 	/* align table to PAGE_SIZE boundary */
-	priv->aligned_ict_tbl_dma =
-		ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
+	trans_pcie->aligned_ict_tbl_dma =
+		ALIGN(trans_pcie->ict_tbl_dma, PAGE_SIZE);
 
-	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
-			     (unsigned long long)priv->ict_tbl_dma,
-			     (unsigned long long)priv->aligned_ict_tbl_dma,
-			     (int)(priv->aligned_ict_tbl_dma -
-			     priv->ict_tbl_dma));
+	IWL_DEBUG_ISR(trans, "ict dma addr %Lx dma aligned %Lx diff %d\n",
+			   (unsigned long long)trans_pcie->ict_tbl_dma,
+			   (unsigned long long)trans_pcie->aligned_ict_tbl_dma,
+			   (int)(trans_pcie->aligned_ict_tbl_dma -
+			   trans_pcie->ict_tbl_dma));
 
-	priv->ict_tbl =  priv->ict_tbl_vir +
-			  (priv->aligned_ict_tbl_dma -
-			  priv->ict_tbl_dma);
+	trans_pcie->ict_tbl =  trans_pcie->ict_tbl_vir +
+			  (trans_pcie->aligned_ict_tbl_dma -
+			  trans_pcie->ict_tbl_dma);
 
-	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
-			     priv->ict_tbl, priv->ict_tbl_vir,
-			(int)(priv->aligned_ict_tbl_dma -
-			    priv->ict_tbl_dma));
+	IWL_DEBUG_ISR(trans, "ict vir addr %p vir aligned %p diff %d\n",
+			     trans_pcie->ict_tbl, trans_pcie->ict_tbl_vir,
+			(int)(trans_pcie->aligned_ict_tbl_dma -
+			    trans_pcie->ict_tbl_dma));
 
 	/* reset table and index to all 0 */
-	memset(priv->ict_tbl_vir, 0,
+	memset(trans_pcie->ict_tbl_vir, 0,
 		(sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
-	priv->ict_index = 0;
+	trans_pcie->ict_index = 0;
 
 	/* add periodic RX interrupt */
-	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
+	trans_pcie->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
 	return 0;
 }
 
@@ -780,110 +791,120 @@ int iwl_reset_ict(struct iwl_priv *priv)
 {
 	u32 val;
 	unsigned long flags;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (!priv->ict_tbl_vir)
+	if (!trans_pcie->ict_tbl_vir)
 		return 0;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwl_disable_interrupts(priv);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_disable_interrupts(trans);
 
-	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
+	memset(&trans_pcie->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
 
-	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
+	val = trans_pcie->aligned_ict_tbl_dma >> PAGE_SHIFT;
 
 	val |= CSR_DRAM_INT_TBL_ENABLE;
 	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
 
-	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
+	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%X "
 			"aligned dma address %Lx\n",
 			val,
-			(unsigned long long)priv->aligned_ict_tbl_dma);
+			(unsigned long long)trans_pcie->aligned_ict_tbl_dma);
 
-	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
-	priv->use_ict = true;
-	priv->ict_index = 0;
-	iwl_write32(priv, CSR_INT, priv->inta_mask);
-	iwl_enable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	iwl_write32(priv(trans), CSR_DRAM_INT_TBL_REG, val);
+	trans_pcie->use_ict = true;
+	trans_pcie->ict_index = 0;
+	iwl_write32(priv(trans), CSR_INT, trans_pcie->inta_mask);
+	iwl_enable_interrupts(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
 	return 0;
 }
 
 /* Device is going down disable ict interrupt usage */
-void iwl_disable_ict(struct iwl_priv *priv)
+void iwl_disable_ict(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	unsigned long flags;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-	priv->use_ict = false;
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	trans_pcie->use_ict = false;
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 }
 
 static irqreturn_t iwl_isr(int irq, void *data)
 {
-	struct iwl_priv *priv = data;
+	struct iwl_trans *trans = data;
+	struct iwl_trans_pcie *trans_pcie;
 	u32 inta, inta_mask;
 	unsigned long flags;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	u32 inta_fh;
 #endif
-	if (!priv)
+	if (!trans)
 		return IRQ_NONE;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 *    back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
 
 	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv, CSR_INT);
+	inta = iwl_read32(priv(trans), CSR_INT);
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
 	if (!inta) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
 		goto none;
 	}
 
 	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
 		/* Hardware disappeared. It might have already raised
 		 * an interrupt */
-		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		IWL_WARN(trans, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
 		goto unplugged;
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv->shrd) & (IWL_DL_ISR)) {
-		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
+	if (iwl_get_debug_level(trans->shrd) & (IWL_DL_ISR)) {
+		inta_fh = iwl_read32(priv(trans), CSR_FH_INT_STATUS);
+		IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x, "
 			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
 	}
 #endif
 
-	priv->inta |= inta;
+	trans_pcie->inta |= inta;
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) &&
-			!priv->inta)
-		iwl_enable_interrupts(priv);
+		tasklet_schedule(&trans_pcie->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+			!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
 
  unplugged:
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 	return IRQ_HANDLED;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service. */
 	/* only Re-enable if disabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
-		iwl_enable_interrupts(priv);
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+		!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 	return IRQ_NONE;
 }
 
@@ -897,50 +918,53 @@ static irqreturn_t iwl_isr(int irq, void *data)
  */
 irqreturn_t iwl_isr_ict(int irq, void *data)
 {
-	struct iwl_priv *priv = data;
+	struct iwl_trans *trans = data;
+	struct iwl_trans_pcie *trans_pcie;
 	u32 inta, inta_mask;
 	u32 val = 0;
 	unsigned long flags;
 
-	if (!priv)
+	if (!trans)
 		return IRQ_NONE;
 
+	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	/* dram interrupt table not set yet,
 	 * use legacy interrupt.
 	 */
-	if (!priv->use_ict)
+	if (!trans_pcie->use_ict)
 		return iwl_isr(irq, data);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Disable (but don't clear!) interrupts here to avoid
 	 * back-to-back ISRs and sporadic interrupts from our NIC.
 	 * If we have something to service, the tasklet will re-enable ints.
 	 * If we *don't* have something, we'll re-enable before leaving here.
 	 */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+	inta_mask = iwl_read32(priv(trans), CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv(trans), CSR_INT_MASK, 0x00000000);
 
 
 	/* Ignore interrupt if there's nothing in NIC to service.
 	 * This may be due to IRQ shared with another device,
 	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!priv->ict_tbl[priv->ict_index]) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+	if (!trans_pcie->ict_tbl[trans_pcie->ict_index]) {
+		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
 		goto none;
 	}
 
 	/* read all entries that not 0 start with ict_index */
-	while (priv->ict_tbl[priv->ict_index]) {
+	while (trans_pcie->ict_tbl[trans_pcie->ict_index]) {
 
-		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
-		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
-				priv->ict_index,
+		val |= le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
+		IWL_DEBUG_ISR(trans, "ICT index %d value 0x%08X\n",
+				trans_pcie->ict_index,
 				le32_to_cpu(
-				    priv->ict_tbl[priv->ict_index]));
-		priv->ict_tbl[priv->ict_index] = 0;
-		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
-						     ICT_COUNT);
+				  trans_pcie->ict_tbl[trans_pcie->ict_index]));
+		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
+		trans_pcie->ict_index =
+			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
 
 	}
 
@@ -959,34 +983,35 @@ irqreturn_t iwl_isr_ict(int irq, void *data)
 		val |= 0x8000;
 
 	inta = (0xff & val) | ((0xff00 & val) << 16);
-	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
+	IWL_DEBUG_ISR(trans, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
 			inta, inta_mask, val);
 
-	inta &= priv->inta_mask;
-	priv->inta |= inta;
+	inta &= trans_pcie->inta_mask;
+	trans_pcie->inta |= inta;
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	if (likely(inta))
-		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) &&
-			!priv->inta) {
+		tasklet_schedule(&trans_pcie->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+			!trans_pcie->inta) {
 		/* Allow interrupt if was disabled by this handler and
 		 * no tasklet was schedules, We should not enable interrupt,
 		 * tasklet will enable it.
 		 */
-		iwl_enable_interrupts(priv);
+		iwl_enable_interrupts(trans);
 	}
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 	return IRQ_HANDLED;
 
  none:
 	/* re-enable interrupts here since we don't have anything to service.
 	 * only Re-enable if disabled by irq.
 	 */
-	if (test_bit(STATUS_INT_ENABLED, &priv->shrd->status) && !priv->inta)
-		iwl_enable_interrupts(priv);
+	if (test_bit(STATUS_INT_ENABLED, &trans->shrd->status) &&
+		!trans_pcie->inta)
+		iwl_enable_interrupts(trans);
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 	return IRQ_NONE;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 621b9a8..687a092 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -711,7 +711,7 @@ static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
 
 	if (iwl_is_rfkill(priv)) {
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
-		iwl_enable_interrupts(priv);
+		iwl_enable_interrupts(trans(priv));
 		return -ERFKILL;
 	}
 
@@ -730,7 +730,7 @@ static int iwl_trans_pcie_start_device(struct iwl_priv *priv)
 
 	/* clear (again), then enable host interrupts */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl_enable_interrupts(trans(priv));
 
 	/* really make sure rfkill handshake bits are cleared */
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
@@ -931,19 +931,14 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 
 static void iwl_trans_pcie_stop_device(struct iwl_priv *priv)
 {
-	unsigned long flags;
-
 	/* stop and reset the on-board processor */
 	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
 
 	/* tell the device to stop sending interrupts */
-	spin_lock_irqsave(&priv->shrd->lock, flags);
-	iwl_disable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
-	iwl_trans_sync_irq(trans(priv));
+	iwl_trans_disable_sync_irq(trans(priv));
 
 	/* device going down, Stop using ICT table */
-	iwl_disable_ict(priv);
+	iwl_disable_ict(trans(priv));
 
 	/*
 	 * If a HW restart happens during firmware loading,
@@ -1132,19 +1127,20 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_priv *priv = priv(trans);
 	int err;
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-		iwl_irq_tasklet, (unsigned long)priv);
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+
+	tasklet_init(&trans_pcie->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)trans);
 
-	iwl_alloc_isr_ict(priv);
+	iwl_alloc_isr_ict(trans);
 
 	err = request_irq(bus(trans)->irq, iwl_isr_ict, IRQF_SHARED,
-		DRV_NAME, priv);
+		DRV_NAME, trans);
 	if (err) {
-		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->bus->irq);
-		iwl_free_isr_ict(priv);
+		IWL_ERR(trans, "Error allocating IRQ %d\n", bus(trans)->irq);
+		iwl_free_isr_ict(trans);
 		return err;
 	}
 
@@ -1152,17 +1148,25 @@ static int iwl_trans_pcie_request_irq(struct iwl_trans *trans)
 	return 0;
 }
 
-static void iwl_trans_pcie_sync_irq(struct iwl_priv *priv)
+static void iwl_trans_pcie_disable_sync_irq(struct iwl_trans *trans)
 {
+	unsigned long flags;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	spin_lock_irqsave(&trans->shrd->lock, flags);
+	iwl_disable_interrupts(trans);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
 	/* wait to make sure we flush pending tasklet*/
-	synchronize_irq(priv->bus->irq);
-	tasklet_kill(&priv->irq_tasklet);
+	synchronize_irq(bus(trans)->irq);
+	tasklet_kill(&trans_pcie->irq_tasklet);
 }
 
 static void iwl_trans_pcie_free(struct iwl_priv *priv)
 {
-	free_irq(priv->bus->irq, priv);
-	iwl_free_isr_ict(priv);
+	free_irq(priv->bus->irq, trans(priv));
+	iwl_free_isr_ict(trans(priv));
 	kfree(trans(priv));
 	trans(priv) = NULL;
 }
@@ -1191,7 +1195,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 {
 	bool hw_rfkill = false;
 
-	iwl_enable_interrupts(priv(trans));
+	iwl_enable_interrupts(trans);
 
 	if (!(iwl_read32(priv(trans), CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
@@ -1500,7 +1504,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.kick_nic = iwl_trans_pcie_kick_nic,
 
-	.sync_irq = iwl_trans_pcie_sync_irq,
+	.disable_sync_irq = iwl_trans_pcie_disable_sync_irq,
 	.free = iwl_trans_pcie_free,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index c12763c..b4c7166 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -94,10 +94,9 @@ struct iwl_shared;
  *                 ready and a successful ADDBA response has been received.
  * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
  * @kick_nic: remove the RESET from the embedded CPU and let it run
- * @sync_irq: the upper layer will typically disable interrupt and call this
- *            handler. After this handler returns, it is guaranteed that all
- *            the ISR / tasklet etc... have finished running and the transport
- *            layer shall not pass any Rx.
+ * @disable_sync_irq: Disable and sync: after this handler returns, it is
+ *	guaranteed that all the ISR / tasklet etc... have finished running
+ *	and the transport layer shall not pass any Rx.
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
@@ -132,7 +131,7 @@ struct iwl_trans_ops {
 
 	void (*kick_nic)(struct iwl_priv *priv);
 
-	void (*sync_irq)(struct iwl_priv *priv);
+	void (*disable_sync_irq)(struct iwl_trans *trans);
 	void (*free)(struct iwl_priv *priv);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
@@ -232,9 +231,9 @@ static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
 	trans->ops->kick_nic(priv(trans));
 }
 
-static inline void iwl_trans_sync_irq(struct iwl_trans *trans)
+static inline void iwl_trans_disable_sync_irq(struct iwl_trans *trans)
 {
-	trans->ops->sync_irq(priv(trans));
+	trans->ops->disable_sync_irq(trans);
 }
 
 static inline void iwl_trans_free(struct iwl_trans *trans)
-- 
1.7.0.4

