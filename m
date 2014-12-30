Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaL3OTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/33] iwlwifi: mvm: add smem content to dump data
Date: Tue, 30 Dec 2014 16:18:47 +0200
Message-Id: <1419949148-24046-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151958_109595_690F13F7)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In NICs that have SMEM - add its content to the dump data
for later debug.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c          |  8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-config.h        |  4 ++++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 19 +++++++++++++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 8f64928..46e9c9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -81,9 +81,11 @@
 #define IWL8000_NVM_VERSION		0x0a1d
 #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
 
-/* DCCM offsets and lengths */
+/* Memory offsets and lengths */
 #define IWL8260_DCCM_OFFSET		0x800000
 #define IWL8260_DCCM_LEN		0x18000
+#define IWL8260_SMEM_OFFSET		0x400000
+#define IWL8260_SMEM_LEN		0x68000
 
 #define IWL8000_FW_PRE "iwlwifi-8000"
 #define IWL8000_MODULE_FIRMWARE(api) \
@@ -131,7 +133,9 @@ static const struct iwl_ht_params iwl8000_ht_params = {
 	.d0i3 = true,						\
 	.non_shared_ant = ANT_A,				\
 	.dccm_offset = IWL8260_DCCM_OFFSET,			\
-	.dccm_len = IWL8260_DCCM_LEN
+	.dccm_len = IWL8260_DCCM_LEN,				\
+	.smem_offset = IWL8260_SMEM_OFFSET,			\
+	.smem_len = IWL8260_SMEM_LEN
 
 const struct iwl_cfg iwl8260_2n_cfg = {
 	.name = "Intel(R) Dual Band Wireless N 8260",
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 2daabab..3985051 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -263,6 +263,8 @@ struct iwl_pwr_tx_backoff {
  *	station can receive in VHT
  * @dccm_offset: offset from which DCCM begins
  * @dccm_len: length of DCCM (including runtime stack CCM)
+ * @smem_offset: offset from which the SMEM begins
+ * @smem_len: the length of SMEM
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -308,6 +310,8 @@ struct iwl_cfg {
 	unsigned int max_vht_ampdu_exponent;
 	const u32 dccm_offset;
 	const u32 dccm_len;
+	const u32 smem_offset;
+	const u32 smem_len;
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 20a8a64..c6a81a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -82,6 +82,7 @@
  * @IWL_FW_ERROR_DUMP_PRPH: range of periphery registers - there can be several
  *	sections like this in a single file.
  * @IWL_FW_ERROR_DUMP_FH_REGS: range of FH registers
+ * @IWL_FW_ERROR_DUMP_SMEM:
  */
 enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_SRAM = 0,
@@ -93,6 +94,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_PRPH = 6,
 	IWL_FW_ERROR_DUMP_TXF = 7,
 	IWL_FW_ERROR_DUMP_FH_REGS = 8,
+	IWL_FW_ERROR_DUMP_SMEM = 9,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f53bfd6..d5d1cda 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -774,9 +774,16 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	u32 file_len, rxf_len;
 	unsigned long flags;
 	int reg_val;
+	u32 smem_len = mvm->cfg->smem_len;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/* W/A for 8000 HW family A-step */
+	if (mvm->cfg->smem_len &&
+	    mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_A_STEP)
+		smem_len = 0x38000;
+
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
 		return;
@@ -806,6 +813,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   rxf_len +
 		   sizeof(*dump_info);
 
+	/* Make room for the SMEM, if it exists */
+	if (smem_len)
+		file_len += sizeof(*dump_data) + smem_len;
+
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
@@ -856,6 +867,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	iwl_trans_read_mem_bytes(mvm->trans, sram_ofs, dump_data->data,
 				 sram_len);
 
+	if (smem_len) {
+		dump_data = iwl_fw_error_next_data(dump_data);
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_SMEM);
+		dump_data->len = cpu_to_le32(smem_len);
+		iwl_trans_read_mem_bytes(mvm->trans, mvm->cfg->smem_offset,
+					 dump_data->data, smem_len);
+	}
+
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
 	fw_error_dump->op_mode_len = file_len;
 	if (fw_error_dump->trans_ptr)
-- 
1.9.1

