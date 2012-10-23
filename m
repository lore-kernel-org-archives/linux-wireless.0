Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2JWN2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 09:28:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: don't leak Tx skb when a queue is disabled
Date: Tue, 23 Oct 2012 15:28:38 +0200
Message-Id: <1350998919-18645-1-git-send-email-johannes@sipsolutions.net> (sfid-20121023_152815_002257_1A86E6DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the queue might not be empty, we need to free the
pending Tx packets.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c    |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c       |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 401178f..6ce58f0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -346,6 +346,7 @@ void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		      enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 			 struct sk_buff_head *skbs);
+void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id);
 int iwl_queue_space(const struct iwl_queue *q);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f95d88d..a6a5181 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -442,10 +442,10 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	return 0;
 }
 
-/**
+/*
  * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
  */
-static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
+void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index db3efbb..5db0314 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -494,6 +494,8 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 	_iwl_write_targ_mem_dwords(trans, stts_addr,
 				   zero_val, ARRAY_SIZE(zero_val));
 
+	iwl_tx_queue_unmap(trans, txq_id);
+
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
 
-- 
1.7.10.4

