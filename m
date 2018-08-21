Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42814 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726602AbeHUJzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:43 +0300
Message-Id: <20180821063657.30071-2-luca@coelho.fi> (sfid-20180821_083712_341837_7E5E3A6D)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 01/15] iwlwifi: remove dump_regs() from transport ops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is used only within PCIe, and there's no reason to go through
the transport methods for a function call within PCIe itself.
Remove the dump_regs() method and call the function directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 11 -----------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  2 +-
 4 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 0b8cf7f3af93..dbac9ac80ce9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -539,9 +539,6 @@ struct iwl_trans_rxq_dma_data {
  * @dump_data: return a vmalloc'ed buffer with debug data, maybe containing last
  *	TX'ed commands and similar. The buffer will be vfree'd by the caller.
  *	Note that the transport must fill in the proper file headers.
- * @dump_regs: dump using IWL_ERR configuration space and memory mapped
- *	registers of the device to diagnose failure, e.g., when HW becomes
- *	inaccessible.
  */
 struct iwl_trans_ops {
 
@@ -612,8 +609,6 @@ struct iwl_trans_ops {
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
 						 const struct iwl_fw_dbg_trigger_tlv
 						 *trigger);
-
-	void (*dump_regs)(struct iwl_trans *trans);
 };
 
 /**
@@ -898,12 +893,6 @@ iwl_trans_dump_data(struct iwl_trans *trans,
 	return trans->ops->dump_data(trans, trigger);
 }
 
-static inline void iwl_trans_dump_regs(struct iwl_trans *trans)
-{
-	if (trans->ops->dump_regs)
-		trans->ops->dump_regs(trans);
-}
-
 static inline struct iwl_device_cmd *
 iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index cb43b194dc05..74442189d639 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -988,6 +988,7 @@ static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
 }
 
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
+void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7d319b6863fe..7cc438f31154 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -92,7 +92,7 @@
 #define IWL_FW_MEM_EXTENDED_START	0x40000
 #define IWL_FW_MEM_EXTENDED_END		0x57FFF
 
-static void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
+void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
 {
 #define PCI_DUMP_SIZE	64
 #define PREFIX_LEN	32
@@ -3175,7 +3175,6 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 	.ref = iwl_trans_pcie_ref,					\
 	.unref = iwl_trans_pcie_unref,					\
 	.dump_data = iwl_trans_pcie_dump_data,				\
-	.dump_regs = iwl_trans_pcie_dump_regs,				\
 	.d3_suspend = iwl_trans_pcie_d3_suspend,			\
 	.d3_resume = iwl_trans_pcie_d3_resume
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index da8e0e7c7844..debff193016e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1912,7 +1912,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	}
 
 	if (test_bit(STATUS_FW_ERROR, &trans->status)) {
-		iwl_trans_dump_regs(trans);
+		iwl_trans_pcie_dump_regs(trans);
 		IWL_ERR(trans, "FW error in SYNC CMD %s\n",
 			iwl_get_cmd_string(trans, cmd->id));
 		dump_stack();
-- 
2.18.0
