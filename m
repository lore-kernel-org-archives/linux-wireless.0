Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1IFRPN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/10] iwlagn: fix compilation when debug flags is unset
Date: Tue,  6 Sep 2011 09:31:25 -0700
Message-Id: <1315326685-22213-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191535_772272_6559CF8E)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Trivial fixes to allow compilation without warnings when debug
compilation flag isn't set.
Also fix the compilation when debugfs flag isn't set.
Fix a warning: unused priv pointer on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c  |  260 ++++++++++++++--------------
 3 files changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f8a4bcf..ba5c514 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -741,7 +741,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int cmd_index = SEQ_TO_INDEX(sequence);
+	int cmd_index __maybe_unused = SEQ_TO_INDEX(sequence);
 	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	struct ieee80211_hdr *hdr;
 	u32 status = le16_to_cpu(tx_resp->status.status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 03f4c64..d987bee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -403,7 +403,7 @@ void iwl_reset_traffic_log(struct iwl_priv *priv);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
 #else
-static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid);
+static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv, u8 ctxid)
 {
 }
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index c495fc3..b2e8907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1505,6 +1505,136 @@ static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
 	return 0;
 }
 
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
+				iwl_read_direct32(bus(trans), fh_tbl[i]));
+		}
+		return pos;
+	}
+#endif
+	IWL_ERR(trans, "FH register values:\n");
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+		IWL_ERR(trans, "  %34s: 0X%08x\n",
+			get_fh_string(fh_tbl[i]),
+			iwl_read_direct32(bus(trans), fh_tbl[i]));
+	}
+	return 0;
+}
+
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
+			iwl_read32(bus(trans), csr_tbl[i]));
+	}
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
@@ -1752,75 +1882,6 @@ static ssize_t iwl_dbgfs_interrupt_write(struct file *file,
 	return count;
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
-void iwl_dump_csr(struct iwl_trans *trans)
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
-	IWL_ERR(trans, "CSR values:\n");
-	IWL_ERR(trans, "(2nd byte of CSR_INT_COALESCING is "
-		"CSR_INT_PERIODIC_REG)\n");
-	for (i = 0; i <  ARRAY_SIZE(csr_tbl); i++) {
-		IWL_ERR(trans, "  %25s: 0X%08x\n",
-			get_csr_string(csr_tbl[i]),
-			iwl_read32(bus(trans), csr_tbl[i]));
-	}
-}
-
 static ssize_t iwl_dbgfs_csr_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -1842,67 +1903,6 @@ static ssize_t iwl_dbgfs_csr_write(struct file *file,
 	return count;
 }
 
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
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
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
-				iwl_read_direct32(bus(trans), fh_tbl[i]));
-		}
-		return pos;
-	}
-#endif
-	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
-		IWL_ERR(trans, "  %34s: 0X%08x\n",
-			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(bus(trans), fh_tbl[i]));
-	}
-	return 0;
-}
-
 static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
-- 
1.7.0.4

