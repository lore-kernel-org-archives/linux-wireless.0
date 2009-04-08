Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59798 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbZDHSdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: adding interrupt counter in debugfs for debugging
Date: Wed,  8 Apr 2009 11:39:32 -0700
Message-Id: <1239215972-1795-7-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203407_225811_5F1D1B56)
In-Reply-To: <1239215972-1795-6-git-send-email-reinette.chatre@intel.com>
References: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-2-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-3-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-4-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-5-git-send-email-reinette.chatre@intel.com>
 <1239215972-1795-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This patch adds interrupt statistics report to debugfs, this can help to
understand number of interrupts happened which including HW/SW error for
easier and better debugging.

in /sys/kernel/debug/ieee80211/phyN/iwlagn/data directory
use "cat interrupt" to view the current interrupt counter
use "echo 0 > interrupt" to clear interrupt counter

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   26 +++++++-
 drivers/net/wireless/iwlwifi/iwl-core.c    |    6 ++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   92 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   18 ++++++
 6 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 248b3db..65372e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -911,6 +911,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
 				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
+			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
 		} else {
 			/* No handling needed */
 			IWL_DEBUG_RX(priv,
@@ -1035,6 +1036,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
 
+		priv->isr_stats.hw++;
 		iwl_irq_handle_error(priv);
 
 		handled |= CSR_INT_BIT_HW_ERR;
@@ -1047,13 +1049,17 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (priv->debug_level & (IWL_DL_ISR)) {
 		/* NIC fires this, but we don't use it, redundant with WAKEUP */
-		if (inta & CSR_INT_BIT_SCD)
+		if (inta & CSR_INT_BIT_SCD) {
 			IWL_DEBUG_ISR(priv, "Scheduler finished to transmit "
 				      "the frame/frames.\n");
+			priv->isr_stats.sch++;
+		}
 
 		/* Alive notification via Rx interrupt will do the real work */
-		if (inta & CSR_INT_BIT_ALIVE)
+		if (inta & CSR_INT_BIT_ALIVE) {
 			IWL_DEBUG_ISR(priv, "Alive interrupt\n");
+			priv->isr_stats.alive++;
+		}
 	}
 #endif
 	/* Safely ignore these bits for debug checks below */
@@ -1069,6 +1075,8 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		IWL_DEBUG_RF_KILL(priv, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio" : "enable radio");
 
+		priv->isr_stats.rfkill++;
+
 		/* driver only loads ucode once setting the interface up.
 		 * the driver allows loading the ucode even if the radio
 		 * is killed. Hence update the killswitch state here. The
@@ -1088,6 +1096,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* Chip got too hot and stopped itself */
 	if (inta & CSR_INT_BIT_CT_KILL) {
 		IWL_ERR(priv, "Microcode CT kill error detected.\n");
+		priv->isr_stats.ctkill++;
 		handled |= CSR_INT_BIT_CT_KILL;
 	}
 
@@ -1095,6 +1104,8 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_SW_ERR) {
 		IWL_ERR(priv, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
+		priv->isr_stats.sw++;
+		priv->isr_stats.sw_err = inta;
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -1110,6 +1121,8 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		iwl_txq_update_write_ptr(priv, &priv->txq[4]);
 		iwl_txq_update_write_ptr(priv, &priv->txq[5]);
 
+		priv->isr_stats.wakeup++;
+
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
 
@@ -1118,19 +1131,23 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	 * notifications from uCode come through here*/
 	if (inta & (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX)) {
 		iwl_rx_handle(priv);
+		priv->isr_stats.rx++;
 		handled |= (CSR_INT_BIT_FH_RX | CSR_INT_BIT_SW_RX);
 	}
 
 	if (inta & CSR_INT_BIT_FH_TX) {
 		IWL_DEBUG_ISR(priv, "Tx interrupt\n");
+		priv->isr_stats.tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* FH finished to write, send event */
 		priv->ucode_write_complete = 1;
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
 
-	if (inta & ~handled)
+	if (inta & ~handled) {
 		IWL_ERR(priv, "Unhandled INTA bits 0x%08x\n", inta & ~handled);
+		priv->isr_stats.unhandled++;
+	}
 
 	if (inta & ~CSR_INI_SET_MASK) {
 		IWL_WARN(priv, "Disabled INTA bits 0x%08x were pending\n",
@@ -1155,6 +1172,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+
 /******************************************************************************
  *
  * uCode download functions
@@ -1983,6 +2001,8 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 
 out:
 	priv->is_open = 1;
+	/* default to MONITOR mode */
+	priv->iw_mode = NL80211_IFTYPE_MONITOR;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9fac8f7..44327da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2118,6 +2118,12 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_reply_error);
 
+void iwl_clear_isr_stats(struct iwl_priv *priv)
+{
+	memset(&priv->isr_stats, 0, sizeof(priv->isr_stats));
+}
+EXPORT_SYMBOL(iwl_clear_isr_stats);
+
 int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index df90c26..8773d73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -480,6 +480,7 @@ int iwl_pci_resume(struct pci_dev *pdev);
 ******************************************************/
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv);
+void iwl_clear_isr_stats(struct iwl_priv *priv);
 
 /*****************************************************
 *  GEOS
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 65d1a7f..db06980 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -75,6 +75,7 @@ struct iwl_debugfs {
 		struct dentry *file_log_event;
 		struct dentry *file_channels;
 		struct dentry *file_status;
+		struct dentry *file_interrupt;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5b8c839..ffc4be3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -473,6 +473,95 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	int cnt = 0;
+	char *buf;
+	int bufsz = 24 * 64; /* 24 items * 64 char per item */
+	ssize_t ret;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Interrupt Statistics Report:\n");
+
+	pos += scnprintf(buf + pos, bufsz - pos, "HW Error:\t\t\t %u\n",
+		priv->isr_stats.hw);
+	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
+		priv->isr_stats.sw);
+	if (priv->isr_stats.sw > 0) {
+		pos += scnprintf(buf + pos, bufsz - pos,
+			"\tLast Restarting Code:  0x%X\n",
+			priv->isr_stats.sw_err);
+	}
+#ifdef CONFIG_IWLWIFI_DEBUG
+	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
+		priv->isr_stats.sch);
+	pos += scnprintf(buf + pos, bufsz - pos, "Alive interrupt:\t\t %u\n",
+		priv->isr_stats.alive);
+#endif
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"HW RF KILL switch toggled:\t %u\n",
+		priv->isr_stats.rfkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "CT KILL:\t\t\t %u\n",
+		priv->isr_stats.ctkill);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Wakeup Interrupt:\t\t %u\n",
+		priv->isr_stats.wakeup);
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+		"Rx command responses:\t\t %u\n",
+		priv->isr_stats.rx);
+	for (cnt = 0; cnt < REPLY_MAX; cnt++) {
+		if (priv->isr_stats.rx_handlers[cnt] > 0)
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"\tRx handler[%36s]:\t\t %u\n",
+				get_cmd_string(cnt),
+				priv->isr_stats.rx_handlers[cnt]);
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Tx/FH interrupt:\t\t %u\n",
+		priv->isr_stats.tx);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "Unexpected INTA:\t\t %u\n",
+		priv->isr_stats.unhandled);
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
+	struct iwl_priv *priv = file->private_data;
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
+		iwl_clear_isr_stats(priv);
+
+	return count;
+}
+
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(eeprom);
@@ -481,6 +570,7 @@ DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_FILE_OPS(channels);
 DEBUGFS_READ_FILE_OPS(status);
+DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 
 /*
  * Create the debugfs files and directories
@@ -516,6 +606,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(tx_statistics, data);
 	DEBUGFS_ADD_FILE(channels, data);
 	DEBUGFS_ADD_FILE(status, data);
+	DEBUGFS_ADD_FILE(interrupt, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -546,6 +637,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_channels);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_status);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_interrupt);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 59930f3..0922e33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -819,6 +819,21 @@ enum {
 	MEASUREMENT_ACTIVE = (1 << 1),
 };
 
+/* interrupt statistics */
+struct isr_statistics {
+	u32 hw;
+	u32 sw;
+	u32 sw_err;
+	u32 sch;
+	u32 alive;
+	u32 rfkill;
+	u32 ctkill;
+	u32 wakeup;
+	u32 rx;
+	u32 rx_handlers[REPLY_MAX];
+	u32 tx;
+	u32 unhandled;
+};
 
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
 
@@ -975,6 +990,9 @@ struct iwl_priv {
 		u64 bytes;
 	} tx_stats[3], rx_stats[3];
 
+	/* counts interrupts */
+	struct isr_statistics isr_stats;
+
 	struct iwl_power_mgr power_data;
 
 	struct iwl_notif_statistics statistics;
-- 
1.5.6.3

