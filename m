Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42846 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbeHUJzz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:47 +0300
Message-Id: <20180821063657.30071-6-luca@coelho.fi> (sfid-20180821_083712_909073_AC656183)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 05/15] iwlwifi: pcie: store the default rxq number
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Store the default rxq number in a variable, so we won't need
to use the actual number in the code.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 74442189d639..c03de2bc5739 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -456,6 +456,7 @@ struct iwl_self_init_dram {
  * @ucode_write_complete: indicates that the ucode has been copied.
  * @ucode_write_waitq: wait queue for uCode load
  * @cmd_queue - command queue number
+ * @def_rx_queue - default rx queue number
  * @rx_buf_size: Rx buffer size
  * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @scd_set_active: should the transport configure the SCD for HCMD queue
@@ -536,6 +537,7 @@ struct iwl_trans_pcie {
 	u8 page_offs, dev_cmd_offs;
 
 	u8 cmd_queue;
+	u8 def_rx_queue;
 	u8 cmd_fifo;
 	unsigned int cmd_q_wdg_timeout;
 	u8 n_no_reclaim_cmds;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index acae8f967912..8075466aa4c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1271,7 +1271,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		index = SEQ_TO_INDEX(sequence);
 		cmd_index = iwl_pcie_get_cmd_index(txq, index);
 
-		if (rxq->id == 0)
+		if (rxq->id == trans_pcie->def_rx_queue)
 			iwl_op_mode_rx(trans->op_mode, &rxq->napi,
 				       &rxcb);
 		else
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7cc438f31154..631f0015102b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3276,6 +3276,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 				       PCIE_LINK_STATE_CLKPM);
 	}
 
+	trans_pcie->def_rx_queue = 0;
+
 	if (cfg->use_tfh) {
 		addr_size = 64;
 		trans_pcie->max_tbs = IWL_TFH_NUM_TBS;
-- 
2.18.0
