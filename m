Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab1CYObj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/12] iwlwifi: remove legacy isr tasklet
Date: Fri, 25 Mar 2011 07:14:13 -0700
Message-Id: <1301062456-17249-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need for support legacy isr, remove it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |  193 +---------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 4 files changed, 3 insertions(+), 196 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index b5cb3be..47e1fa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -59,8 +59,6 @@ void iwl_free_isr_ict(struct iwl_priv *priv)
 int iwl_alloc_isr_ict(struct iwl_priv *priv)
 {
 
-	if (priv->cfg->base_params->use_isr_legacy)
-		return 0;
 	/* allocate shrared data table */
 	priv->_agn.ict_tbl_vir =
 		dma_alloc_coherent(&priv->pci_dev->dev,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 2003c1d..8163a0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -652,8 +652,7 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
 
-	if (!priv->cfg->base_params->use_isr_legacy)
-		rb_timeout = RX_RB_TIMEOUT;
+	rb_timeout = RX_RB_TIMEOUT;
 
 	if (priv->cfg->mod_params->amsdu_size_8K)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8fdd174..bd980a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -845,191 +845,6 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
-static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
-{
-	u32 inta, handled = 0;
-	u32 inta_fh;
-	unsigned long flags;
-	u32 i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 inta_mask;
-#endif
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Ack/clear/reset pending uCode interrupts.
-	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
-	 *  and will clear only when CSR_FH_INT_STATUS gets cleared. */
-	inta = iwl_read32(priv, CSR_INT);
-	iwl_write32(priv, CSR_INT, inta);
-
-	/* Ack/clear/reset pending flow-handler (DMA) interrupts.
-	 * Any new interrupts that happen after this, either while we're
-	 * in this tasklet, or later, will show up in next ISR/tasklet. */
-	inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-	iwl_write32(priv, CSR_FH_INT_STATUS, inta_fh);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
-		/* just for debug */
-		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		IWL_DEBUG_ISR(priv, "inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-			      inta, inta_mask, inta_fh);
-	}
-#endif
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Since CSR_INT and CSR_FH_INT_STATUS reads and clears are not
-	 * atomic, make sure that inta covers all the interrupts that
-	 * we've discovered, even if FH interrupt came in just after
-	 * reading CSR_INT. */
-	if (inta_fh & CSR49_FH_INT_RX_MASK)
-		inta |= CSR_INT_BIT_FH_RX;
-	if (inta_fh & CSR49_FH_INT_TX_MASK)
-		inta |= CSR_INT_BIT_FH_TX;
-
-	/* Now service all interrupt bits discovered above. */
-	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
-
-		/* Tell the device to stop sending interrupts */
-		iwl_disable_interrupts(priv);
-
-		priv->isr_stats.hw++;
-		iwl_irq_handle_error(priv);
-
-		handled |= CSR_INT_BIT_HW_ERR;
-
-		return;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
-		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD) {
-			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
-				      "the frame/frames.\n");
-			priv->isr_stats.sch++;
-		}
-
-		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE) {
-			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
-			priv->isr_stats.alive++;
-		}
-	}
-#endif
-	/* Safely ignore these bits for debug checks below */
-	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
-
-	/* HW RF KILL switch toggled */
-	if (inta & CSR_INT_BIT_RF_KILL) {
-		int hw_rf_kill = 0;
-		if (!(iwl_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-			hw_rf_kill = 1;
-
-		IWL_WARN(priv, "RF_KILL bit toggled to %s.\n",
-				hw_rf_kill ? "disable radio" : "enable radio");
-
-		priv->isr_stats.rfkill++;
-
-		/* driver only loads ucode once setting the interface up.
-		 * the driver allows loading the ucode even if the radio
-		 * is killed. Hence update the killswitch state here. The
-		 * rfkill handler will care about restarting if needed.
-		 */
-		if (!test_bit(STATUS_ALIVE, &priv->status)) {
-			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &priv->status);
-			else
-				clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
-		}
-
-		handled |= CSR_INT_BIT_RF_KILL;
-	}
-
-	/* Chip got too hot and stopped itself */
-	if (inta & CSR_INT_BIT_CT_KILL) {
-		IWL_ERR(priv, "Microcode CT kill error detected.\n");
-		priv->isr_stats.ctkill++;
-		handled |= CSR_INT_BIT_CT_KILL;
-	}
-
-	/* Error detected by uCode */
-	if (inta & CSR_INT_BIT_SW_ERR) {
-		IWL_ERR(priv, "Microcode SW error detected. "
-			" Restarting 0x%X.\n", inta);
-		priv->isr_stats.sw++;
-		iwl_irq_handle_error(priv);
-		handled |= CSR_INT_BIT_SW_ERR;
-	}
-
-	/*
-	 * uCode wakes up after power-down sleep.
-	 * Tell device about any new tx or host commands enqueued,
-	 * and about any Rx buffers made available while asleep.
-	 */
-	if (inta & CSR_INT_BIT_WAKEUP) {
-		IWL_DEBUG_ISR(priv, "Wakeup interrupt\n");
-		iwl_rx_queue_update_write_ptr(priv, &priv->rxq);
-		for (i = 0; i < priv->hw_params.max_txq_num; i++)
-			iwl_txq_update_write_ptr(priv, &priv->txq[i]);
-		priv->isr_stats.wakeup++;
-		handled |= CSR_INT_BIT_WAKEUP;
-	}
-
-	/* All uCode command responses, including Tx command responses,
-	 * Rx "responses" (frame-received notification), and other
-	 * notifications from uCode come through here*/
-	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
-		iwl_rx_handle(priv);
-		priv->isr_stats.rx++;
-		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
-	}
-
-	/* This "Tx" DMA channel is used only for loading uCode */
-	if (inta & CSR_INT_BIT_FH_TX) {
-		IWL_DEBUG_ISR(priv, "uCode load interrupt\n");
-		priv->isr_stats.tx++;
-		handled |= CSR_INT_BIT_FH_TX;
-		/* Wake up uCode load routine, now that load is complete */
-		priv->ucode_write_complete = 1;
-		wake_up_interruptible(&priv->wait_command_queue);
-	}
-
-	if (inta & ~handled) {
-		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
-		priv->isr_stats.unhandled++;
-	}
-
-	if (inta & ~(priv->inta_mask)) {
-		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
-			 inta & ~priv->inta_mask);
-		IWL_WARN(priv, "   with FH_INT = 0x%08x\n", inta_fh);
-	}
-
-	/* Re-enable all interrupts */
-	/* only Re-enable if disabled by irq */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status))
-		iwl_enable_interrupts(priv);
-	/* Re-enable RF_KILL if it occurred */
-	else if (handled & CSR_INT_BIT_RF_KILL)
-		iwl_enable_rfkill_int(priv);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
-		inta = iwl_read32(priv, CSR_INT);
-		inta_mask = iwl_read32(priv, CSR_INT_MASK);
-		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR(priv, "End inta 0x%08x, enabled 0x%08x, fh 0x%08x, "
-			"flags 0x%08lx\n", inta, inta_mask, inta_fh, flags);
-	}
-#endif
-}
-
 /* tasklet for iwlagn interrupt */
 static void iwl_irq_tasklet(struct iwl_priv *priv)
 {
@@ -3751,12 +3566,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->watchdog.data = (unsigned long)priv;
 	priv->watchdog.function = iwl_bg_watchdog;
 
-	if (!priv->cfg->base_params->use_isr_legacy)
-		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-			iwl_irq_tasklet, (unsigned long)priv);
-	else
-		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
-			iwl_irq_tasklet_legacy, (unsigned long)priv);
+	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+		iwl_irq_tasklet, (unsigned long)priv);
 }
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3e680af..3a4e9b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -291,7 +291,6 @@ struct iwl_base_params {
 	bool set_l0s;
 	bool use_bsm;
 
-	bool use_isr_legacy;
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
 	u16 led_compensation;
-- 
1.7.0.4

