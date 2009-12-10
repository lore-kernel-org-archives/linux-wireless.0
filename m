Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761875AbZLJWhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:23 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: dump "Control and Status Register" when detect uCode HW/SW error
Date: Thu, 10 Dec 2009 14:37:25 -0800
Message-Id: <1260484647-5114-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When uCode HW/SW error detected, dumping important CSR (Control and Status
Registers) values.
Also add "csr" debugfs file to dump the current values of CSR defined in
CSR table to syslog.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c    |   73 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   25 ++++++++++
 7 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 59f2332..d461d36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -105,6 +105,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.load_ucode = iwl5000_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e2f8615..5a277cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1465,6 +1465,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
@@ -1517,6 +1518,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a7ccbef..7e8880a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -215,6 +215,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.load_ucode = iwl5000_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 574d366..47ece91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1363,6 +1363,8 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
 	priv->cfg->ops->lib->dump_nic_error_log(priv);
+	if (priv->cfg->ops->lib->dump_csr)
+		priv->cfg->ops->lib->dump_csr(priv);
 	priv->cfg->ops->lib->dump_nic_event_log(priv, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
@@ -3191,6 +3193,77 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
 
+const static char *get_csr_string(int cmd)
+{
+	switch (cmd) {
+		IWL_CMD(CSR_HW_IF_CONFIG_REG);
+		IWL_CMD(CSR_INT_COALESCING);
+		IWL_CMD(CSR_INT);
+		IWL_CMD(CSR_INT_MASK);
+		IWL_CMD(CSR_FH_INT_STATUS);
+		IWL_CMD(CSR_GPIO_IN);
+		IWL_CMD(CSR_RESET);
+		IWL_CMD(CSR_GP_CNTRL);
+		IWL_CMD(CSR_HW_REV);
+		IWL_CMD(CSR_EEPROM_REG);
+		IWL_CMD(CSR_EEPROM_GP);
+		IWL_CMD(CSR_OTP_GP_REG);
+		IWL_CMD(CSR_GIO_REG);
+		IWL_CMD(CSR_GP_UCODE_REG);
+		IWL_CMD(CSR_GP_DRIVER_REG);
+		IWL_CMD(CSR_UCODE_DRV_GP1);
+		IWL_CMD(CSR_UCODE_DRV_GP2);
+		IWL_CMD(CSR_LED_REG);
+		IWL_CMD(CSR_DRAM_INT_TBL_REG);
+		IWL_CMD(CSR_GIO_CHICKEN_BITS);
+		IWL_CMD(CSR_ANA_PLL_CFG);
+		IWL_CMD(CSR_HW_REV_WA_REG);
+		IWL_CMD(CSR_DBG_HPET_MEM_REG);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
+void iwl_dump_csr(struct iwl_priv *priv)
+{
+	int i;
+	u32 csr_tbl[] = {
+		CSR_HW_IF_CONFIG_REG,
+		CSR_INT_COALESCING,
+		CSR_INT,
+		CSR_INT_MASK,
+		CSR_FH_INT_STATUS,
+		CSR_GPIO_IN,
+		CSR_RESET,
+		CSR_GP_CNTRL,
+		CSR_HW_REV,
+		CSR_EEPROM_REG,
+		CSR_EEPROM_GP,
+		CSR_OTP_GP_REG,
+		CSR_GIO_REG,
+		CSR_GP_UCODE_REG,
+		CSR_GP_DRIVER_REG,
+		CSR_UCODE_DRV_GP1,
+		CSR_UCODE_DRV_GP2,
+		CSR_LED_REG,
+		CSR_DRAM_INT_TBL_REG,
+		CSR_GIO_CHICKEN_BITS,
+		CSR_ANA_PLL_CFG,
+		CSR_HW_REV_WA_REG,
+		CSR_DBG_HPET_MEM_REG
+	};
+	IWL_ERR(priv, "CSR values:\n");
+	IWL_ERR(priv, "(2nd byte of CSR_INT_COALESCING is "
+		"CSR_INT_PERIODIC_REG)\n");
+	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
+		IWL_ERR(priv, "  %25s: 0X%08x\n",
+			get_csr_string(csr_tbl[i]),
+			iwl_read32(priv, csr_tbl[i]));
+	}
+}
+EXPORT_SYMBOL(iwl_dump_csr);
+
 #ifdef CONFIG_PM
 
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 22a20c1..d5c8b06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -171,6 +171,7 @@ struct iwl_lib_ops {
 	int (*load_ucode)(struct iwl_priv *priv);
 	void (*dump_nic_event_log)(struct iwl_priv *priv, bool full_log);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
+	void (*dump_csr)(struct iwl_priv *priv);
 	int (*set_channel_switch)(struct iwl_priv *priv, u16 channel);
 	/* power management */
 	struct iwl_apm_ops apm_ops;
@@ -582,6 +583,7 @@ int iwl_pci_resume(struct pci_dev *pdev);
 ******************************************************/
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 void iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log);
+void iwl_dump_csr(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv);
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index d61293a..86a6767 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -109,6 +109,7 @@ struct iwl_debugfs {
 		struct dentry *file_power_save_status;
 		struct dentry *file_clear_ucode_statistics;
 		struct dentry *file_clear_traffic_statistics;
+		struct dentry *file_csr;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 21e0f66..2be3549 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1845,6 +1845,28 @@ static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_csr_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int csr;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &csr) != 1)
+		return -EFAULT;
+
+	if (priv->cfg->ops->lib->dump_csr)
+		priv->cfg->ops->lib->dump_csr(priv);
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1859,6 +1881,7 @@ DEBUGFS_READ_FILE_OPS(tx_power);
 DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
+DEBUGFS_WRITE_FILE_OPS(csr);
 
 /*
  * Create the debugfs files and directories
@@ -1909,6 +1932,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(power_save_status, debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(csr, debug, S_IWUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug, S_IRUSR);
@@ -1966,6 +1990,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 			file_clear_ucode_statistics);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_clear_traffic_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_csr);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
-- 
1.5.6.3

