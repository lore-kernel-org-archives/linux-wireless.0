Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53184 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758191AbdJMNZT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Oct 2017 16:24:58 +0300
Message-Id: <20171013132502.10473-6-luca@coelho.fi> (sfid-20171013_152606_269992_EBAF0C70)
In-Reply-To: <20171013132502.10473-1-luca@coelho.fi>
References: <20171013132502.10473-1-luca@coelho.fi>
Subject: [PATCH 5/9] iwlwifi: mvm: move umac_error_event_table validity check to where it's set
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There's no point in checking the validity of the
umac_error_event_table pointer every time we generate a dump.  It's
cleaner to do so when we read the value, namely when we receive the
alive data.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c    | 13 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 18 ++++--------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f476882291ae..70d0505a176e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -200,10 +200,19 @@ static bool iwl_alive_fn(struct iwl_notif_wait_data *notif_wait,
 
 	mvm->umac_error_event_table = le32_to_cpu(umac->error_info_addr);
 
+	if (mvm->umac_error_event_table <
+	    (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000 ?
+	     0x400000 : 0x800000))
+		IWL_ERR(mvm,
+			"Not valid error log pointer 0x%08X for %s uCode\n",
+			mvm->umac_error_event_table,
+			(mvm->fwrt.cur_fw_img == IWL_UCODE_INIT) ?
+			"Init" : "RT");
+	else
+		mvm->support_umac_log = true;
+
 	alive_data->scd_base_addr = le32_to_cpu(lmac1->scd_base_ptr);
 	alive_data->valid = status == IWL_ALIVE_STATUS_OK;
-	if (mvm->umac_error_event_table)
-		mvm->support_umac_log = true;
 
 	IWL_DEBUG_FW(mvm,
 		     "Alive ucode status 0x%04x revision 0x%01X 0x%01X\n",
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 4ade688db63b..d46115e2d69e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -455,21 +455,12 @@ static void iwl_mvm_dump_umac_error_log(struct iwl_mvm *mvm)
 {
 	struct iwl_trans *trans = mvm->trans;
 	struct iwl_umac_error_event_table table;
-	u32 base;
 
-	base = mvm->umac_error_event_table;
-
-	if (base < (mvm->trans->cfg->device_family == IWL_DEVICE_FAMILY_A000 ?
-		    0x400000 : 0x800000)) {
-		IWL_ERR(mvm,
-			"Not valid error log pointer 0x%08X for %s uCode\n",
-			base,
-			(mvm->fwrt.cur_fw_img == IWL_UCODE_INIT)
-			? "Init" : "RT");
+	if (!mvm->support_umac_log)
 		return;
-	}
 
-	iwl_trans_read_mem_bytes(trans, base, &table, sizeof(table));
+	iwl_trans_read_mem_bytes(trans, mvm->umac_error_event_table, &table,
+				 sizeof(table));
 
 	if (ERROR_START_OFFSET <= table.valid * ERROR_ELEM_SIZE) {
 		IWL_ERR(trans, "Start IWL Error Log Dump:\n");
@@ -609,8 +600,7 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 	if (mvm->error_event_table[1])
 		iwl_mvm_dump_lmac_error_log(mvm, mvm->error_event_table[1]);
 
-	if (mvm->support_umac_log)
-		iwl_mvm_dump_umac_error_log(mvm);
+	iwl_mvm_dump_umac_error_log(mvm);
 }
 
 int iwl_mvm_find_free_queue(struct iwl_mvm *mvm, u8 sta_id, u8 minq, u8 maxq)
-- 
2.14.2
