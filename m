Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:47:02 +0300
Message-Id: <20170915124704.9032-9-luca@coelho.fi> (sfid-20170915_144733_657278_2DBB33FB)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 08/10] iwlwifi: Add few debug prints to the WRT dump flow
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

This would enable to better catch timing issues with
cases that WRT dump takes too much time.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6afc7a799892..f7eab03937f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -93,6 +93,8 @@ static void iwl_read_radio_regs(struct iwl_fw_runtime *fwrt,
 	unsigned long flags;
 	int i;
 
+	IWL_DEBUG_INFO(fwrt, "WRT radio registers dump\n");
+
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
@@ -233,6 +235,8 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 	unsigned long flags;
 	int i, j;
 
+	IWL_DEBUG_INFO(fwrt, "WRT FIFO dump\n");
+
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
@@ -476,6 +480,8 @@ static void iwl_dump_prph(struct iwl_trans *trans,
 	unsigned long flags;
 	u32 i;
 
+	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
+
 	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return;
 
@@ -559,6 +565,8 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	bool monitor_dump_only = false;
 	int i;
 
+	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
+
 	/* there's no point in fw dump if the bus is dead */
 	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
 		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
@@ -816,6 +824,9 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		dump_mem->type = fw_dbg_mem[i].data_type;
 		dump_mem->offset = cpu_to_le32(ofs);
 
+		IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n",
+			       dump_mem->type);
+
 		switch (dump_mem->type & cpu_to_le32(FW_DBG_MEM_TYPE_MASK)) {
 		case cpu_to_le32(FW_DBG_MEM_TYPE_REGULAR):
 			iwl_trans_read_mem_bytes(fwrt->trans, ofs,
@@ -841,6 +852,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	if (smem_len) {
+		IWL_DEBUG_INFO(fwrt, "WRT SMEM dump\n");
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
@@ -853,6 +865,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	if (sram2_len) {
+		IWL_DEBUG_INFO(fwrt, "WRT SRAM dump\n");
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		dump_data->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
 		dump_mem = (void *)dump_data->data;
@@ -868,6 +881,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (!fwrt->trans->cfg->gen2 &&
 	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
 	    fwrt->fw_paging_db[0].fw_paging_block) {
+		IWL_DEBUG_INFO(fwrt, "WRT paging dump\n");
 		for (i = 1; i < fwrt->num_of_paging_blk + 1; i++) {
 			struct iwl_fw_error_dump_paging *paging;
 			struct page *pages =
@@ -930,6 +944,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	iwl_fw_free_dump_desc(fwrt);
 	fwrt->dump.trig = NULL;
 	clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
+	IWL_DEBUG_INFO(fwrt, "WRT dump done\n");
 }
 IWL_EXPORT_SYMBOL(iwl_fw_error_dump);
 
-- 
2.14.1
