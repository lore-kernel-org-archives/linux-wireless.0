Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab0JGXIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/22] iwlwifi: move iwl_dump_csr to agn
Date: Thu,  7 Oct 2010 16:07:51 -0700
Message-Id: <1286492881-15743-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_dump_csr function is only used
within the agn module, so it can be
moved there instead of being exported
by the core.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   69 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c    |   71 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 4 files changed, 70 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9f1c93b..de91ff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2222,3 +2222,72 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant, u8 valid)
 	}
 	return ant;
 }
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cc7a3b5..5458e63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -162,6 +162,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
+void iwl_dump_csr(struct iwl_priv *priv);
 
 /* rx */
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88c1ed5..c0d531c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2351,77 +2351,6 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
 
-static const char *get_csr_string(int cmd)
-{
-	switch (cmd) {
-		IWL_CMD(CSR_HW_IF_CONFIG_REG);
-		IWL_CMD(CSR_INT_COALESCING);
-		IWL_CMD(CSR_INT);
-		IWL_CMD(CSR_INT_MASK);
-		IWL_CMD(CSR_FH_INT_STATUS);
-		IWL_CMD(CSR_GPIO_IN);
-		IWL_CMD(CSR_RESET);
-		IWL_CMD(CSR_GP_CNTRL);
-		IWL_CMD(CSR_HW_REV);
-		IWL_CMD(CSR_EEPROM_REG);
-		IWL_CMD(CSR_EEPROM_GP);
-		IWL_CMD(CSR_OTP_GP_REG);
-		IWL_CMD(CSR_GIO_REG);
-		IWL_CMD(CSR_GP_UCODE_REG);
-		IWL_CMD(CSR_GP_DRIVER_REG);
-		IWL_CMD(CSR_UCODE_DRV_GP1);
-		IWL_CMD(CSR_UCODE_DRV_GP2);
-		IWL_CMD(CSR_LED_REG);
-		IWL_CMD(CSR_DRAM_INT_TBL_REG);
-		IWL_CMD(CSR_GIO_CHICKEN_BITS);
-		IWL_CMD(CSR_ANA_PLL_CFG);
-		IWL_CMD(CSR_HW_REV_WA_REG);
-		IWL_CMD(CSR_DBG_HPET_MEM_REG);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
-void iwl_dump_csr(struct iwl_priv *priv)
-{
-	int i;
-	u32 csr_tbl[] = {
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
-EXPORT_SYMBOL(iwl_dump_csr);
-
 static const char *get_fh_string(int cmd)
 {
 	switch (cmd) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0bc7b7a..7e99b7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -659,7 +659,6 @@ int iwl_pci_resume(struct pci_dev *pdev);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv,
 			   bool full_log, char **buf, bool display);
-void iwl_dump_csr(struct iwl_priv *priv);
 int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
-- 
1.7.0.4

