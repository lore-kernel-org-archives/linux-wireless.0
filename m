Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbDBGlc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/31] iwlwifi: mvm: add iccm data to 8000 b-step data dump
Date: Thu,  2 Apr 2015 09:40:53 +0300
Message-Id: <1427956879-11725-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084135_499887_2388EE78)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In 8000 HW family B-step only, the ICCM is separate
from the SRAM. This adds the ICCM to the dump data
collected for FW debug.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index babe892..a3a84d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1007,6 +1007,9 @@ void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
 	mvm->fw_dump_desc = NULL;
 }
 
+#define IWL8260_ICCM_OFFSET		0x44000 /* Only for B-step */
+#define IWL8260_ICCM_LEN		0xC000 /* Only for B-step */
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
@@ -1083,6 +1086,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   fifo_data_len +
 		   sizeof(*dump_info);
 
+	/*
+	 * In 8000 HW family B-step include the ICCM (which resides separately)
+	 */
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP)
+		file_len += sizeof(*dump_data) + sizeof(*dump_mem) +
+			    IWL8260_ICCM_LEN;
+
 	if (mvm->fw_dump_desc)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    mvm->fw_dump_desc->len;
@@ -1170,6 +1181,19 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 dump_mem->data, sram2_len);
 	}
 
+	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_8000 &&
+	    CSR_HW_REV_STEP(mvm->trans->hw_rev) == SILICON_B_STEP) {
+		dump_data = iwl_fw_error_next_data(dump_data);
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+		dump_data->len = cpu_to_le32(IWL8260_ICCM_LEN +
+					     sizeof(*dump_mem));
+		dump_mem = (void *)dump_data->data;
+		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
+		dump_mem->offset = cpu_to_le32(IWL8260_ICCM_OFFSET);
+		iwl_trans_read_mem_bytes(mvm->trans, IWL8260_ICCM_OFFSET,
+					 dump_mem->data, IWL8260_ICCM_LEN);
+	}
+
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans);
 	fw_error_dump->op_mode_len = file_len;
 	if (fw_error_dump->trans_ptr)
-- 
1.9.1

