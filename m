Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab1HMSSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/60] iwlagn: move isr_statistics to transport layer
Date: Sat, 13 Aug 2011 10:38:03 -0700
Message-Id: <1313257116-2697-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201901_971544_F001AAE4)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is accessed by the transport layer only, hence the move.
The debugfs handlers that accessed it moved to the transport layer too.
The rx_handlers part of it stayed in the upper layer and a special debugfs
has been added for it

Also add missing includes to iwl-commands.h.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |    5 -
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   54 +++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h            |   23 +-----
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   19 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |   27 ++++---
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   88 +++++++++++++++++++++
 9 files changed, 140 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 4e92d56..b478206 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -69,6 +69,9 @@
 #ifndef __iwl_commands_h__
 #define __iwl_commands_h__
 
+#include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
+
 struct iwl_priv;
 
 /* uCode version contains 4 values: Major/Minor/API/Serial */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88fc396..347cbec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1121,11 +1121,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-void iwl_clear_isr_stats(struct iwl_priv *priv)
-{
-	memset(&priv->isr_stats, 0, sizeof(priv->isr_stats));
-}
-
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2a24fb6..323756c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -385,8 +385,6 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-void iwl_clear_isr_stats(struct iwl_priv *priv);
-
 /*****************************************************
 *  GEOS
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fa070de..787dae5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -556,11 +556,12 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
+static ssize_t iwl_dbgfs_rx_handlers_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = file->private_data;
+
 	int pos = 0;
 	int cnt = 0;
 	char *buf;
@@ -573,61 +574,25 @@ static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 		return -ENOMEM;
 	}
 
-	pos += scnprintf(buf + pos, bufsz - pos,
-			"Interrupt Statistics Report:\n");
-
-	pos += scnprintf(buf + pos, bufsz - pos, "HW Error:\t\t\t %u\n",
-		priv->isr_stats.hw);
-	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
-		priv->isr_stats.sw);
-	if (priv->isr_stats.sw || priv->isr_stats.hw) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"\tLast Restarting Code:  0x%X\n",
-			priv->isr_stats.err_code);
-	}
-#ifdef CONFIG_IWLWIFI_DEBUG
-	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
-		priv->isr_stats.sch);
-	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
-		priv->isr_stats.alive);
-#endif
-	pos += scnprintf(buf + pos, bufsz - pos,
-		"HW RF KILL switch toggled:\t %u\n",
-		priv->isr_stats.rfkill);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "CT KILL:\t\t\t %u\n",
-		priv->isr_stats.ctkill);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Wakeup Interrupt:\t\t %u\n",
-		priv->isr_stats.wakeup);
-
-	pos += scnprintf(buf + pos, bufsz - pos,
-		"Rx command responses:\t\t %u\n",
-		priv->isr_stats.rx);
 	for (cnt = 0; cnt < REPLY_MAX; cnt++) {
-		if (priv->isr_stats.rx_handlers[cnt] > 0)
+		if (priv->rx_handlers_stats[cnt] > 0)
 			pos += scnprintf(buf + pos, bufsz - pos,
 				"\tRx handler[%36s]:\t\t %u\n",
 				get_cmd_string(cnt),
-				priv->isr_stats.rx_handlers[cnt]);
+				priv->rx_handlers_stats[cnt]);
 	}
 
-	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
-		priv->isr_stats.tx);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Unexpected INTA:\t\t %u\n",
-		priv->isr_stats.unhandled);
-
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
+static ssize_t iwl_dbgfs_rx_handlers_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
+
 	char buf[8];
 	int buf_size;
 	u32 reset_flag;
@@ -639,7 +604,8 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 	if (sscanf(buf, "%x", &reset_flag) != 1)
 		return -EFAULT;
 	if (reset_flag == 0)
-		iwl_clear_isr_stats(priv);
+		memset(&priv->rx_handlers_stats[0], 0,
+			sizeof(priv->rx_handlers_stats));
 
 	return count;
 }
@@ -834,7 +800,7 @@ DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
-DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
+DEBUGFS_READ_WRITE_FILE_OPS(rx_handlers);
 DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_FILE_OPS(thermal_throttling);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
@@ -2471,7 +2437,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_handlers, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c06d93b..9c7bbf8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -809,22 +809,6 @@ enum iwl_pa_type {
 	IWL_PA_INTERNAL = 1,
 };
 
-/* interrupt statistics */
-struct isr_statistics {
-	u32 hw;
-	u32 sw;
-	u32 err_code;
-	u32 sch;
-	u32 alive;
-	u32 rfkill;
-	u32 ctkill;
-	u32 wakeup;
-	u32 rx;
-	u32 rx_handlers[REPLY_MAX];
-	u32 tx;
-	u32 unhandled;
-};
-
 /* reply_tx_statistics (for _agn devices) */
 struct reply_tx_error_statistics {
 	u32 pp_delay;
@@ -1157,6 +1141,9 @@ struct iwl_priv {
 	/* jiffies when last recovery from statistics was performed */
 	unsigned long rx_statistics_jiffies;
 
+	/*counters */
+	u32 rx_handlers_stats[REPLY_MAX];
+
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
 
@@ -1260,10 +1247,6 @@ struct iwl_priv {
 	struct traffic_stats tx_stats;
 	struct traffic_stats rx_stats;
 
-	/* counts interrupts */
-	/* TODO: move to the transport layer */
-	struct isr_statistics isr_stats;
-
 	struct iwl_power_mgr power_data;
 	struct iwl_tt_mgmt thermal_throttle;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index a5e4dda..d7c7c93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1020,7 +1020,7 @@ void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	 *   handle those that need handling via function in
 	 *   rx_handlers table.  See iwl_setup_rx_handlers() */
 	if (priv->rx_handlers[pkt->hdr.cmd]) {
-		priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
+		priv->rx_handlers_stats[pkt->hdr.cmd]++;
 		priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 	} else {
 		/* No handling needed */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 4694c46..f60b26f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -33,6 +33,24 @@
  * trans_pcie layer */
 
 /**
+ * struct isr_statistics - interrupt statistics
+ *
+ */
+struct isr_statistics {
+	u32 hw;
+	u32 sw;
+	u32 err_code;
+	u32 sch;
+	u32 alive;
+	u32 rfkill;
+	u32 ctkill;
+	u32 wakeup;
+	u32 rx;
+	u32 tx;
+	u32 unhandled;
+};
+
+/**
  * struct iwl_rx_queue - Rx queue
  * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
  * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
@@ -88,6 +106,7 @@ struct iwl_trans_pcie {
 	u32 inta;
 	bool use_ict;
 	struct tasklet_struct irq_tasklet;
+	struct isr_statistics isr_stats;
 
 	u32 inta_mask;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index aa7ced4..b1635ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -569,6 +569,9 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 {
 	u32 base;
 	struct iwl_error_event_table table;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	base = priv->device_pointers.error_event_table;
 	if (priv->ucode_type == IWL_UCODE_INIT) {
@@ -596,7 +599,7 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			priv->shrd->status, table.valid);
 	}
 
-	priv->isr_stats.err_code = table.error_id;
+	trans_pcie->isr_stats.err_code = table.error_id;
 
 	trace_iwlwifi_dev_ucode_error(priv, table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.line,
@@ -905,6 +908,8 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
 
 	spin_lock_irqsave(&trans->shrd->lock, flags);
 
@@ -945,7 +950,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(trans);
 
-		priv(trans)->isr_stats.hw++;
+		isr_stats->hw++;
 		iwl_irq_handle_error(priv(trans));
 
 		handled |= CSR_INT_BIT_HW_ERR;
@@ -959,13 +964,13 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(trans, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
-			priv(trans)->isr_stats.sch++;
+			isr_stats->sch++;
 		}
 
 		/* Alive notification via Rx interrupt will do the real work */
 		if (inta & CSR_INT_BIT_ALIVE) {
 			IWL_DEBUG_ISR(trans, "Alive interrupt\n");
-			priv(trans)->isr_stats.alive++;
+			isr_stats->alive++;
 		}
 	}
 #endif
@@ -982,7 +987,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		IWL_WARN(trans, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
-		priv(trans)->isr_stats.rfkill++;
+		isr_stats->rfkill++;
 
 		/* driver only loads ucode once setting the interface up.
 		 * the driver allows loading the ucode even if the radio
@@ -1006,7 +1011,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
 		IWL_ERR(trans, "Microcode CT kill error detected.\n");
-		priv(trans)->isr_stats.ctkill++;
+		isr_stats->ctkill++;
 		handled |= CSR_INT_BIT_CT_KILL;
 	}
 
@@ -1014,7 +1019,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERR(trans, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
-		priv(trans)->isr_stats.sw++;
+		isr_stats->sw++;
 		iwl_irq_handle_error(priv(trans));
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -1027,7 +1032,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 			iwl_txq_update_write_ptr(priv(trans),
 						 &priv(trans)->txq[i]);
 
-		priv(trans)->isr_stats.wakeup++;
+		isr_stats->wakeup++;
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
@@ -1075,14 +1080,14 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 			iwl_write8(priv(trans), CSR_INT_PERIODIC_REG,
 				    CSR_INT_PERIODIC_ENA);
 
-		priv(trans)->isr_stats.rx++;
+		isr_stats->rx++;
 	}
 
 	/* This "Tx" DMA channel is used only for loading uCode */
 	if (inta & CSR_INT_BIT_FH_TX) {
 		iwl_write32(priv(trans), CSR_FH_INT_STATUS, CSR_FH_INT_TX_MASK);
 		IWL_DEBUG_ISR(trans, "uCode load interrupt\n");
-		priv(trans)->isr_stats.tx++;
+		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv(trans)->ucode_write_complete = 1;
@@ -1091,7 +1096,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 
 	if (inta & ~handled) {
 		IWL_ERR(trans, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
-		priv(trans)->isr_stats.unhandled++;
+		isr_stats->unhandled++;
 	}
 
 	if (inta & ~(trans_pcie->inta_mask)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 5926cac..63a3101 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1496,8 +1496,95 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
+	int pos = 0;
+	char *buf;
+	int bufsz = 24 * 64; /* 24 items * 64 char per item */
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(trans, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Interrupt Statistics Report:\n");
+
+	pos += scnprintf(buf + pos, bufsz - pos, "HW Error:\t\t\t %u\n",
+		isr_stats->hw);
+	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
+		isr_stats->sw);
+	if (isr_stats->sw || isr_stats->hw) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"\tLast Restarting Code:  0x%X\n",
+			isr_stats->err_code);
+	}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
+		isr_stats->sch);
+	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
+		isr_stats->alive);
+#endif
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"HW RF KILL switch toggled:\t %u\n", isr_stats->rfkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "CT KILL:\t\t\t %u\n",
+		isr_stats->ctkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Wakeup Interrupt:\t\t %u\n",
+		isr_stats->wakeup);
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"Rx command responses:\t\t %u\n", isr_stats->rx);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
+		isr_stats->tx);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Unexpected INTA:\t\t %u\n",
+		isr_stats->unhandled);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
+
+	char buf[8];
+	int buf_size;
+	u32 reset_flag;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x", &reset_flag) != 1)
+		return -EFAULT;
+	if (reset_flag == 0)
+		memset(isr_stats, 0, sizeof(*isr_stats));
+
+	return count;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
 
@@ -1512,6 +1599,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	return 0;
 }
 #else
-- 
1.7.0.4

