Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2FTHiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/12] iwlwifi: print the scratch of all the buffers stuck in a queue
Date: Wed, 20 Jun 2012 09:38:04 +0200
Message-Id: <1340177894-12992-3-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093841_566684_1DD9F94F)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index cc93516..c6f53af 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -296,6 +296,7 @@ static void iwlagn_free_dma_ptr(struct iwl_trans *trans,
 static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 {
 	struct iwl_tx_queue *txq = (void *)data;
+	struct iwl_queue *q = &txq->q;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
 	u32 scd_sram_addr = trans_pcie->scd_base_addr +
@@ -346,6 +347,14 @@ static void iwl_trans_pcie_queue_stuck_timer(unsigned long data)
 			iwl_read_prph(trans, SCD_QUEUE_WRPTR(i)));
 	}
 
+	for (i = q->read_ptr; i != q->write_ptr;
+	     i = iwl_queue_inc_wrap(i, q->n_bd)) {
+		struct iwl_tx_cmd *tx_cmd =
+			(struct iwl_tx_cmd *)txq->entries[i].cmd->payload;
+		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
+			get_unaligned_le32(&tx_cmd->scratch));
+	}
+
 	iwl_op_mode_nic_error(trans->op_mode);
 }
 
-- 
1.7.10

