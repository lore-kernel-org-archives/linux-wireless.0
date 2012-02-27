Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2B0XTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/24] iwlwifi: virtualize op_mode's stop/start queue
Date: Mon, 27 Feb 2012 14:07:35 -0800
Message-Id: <1330380468-17674-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002020_817366_9A463BD9)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Export them as "queue_full" and "queue_not_full" notification.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    3 +++
 drivers/net/wireless/iwlwifi/iwl-core.c           |    8 ++++++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |   17 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 +++--
 6 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bafa546..91aa83f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1386,6 +1386,8 @@ const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
 	.rx = iwl_rx_dispatch,
+	.queue_full = iwl_stop_sw_queue,
+	.queue_not_full = iwl_wake_sw_queue,
 	.free_skb = iwl_free_skb,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 337e098..db0e2ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -84,6 +84,9 @@ void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_rx_mem_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
+void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
+void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
+
 
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 675464a..2aa69e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1475,12 +1475,16 @@ void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-void iwl_stop_sw_queue(struct iwl_priv *priv, u8 ac)
+void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
 	ieee80211_stop_queue(priv->hw, ac);
 }
 
-void iwl_wake_sw_queue(struct iwl_priv *priv, u8 ac)
+void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
 	ieee80211_wake_queue(priv->hw, ac);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index b0272fd..c1664e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -80,6 +80,10 @@ struct iwl_rx_mem_buffer;
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD the this Rx responds to.
+ * @queue_full: notifies that a HW queue is full. Ac is the ac of the queue
+ *	Must be atomic
+ * @queue_not_full: notifies that a HW queue is not full any more.
+ *	Ac is the ac of the queue. Must be atomic
  * @free_skb: allows the transport layer to free skbs that haven't been
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
@@ -90,6 +94,8 @@ struct iwl_op_mode_ops {
 	void (*stop)(struct iwl_op_mode *op_mode);
 	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_mem_buffer *rxb,
 		  struct iwl_device_cmd *cmd);
+	void (*queue_full)(struct iwl_op_mode *op_mode, u8 ac);
+	void (*queue_not_full)(struct iwl_op_mode *op_mode, u8 ac);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 };
 
@@ -119,6 +125,17 @@ static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
 	return op_mode->ops->rx(op_mode, rxb, cmd);
 }
 
+static inline void iwl_op_mode_queue_full(struct iwl_op_mode *op_mode, u8 ac)
+{
+	op_mode->ops->queue_full(op_mode, ac);
+}
+
+static inline void iwl_op_mode_queue_not_full(struct iwl_op_mode *op_mode,
+					      u8 ac)
+{
+	op_mode->ops->queue_not_full(op_mode, ac);
+}
+
 static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
 					struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index b63423f..0a3f6fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -539,8 +539,6 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
-void iwl_stop_sw_queue(struct iwl_priv *priv, u8 ac);
-void iwl_wake_sw_queue(struct iwl_priv *priv, u8 ac);
 
 /* notification wait support */
 void iwl_abort_notification_waits(struct iwl_shared *shrd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 8c30fea..5b26b71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -40,6 +40,7 @@
 #include "iwl-trans.h"
 #include "iwl-debug.h"
 #include "iwl-io.h"
+#include "iwl-op-mode.h"
 
 struct iwl_tx_queue;
 struct iwl_queue;
@@ -374,7 +375,7 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 
 	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped)) {
 		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0) {
-			iwl_wake_sw_queue(priv(trans), ac);
+			iwl_op_mode_queue_not_full(trans->op_mode, ac);
 			IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d ac %d. %s",
 					    hwq, ac, msg);
 		} else {
@@ -397,7 +398,7 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 
 	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped)) {
 		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0) {
-			iwl_stop_sw_queue(priv(trans), ac);
+			iwl_op_mode_queue_full(trans->op_mode, ac);
 			IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d ac %d"
 					    " stop count %d. %s",
 					    hwq, ac, atomic_read(&trans_pcie->
-- 
1.7.0.4

