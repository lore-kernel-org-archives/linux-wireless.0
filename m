Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33514 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753830AbcGFKpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:05 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:18 +0300
Message-Id: <1467801651-1816-23-git-send-email-luca@coelho.fi> (sfid-20160706_124548_479339_25FB912B)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 23/56] iwlwifi: add dump of RFH
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add support of dumping new RFH instead of FH registers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c | 115 +++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 32c8f84..d8b4306 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project.
  *
@@ -228,9 +228,117 @@ void iwl_force_nmi(struct iwl_trans *trans)
 }
 IWL_EXPORT_SYMBOL(iwl_force_nmi);
 
-static const char *get_fh_string(int cmd)
+static const char *get_rfh_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
+#define IWL_CMD_MQ(arg, reg, q) { if (arg == reg(q)) return #reg; }
+
+	int i;
+
+	for (i = 0; i < IWL_MAX_RX_HW_QUEUES; i++) {
+		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_BA_LSB, i);
+		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_WIDX, i);
+		IWL_CMD_MQ(cmd, RFH_Q_FRBDCB_RIDX, i);
+		IWL_CMD_MQ(cmd, RFH_Q_URBD_STTS_WPTR_LSB, i);
+	};
+
+	switch (cmd) {
+	IWL_CMD(RFH_RXF_DMA_CFG);
+	IWL_CMD(RFH_GEN_CFG);
+	IWL_CMD(RFH_GEN_STATUS);
+	IWL_CMD(FH_TSSR_TX_STATUS_REG);
+	IWL_CMD(FH_TSSR_TX_ERROR_REG);
+	default:
+		return "UNKNOWN";
+	}
+#undef IWL_CMD_MQ
+}
+
+struct reg {
+	u32 addr;
+	bool is64;
+};
+
+static int iwl_dump_rfh(struct iwl_trans *trans, char **buf)
+{
+	int i, q;
+	int num_q = trans->num_rx_queues;
+	static const u32 rfh_tbl[] = {
+		RFH_RXF_DMA_CFG,
+		RFH_GEN_CFG,
+		RFH_GEN_STATUS,
+		FH_TSSR_TX_STATUS_REG,
+		FH_TSSR_TX_ERROR_REG,
+	};
+	static const struct reg rfh_mq_tbl[] = {
+		{ RFH_Q0_FRBDCB_BA_LSB, true },
+		{ RFH_Q0_FRBDCB_WIDX, false },
+		{ RFH_Q0_FRBDCB_RIDX, false },
+		{ RFH_Q0_URBD_STTS_WPTR_LSB, true },
+	};
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (buf) {
+		int pos = 0;
+		/*
+		 * Register (up to 34 for name + 8 blank/q for MQ): 40 chars
+		 * Colon + space: 2 characters
+		 * 0X%08x: 10 characters
+		 * New line: 1 character
+		 * Total of 53 characters
+		 */
+		size_t bufsz = ARRAY_SIZE(rfh_tbl) * 53 +
+			       ARRAY_SIZE(rfh_mq_tbl) * 53 * num_q + 40;
+
+		*buf = kmalloc(bufsz, GFP_KERNEL);
+		if (!*buf)
+			return -ENOMEM;
+
+		pos += scnprintf(*buf + pos, bufsz - pos,
+				"RFH register values:\n");
+
+		for (i = 0; i < ARRAY_SIZE(rfh_tbl); i++)
+			pos += scnprintf(*buf + pos, bufsz - pos,
+				"%40s: 0X%08x\n",
+				get_rfh_string(rfh_tbl[i]),
+				iwl_read_prph(trans, rfh_tbl[i]));
+
+		for (i = 0; i < ARRAY_SIZE(rfh_mq_tbl); i++)
+			for (q = 0; q < num_q; q++) {
+				u32 addr = rfh_mq_tbl[i].addr;
+
+				addr += q * (rfh_mq_tbl[i].is64 ? 8 : 4);
+				pos += scnprintf(*buf + pos, bufsz - pos,
+					"%34s(q %2d): 0X%08x\n",
+					get_rfh_string(addr), q,
+					iwl_read_prph(trans, addr));
+			}
+
+		return pos;
+	}
+#endif
+
+	IWL_ERR(trans, "RFH register values:\n");
+	for (i = 0; i < ARRAY_SIZE(rfh_tbl); i++)
+		IWL_ERR(trans, "  %34s: 0X%08x\n",
+			get_rfh_string(rfh_tbl[i]),
+			iwl_read_prph(trans, rfh_tbl[i]));
+
+	for (i = 0; i < ARRAY_SIZE(rfh_mq_tbl); i++)
+		for (q = 0; q < num_q; q++) {
+			u32 addr = rfh_mq_tbl[i].addr;
+
+			addr += q * (rfh_mq_tbl[i].is64 ? 8 : 4);
+			IWL_ERR(trans, "  %34s(q %d): 0X%08x\n",
+				get_rfh_string(addr), q,
+				iwl_read_prph(trans, addr));
+		}
+
+	return 0;
+}
+
+static const char *get_fh_string(int cmd)
+{
 	switch (cmd) {
 	IWL_CMD(FH_RSCSR_CHNL0_STTS_WPTR_REG);
 	IWL_CMD(FH_RSCSR_CHNL0_RBDCB_BASE_REG);
@@ -262,6 +370,9 @@ int iwl_dump_fh(struct iwl_trans *trans, char **buf)
 		FH_TSSR_TX_ERROR_REG
 	};
 
+	if (trans->cfg->mq_rx_supported)
+		return iwl_dump_rfh(trans, buf);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (buf) {
 		int pos = 0;
-- 
2.8.1

