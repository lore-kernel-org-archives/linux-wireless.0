Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbLUUws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 45/45] iwlwifi: bail out in case of bad trans state
Date: Mon, 21 Dec 2015 22:50:46 +0200
Message-Id: <1450731046-2796-45-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220100_008685_F2EF83AE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In case of bad trans state (i.e. fw is not loaded) bail
out immediately instead of calling the trans, which might
not be fully initialized yet.

Also add WARN_ON_ONCE to help debugging where the errorneous
call is coming from.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 290d538..81b7cb7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1001,8 +1001,10 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
 		return -EIO;
 
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return -EIO;
+	}
 
 	return trans->ops->tx(trans, skb, dev_cmd, queue);
 }
@@ -1010,8 +1012,10 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 				     int ssn, struct sk_buff_head *skbs)
 {
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return;
+	}
 
 	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
@@ -1029,8 +1033,10 @@ iwl_trans_txq_enable_cfg(struct iwl_trans *trans, int queue, u16 ssn,
 {
 	might_sleep();
 
-	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return;
+	}
 
 	trans->ops->txq_enable(trans, queue, ssn, cfg, queue_wdg_timeout);
 }
@@ -1070,8 +1076,10 @@ static inline void iwl_trans_freeze_txq_timer(struct iwl_trans *trans,
 					      unsigned long txqs,
 					      bool freeze)
 {
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return;
+	}
 
 	if (trans->ops->freeze_txq_timer)
 		trans->ops->freeze_txq_timer(trans, txqs, freeze);
@@ -1080,8 +1088,10 @@ static inline void iwl_trans_freeze_txq_timer(struct iwl_trans *trans,
 static inline void iwl_trans_block_txq_ptrs(struct iwl_trans *trans,
 					    bool block)
 {
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return;
+	}
 
 	if (trans->ops->block_txq_ptrs)
 		trans->ops->block_txq_ptrs(trans, block);
@@ -1090,8 +1100,10 @@ static inline void iwl_trans_block_txq_ptrs(struct iwl_trans *trans,
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 						u32 txqs)
 {
-	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+		return -EIO;
+	}
 
 	return trans->ops->wait_tx_queue_empty(trans, txqs);
 }
-- 
2.5.0

