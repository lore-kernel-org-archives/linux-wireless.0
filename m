Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab1HMSS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 36/60] iwlagn: move dump_csr and dump_fh to transport layer
Date: Sat, 13 Aug 2011 10:38:12 -0700
Message-Id: <1313257116-2697-37-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201906_806058_501A0596)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These are transport layer related. Move also the corresponding debugfs handlers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |  130 ---------------
 drivers/net/wireless/iwlwifi/iwl-core.h           |    2 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |   44 -----
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c          |  182 +++++++++++++++++++++
 6 files changed, 187 insertions(+), 178 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index bca5f99..359bd90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1395,136 +1395,6 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 	return ant;
 }
 
-static const char *get_csr_string(int cmd)
-{
-	switch (cmd) {
-	IWL_CMD(CSR_HW_IF_CONFIG_REG);
-	IWL_CMD(CSR_INT_COALESCING);
-	IWL_CMD(CSR_INT);
-	IWL_CMD(CSR_INT_MASK);
-	IWL_CMD(CSR_FH_INT_STATUS);
-	IWL_CMD(CSR_GPIO_IN);
-	IWL_CMD(CSR_RESET);
-	IWL_CMD(CSR_GP_CNTRL);
-	IWL_CMD(CSR_HW_REV);
-	IWL_CMD(CSR_EEPROM_REG);
-	IWL_CMD(CSR_EEPROM_GP);
-	IWL_CMD(CSR_OTP_GP_REG);
-	IWL_CMD(CSR_GIO_REG);
-	IWL_CMD(CSR_GP_UCODE_REG);
-	IWL_CMD(CSR_GP_DRIVER_REG);
-	IWL_CMD(CSR_UCODE_DRV_GP1);
-	IWL_CMD(CSR_UCODE_DRV_GP2);
-	IWL_CMD(CSR_LED_REG);
-	IWL_CMD(CSR_DRAM_INT_TBL_REG);
-	IWL_CMD(CSR_GIO_CHICKEN_BITS);
-	IWL_CMD(CSR_ANA_PLL_CFG);
-	IWL_CMD(CSR_HW_REV_WA_REG);
-	IWL_CMD(CSR_DBG_HPET_MEM_REG);
-	default:
-		return "UNKNOWN";
-	}
-}
-
-void iwl_dump_csr(struct iwl_priv *priv)
-{
-	int i;
-	static const u32 csr_tbl[] = {
-		CSR_HW_IF_CONFIG_REG,
-		CSR_INT_COALESCING,
-		CSR_INT,
-		CSR_INT_MASK,
-		CSR_FH_INT_STATUS,
-		CSR_GPIO_IN,
-		CSR_RESET,
-		CSR_GP_CNTRL,
-		CSR_HW_REV,
-		CSR_EEPROM_REG,
-		CSR_EEPROM_GP,
-		CSR_OTP_GP_REG,
-		CSR_GIO_REG,
-		CSR_GP_UCODE_REG,
-		CSR_GP_DRIVER_REG,
-		CSR_UCODE_DRV_GP1,
-		CSR_UCODE_DRV_GP2,
-		CSR_LED_REG,
-		CSR_DRAM_INT_TBL_REG,
-		CSR_GIO_CHICKEN_BITS,
-		CSR_ANA_PLL_CFG,
-		CSR_HW_REV_WA_REG,
-		CSR_DBG_HPET_MEM_REG
-	};
-	IWL_ERR(priv, "CSR values:\n");
-	IWL_ERR(priv, "(2nd byte of CSR_INT_COALESCING is "
-		"CSR_INT_PERIODIC_REG)\n");
-	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
-		IWL_ERR(priv, "  %25s: 0X%08x\n",
-			get_csr_string(csr_tbl[i]),
-			iwl_read32(priv, csr_tbl[i]));
-	}
-}
-
-static const char *get_fh_string(int cmd)
-{
-	switch (cmd) {
-	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
-	IWL_CMD(FH_RSCSR_CHNL0_WPTR);
-	IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
-	IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
-	IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
-	IWL_CMD(FH_TSSR_TX_STATUS_REG);
-	IWL_CMD(FH_TSSR_TX_ERROR_REG);
-	default:
-		return "UNKNOWN";
-	}
-}
-
-int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display)
-{
-	int i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int pos = 0;
-	size_t bufsz = 0;
-#endif
-	static const u32 fh_tbl[] = {
-		FH_RSCSR_CHNL0_STTS_WPTR_REG,
-		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-		FH_RSCSR_CHNL0_WPTR,
-		FH_MEM_RCSR_CHNL0_CONFIG_REG,
-		FH_MEM_RSSR_SHARED_CTRL_REG,
-		FH_MEM_RSSR_RX_STATUS_REG,
-		FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV,
-		FH_TSSR_TX_STATUS_REG,
-		FH_TSSR_TX_ERROR_REG
-	};
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-		pos += scnprintf(*buf + pos, bufsz - pos,
-				"FH register values:\n");
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
-			pos += scnprintf(*buf + pos, bufsz - pos,
-				"  %34s: 0X%08x\n",
-				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(priv, fh_tbl[i]));
-		}
-		return pos;
-	}
-#endif
-	IWL_ERR(priv, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
-		IWL_ERR(priv, "  %34s: 0X%08x\n",
-			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(priv, fh_tbl[i]));
-	}
-	return 0;
-}
-
 /* notification wait support */
 void iwlagn_init_notification_wait(struct iwl_priv *priv,
 				   struct iwl_notification_wait *wait_entry,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index cebc0e9..470d831 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -373,8 +373,6 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 /*****************************************************
 *  Error Handling Debugging
 ******************************************************/
-void iwl_dump_csr(struct iwl_priv *priv);
-int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 9ca429c..a12b8d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1991,27 +1991,6 @@ static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_csr_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int csr;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &csr) != 1)
-		return -EFAULT;
-
-	iwl_dump_csr(priv);
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_ucode_tracing_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2088,25 +2067,6 @@ static ssize_t iwl_dbgfs_rxon_filter_flags_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -EFAULT;
-
-	ret = pos = iwl_dump_fh(priv, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf,
-					      count, ppos, buf, pos);
-		kfree(buf);
-	}
-
-	return ret;
-}
-
 static ssize_t iwl_dbgfs_missed_beacon_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2391,9 +2351,7 @@ DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
 DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
-DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
-DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
@@ -2448,8 +2406,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(csr, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index b2af467..0e4efb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -169,6 +169,9 @@ void iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 ******************************************************/
 int iwl_dump_nic_event_log(struct iwl_priv *priv,
 			   bool full_log, char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+void iwl_dump_csr(struct iwl_trans *trans);
+
 
 static inline void iwl_disable_interrupts(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index b1635ee..0b6c527 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -655,8 +655,8 @@ static void iwl_irq_handle_error(struct iwl_priv *priv)
 		priv->hw->wiphy->fw_version);
 
 	iwl_dump_nic_error_log(priv);
-	iwl_dump_csr(priv);
-	iwl_dump_fh(priv, NULL, false);
+	iwl_dump_csr(trans(priv));
+	iwl_dump_fh(trans(priv), NULL, false);
 	iwl_dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv->shrd) & IWL_DL_FW_ERRORS)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 73883fe..e55636e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1324,6 +1324,14 @@ static const struct file_operations iwl_dbgfs_##name##_ops = {		\
 	.llseek = generic_file_llseek,					\
 };
 
+#define DEBUGFS_WRITE_FILE_OPS(name)                                    \
+	DEBUGFS_WRITE_FUNC(name);                                       \
+static const struct file_operations iwl_dbgfs_##name##_ops = {          \
+	.write = iwl_dbgfs_##name##_write,                              \
+	.open = iwl_dbgfs_open_file_generic,				\
+	.llseek = generic_file_llseek,					\
+};
+
 #define DEBUGFS_READ_WRITE_FILE_OPS(name)				\
 	DEBUGFS_READ_FUNC(name);					\
 	DEBUGFS_WRITE_FUNC(name);					\
@@ -1635,11 +1643,183 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 	return count;
 }
 
+static const char *get_csr_string(int cmd)
+{
+	switch (cmd) {
+	IWL_CMD(CSR_HW_IF_CONFIG_REG);
+	IWL_CMD(CSR_INT_COALESCING);
+	IWL_CMD(CSR_INT);
+	IWL_CMD(CSR_INT_MASK);
+	IWL_CMD(CSR_FH_INT_STATUS);
+	IWL_CMD(CSR_GPIO_IN);
+	IWL_CMD(CSR_RESET);
+	IWL_CMD(CSR_GP_CNTRL);
+	IWL_CMD(CSR_HW_REV);
+	IWL_CMD(CSR_EEPROM_REG);
+	IWL_CMD(CSR_EEPROM_GP);
+	IWL_CMD(CSR_OTP_GP_REG);
+	IWL_CMD(CSR_GIO_REG);
+	IWL_CMD(CSR_GP_UCODE_REG);
+	IWL_CMD(CSR_GP_DRIVER_REG);
+	IWL_CMD(CSR_UCODE_DRV_GP1);
+	IWL_CMD(CSR_UCODE_DRV_GP2);
+	IWL_CMD(CSR_LED_REG);
+	IWL_CMD(CSR_DRAM_INT_TBL_REG);
+	IWL_CMD(CSR_GIO_CHICKEN_BITS);
+	IWL_CMD(CSR_ANA_PLL_CFG);
+	IWL_CMD(CSR_HW_REV_WA_REG);
+	IWL_CMD(CSR_DBG_HPET_MEM_REG);
+	default:
+		return "UNKNOWN";
+	}
+}
+
+void iwl_dump_csr(struct iwl_trans *trans)
+{
+	int i;
+	static const u32 csr_tbl[] = {
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
+	IWL_ERR(trans, "CSR values:\n");
+	IWL_ERR(trans, "(2nd byte of CSR_INT_COALESCING is "
+		"CSR_INT_PERIODIC_REG)\n");
+	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
+		IWL_ERR(trans, "  %25s: 0X%08x\n",
+			get_csr_string(csr_tbl[i]),
+			iwl_read32(priv(trans), csr_tbl[i]));
+	}
+}
+
+static ssize_t iwl_dbgfs_csr_write(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
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
+	iwl_dump_csr(trans);
+
+	return count;
+}
+
+static const char *get_fh_string(int cmd)
+{
+	switch (cmd) {
+	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
+	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
+	IWL_CMD(FH_RSCSR_CHNL0_WPTR);
+	IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
+	IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
+	IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
+	IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
+	IWL_CMD(FH_TSSR_TX_STATUS_REG);
+	IWL_CMD(FH_TSSR_TX_ERROR_REG);
+	default:
+		return "UNKNOWN";
+	}
+}
+
+int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
+{
+	int i;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	int pos = 0;
+	size_t bufsz = 0;
+#endif
+	static const u32 fh_tbl[] = {
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
+				iwl_read_direct32(priv(trans), fh_tbl[i]));
+		}
+		return pos;
+	}
+#endif
+	IWL_ERR(trans, "FH register values:\n");
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+		IWL_ERR(trans, "  %34s: 0X%08x\n",
+			get_fh_string(fh_tbl[i]),
+			iwl_read_direct32(priv(trans), fh_tbl[i]));
+	}
+	return 0;
+}
+
+static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+	char *buf;
+	int pos = 0;
+	ssize_t ret = -EFAULT;
+
+	ret = pos = iwl_dump_fh(trans, &buf, true);
+	if (buf) {
+		ret = simple_read_from_buffer(user_buf,
+					      count, ppos, buf, pos);
+		kfree(buf);
+	}
+
+	return ret;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
+DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
+DEBUGFS_WRITE_FILE_OPS(csr);
 
 /*
  * Create the debugfs files and directories
@@ -1653,6 +1833,8 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
+	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
 	return 0;
 }
 #else
-- 
1.7.0.4

