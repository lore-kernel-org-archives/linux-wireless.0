Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65194 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaDMTUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:39 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so3139550wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:37 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/47] iwlwifi: mvm: dump Rx FIFO when the firmware asserts
Date: Sun, 13 Apr 2014 22:19:34 +0300
Message-Id: <1397416802-32403-19-git-send-email-egrumbach@gmail.com> (sfid-20140413_213517_050397_04D85B7E)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The Rx FIFO includes valuable data - dump it when the FW
asserts. Also - free the SRAM and Rx FIFO when we create
the file, and don't collect new SRAM / Rx FIFO if the
previous file hasn't been collected through debugfs yet.

Also - add a comment to saying that the ASSERT output should
not be modified since we have automatic scripts that monitor
this output.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h          |  8 +++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  3 --
 drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h |  6 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  3 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c           | 20 +++++++++--
 drivers/net/wireless/iwlwifi/mvm/utils.c         | 46 +++++++++++++++++++++++-
 6 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 5f657c5..7793110 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -348,4 +348,12 @@ enum secure_load_status_reg {
 
 #define LMPM_SECURE_TIME_OUT	(100)
 
+/* Rx FIFO */
+#define RXF_SIZE_ADDR			(0xa00c88)
+#define RXF_SIZE_BYTE_CND_POS		(7)
+#define RXF_SIZE_BYTE_CNT_MSK		(0x3ff << RXF_SIZE_BYTE_CND_POS)
+
+#define RXF_LD_FENCE_OFFSET_ADDR	(0xa00c10)
+#define RXF_FIFO_RD_FENCE_ADDR		(0xa00c0c)
+
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 1b52dee..d727572 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -136,9 +136,6 @@ static int iwl_dbgfs_fw_error_dump_open(struct inode *inode, struct file *file)
 
 	file->private_data = mvm->fw_error_dump;
 	mvm->fw_error_dump = NULL;
-	kfree(mvm->fw_error_sram);
-	mvm->fw_error_sram = NULL;
-	mvm->fw_error_sram_len = 0;
 	ret = 0;
 
 out:
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h b/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
index 58c8941..f381908 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-error-dump.h
@@ -71,10 +71,12 @@
  * enum iwl_fw_error_dump_type - types of data in the dump file
  * @IWL_FW_ERROR_DUMP_SRAM:
  * @IWL_FW_ERROR_DUMP_REG:
+ * @IWL_FW_ERROR_DUMP_RXF:
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
 	IWL_FW_ERROR_DUMP_REG = 1,
+	IWL_FW_ERROR_DUMP_RXF = 2,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -89,7 +91,7 @@ struct iwl_fw_error_dump_data {
 	__le32 type;
 	__le32 len;
 	__u8 data[];
-} __packed __aligned(4);
+} __packed;
 
 /**
  * struct iwl_fw_error_dump_file - the layout of the header of the file
@@ -101,6 +103,6 @@ struct iwl_fw_error_dump_file {
 	__le32 barker;
 	__le32 file_len;
 	u8 data[0];
-} __packed __aligned(4);
+} __packed;
 
 #endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5420700..9f2ecf2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -580,6 +580,8 @@ struct iwl_mvm {
 	void *fw_error_dump;
 	void *fw_error_sram;
 	u32 fw_error_sram_len;
+	u32 *fw_error_rxf;
+	u32 fw_error_rxf_len;
 
 	struct led_classdev led;
 
@@ -705,6 +707,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm);
+void iwl_mvm_fw_error_rxf_dump(struct iwl_mvm *mvm);
 #endif
 u8 first_antenna(u8 mask);
 u8 iwl_mvm_next_antenna(struct iwl_mvm *mvm, u8 valid, u8 last_idx);
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e436c04..7cb401b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -538,6 +538,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	kfree(mvm->scan_cmd);
 	vfree(mvm->fw_error_dump);
 	kfree(mvm->fw_error_sram);
+	kfree(mvm->fw_error_rxf);
 	kfree(mvm->mcast_filter_cmd);
 	mvm->mcast_filter_cmd = NULL;
 
@@ -821,8 +822,9 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		return;
 
 	file_len = mvm->fw_error_sram_len +
+		   mvm->fw_error_rxf_len +
 		   sizeof(*dump_file) +
-		   sizeof(*dump_data);
+		   sizeof(*dump_data) * 2;
 
 	dump_file = vmalloc(file_len);
 	if (!dump_file)
@@ -833,7 +835,12 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_file->file_len = cpu_to_le32(file_len);
 	dump_data = (void *)dump_file->data;
-	dump_data->type = IWL_FW_ERROR_DUMP_SRAM;
+	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
+	dump_data->len = cpu_to_le32(mvm->fw_error_rxf_len);
+	memcpy(dump_data->data, mvm->fw_error_rxf, mvm->fw_error_rxf_len);
+
+	dump_data = (void *)((u8 *)dump_data->data + mvm->fw_error_rxf_len);
+	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SRAM);
 	dump_data->len = cpu_to_le32(mvm->fw_error_sram_len);
 
 	/*
@@ -842,6 +849,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	 * mvm->fw_error_sram right now.
 	 */
 	memcpy(dump_data->data, mvm->fw_error_sram, mvm->fw_error_sram_len);
+
+	kfree(mvm->fw_error_rxf);
+	mvm->fw_error_rxf = NULL;
+	mvm->fw_error_rxf_len = 0;
+
+	kfree(mvm->fw_error_sram);
+	mvm->fw_error_sram = NULL;
+	mvm->fw_error_sram_len = 0;
 }
 #endif
 
@@ -853,6 +868,7 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_fw_error_sram_dump(mvm);
+	iwl_mvm_fw_error_rxf_dump(mvm);
 #endif
 
 	iwl_mvm_nic_restart(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index d619851..c5f4532 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -64,6 +64,7 @@
 
 #include "iwl-debug.h"
 #include "iwl-io.h"
+#include "iwl-prph.h"
 
 #include "mvm.h"
 #include "fw-api-rs.h"
@@ -469,6 +470,8 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 			mvm->status, table.valid);
 	}
 
+	/* Do not change this output - scripts rely on it */
+
 	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
 
 	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
@@ -522,7 +525,7 @@ void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
 	u32 ofs, sram_len;
 	void *sram;
 
-	if (!mvm->ucode_loaded || mvm->fw_error_sram)
+	if (!mvm->ucode_loaded || mvm->fw_error_sram || mvm->fw_error_dump)
 		return;
 
 	img = &mvm->fw->img[mvm->cur_ucode];
@@ -538,6 +541,47 @@ void iwl_mvm_fw_error_sram_dump(struct iwl_mvm *mvm)
 	mvm->fw_error_sram_len = sram_len;
 }
 
+void iwl_mvm_fw_error_rxf_dump(struct iwl_mvm *mvm)
+{
+	int i, reg_val;
+	unsigned long flags;
+
+	if (!mvm->ucode_loaded || mvm->fw_error_rxf || mvm->fw_error_dump)
+		return;
+
+	/* reading buffer size */
+	reg_val = iwl_trans_read_prph(mvm->trans, RXF_SIZE_ADDR);
+	mvm->fw_error_rxf_len =
+		(reg_val & RXF_SIZE_BYTE_CNT_MSK) >> RXF_SIZE_BYTE_CND_POS;
+
+	/* the register holds the value divided by 128 */
+	mvm->fw_error_rxf_len = mvm->fw_error_rxf_len << 7;
+
+	if (!mvm->fw_error_rxf_len)
+		return;
+
+	mvm->fw_error_rxf =  kzalloc(mvm->fw_error_rxf_len, GFP_ATOMIC);
+	if (!mvm->fw_error_rxf) {
+		mvm->fw_error_rxf_len = 0;
+		return;
+	}
+
+	if (!iwl_trans_grab_nic_access(mvm->trans, false, &flags)) {
+		kfree(mvm->fw_error_rxf);
+		mvm->fw_error_rxf = NULL;
+		mvm->fw_error_rxf_len = 0;
+		return;
+	}
+
+	for (i = 0; i < (mvm->fw_error_rxf_len / sizeof(u32)); i++) {
+		iwl_trans_write_prph(mvm->trans, RXF_LD_FENCE_OFFSET_ADDR,
+				     i * sizeof(u32));
+		mvm->fw_error_rxf[i] =
+			iwl_trans_read_prph(mvm->trans, RXF_FIFO_RD_FENCE_ADDR);
+	}
+	iwl_trans_release_nic_access(mvm->trans, &flags);
+}
+
 /**
  * iwl_mvm_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
-- 
1.8.3.2

