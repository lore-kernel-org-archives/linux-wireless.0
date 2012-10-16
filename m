Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2JPSPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/8] iwlwifi: wipe out the status of the SCD when we disable a queue
Date: Tue, 16 Oct 2012 20:16:16 +0200
Message-Id: <1350411380-2391-5-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201554_362902_BF40059C)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we disable a queue, we don't want the SCD to remember anything
about this queue (what packet was transmitted but not acked, what
packed was acked etc...).
Wipe out all this data in its SRAM.

Constify the arguments to iwl_write_targ_mem_dwords on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h |    3 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c  |    6 ++++++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 3dfebfb..54c41b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -327,11 +327,11 @@ u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr)
 EXPORT_SYMBOL_GPL(iwl_read_targ_mem);
 
 int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       void *buf, int dwords)
+			       const void *buf, int dwords)
 {
 	unsigned long flags;
 	int offs, result = 0;
-	u32 *vals = buf;
+	const u32 *vals = buf;
 
 	spin_lock_irqsave(&trans->reg_lock, flags);
 	if (likely(iwl_grab_nic_access(trans))) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 50d3819..e1aa69f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -87,7 +87,7 @@ void _iwl_read_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
 	} while (0)
 
 int _iwl_write_targ_mem_dwords(struct iwl_trans *trans, u32 addr,
-			       void *buf, int dwords);
+			       const void *buf, int dwords);
 
 u32 iwl_read_targ_mem(struct iwl_trans *trans, u32 addr);
 int iwl_write_targ_mem(struct iwl_trans *trans, u32 addr, u32 val);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 9253ef1..c3a4bb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -213,6 +213,9 @@
 #define SCD_CONTEXT_QUEUE_OFFSET(x)\
 	(SCD_CONTEXT_MEM_LOWER_BOUND + ((x) * 8))
 
+#define SCD_TX_STTS_QUEUE_OFFSET(x)\
+	(SCD_TX_STTS_MEM_LOWER_BOUND + ((x) * 16))
+
 #define SCD_TRANS_TBL_OFFSET_QUEUE(x) \
 	((SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index b50d1b4..f3c23af 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -481,6 +481,9 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u16 rd_ptr, wr_ptr;
+	u32 stts_addr = trans_pcie->scd_base_addr +
+			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
+	static const u32 zero_val[4] = {};
 	int n_bd = trans_pcie->txq[txq_id].q.n_bd;
 
 	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
@@ -494,6 +497,9 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 	WARN_ONCE(rd_ptr != wr_ptr, "queue %d isn't empty: [%d,%d]",
 		  txq_id, rd_ptr, wr_ptr);
 
+	_iwl_write_targ_mem_dwords(trans, stts_addr,
+				   zero_val, ARRAY_SIZE(zero_val));
+
 	iwl_txq_set_inactive(trans, txq_id);
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
-- 
1.7.10.4

