Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62825 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:48 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so28877761wib.4
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:47 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/26] iwlwifi: pcie: add fh registers to dump data
Date: Tue,  2 Dec 2014 20:11:08 +0200
Message-Id: <1417543877-24193-17-git-send-email-egrumbach@gmail.com> (sfid-20141202_191346_929548_966AE4DD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Adds all FH registers between FH_MEM_UPPER_BOUND and
FH_MEM_LOWER_BOUND (which should be readable to the driver)
to the dump data when it is collected.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  3 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 30 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index e30a41d..20a8a64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -81,6 +81,7 @@
  * @IWL_FW_ERROR_DUMP_FW_MONITOR: firmware monitor
  * @IWL_FW_ERROR_DUMP_PRPH: range of periphery registers - there can be several
  *	sections like this in a single file.
+ * @IWL_FW_ERROR_DUMP_FH_REGS: range of FH registers
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
@@ -90,6 +91,8 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_DEV_FW_INFO = 4,
 	IWL_FW_ERROR_DUMP_FW_MONITOR = 5,
 	IWL_FW_ERROR_DUMP_PRPH = 6,
+	IWL_FW_ERROR_DUMP_TXF = 7,
+	IWL_FW_ERROR_DUMP_FH_REGS = 8,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 666925c..ced3354 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -78,6 +78,7 @@
 #include "iwl-agn-hw.h"
 #include "iwl-fw-error-dump.h"
 #include "internal.h"
+#include "iwl-fh.h"
 
 /* extended range in FW SRAM */
 #define IWL_FW_MEM_EXTENDED_START	0x40000
@@ -1970,6 +1971,31 @@ static u32 iwl_trans_pcie_dump_csr(struct iwl_trans *trans,
 	return csr_len;
 }
 
+static u32 iwl_trans_pcie_fh_regs_dump(struct iwl_trans *trans,
+				       struct iwl_fw_error_dump_data **data)
+{
+	u32 fh_regs_len = FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND;
+	unsigned long flags;
+	__le32 *val;
+	int i;
+
+	if (!iwl_trans_grab_nic_access(trans, false, &flags))
+		return 0;
+
+	(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FH_REGS);
+	(*data)->len = cpu_to_le32(fh_regs_len);
+	val = (void *)(*data)->data;
+
+	for (i = FH_MEM_LOWER_BOUND; i < FH_MEM_UPPER_BOUND; i += sizeof(u32))
+		*val++ = cpu_to_le32(iwl_trans_pcie_read32(trans, i));
+
+	iwl_trans_release_nic_access(trans, &flags);
+
+	*data = iwl_fw_error_next_data(*data);
+
+	return sizeof(**data) + fh_regs_len;
+}
+
 static
 struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 {
@@ -2001,6 +2027,9 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 			num_bytes_in_chunk;
 	}
 
+	/* FH registers */
+	len += sizeof(*data) + (FH_MEM_UPPER_BOUND - FH_MEM_LOWER_BOUND);
+
 	/* FW monitor */
 	if (trans_pcie->fw_mon_page)
 		len += sizeof(*data) + sizeof(struct iwl_fw_error_dump_fw_mon) +
@@ -2041,6 +2070,7 @@ struct iwl_trans_dump_data *iwl_trans_pcie_dump_data(struct iwl_trans *trans)
 
 	len += iwl_trans_pcie_dump_prph(trans, &data);
 	len += iwl_trans_pcie_dump_csr(trans, &data);
+	len += iwl_trans_pcie_fh_regs_dump(trans, &data);
 	/* data is already pointing to the next section */
 
 	if (trans_pcie->fw_mon_page) {
-- 
1.9.1

