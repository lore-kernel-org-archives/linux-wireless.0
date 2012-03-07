Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab2CGTGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:31 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 07/35] iwlwifi: redesign PASSIVE_NO_RX workaround
Date: Wed,  7 Mar 2012 09:52:16 -0800
Message-Id: <1331142764-5750-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200734_794905_6E32AA01)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The PASSIVE_NO_RX workaround currently crosses
through the op_mode and transport layers, which
is a bit odd. This also isn't necessary, if the
transport simply reports when queues are full
(or no longer full) the op_mode can keep track
of this state, and report to mac80211 only what
*it* thinks is appropriate. What is appropriate
can then be based on whether queues should be
stopped to wait for RX or not.

This significantly simplifies the transport API,
it no longer needs to expose anything to stop a
queue, nor to wake "any" queue, this can all be
handled in the upper layer completely.

Also simplify the handling to not be dependent
on the context, that makes little sense as the
queues are shared and both contexts have to be
on the same channel anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    8 +---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    8 +---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   33 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    5 +--
 drivers/net/wireless/iwlwifi/iwl-core.c           |   14 --------
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   12 -------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   36 +-------------------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   36 ++-------------------
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    6 ++--
 11 files changed, 56 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 521c820..a9bdbad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -807,16 +807,12 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 	* sometimes even after already having transmitted frames for the
 	* association because the new RXON may reset the information.
 	*/
-	if (unlikely(ieee80211_is_beacon(fc))) {
+	if (unlikely(ieee80211_is_beacon(fc) && priv->passive_no_rx)) {
 		for_each_context(priv, ctx) {
-			if (!ctx->last_tx_rejected)
-				continue;
 			if (compare_ether_addr(hdr->addr3,
 					       ctx->active.bssid_addr))
 				continue;
-			ctx->last_tx_rejected = false;
-			iwl_trans_wake_any_queue(trans(priv), ctx->ctxid,
-				"channel got active");
+			iwlagn_lift_passive_no_rx(priv);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 9d955fa..66e9a71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -833,12 +833,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			 * not get stuck in this case either since it
 			 * can happen if userspace gets confused.
 			 */
-			if (ctx->last_tx_rejected) {
-				ctx->last_tx_rejected = false;
-				iwl_trans_wake_any_queue(trans(priv),
-							 ctx->ctxid,
-							 "Disassoc: flush queue");
-			}
+			iwlagn_lift_passive_no_rx(priv);
+
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 			if (ctx->ctxid == IWL_RXON_CTX_BSS)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 14a6bde..527fde0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1064,8 +1064,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		}
 
 		/*we can free until ssn % q.n_bd not inclusive */
-		WARN_ON(iwl_trans_reclaim(trans(priv), sta_id, tid, txq_id,
-				  ssn, status, &skbs));
+		WARN_ON(iwl_trans_reclaim(trans(priv), sta_id, tid,
+					  txq_id, ssn, &skbs));
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 
@@ -1086,9 +1086,9 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (status == TX_STATUS_FAIL_PASSIVE_NO_RX &&
 			    iwl_is_associated_ctx(ctx) && ctx->vif &&
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
-				ctx->last_tx_rejected = true;
-				iwl_trans_stop_queue(trans(priv), txq_id,
-					"Tx on passive channel");
+				/* block and stop all queues */
+				priv->passive_no_rx = true;
+				ieee80211_stop_queues(priv->hw);
 
 				IWL_DEBUG_TX_REPLY(priv,
 					   "TXQ %d status %s (0x%08x) "
@@ -1182,7 +1182,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
 	if (iwl_trans_reclaim(trans(priv), sta_id, tid, scd_flow,
-			      ba_resp_scd_ssn, 0, &reclaimed_skbs)) {
+			      ba_resp_scd_ssn, &reclaimed_skbs)) {
 		spin_unlock(&priv->sta_lock);
 		return 0;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 397faf9..29f40ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1427,6 +1427,39 @@ static void iwl_nic_config(struct iwl_op_mode *op_mode)
 	cfg(priv)->lib->nic_config(priv);
 }
 
+static void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	set_bit(ac, &priv->transport_queue_stop);
+	ieee80211_stop_queue(priv->hw, ac);
+}
+
+static void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
+{
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
+
+	clear_bit(ac, &priv->transport_queue_stop);
+
+	if (!priv->passive_no_rx)
+		ieee80211_wake_queue(priv->hw, ac);
+}
+
+void iwlagn_lift_passive_no_rx(struct iwl_priv *priv)
+{
+	int ac;
+
+	if (!priv->passive_no_rx)
+		return;
+
+	for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS; ac++) {
+		if (!test_bit(ac, &priv->transport_queue_stop))
+			ieee80211_wake_queue(priv->hw, ac);
+	}
+
+	priv->passive_no_rx = false;
+}
+
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 82930ef..b56498b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -84,14 +84,13 @@ void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
 				 struct iwl_rx_cmd_buffer *rxb,
 				 struct iwl_device_cmd *cmd);
-void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
-void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_set_hw_rfkill_state(struct iwl_op_mode *op_mode, bool state);
-void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac);
 void iwl_nic_error(struct iwl_op_mode *op_mode);
 
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
 
+void iwlagn_lift_passive_no_rx(struct iwl_priv *priv);
+
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
 int iwlagn_mac_setup_register(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6648c1b..c2e604b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1488,17 +1488,3 @@ void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 	kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
 	dev_kfree_skb_any(skb);
 }
-
-void iwl_stop_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
-{
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-
-	ieee80211_stop_queue(priv->hw, ac);
-}
-
-void iwl_wake_sw_queue(struct iwl_op_mode *op_mode, u8 ac)
-{
-	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
-
-	ieee80211_wake_queue(priv->hw, ac);
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d1e722b..7442970 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -670,8 +670,6 @@ struct iwl_rxon_context {
 		bool enabled, is_40mhz;
 		u8 extension_chan_offset;
 	} ht;
-
-	bool last_tx_rejected;
 };
 
 enum iwl_scan_type {
@@ -720,6 +718,9 @@ struct iwl_priv {
 	spinlock_t sta_lock;
 	struct mutex mutex;
 
+	unsigned long transport_queue_stop;
+	bool passive_no_rx;
+
 	/* ieee device used by generic ieee processing code */
 	struct ieee80211_hw *hw;
 	struct ieee80211_channel *ieee_channels;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index d13b8d1..4f73a6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -451,18 +451,6 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 	}
 }
 
-#ifdef ieee80211_stop_queue
-#undef ieee80211_stop_queue
-#endif
-
-#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
-
-#ifdef ieee80211_wake_queue
-#undef ieee80211_wake_queue
-#endif
-
-#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
-
 static inline void iwl_txq_ctx_activate(struct iwl_trans_pcie *trans_pcie,
 					int txq_id)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 836e067..4844fb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1568,8 +1568,7 @@ static void iwl_trans_pcie_stop_hw(struct iwl_trans *trans)
 }
 
 static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
-		      int txq_id, int ssn, u32 status,
-		      struct sk_buff_head *skbs)
+		      int txq_id, int ssn, struct sk_buff_head *skbs)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
@@ -1602,9 +1601,7 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 				txq_id, iwl_get_queue_ac(txq), txq->q.read_ptr,
 				tfd_num, ssn);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
-		if (iwl_queue_space(&txq->q) > txq->q.low_mark &&
-		   (!txq->sched_retry ||
-		   status != TX_STATUS_FAIL_PASSIVE_NO_RX))
+		if (iwl_queue_space(&txq->q) > txq->q.low_mark)
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
 
@@ -1671,32 +1668,6 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
-					  enum iwl_rxon_context_id ctx,
-					  const char *msg)
-{
-	u8 ac, txq_id;
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	for (ac = 0; ac < AC_NUM; ac++) {
-		txq_id = trans_pcie->ac_to_queue[ctx][ac];
-		IWL_DEBUG_TX_QUEUES(trans, "Queue Status: Q[%d] %s\n",
-			ac,
-			(atomic_read(&trans_pcie->queue_stop_count[ac]) > 0)
-			      ? "stopped" : "awake");
-		iwl_wake_queue(trans, &trans_pcie->txq[txq_id], msg);
-	}
-}
-
-static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id,
-				      const char *msg)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-
-	iwl_stop_queue(trans, &trans_pcie->txq[txq_id], msg);
-}
-
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
@@ -2218,8 +2189,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.wowlan_suspend = iwl_trans_pcie_wowlan_suspend,
 
-	.wake_any_queue = iwl_trans_pcie_wake_any_queue,
-
 	.send_cmd = iwl_trans_pcie_send_cmd,
 
 	.tx = iwl_trans_pcie_tx,
@@ -2230,7 +2199,6 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
 	.free = iwl_trans_pcie_free,
-	.stop_queue = iwl_trans_pcie_stop_queue,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 15bb208..609949f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -289,7 +289,6 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	May sleep
  * @fw_alive: called when the fw sends alive notification
  *	May sleep
- * @wake_any_queue: wake all the queues of a specfic context IWL_RXON_CTX_*
  * @stop_device:stops the whole device (embedded CPU put to reset)
  *	May sleep
  * @wowlan_suspend: put the device into the correct mode for WoWLAN during
@@ -312,7 +311,6 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	irq, tasklet etc... From this point on, the device may not issue
  *	any interrupt (incl. RFKILL).
  *	May sleep
- * @stop_queue: stop a specific queue
  * @check_stuck_queue: check if a specific queue is stuck
  * @wait_tx_queue_empty: wait until all tx queues are empty
  *	May sleep
@@ -334,18 +332,13 @@ struct iwl_trans_ops {
 
 	void (*wowlan_suspend)(struct iwl_trans *trans);
 
-	void (*wake_any_queue)(struct iwl_trans *trans,
-			       enum iwl_rxon_context_id ctx,
-			       const char *msg);
-
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
 	int (*tx)(struct iwl_trans *trans, struct sk_buff *skb,
 		struct iwl_device_cmd *dev_cmd, enum iwl_rxon_context_id ctx,
 		u8 sta_id, u8 tid);
 	int (*reclaim)(struct iwl_trans *trans, int sta_id, int tid,
-			int txq_id, int ssn, u32 status,
-			struct sk_buff_head *skbs);
+			int txq_id, int ssn, struct sk_buff_head *skbs);
 
 	int (*tx_agg_disable)(struct iwl_trans *trans,
 			      int sta_id, int tid);
@@ -357,8 +350,6 @@ struct iwl_trans_ops {
 
 	void (*free)(struct iwl_trans *trans);
 
-	void (*stop_queue)(struct iwl_trans *trans, int q, const char *msg);
-
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
@@ -474,17 +465,6 @@ static inline void iwl_trans_wowlan_suspend(struct iwl_trans *trans)
 	trans->ops->wowlan_suspend(trans);
 }
 
-static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
-					    enum iwl_rxon_context_id ctx,
-					    const char *msg)
-{
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
-
-	trans->ops->wake_any_queue(trans, ctx, msg);
-}
-
-
 static inline int iwl_trans_send_cmd(struct iwl_trans *trans,
 				struct iwl_host_cmd *cmd)
 {
@@ -505,14 +485,13 @@ static inline int iwl_trans_tx(struct iwl_trans *trans, struct sk_buff *skb,
 }
 
 static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
-				 int tid, int txq_id, int ssn, u32 status,
+				 int tid, int txq_id, int ssn,
 				 struct sk_buff_head *skbs)
 {
 	if (trans->state != IWL_TRANS_FW_ALIVE)
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
-	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn,
-				   status, skbs);
+	return trans->ops->reclaim(trans, sta_id, tid, txq_id, ssn, skbs);
 }
 
 static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
@@ -554,15 +533,6 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 	trans->ops->free(trans);
 }
 
-static inline void iwl_trans_stop_queue(struct iwl_trans *trans, int q,
-					const char *msg)
-{
-	if (trans->state != IWL_TRANS_FW_ALIVE)
-		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
-
-	trans->ops->stop_queue(trans, q, msg);
-}
-
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
 	if (trans->state != IWL_TRANS_FW_ALIVE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 8267dbe..404fd8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -316,7 +316,6 @@ int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 static int iwl_alive_notify(struct iwl_priv *priv)
 {
-	struct iwl_rxon_context *ctx;
 	int ret;
 
 	if (!priv->tx_cmd_pool)
@@ -329,8 +328,9 @@ static int iwl_alive_notify(struct iwl_priv *priv)
 		return -ENOMEM;
 
 	iwl_trans_fw_alive(trans(priv));
-	for_each_context(priv, ctx)
-		ctx->last_tx_rejected = false;
+
+	priv->passive_no_rx = false;
+	priv->transport_queue_stop = 0;
 
 	ret = iwl_send_wimax_coex(priv);
 	if (ret)
-- 
1.7.0.4

