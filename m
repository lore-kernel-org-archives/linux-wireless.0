Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52134 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752207AbeF3NXo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 09:23:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 16:23:23 +0300
Message-Id: <20180630132330.14928-9-luca@coelho.fi> (sfid-20180630_152357_200641_CAB8325C)
In-Reply-To: <20180630132330.14928-1-luca@coelho.fi>
References: <20180630132330.14928-1-luca@coelho.fi>
Subject: [PATCH 08/15] iwlwifi: pcie: start early debug for 22560 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

In 22560 devices we can start debug using context info gen3. Configure
the fw to start collecting logs to the dram before init.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  | 15 ++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/internal.h    |  3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index fc926354e573..2146fda8da2f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -84,13 +84,22 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	control_flags = IWL_PRPH_SCRATCH_RB_SIZE_4K |
 			IWL_PRPH_SCRATCH_MTR_MODE |
 			(IWL_PRPH_MTR_FORMAT_256B &
-			 IWL_PRPH_SCRATCH_MTR_FORMAT);
+			 IWL_PRPH_SCRATCH_MTR_FORMAT) |
+			IWL_PRPH_SCRATCH_EARLY_DEBUG_EN |
+			IWL_PRPH_SCRATCH_EDBG_DEST_DRAM;
 	prph_sc_ctrl->control.control_flags = cpu_to_le32(control_flags);
 
 	/* initialize RX default queue */
 	prph_sc_ctrl->rbd_cfg.free_rbd_addr =
 		cpu_to_le64(trans_pcie->rxq->bd_dma);
 
+	/* Configure debug, for integration */
+	iwl_pcie_alloc_fw_monitor(trans, 0);
+	prph_sc_ctrl->hwm_cfg.hwm_base_addr =
+		cpu_to_le64(trans_pcie->fw_mon_phys);
+	prph_sc_ctrl->hwm_cfg.hwm_size =
+		cpu_to_le32(trans_pcie->fw_mon_size);
+
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &prph_scratch->dram);
 	if (ret) {
@@ -157,10 +166,6 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
 	iwl_enable_interrupts(trans);
 
-	/* Configure debug, if exists */
-	if (trans->dbg_dest_tlv)
-		iwl_pcie_apply_destination(trans);
-
 	/* kick FW self load */
 	iwl_write64(trans, CSR_CTXT_INFO_ADDR,
 		    trans_pcie->ctxt_info_dma_addr);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 5db9ded4bb23..e14d2003244f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -895,6 +895,9 @@ void iwl_pcie_free_tso_page(struct iwl_trans_pcie *trans_pcie,
 struct iwl_tso_hdr_page *get_page_hdr(struct iwl_trans *trans, size_t len);
 #endif
 
+/* common functions that are used by gen3 transport */
+void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power);
+
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 				 const struct fw_img *fw, bool run_in_rfkill);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e0398ef07388..bc14227c95ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -203,7 +203,7 @@ static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 	trans_pcie->fw_mon_size = 0;
 }
 
-static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
+void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct page *page = NULL;
-- 
2.18.0
