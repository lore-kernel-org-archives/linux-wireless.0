Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2JPSPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/8] iwlwifi: don't WARN when a non empty queue is disabled
Date: Tue, 16 Oct 2012 20:16:20 +0200
Message-Id: <1350411380-2391-9-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201604_772925_7DEC2783)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can happen when we shut down suddenly an interface.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 39ead8c..db3efbb 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -480,11 +480,9 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u16 rd_ptr, wr_ptr;
 	u32 stts_addr = trans_pcie->scd_base_addr +
 			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 	static const u32 zero_val[4] = {};
-	int n_bd = trans_pcie->txq[txq_id].q.n_bd;
 
 	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
 		WARN_ONCE(1, "queue %d not used", txq_id);
@@ -493,12 +491,6 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 
 	iwl_txq_set_inactive(trans, txq_id);
 
-	rd_ptr = iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) & (n_bd - 1);
-	wr_ptr = iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id));
-
-	WARN_ONCE(rd_ptr != wr_ptr, "queue %d isn't empty: [%d,%d]",
-		  txq_id, rd_ptr, wr_ptr);
-
 	_iwl_write_targ_mem_dwords(trans, stts_addr,
 				   zero_val, ARRAY_SIZE(zero_val));
 
-- 
1.7.10.4

