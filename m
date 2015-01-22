Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbbAVUeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/38] iwlwifi: mvm: add support for dumping a secondary SRAM
Date: Thu, 22 Jan 2015 22:33:06 +0200
Message-Id: <1421958809-3371-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214445_680284_13D4896A)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Some HW modules have two SRAMs. In such cases add the secondary SRAM to
the list of dumped segments.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c     |  4 ++++
 drivers/net/wireless/iwlwifi/iwl-config.h   |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 ++++++++++++++++++++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 9eca533..d6c05eab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -84,6 +84,8 @@
 /* Memory offsets and lengths */
 #define IWL8260_DCCM_OFFSET		0x800000
 #define IWL8260_DCCM_LEN		0x18000
+#define IWL8260_DCCM2_OFFSET		0x880000
+#define IWL8260_DCCM2_LEN		0x8000
 #define IWL8260_SMEM_OFFSET		0x400000
 #define IWL8260_SMEM_LEN		0x68000
 
@@ -134,6 +136,8 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.non_shared_ant = ANT_A,				\
 	.dccm_offset = IWL8260_DCCM_OFFSET,			\
 	.dccm_len = IWL8260_DCCM_LEN,				\
+	.dccm2_offset = IWL8260_DCCM2_OFFSET,			\
+	.dccm2_len = IWL8260_DCCM2_LEN,				\
 	.smem_offset = IWL8260_SMEM_OFFSET,			\
 	.smem_len = IWL8260_SMEM_LEN
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 0eaafd8..445bff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -263,6 +263,8 @@ struct iwl_pwr_tx_backoff {
  *	station can receive in VHT
  * @dccm_offset: offset from which DCCM begins
  * @dccm_len: length of DCCM (including runtime stack CCM)
+ * @dccm2_offset: offset from which the second DCCM begins
+ * @dccm2_len: length of the second DCCM
  * @smem_offset: offset from which the SMEM begins
  * @smem_len: the length of SMEM
  *
@@ -310,6 +312,8 @@ struct iwl_cfg {
 	unsigned int max_vht_ampdu_exponent;
 	const u32 dccm_offset;
 	const u32 dccm_len;
+	const u32 dccm2_offset;
+	const u32 dccm2_len;
 	const u32 smem_offset;
 	const u32 smem_len;
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c4552b5..b5f401d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -778,14 +778,19 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	unsigned long flags;
 	int reg_val;
 	u32 smem_len = mvm->cfg->smem_len;
+	u32 sram2_len = mvm->cfg->dccm2_len;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	/* W/A for 8000 HW family A-step */
-	if (mvm->cfg->smem_len &&
-	    mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
-	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
-		smem_len = 0x38000;
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP) {
+		if (smem_len)
+			smem_len = 0x38000;
+
+		if (sram2_len)
+			sram2_len = 0x10000;
+	}
 
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
@@ -820,6 +825,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (smem_len)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + smem_len;
 
+	/* Make room for the secondary SRAM, if it exists */
+	if (sram2_len)
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + sram2_len;
+
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
@@ -884,6 +893,17 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 dump_mem->data, smem_len);
 	}
 
+	if (sram2_len) {
+		dump_data = iwl_fw_error_next_data(dump_data);
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		dump_data->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
+		dump_mem = (void *)dump_data->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+		dump_mem->offset = cpu_to_le32(mvm->cfg->dccm2_offset);
+		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->dccm2_offset,
+					 dump_mem->data, sram2_len);
+	}
+
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
 	fw_error_dump->op_mode_len = file_len;
 	if (fw_error_dump->trans_ptr)
-- 
1.9.1

