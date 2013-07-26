Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GZI2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Inbal Hacohen <Inbal.Hacohen@intel.com>
Subject: [PATCH 01/30] iwlwifi: move dump_fh into common code
Date: Fri, 26 Jul 2013 10:28:18 +0200
Message-Id: <1374827327-3464-2-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102859_787820_61A8D695)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Inbal Hacohen <Inbal.Hacohen@intel.com>

This means it can be shared for different transport
layers in the future.

Signed-off-by: Inbal Hacohen <Inbal.Hacohen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-io.c        | 67 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-io.h        |  3 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |  1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 67 +---------------------------
 5 files changed, 72 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 305c81f..dfa4d2e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -33,6 +33,8 @@
 #include "iwl-io.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
+#include "iwl-fh.h"
+#include "iwl-csr.h"
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
@@ -166,3 +168,68 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	}
 }
 IWL_EXPORT_SYMBOL(iwl_clear_bits_prph);
+
+static const char *get_fh_string(int cmd)
+{
+#define IWL_CMD(x) case x: return #x
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
+#undef IWL_CMD
+}
+
+int iwl_dump_fh(struct iwl_trans *trans, char **buf)
+{
+	int i;
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
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (buf) {
+		int pos = 0;
+		size_t bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+
+		pos += scnprintf(*buf + pos, bufsz - pos,
+				"FH register values:\n");
+
+		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++)
+			pos += scnprintf(*buf + pos, bufsz - pos,
+				"  %34s: 0X%08x\n",
+				get_fh_string(fh_tbl[i]),
+				iwl_read_direct32(trans, fh_tbl[i]));
+
+		return pos;
+	}
+#endif
+
+	IWL_ERR(trans, "FH register values:\n");
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++)
+		IWL_ERR(trans, "  %34s: 0X%08x\n",
+			get_fh_string(fh_tbl[i]),
+			iwl_read_direct32(trans, fh_tbl[i]));
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index fd9f5b9..63d10ec0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -77,4 +77,7 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
 void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 
+/* Error handling */
+int iwl_dump_fh(struct iwl_trans *trans, char **buf);
+
 #endif
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index b654dcd..fa22639 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -392,7 +392,6 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
 /*****************************************************
 * Error handling
 ******************************************************/
-int iwl_pcie_dump_fh(struct iwl_trans *trans, char **buf);
 void iwl_pcie_dump_csr(struct iwl_trans *trans);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index fd848cd..5fdb4ee 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -793,7 +793,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	}
 
 	iwl_pcie_dump_csr(trans);
-	iwl_pcie_dump_fh(trans, NULL);
+	iwl_dump_fh(trans, NULL);
 
 	set_bit(STATUS_FW_ERROR, &trans_pcie->status);
 	clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 826c156..82194e8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1033,71 +1033,6 @@ static void iwl_trans_pcie_set_bits_mask(struct iwl_trans *trans, u32 reg,
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
 }
 
-static const char *get_fh_string(int cmd)
-{
-#define IWL_CMD(x) case x: return #x
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
-#undef IWL_CMD
-}
-
-int iwl_pcie_dump_fh(struct iwl_trans *trans, char **buf)
-{
-	int i;
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
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (buf) {
-		int pos = 0;
-		size_t bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
-
-		*buf = kmalloc(bufsz, GFP_KERNEL);
-		if (!*buf)
-			return -ENOMEM;
-
-		pos += scnprintf(*buf + pos, bufsz - pos,
-				"FH register values:\n");
-
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++)
-			pos += scnprintf(*buf + pos, bufsz - pos,
-				"  %34s: 0X%08x\n",
-				get_fh_string(fh_tbl[i]),
-				iwl_read_direct32(trans, fh_tbl[i]));
-
-		return pos;
-	}
-#endif
-
-	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++)
-		IWL_ERR(trans, "  %34s: 0X%08x\n",
-			get_fh_string(fh_tbl[i]),
-			iwl_read_direct32(trans, fh_tbl[i]));
-
-	return 0;
-}
-
 static const char *get_csr_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
@@ -1390,7 +1325,7 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	ret = pos = iwl_pcie_dump_fh(trans, &buf);
+	ret = pos = iwl_dump_fh(trans, &buf);
 	if (buf) {
 		ret = simple_read_from_buffer(user_buf,
 					      count, ppos, buf, pos);
-- 
1.8.0

