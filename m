Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3APN6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] iwlwifi: simplify scheduler memory clearing
Date: Wed, 16 Jan 2013 14:58:37 +0100
Message-Id: <1358344719-26486-4-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145848_850721_2D12EA4C)
In-Reply-To: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
 <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Writing 130 dwords into the device one by one is
rather inefficient, every one needs to lock, grab
NIC access (a few register reads/writes) and then
write the address and data registers.

Use the new memory clearing function to make this
easier and faster.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 3ff3e8b..d3c4e8f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -641,9 +641,11 @@ static void iwl_pcie_txq_set_sched(struct iwl_trans *trans, u32 mask)
 void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 a;
+	int nq = trans->cfg->base_params->num_of_queues;
 	int chan;
 	u32 reg_val;
+	int clear_dwords = (SCD_TRANS_TBL_OFFSET_QUEUE(nq) -
+				SCD_CONTEXT_MEM_LOWER_BOUND) / sizeof(u32);
 
 	/* make sure all queue are not stopped/used */
 	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
@@ -655,20 +657,10 @@ void iwl_pcie_tx_start(struct iwl_trans *trans, u32 scd_base_addr)
 	WARN_ON(scd_base_addr != 0 &&
 		scd_base_addr != trans_pcie->scd_base_addr);
 
-	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
-	/* reset conext data memory */
-	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_trans_write_mem32(trans, a, 0);
-	/* reset tx status memory */
-	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_trans_write_mem32(trans, a, 0);
-	for (; a < trans_pcie->scd_base_addr +
-	       SCD_TRANS_TBL_OFFSET_QUEUE(
-				trans->cfg->base_params->num_of_queues);
-	       a += 4)
-		iwl_trans_write_mem32(trans, a, 0);
+	/* reset context data, TX status and translation data */
+	iwl_trans_write_mem(trans, trans_pcie->scd_base_addr +
+				   SCD_CONTEXT_MEM_LOWER_BOUND,
+			    NULL, clear_dwords);
 
 	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
-- 
1.8.0

