Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab0AOVnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:52 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/9] iwlwifi: display flowhandler register when sw error or on-demand
Date: Fri, 15 Jan 2010 13:43:39 -0800
Message-Id: <1263591821-14867-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Flowhandler handle the communication between driver and uCode, when any
uCode error happen, we also like to know what is the status of the
flowhandler; it can help to debug flowhandler related problem.

Also adding debugfs file to dump current value of flowhandler registers.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c    |   65 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   24 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-fh.h      |   19 ++++++++
 8 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 0db1fda..506429f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -106,6 +106,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
+	.dump_fh = iwl_dump_fh,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c3f8ec0..14ef211 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1467,6 +1467,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
+	.dump_fh = iwl_dump_fh,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a5a0ed4..c5f244f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -216,6 +216,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
+	.dump_fh = iwl_dump_fh,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2323073..21bbd00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1353,6 +1353,8 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
 	if (priv->cfg->ops->lib->dump_csr)
 		priv->cfg->ops->lib->dump_csr(priv);
+	if (priv->cfg->ops->lib->dump_fh)
+		priv->cfg->ops->lib->dump_fh(priv, NULL, false);
 	priv->cfg->ops->lib->dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
@@ -3273,6 +3275,69 @@ void iwl_dump_csr(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_dump_csr);
 
+const static char *get_fh_string(int cmd)
+{
+	switch (cmd) {
+		IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
+		IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
+		IWL_CMD(FH_RSCSR_CHNL0_WPTR);
+		IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
+		IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
+		IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
+		IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
+		IWL_CMD(FH_TSSR_TX_STATUS_REG);
+		IWL_CMD(FH_TSSR_TX_ERROR_REG);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
+int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display)
+{
+	int i;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	int pos = 0;
+	size_t bufsz = 0;
+#endif
+	u32 fh_tbl[] = {
+		FH_RSCSR_CHNL0_STTS_WPTR_REG,
+		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+		FH_RSCSR_CHNL0_WPTR,
+		FH_MEM_RCSR_CHNL0_CONFIG_REG,
+		FH_MEM_RSSR_SHARED_CTRL_REG,
+		FH_MEM_RSSR_RX_STATUS_REG,
+		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
+		FH_TSSR_TX_STATUS_REG,
+		FH_TSSR_TX_ERROR_REG
+	};
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (display) {
+		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+		pos += scnprintf(*buf + pos, bufsz - pos,
+				"FH register values:\n");
+		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
+			pos += scnprintf(*buf + pos, bufsz - pos,
+				"  %34s: 0X%08x\n",
+				get_fh_string(fh_tbl[i]),
+				iwl_read_direct32(priv, fh_tbl[i]));
+		}
+		return pos;
+	}
+#endif
+	IWL_ERR(priv, "FH register values:\n");
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+		IWL_ERR(priv, "  %34s: 0X%08x\n",
+			get_fh_string(fh_tbl[i]),
+			iwl_read_direct32(priv, fh_tbl[i]));
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iwl_dump_fh);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8deb83b..666b0e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -171,6 +171,7 @@ struct iwl_lib_ops {
 				  bool full_log, char **buf, bool display);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
 	void (*dump_csr)(struct iwl_priv *priv);
+	int (*dump_fh)(struct iwl_priv *priv, char **buf, bool display);
 	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
 	/* power management */
 	struct iwl_apm_ops apm_ops;
@@ -582,6 +583,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv,
 			   bool full_log, char **buf, bool display);
 void iwl_dump_csr(struct iwl_priv *priv);
+int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv);
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 58e0462..1d1e655 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -111,6 +111,7 @@ struct iwl_debugfs {
 		struct dentry *file_clear_traffic_statistics;
 		struct dentry *file_csr;
 		struct dentry *file_ucode_tracing;
+		struct dentry *file_fh_reg;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a7ca06d..a3d461f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2151,6 +2151,27 @@ static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -EFAULT;
+
+	if (priv->cfg->ops->lib->dump_fh) {
+		ret = pos = priv->cfg->ops->lib->dump_fh(priv, &buf, true);
+		if (buf) {
+			ret = simple_read_from_buffer(user_buf,
+						      count, ppos, buf, pos);
+			kfree(buf);
+		}
+	}
+
+	return ret;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2167,6 +2188,7 @@ DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
+DEBUGFS_READ_FILE_OPS(fh_reg);
 
 /*
  * Create the debugfs files and directories
@@ -2218,6 +2240,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(csr, debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(fh_reg, debug, S_IRUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
@@ -2277,6 +2300,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_clear_traffic_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_csr);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_fh_reg);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 65fa8a6..1342cf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -379,6 +379,25 @@
 
 #define FH_TSSR_TX_STATUS_REG		(FH_TSSR_LOWER_BOUND + 0x010)
 
+/**
+ * Bit fields for TSSR(Tx Shared Status & Control) error status register:
+ * 31:  Indicates an address error when accessed to internal memory
+ *	uCode/driver must write "1" in order to clear this flag
+ * 30:  Indicates that Host did not send the expected number of dwords to FH
+ *	uCode/driver must write "1" in order to clear this flag
+ * 16-9:Each status bit is for one channel. Indicates that an (Error) ActDMA
+ *	command was received from the scheduler while the TRB was already full
+ *	with previous command
+ *	uCode/driver must write "1" in order to clear this flag
+ * 7-0: Each status bit indicates a channel's TxCredit error. When an error
+ *	bit is set, it indicates that the FH has received a full indication
+ *	from the RTC TxFIFO and the current value of the TxCredit counter was
+ *	not equal to zero. This mean that the credit mechanism was not
+ *	synchronized to the TxFIFO status
+ *	uCode/driver must write "1" in order to clear this flag
+ */
+#define FH_TSSR_TX_ERROR_REG		(FH_TSSR_LOWER_BOUND + 0x018)
+
 #define FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_chnl) ((1 << (_chnl)) << 24)
 #define FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_chnl) ((1 << (_chnl)) << 16)
 
-- 
1.6.3.3

