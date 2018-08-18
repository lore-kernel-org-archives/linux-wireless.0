Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42192 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbeHRLfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 07:35:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 18 Aug 2018 11:27:50 +0300
Message-Id: <20180818082750.28717-17-luca@coelho.fi> (sfid-20180818_102832_026671_07537229)
In-Reply-To: <20180818082750.28717-1-luca@coelho.fi>
References: <20180818082750.28717-1-luca@coelho.fi>
Subject: [PATCH 16/16] iwlwifi: pcie: make non-static hcmd and rx code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Allow other device generations to use the utilities that
are used to send and reclaim host commands and to allocate
rx, by making it non-static.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  8 ++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  2 +-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index da6d367de76e..cb43b194dc05 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -613,6 +613,7 @@ void iwl_trans_pcie_free(struct iwl_trans *trans);
 /*****************************************************
 * RX
 ******************************************************/
+int _iwl_pcie_rx_init(struct iwl_trans *trans);
 int iwl_pcie_rx_init(struct iwl_trans *trans);
 int iwl_pcie_gen2_rx_init(struct iwl_trans *trans);
 irqreturn_t iwl_pcie_msix_isr(int irq, void *data);
@@ -626,6 +627,7 @@ void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq);
 int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget);
 void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority,
 			    struct iwl_rxq *rxq);
+int iwl_pcie_rx_alloc(struct iwl_trans *trans);
 
 /*****************************************************
 * ICT - interrupt handling
@@ -658,11 +660,17 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
+void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx);
+void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
+				  struct iwl_txq *txq);
 void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 			    struct iwl_rx_cmd_buffer *rxb);
 void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs);
 void iwl_trans_pcie_tx_reset(struct iwl_trans *trans);
+void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
+				   struct iwl_txq *txq, u16 byte_cnt,
+				   int num_tbs);
 
 static inline u16 iwl_pcie_tfd_tb_get_len(struct iwl_trans *trans, void *_tfd,
 					  u8 idx)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index b82f7a0509ec..acae8f967912 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -776,7 +776,7 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 	return -ENOMEM;
 }
 
-static int iwl_pcie_rx_alloc(struct iwl_trans *trans)
+int iwl_pcie_rx_alloc(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rb_allocator *rba = &trans_pcie->rba;
@@ -1002,7 +1002,7 @@ int iwl_pcie_dummy_napi_poll(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-static int _iwl_pcie_rx_init(struct iwl_trans *trans)
+int _iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_rxq *def_rxq;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 9ce7b2072613..4a08f4eab1a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -87,9 +87,9 @@ void iwl_pcie_gen2_tx_stop(struct iwl_trans *trans)
 /*
  * iwl_pcie_txq_update_byte_tbl - Set up entry in Tx byte-count array
  */
-static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
-					  struct iwl_txq *txq, u16 byte_cnt,
-					  int num_tbs)
+void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
+				   struct iwl_txq *txq, u16 byte_cnt,
+				   int num_tbs)
 {
 	struct iwlagn_scd_bc_tbl *scd_bc_tbl = txq->bc_tbl.addr;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
@@ -127,8 +127,8 @@ static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans_pcie *trans_pcie,
 /*
  * iwl_pcie_gen2_txq_inc_wr_ptr - Send new write index to hardware
  */
-static void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
-					 struct iwl_txq *txq)
+void iwl_pcie_gen2_txq_inc_wr_ptr(struct iwl_trans *trans,
+				  struct iwl_txq *txq)
 {
 	lockdep_assert_held(&txq->lock);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 93f0d387688a..da8e0e7c7844 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1230,7 +1230,7 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
+void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans_pcie->txq[txq_id];
-- 
2.18.0
