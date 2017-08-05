Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42620 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdHEToy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:44:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:30 +0300
Message-Id: <20170805194331.17426-19-luca@coelho.fi> (sfid-20170805_220252_333764_7D725158)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 18/19] iwlwifi: pcie: free the TSO page when a Tx queue is unmapped on A000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we unmap a non-empty Tx queue, we need to free the
pages that we allocated for the headers in TSO flows.
This code existed for the 9000 device family, but somehow
it got left out when the new Tx path for the A000 devices
was written.

Fixes: 2b0c5946d9ed ("iwlwifi: pcie: introduce a000 TX queues management")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 9 +++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index a8ffd4ca8cd8..f46871840fd2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -806,6 +806,8 @@ int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
 			   struct iwl_dma_ptr *ptr, size_t size);
 void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr);
 void iwl_pcie_apply_destination(struct iwl_trans *trans);
+void iwl_pcie_free_tso_page(struct iwl_trans_pcie *trans_pcie,
+			    struct sk_buff *skb);
 #ifdef CONFIG_INET
 struct iwl_tso_hdr_page *get_page_hdr(struct iwl_trans *trans, size_t len);
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 83a28892dc4f..4db45e56b6ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -937,6 +937,15 @@ void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
 				   txq_id, txq->read_ptr);
 
+		if (txq_id != trans_pcie->cmd_queue) {
+			int idx = get_cmd_index(txq, txq->read_ptr);
+			struct sk_buff *skb = txq->entries[idx].skb;
+
+			if (WARN_ON_ONCE(!skb))
+				continue;
+
+			iwl_pcie_free_tso_page(trans_pcie, skb);
+		}
 		iwl_pcie_gen2_free_tfd(trans, txq);
 		txq->read_ptr = iwl_queue_inc_wrap(txq->read_ptr);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 073793a53d8e..1602ea1175c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -574,8 +574,8 @@ int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	return 0;
 }
 
-static void iwl_pcie_free_tso_page(struct iwl_trans_pcie *trans_pcie,
-				   struct sk_buff *skb)
+void iwl_pcie_free_tso_page(struct iwl_trans_pcie *trans_pcie,
+			    struct sk_buff *skb)
 {
 	struct page **page_ptr;
 
-- 
2.13.2
