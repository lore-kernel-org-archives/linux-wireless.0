Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50158 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S943303AbcJSOz0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 10:27:20 +0300
Message-Id: <20161019072726.22018-2-luca@coelho.fi> (sfid-20161019_165541_346612_EF91CB1C)
In-Reply-To: <20161019072726.22018-1-luca@coelho.fi>
References: <20161019072726.22018-1-luca@coelho.fi>
Subject: [PATCH 1/7] iwlwifi: pcie: mark command queue lock with separate lockdep class
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Emmanuel reports that when CMD_WANT_ASYNC_CALLBACK is used by mvm,
the callback will be called with the command queue lock held, and
mvm will try to stop all (other) TX queues, which acquires their
locks - this caused a false lockdep recursive locking report.

Suppress this report by marking the command queue lock with a new,
separate, lock class so lockdep can tell the difference between
the two types of queues.

Fixes: 156f92f2b471 ("iwlwifi: block the queues when we send ADD_STA for uAPSD")
Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index e9a278b..5f840f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -592,6 +592,7 @@ error:
 static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 			      int slots_num, u32 txq_id)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 
 	txq->need_update = false;
@@ -606,6 +607,13 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 		return ret;
 
 	spin_lock_init(&txq->lock);
+
+	if (txq_id == trans_pcie->cmd_queue) {
+		static struct lock_class_key iwl_pcie_cmd_queue_lock_class;
+
+		lockdep_set_class(&txq->lock, &iwl_pcie_cmd_queue_lock_class);
+	}
+
 	__skb_queue_head_init(&txq->overflow_q);
 
 	/*
-- 
2.9.3
