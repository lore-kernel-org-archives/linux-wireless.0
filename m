Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2JPSPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/8] iwlwifi: first deactivate a queue, then wipe out its data
Date: Tue, 16 Oct 2012 20:16:18 +0200
Message-Id: <1350411380-2391-7-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201600_601503_9DDAE378)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Doing the opposite is wrong, the SCD wouldn't like someone
to clear its data while the queue is still active.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index f3c23af..39ead8c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -491,6 +491,8 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 		return;
 	}
 
+	iwl_txq_set_inactive(trans, txq_id);
+
 	rd_ptr = iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) & (n_bd - 1);
 	wr_ptr = iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id));
 
@@ -500,7 +502,6 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 	_iwl_write_targ_mem_dwords(trans, stts_addr,
 				   zero_val, ARRAY_SIZE(zero_val));
 
-	iwl_txq_set_inactive(trans, txq_id);
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
 
-- 
1.7.10.4

