Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2CJU71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlwifi: convert bad state message into warning
Date: Sat, 10 Mar 2012 13:00:08 -0800
Message-Id: <1331413215-10027-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_220012_853048_42BE25B1)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Looking at logs, I see that we did get the bad
state message a few times for some reason, but
it doesn't indicate why or where it came from,
so make it a warning in order to identify it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 95f3faf..782cb0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -497,8 +497,8 @@ static inline void iwl_trans_wowlan_suspend(struct iwl_trans *trans)
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->send_cmd(trans, cmd);
 }
@@ -517,8 +517,8 @@ static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 				 int tid, int txq_id, int ssn,
 				 struct sk_buff_head *skbs)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, skbs);
 }
@@ -526,8 +526,8 @@ static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 					    int sta_id, int tid)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->tx_agg_disable(trans, sta_id, tid);
 }
@@ -535,8 +535,8 @@ static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
 					 int sta_id, int tid)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->tx_agg_alloc(trans, sta_id, tid);
 }
@@ -549,8 +549,8 @@ static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
 {
 	might_sleep();
 
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit, ssn);
 }
@@ -562,16 +562,16 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->wait_tx_queue_empty(trans);
 }
 
 static inline int iwl_trans_check_stuck_queue(struct iwl_trans *trans, int q)
 {
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
+		  "%s bad state = %d", __func__, trans->state);
 
 	return trans->ops->check_stuck_queue(trans, q);
 }
-- 
1.7.0.4

