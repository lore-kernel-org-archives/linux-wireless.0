Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54156 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954156AbdDYUXI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:26 +0300
Message-Id: <20170425202243.7844-9-luca@coelho.fi> (sfid-20170425_222325_640640_22C0276A)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: pcie: support debug applying on a000 hw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Allow configuring debug destination on a000 HW.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c | 4 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h  | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 1d95512361b2..b1f43397bb59 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -251,6 +251,10 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 
 	iwl_enable_interrupts(trans);
 
+	/* Configure debug, if exists */
+	if (trans->dbg_dest_tlv)
+		iwl_pcie_apply_destination(trans);
+
 	/* kick FW self load */
 	iwl_write64(trans, CSR_CTXT_INFO_BA, trans_pcie->ctxt_info_dma_addr);
 	iwl_write_prph(trans, UREG_CPU_INIT_RUN, 1);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index b9e9e10c32fa..30835f06a6e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -778,6 +778,7 @@ int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
 			   struct iwl_dma_ptr *ptr, size_t size);
 void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr);
+void iwl_pcie_apply_destination(struct iwl_trans *trans);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 91f6030529b3..5120fbcfcaf2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -831,7 +831,7 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 	return 0;
 }
 
-static void iwl_pcie_apply_destination(struct iwl_trans *trans)
+void iwl_pcie_apply_destination(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	const struct iwl_fw_dbg_dest_tlv *dest = trans->dbg_dest_tlv;
-- 
2.11.0
