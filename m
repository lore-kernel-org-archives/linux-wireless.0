Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbcAGMr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/21] iwlwifi: mvm: dump the radio registers when the firmware crashes
Date: Thu,  7 Jan 2016 14:47:30 +0200
Message-Id: <1452170861-10060-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_140653_388255_1AD312C7)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dumping the content of the radio registers greatly helps
to debug PHY issues, which can lead to TFD queue hang.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  6 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 40 ++++++++++++++++++++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index f08a131..a5aaf68 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -88,6 +88,7 @@
  *	&struct iwl_fw_error_dump_rb
  * @IWL_FW_ERROR_PAGING: UMAC's image memory segments which were
  *	paged to the DRAM.
+ * @IWL_FW_ERROR_DUMP_RADIO_REG: Dump the radio registers.
  */
 enum iwl_fw_error_dump_type {
 	/* 0 is deprecated */
@@ -103,6 +104,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_ERROR_INFO = 10,
 	IWL_FW_ERROR_DUMP_RB = 11,
 	IWL_FW_ERROR_DUMP_PAGING = 12,
+	IWL_FW_ERROR_DUMP_RADIO_REG = 13,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 9da7dc4..5bde23a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -345,6 +345,12 @@ enum secure_load_status_reg {
 #define TXF_READ_MODIFY_DATA		(0xa00448)
 #define TXF_READ_MODIFY_ADDR		(0xa0044c)
 
+/* Radio registers access */
+#define RSP_RADIO_CMD			(0xa02804)
+#define RSP_RADIO_RDDAT			(0xa02814)
+#define RADIO_RSP_ADDR_POS		(6)
+#define RADIO_RSP_RD_CMD		(3)
+
 /* FW monitor */
 #define MON_BUFF_SAMPLE_CTL		(0xa03c00)
 #define MON_BUFF_BASE_ADDR		(0xa03c3c)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index f406c76..59450f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -113,6 +113,35 @@ static void iwl_mvm_free_coredump(const void *data)
 	kfree(fw_error_dump);
 }
 
+#define RADIO_REG_MAX_READ 0x2ad
+static void iwl_mvm_read_radio_reg(struct iwl_mvm *mvm,
+				   struct iwl_fw_error_dump_data **dump_data)
+{
+	u8 *pos = (void *)(*dump_data)->data;
+	unsigned long flags;
+	int i;
+
+	if (!iwl_trans_grab_nic_access(mvm->trans, &flags))
+		return;
+
+	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RADIO_REG);
+	(*dump_data)->len = cpu_to_le32(RADIO_REG_MAX_READ);
+
+	for (i = 0; i < RADIO_REG_MAX_READ; i++) {
+		u32 rd_cmd = RADIO_RSP_RD_CMD;
+
+		rd_cmd |= i << RADIO_RSP_ADDR_POS;
+		iwl_write_prph_no_grab(mvm->trans, RSP_RADIO_CMD, rd_cmd);
+		*pos =  (u8)iwl_read_prph_no_grab(mvm->trans, RSP_RADIO_RDDAT);
+
+		pos++;
+	}
+
+	*dump_data = iwl_fw_error_next_data(*dump_data);
+
+	iwl_trans_release_nic_access(mvm->trans, &flags);
+}
+
 static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 			       struct iwl_fw_error_dump_data **dump_data)
 {
@@ -401,7 +430,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
-	u32 file_len, fifo_data_len = 0, prph_len = 0;
+	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
 	u32 smem_len = mvm->cfg->smem_len;
 	u32 sram2_len = mvm->cfg->dccm2_len;
 	bool monitor_dump_only = false;
@@ -472,6 +501,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 				sizeof(struct iwl_fw_error_dump_prph) +
 				num_bytes_in_chunk;
 		}
+
+		if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000)
+			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
 
 	file_len = sizeof(*dump_file) +
@@ -479,6 +511,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   sram_len + sizeof(*dump_mem) +
 		   fifo_data_len +
 		   prph_len +
+		   radio_len +
 		   sizeof(*dump_info);
 
 	/* Make room for the SMEM, if it exists */
@@ -543,8 +576,11 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	dump_data = iwl_fw_error_next_data(dump_data);
 	/* We only dump the FIFOs if the FW is in error state */
-	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status))
+	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
 		iwl_mvm_dump_fifos(mvm, &dump_data);
+		if (radio_len)
+			iwl_mvm_read_radio_reg(mvm, &dump_data);
+	}
 
 	if (mvm->fw_dump_desc) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_ERROR_INFO);
-- 
2.5.0

