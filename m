Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:51552 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGVT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:47 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so107438wes.36
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:45 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/20] iwlwifi: dump CSRs to fw-error-dump
Date: Tue, 22 Jul 2014 22:26:48 +0300
Message-Id: <1406057211-31752-17-git-send-email-egrumbach@gmail.com> (sfid-20140722_212801_138351_974AAAD6)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add the Control Status Registers to the firmware error dump
infrastructure.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  4 +--
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 33 +++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 5121479..de5994a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -70,7 +70,7 @@
 /**
  * enum iwl_fw_error_dump_type - types of data in the dump file
  * @IWL_FW_ERROR_DUMP_SRAM:
- * @IWL_FW_ERROR_DUMP_REG:
+ * @IWL_FW_ERROR_DUMP_CSR: Control Status Registers - from offset 0
  * @IWL_FW_ERROR_DUMP_RXF:
  * @IWL_FW_ERROR_DUMP_TXCMD: last TX command data, structured as
  *	&struct iwl_fw_error_dump_txcmd packets
@@ -82,7 +82,7 @@
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
-	IWL_FW_ERROR_DUMP_REG = 1,
+	IWL_FW_ERROR_DUMP_CSR = 1,
 	IWL_FW_ERROR_DUMP_RXF = 2,
 	IWL_FW_ERROR_DUMP_TXCMD = 3,
 	IWL_FW_ERROR_DUMP_DEV_FW_INFO = 4,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 153c3dd..06e04aa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1912,6 +1912,27 @@ static u32 iwl_trans_pcie_dump_prph(struct iwl_trans *trans,
 	return prph_len;
 }
 
+#define IWL_CSR_TO_DUMP (0x250)
+
+static u32 iwl_trans_pcie_dump_csr(struct iwl_trans *trans,
+				   struct iwl_fw_error_dump_data **data)
+{
+	u32 csr_len = sizeof(**data) + IWL_CSR_TO_DUMP;
+	__le32 *val;
+	int i;
+
+	(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_CSR);
+	(*data)->len = cpu_to_le32(IWL_CSR_TO_DUMP);
+	val = (void *)(*data)->data;
+
+	for (i = 0; i < IWL_CSR_TO_DUMP; i += 4)
+		*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
+
+	*data = iwl_fw_error_next_data(*data);
+
+	return csr_len;
+}
+
 static
 struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 {
@@ -1923,9 +1944,17 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	u32 len;
 	int i, ptr;
 
-	len = sizeof(*dump_data) + sizeof(*data) +
+	/* transport dump header */
+	len = sizeof(*dump_data);
+
+	/* host commands */
+	len += sizeof(*data) +
 		cmdq->q.n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
+	/* CSR registers */
+	len += sizeof(*data) + IWL_CSR_TO_DUMP;
+
+	/* PRPH registers */
 	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
 		/* The range includes both boundaries */
 		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
@@ -1935,6 +1964,7 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 			num_bytes_in_chunk;
 	}
 
+	/* FW monitor */
 	if (trans_pcie->fw_mon_page)
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
 			trans_pcie->fw_mon_size;
@@ -1973,6 +2003,7 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 	data = iwl_fw_error_next_data(data);
 
 	len += iwl_trans_pcie_dump_prph(trans, &data);
+	len += iwl_trans_pcie_dump_csr(trans, &data);
 	/* data is already pointing to the next section */
 
 	if (trans_pcie->fw_mon_page) {
-- 
1.8.3.2

