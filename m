Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965134AbbBCHOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/19] iwlwifi: pcie: don't dump useless data when a TFD queue hangs
Date: Tue,  3 Feb 2015 09:14:24 +0200
Message-Id: <1422947678-16917-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081455_729044_8F3E747F)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Printing all the scratch data of the TFDs of that queue is
useless and stuffed the kernel log with data. Remove that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index d40cd4a..6c7bfe8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -147,7 +147,6 @@ static void iwl_pcie_free_dma_ptr(struct iwl_trans *trans,
 static void iwl_pcie_txq_stuck_timer(unsigned long data)
 {
 	struct iwl_txq *txq = (void *)data;
-	struct iwl_queue *q = &txq->q;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
 	u32 scd_sram_addr = trans_pcie->scd_base_addr +
@@ -198,11 +197,6 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 			iwl_read_prph(trans, SCD_QUEUE_WRPTR(i)));
 	}
 
-	for (i = q->read_ptr; i != q->write_ptr;
-	     i = iwl_queue_inc_wrap(i))
-		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
-			le32_to_cpu(txq->scratchbufs[i].scratch));
-
 	iwl_force_nmi(trans);
 }
 
-- 
1.9.1

