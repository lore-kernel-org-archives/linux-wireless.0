Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3JIN00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 09:26:26 -0400
Date: Wed, 9 Oct 2013 15:24:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: don't WARN on bad firmware state
Message-ID: <20131009132429.GA1265@redhat.com> (sfid-20131009_152630_515790_A7BF840B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we restart firmware and it is marked as not alive, we can still get
calls from mac80211. Don't WARN on in this situation as this triggers
automatic bug reports with no valuable information.

This continuation of:

commit 8ca95995e64f5d270889badb3e449dca91106a2b
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Sun Sep 15 11:37:17 2013 +0300

    iwlwifi: don't WARN on host commands sent when firmware is dead

which remove WARN_ONCE from one place, but those warnings are also
triggered from other functions.

Patch also adds unlikely() statement.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 80b4750..c6bac7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -601,7 +601,7 @@ static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 {
 	int ret;
 
-	if (trans->state != IWL_TRANS_FW_ALIVE) {
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 		return -EIO;
 	}
@@ -640,8 +640,8 @@ static inline void iwl_trans_free_tx_cmd(struct iwl_trans *trans,
 static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			       struct iwl_device_cmd *dev_cmd, int queue)
 {
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->tx(trans, skb, dev_cmd, queue);
 }
@@ -649,16 +649,16 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 				     int ssn, struct sk_buff_head *skbs)
 {
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
 	trans->ops->reclaim(trans, queue, ssn, skbs);
 }
 
 static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue)
 {
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
 	trans->ops->txq_disable(trans, queue);
 }
@@ -669,8 +669,8 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 {
 	might_sleep();
 
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (unlikely((trans->state != IWL_TRANS_FW_ALIVE)))
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
 	trans->ops->txq_enable(trans, queue, fifo, sta_id, tid,
 				 frame_limit, ssn);
@@ -685,8 +685,8 @@ static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
-	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
-		  "%s bad state = %d", __func__, trans->state);
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->wait_tx_queue_empty(trans);
 }
-- 
1.7.1

