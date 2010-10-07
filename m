Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab0JGXIv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/22] iwlwifi: move iwl_dump_fh to agn
Date: Thu,  7 Oct 2010 16:07:52 -0700
Message-Id: <1286492881-15743-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_dump_fh function is only used
by the agn module, so it can be there
instead of being exported by the core.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   61 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c    |   63 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 4 files changed, 62 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index de91ff6..ff5f2fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2291,3 +2291,64 @@ void iwl_dump_csr(struct iwl_priv *priv)
 			iwl_read32(priv, csr_tbl[i]));
 	}
 }
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5458e63..1fca5af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -163,6 +163,7 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwl_dump_csr(struct iwl_priv *priv);
+int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 
 /* rx */
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c0d531c..5cd16a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2351,69 +2351,6 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 EXPORT_SYMBOL(iwl_update_stats);
 #endif
 
-static const char *get_fh_string(int cmd)
-{
-	switch (cmd) {
-		IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
-		IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
-		IWL_CMD(FH_RSCSR_CHNL0_WPTR);
-		IWL_CMD(FH_MEM_RCSR_CHNL0_CONFIG_REG);
-		IWL_CMD(FH_MEM_RSSR_SHARED_CTRL_REG);
-		IWL_CMD(FH_MEM_RSSR_RX_STATUS_REG);
-		IWL_CMD(FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV);
-		IWL_CMD(FH_TSSR_TX_STATUS_REG);
-		IWL_CMD(FH_TSSR_TX_ERROR_REG);
-	default:
-		return "UNKNOWN";
-
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
-	u32 fh_tbl[] = {
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
-EXPORT_SYMBOL(iwl_dump_fh);
-
 static void iwl_force_rf_reset(struct iwl_priv *priv)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7e99b7d..b02db31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -659,7 +659,6 @@ int iwl_pci_resume(struct pci_dev *pdev);
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv,
 			   bool full_log, char **buf, bool display);
-int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx);
-- 
1.7.0.4

