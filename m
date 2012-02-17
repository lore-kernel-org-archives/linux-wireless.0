Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab2BQUXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:55 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/26] iwlwifi: the transport knows its state
Date: Fri, 17 Feb 2012 11:13:49 -0800
Message-Id: <1329506034-1394-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212401_226166_EEED5C52)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to handle races such as Tx packets on their way to be
sent although the transport has been stopped already.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |   49 ++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 2a2941f..20b50a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -69,6 +69,7 @@
 #include "iwl-shared.h"
 #include "iwl-commands.h"
 #include "iwl-ucode.h"
+#include "iwl-debug.h"
 
 /**
  * DOC: Transport layer - what is it ?
@@ -297,6 +298,17 @@ struct iwl_calib_result {
 };
 
 /**
+ * enum iwl_trans_state - state of the transport layer
+ *
+ * @IWL_TRANS_NO_FW: no fw has sent an alive response
+ * @IWL_TRANS_FW_ALIVE: a fw has sent an alive response
+ */
+enum iwl_trans_state {
+	IWL_TRANS_NO_FW = 0,
+	IWL_TRANS_FW_ALIVE	= 1,
+};
+
+/**
  * struct iwl_trans - transport common data
  *
  * @ops - pointer to iwl_trans_ops
@@ -319,6 +331,7 @@ struct iwl_calib_result {
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
 	struct iwl_shared *shrd;
+	enum iwl_trans_state state;
 	spinlock_t hcmd_lock;
 	spinlock_t reg_lock;
 
@@ -352,6 +365,8 @@ static inline void iwl_trans_stop_hw(struct iwl_trans *trans)
 	might_sleep();
 
 	trans->ops->stop_hw(trans);
+
+	trans->state = IWL_TRANS_NO_FW;
 }
 
 static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
@@ -359,6 +374,8 @@ static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
 	might_sleep();
 
 	trans->ops->fw_alive(trans);
+
+	trans->state = IWL_TRANS_FW_ALIVE;
 }
 
 static inline int iwl_trans_start_fw(struct iwl_trans *trans, struct fw_img *fw)
@@ -373,12 +390,17 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 	might_sleep();
 
 	trans->ops->stop_device(trans);
+
+	trans->state = IWL_TRANS_NO_FW;
 }
 
 static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
 					    enum iwl_rxon_context_id ctx,
 					    const char *msg)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	trans->ops->wake_any_queue(trans, ctx, msg);
 }
 
@@ -386,6 +408,9 @@ static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->send_cmd(trans, cmd);
 }
 
@@ -396,6 +421,9 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id, u8 tid)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->tx(trans, skb, dev_cmd, ctx, sta_id, tid);
 }
 
@@ -403,6 +431,9 @@ static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 				 int tid, int txq_id, int ssn, u32 status,
 				 struct sk_buff_head *skbs)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn,
 				   status, skbs);
 }
@@ -412,6 +443,9 @@ static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 {
 	might_sleep();
 
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->tx_agg_disable(trans, sta_id, tid);
 }
 
@@ -420,6 +454,9 @@ static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
 {
 	might_sleep();
 
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->tx_agg_alloc(trans, sta_id, tid);
 }
 
@@ -431,6 +468,9 @@ static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
 {
 	might_sleep();
 
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit, ssn);
 }
 
@@ -442,16 +482,25 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 static inline void iwl_trans_stop_queue(struct iwl_trans *trans, int q,
 					const char *msg)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	trans->ops->stop_queue(trans, q, msg);
 }
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->wait_tx_queue_empty(trans);
 }
 
 static inline int iwl_trans_check_stuck_queue(struct iwl_trans *trans, int q)
 {
+	if (trans->state != IWL_TRANS_FW_ALIVE)
+		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
+
 	return trans->ops->check_stuck_queue(trans, q);
 }
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
-- 
1.7.0.4

