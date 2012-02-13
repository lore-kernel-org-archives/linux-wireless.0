Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548Ab2BMKY1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:27 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 17/24] iwlegacy: do not grab nic access if rfkill
Date: Mon, 13 Feb 2012 11:23:24 +0100
Message-Id: <1329128611-6815-18-git-send-email-sgruszka@redhat.com> (sfid-20120213_112435_669438_209C3BC6)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rfkill is on il_grab_nic_access() fail and we can not write to the
various registers during stop procedure. Write to those registers
unconditionally instead.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   17 +++++--
 drivers/net/wireless/iwlegacy/3945.c     |   29 ++++++-----
 drivers/net/wireless/iwlegacy/4965-mac.c |   81 ++++++++++++++++++------------
 drivers/net/wireless/iwlegacy/common.c   |   25 +++++++--
 drivers/net/wireless/iwlegacy/common.h   |    4 +-
 5 files changed, 98 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 002cf4f..ee91ab2 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2286,16 +2286,25 @@ __il3945_down(struct il_priv *il)
 	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 
+	/*
+	 * We disabled and synchronized interrupt, and priv->mutex is taken, so
+	 * here is the only thread which will program device registers, but
+	 * still have lockdep assertions, so we are taking reg_lock.
+	 */
+	spin_lock_irq(&il->reg_lock);
+	/* FIXME: il_grab_nic_access if rfkill is off ? */
+
 	il3945_hw_txq_ctx_stop(il);
 	il3945_hw_rxq_stop(il);
-
 	/* Power-down device's busmaster DMA clocks */
-	il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	_il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
-
 	/* Stop the device, and put it in low power state */
-	il_apm_stop(il);
+	_il_apm_stop(il);
 
+	spin_unlock_irq(&il->reg_lock);
+
+	il3945_hw_txq_ctx_free(il);
 exit:
 	memset(&il->card_alive, 0, sizeof(struct il_alive_resp));
 
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 95ebd43..103251d 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1016,18 +1016,17 @@ il3945_hw_txq_ctx_stop(struct il_priv *il)
 	int txq_id;
 
 	/* stop SCD */
-	il_wr_prph(il, ALM_SCD_MODE_REG, 0);
-	il_wr_prph(il, ALM_SCD_TXFACT_REG, 0);
+	_il_wr_prph(il, ALM_SCD_MODE_REG, 0);
+	_il_wr_prph(il, ALM_SCD_TXFACT_REG, 0);
 
 	/* reset TFD queues */
 	for (txq_id = 0; txq_id < il->hw_params.max_txq_num; txq_id++) {
-		il_wr(il, FH39_TCSR_CONFIG(txq_id), 0x0);
-		il_poll_bit(il, FH39_TSSR_TX_STATUS,
-			    FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
-			    1000);
+		_il_wr(il, FH39_TCSR_CONFIG(txq_id), 0x0);
+		_il_poll_bit(il, FH39_TSSR_TX_STATUS,
+			     FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
+			     FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
+			     1000);
 	}
-
-	il3945_hw_txq_ctx_free(il);
 }
 
 /**
@@ -2176,12 +2175,14 @@ il3945_txpower_set_from_eeprom(struct il_priv *il)
 int
 il3945_hw_rxq_stop(struct il_priv *il)
 {
-	int rc;
+	int ret;
 
-	il_wr(il, FH39_RCSR_CONFIG(0), 0);
-	rc = il_poll_bit(il, FH39_RSSR_STATUS,
-			 FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
-	if (rc < 0)
+	_il_wr(il, FH39_RCSR_CONFIG(0), 0);
+	ret = _il_poll_bit(il, FH39_RSSR_STATUS,
+			   FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+			   FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+			   1000);
+	if (ret < 0)
 		IL_ERR("Can't stop Rx DMA.\n");
 
 	return 0;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 8930e7a..5ebf761 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -441,11 +441,15 @@ il4965_rx_queue_free(struct il_priv *il, struct il_rx_queue *rxq)
 int
 il4965_rxq_stop(struct il_priv *il)
 {
+	int ret;
 
-	/* stop Rx DMA */
-	il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-	il_poll_bit(il, FH49_MEM_RSSR_RX_STATUS_REG,
-		    FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+	_il_wr(il, FH49_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+	ret = _il_poll_bit(il, FH49_MEM_RSSR_RX_STATUS_REG,
+			   FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+			   FH49_RSSR_CHNL0_RX_STATUS_CHNL_IDLE,
+			   1000);
+	if (ret < 0)
+		IL_ERR("Can't stop Rx DMA.\n");
 
 	return 0;
 }
@@ -2031,31 +2035,10 @@ il4965_txq_ctx_reset(struct il_priv *il)
 	}
 }
 
-/**
- * il4965_txq_ctx_stop - Stop all Tx DMA channels
- */
 void
-il4965_txq_ctx_stop(struct il_priv *il)
+il4965_txq_ctx_unmap(struct il_priv *il)
 {
-	int ch, txq_id;
-	unsigned long flags;
-
-	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&il->lock, flags);
-
-	il4965_txq_set_sched(il, 0);
-
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < il->hw_params.dma_chnl_num; ch++) {
-		il_wr(il, FH49_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (il_poll_bit
-		    (il, FH49_TSSR_TX_STATUS_REG,
-		     FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch), 1000))
-			IL_ERR("Failing on timeout while stopping"
-			       " DMA channel %d [0x%08x]", ch,
-			       il_rd(il, FH49_TSSR_TX_STATUS_REG));
-	}
-	spin_unlock_irqrestore(&il->lock, flags);
+	int txq_id;
 
 	if (!il->txq)
 		return;
@@ -2068,6 +2051,30 @@ il4965_txq_ctx_stop(struct il_priv *il)
 			il_tx_queue_unmap(il, txq_id);
 }
 
+/**
+ * il4965_txq_ctx_stop - Stop all Tx DMA channels
+ */
+void
+il4965_txq_ctx_stop(struct il_priv *il)
+{
+	int ch, ret;
+
+	_il_wr_prph(il, IL49_SCD_TXFACT, 0);
+
+	/* Stop each Tx DMA channel, and wait for it to be idle */
+	for (ch = 0; ch < il->hw_params.dma_chnl_num; ch++) {
+		_il_wr(il, FH49_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		ret =
+		    _il_poll_bit(il, FH49_TSSR_TX_STATUS_REG,
+				 FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				 FH49_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				 1000);
+		if (ret < 0)
+			IL_ERR("Timeout stopping DMA channel %d [0x%08x]",
+			       ch, _il_rd(il, FH49_TSSR_TX_STATUS_REG));
+	}
+}
+
 /*
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
@@ -5398,19 +5405,27 @@ __il4965_down(struct il_priv *il)
 	    test_bit(S_FW_ERROR, &il->status) << S_FW_ERROR |
 	    test_bit(S_EXIT_PENDING, &il->status) << S_EXIT_PENDING;
 
+	/*
+	 * We disabled and synchronized interrupt, and priv->mutex is taken, so
+	 * here is the only thread which will program device registers, but
+	 * still have lockdep assertions, so we are taking reg_lock.
+	 */
+	spin_lock_irq(&il->reg_lock);
+	/* FIXME: il_grab_nic_access if rfkill is off ? */
+
 	il4965_txq_ctx_stop(il);
 	il4965_rxq_stop(il);
-
 	/* Power-down device's busmaster DMA clocks */
-	il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
+	_il_wr_prph(il, APMG_CLK_DIS_REG, APMG_CLK_VAL_DMA_CLK_RQT);
 	udelay(5);
-
 	/* Make sure (redundant) we've released our request to stay awake */
-	il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
+	_il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	/* Stop the device, and put it in low power state */
-	il_apm_stop(il);
+	_il_apm_stop(il);
+
+	spin_unlock_irq(&il->reg_lock);
 
+	il4965_txq_ctx_unmap(il);
 exit:
 	memset(&il->card_alive, 0, sizeof(struct il_alive_resp));
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 0d1a643..f343f27 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4126,12 +4126,12 @@ il_irq_handle_error(struct il_priv *il)
 EXPORT_SYMBOL(il_irq_handle_error);
 
 static int
-il_apm_stop_master(struct il_priv *il)
+_il_apm_stop_master(struct il_priv *il)
 {
 	int ret = 0;
 
 	/* stop device's busmaster DMA activity */
-	il_set_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
+	_il_set_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
 	ret =
 	    _il_poll_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
@@ -4145,15 +4145,17 @@ il_apm_stop_master(struct il_priv *il)
 }
 
 void
-il_apm_stop(struct il_priv *il)
+_il_apm_stop(struct il_priv *il)
 {
+	lockdep_assert_held(&il->reg_lock);
+
 	D_INFO("Stop card, put in low power state\n");
 
 	/* Stop device's DMA activity */
-	il_apm_stop_master(il);
+	_il_apm_stop_master(il);
 
 	/* Reset the entire device */
-	il_set_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	_il_set_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
 
 	udelay(10);
 
@@ -4161,7 +4163,18 @@ il_apm_stop(struct il_priv *il)
 	 * Clear "initialization complete" bit to move adapter from
 	 * D0A* (powered-up Active) --> D0U* (Uninitialized) state.
 	 */
-	il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+	_il_clear_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
+}
+EXPORT_SYMBOL(_il_apm_stop);
+
+void
+il_apm_stop(struct il_priv *il)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&il->reg_lock, flags);
+	_il_apm_stop(il);
+	spin_unlock_irqrestore(&il->reg_lock, flags);
 }
 EXPORT_SYMBOL(il_apm_stop);
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index a779445..13bfd43 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1976,7 +1976,9 @@ il_is_ready_rf(struct il_priv *il)
 
 extern void il_send_bt_config(struct il_priv *il);
 extern int il_send_stats_request(struct il_priv *il, u8 flags, bool clear);
-void il_apm_stop(struct il_priv *il);
+extern void il_apm_stop(struct il_priv *il);
+extern void _il_apm_stop(struct il_priv *il);
+
 int il_apm_init(struct il_priv *il);
 
 int il_send_rxon_timing(struct il_priv *il);
-- 
1.7.1

