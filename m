Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1HZGxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 59/60] iwlagn: move the stop / wake queue logic to transport layer
Date: Thu, 25 Aug 2011 23:11:31 -0700
Message-Id: <1314339092-20797-60-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085352_602052_7BB38D51)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

priv->mac80211_registered and priv->hw needed to move to shared.
stop_queue API was added in order to allow the upper layer to stop
the SW queues for regulatory purposes.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    9 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |   61 ---------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 ++
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   61 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   14 ++++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    8 +++
 9 files changed, 93 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index 495f936..92ba8cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -209,7 +209,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 {
 	if (stop) {
 		IWL_DEBUG_TEMP(priv, "Stop all queues\n");
-		if (priv->mac80211_registered)
+		if (priv->shrd->mac80211_registered)
 			ieee80211_stop_queues(priv->hw);
 		IWL_DEBUG_TEMP(priv,
 				"Schedule 5 seconds CT_KILL Timer\n");
@@ -217,7 +217,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 			  jiffies + CT_KILL_EXIT_DURATION * HZ);
 	} else {
 		IWL_DEBUG_TEMP(priv, "Wake all queues\n");
-		if (priv->mac80211_registered)
+		if (priv->shrd->mac80211_registered)
 			ieee80211_wake_queues(priv->hw);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 9969a76..44e408e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -803,7 +803,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 			    iwl_is_associated_ctx(ctx) && ctx->vif &&
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
 				ctx->last_tx_rejected = true;
-				iwl_stop_queue(priv, &priv->txq[txq_id]);
+				iwl_trans_stop_queue(trans(priv), txq_id);
 
 				IWL_DEBUG_TX_REPLY(priv,
 					   "TXQ %d status %s (0x%08x) "
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5fdf9b1..a0cf486 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1519,7 +1519,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (!exit_pending)
 		clear_bit(STATUS_EXIT_PENDING, &priv->shrd->status);
 
-	if (priv->mac80211_registered)
+	if (priv->shrd->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
 	/* Clear out all status bits but a few that are stable across reset */
@@ -1863,7 +1863,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
 		return ret;
 	}
-	priv->mac80211_registered = 1;
+	priv->shrd->mac80211_registered = 1;
 
 	return 0;
 }
@@ -3243,6 +3243,7 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 	priv->shrd = &priv->_shrd;
 	priv->shrd->bus = bus;
 	priv->shrd->priv = priv;
+	priv->shrd->hw = hw;
 	bus_set_drv_data(priv->bus, priv->shrd);
 
 	priv->shrd->trans = trans_ops->alloc(priv->shrd);
@@ -3418,9 +3419,9 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_testmode_cleanup(priv);
 	iwl_leds_exit(priv);
 
-	if (priv->mac80211_registered) {
+	if (priv->shrd->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		priv->mac80211_registered = 0;
+		priv->shrd->mac80211_registered = 0;
 	}
 
 	iwl_tt_exit(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2e75429..08e8e1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1181,8 +1181,6 @@ struct iwl_priv {
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
 
-	u8 mac80211_registered;
-
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 	int    nvm_device_type;
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 7f92d14..d3feac9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -64,67 +64,6 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 	return --index & (n_bd - 1);
 }
 
-/*
- * we have 8 bits used like this:
- *
- * 7 6 5 4 3 2 1 0
- * | | | | | | | |
- * | | | | | | +-+-------- AC queue (0-3)
- * | | | | | |
- * | +-+-+-+-+------------ HW queue ID
- * |
- * +---------------------- unused
- */
-static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
-{
-	BUG_ON(ac > 3);   /* only have 2 bits */
-	BUG_ON(hwq > 31); /* only use 5 bits */
-
-	txq->swq_id = (hwq << 2) | ac;
-}
-
-static inline void iwl_wake_queue(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-
-	if (unlikely(!priv->mac80211_registered))
-		return;
-
-	if (test_and_clear_bit(hwq, priv->queue_stopped))
-		if (atomic_dec_return(&priv->queue_stop_count[ac]) <= 0)
-			ieee80211_wake_queue(priv->hw, ac);
-}
-
-static inline void iwl_stop_queue(struct iwl_priv *priv,
-				  struct iwl_tx_queue *txq)
-{
-	u8 queue = txq->swq_id;
-	u8 ac = queue & 3;
-	u8 hwq = (queue >> 2) & 0x1f;
-
-	if (unlikely(!priv->mac80211_registered))
-		return;
-
-	if (!test_and_set_bit(hwq, priv->queue_stopped))
-		if (atomic_inc_return(&priv->queue_stop_count[ac]) > 0)
-			ieee80211_stop_queue(priv->hw, ac);
-}
-
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
 static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 17a02a7..8b8cd54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -243,6 +243,12 @@ struct iwl_shared {
 	spinlock_t sta_lock;
 	struct mutex mutex;
 
+	/*these 2 shouldn't really be here, but they are needed for
+	 * iwl_queue_stop, which is called from the upper layer too
+	 */
+	u8 mac80211_registered;
+	struct ieee80211_hw *hw;
+
 	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index abb2ce6..255b326 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -240,4 +240,65 @@ static inline void iwl_enable_interrupts(struct iwl_trans *trans)
 	iwl_write32(bus(trans), CSR_INT_MASK, trans_pcie->inta_mask);
 }
 
+/*
+ * we have 8 bits used like this:
+ *
+ * 7 6 5 4 3 2 1 0
+ * | | | | | | | |
+ * | | | | | | +-+-------- AC queue (0-3)
+ * | | | | | |
+ * | +-+-+-+-+------------ HW queue ID
+ * |
+ * +---------------------- unused
+ */
+static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
+{
+	BUG_ON(ac > 3);   /* only have 2 bits */
+	BUG_ON(hwq > 31); /* only use 5 bits */
+
+	txq->swq_id = (hwq << 2) | ac;
+}
+
+static inline void iwl_wake_queue(struct iwl_trans *trans,
+				  struct iwl_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+
+	if (unlikely(!trans->shrd->mac80211_registered))
+		return;
+
+	if (test_and_clear_bit(hwq, priv(trans)->queue_stopped))
+		if (atomic_dec_return(&priv(trans)->queue_stop_count[ac]) <= 0)
+			ieee80211_wake_queue(trans->shrd->hw, ac);
+}
+
+static inline void iwl_stop_queue(struct iwl_trans *trans,
+				  struct iwl_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+
+	if (unlikely(!trans->shrd->mac80211_registered))
+		return;
+
+	if (!test_and_set_bit(hwq, priv(trans)->queue_stopped))
+		if (atomic_inc_return(&priv(trans)->queue_stop_count[ac]) > 0)
+			ieee80211_stop_queue(trans->shrd->hw, ac);
+}
+
+#ifdef ieee80211_stop_queue
+#undef ieee80211_stop_queue
+#endif
+
+#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
+
+#ifdef ieee80211_wake_queue
+#undef ieee80211_wake_queue
+#endif
+
+#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
+
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 6461704..cce57d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1228,7 +1228,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			txq->need_update = 1;
 			iwl_txq_update_write_ptr(trans, txq);
 		} else {
-			iwl_stop_queue(priv(trans), txq);
+			iwl_stop_queue(trans, txq);
 		}
 	}
 	return 0;
@@ -1286,7 +1286,7 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
 						   sta_id, tid);
-			iwl_wake_queue(priv(trans), &priv(trans)->txq[txq_id]);
+			iwl_wake_queue(trans, &priv(trans)->txq[txq_id]);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
@@ -1345,7 +1345,7 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 				ssn , tfd_num, txq_id, txq->swq_id);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
-			iwl_wake_queue(priv(trans), txq);
+			iwl_wake_queue(trans, txq);
 	}
 
 	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
@@ -1423,7 +1423,7 @@ static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 			ac,
 			(atomic_read(&priv(trans)->queue_stop_count[ac]) > 0)
 			      ? "stopped" : "awake");
-		iwl_wake_queue(priv(trans), &priv(trans)->txq[txq_id]);
+		iwl_wake_queue(trans, &priv(trans)->txq[txq_id]);
 	}
 }
 
@@ -1446,6 +1446,11 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 	return iwl_trans;
 }
 
+static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id)
+{
+	iwl_stop_queue(trans, &priv(trans)->txq[txq_id]);
+}
+
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
@@ -2078,6 +2083,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.kick_nic = iwl_trans_pcie_kick_nic,
 
 	.free = iwl_trans_pcie_free,
+	.stop_queue = iwl_trans_pcie_stop_queue,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 6edf2e0..7a2daa8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -101,6 +101,7 @@ struct iwl_device_cmd;
  * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
+ * @stop_queue: stop a specific queue
  * @check_stuck_queue: check if a specific queue is stuck
  * @wait_tx_queue_empty: wait until all tx queues are empty
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
@@ -143,6 +144,8 @@ struct iwl_trans_ops {
 
 	void (*free)(struct iwl_trans *trans);
 
+	void (*stop_queue)(struct iwl_trans *trans, int q);
+
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
@@ -256,6 +259,11 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 	trans->ops->free(trans);
 }
 
+static inline void iwl_trans_stop_queue(struct iwl_trans *trans, int q)
+{
+	trans->ops->stop_queue(trans, q);
+}
+
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
 	return trans->ops->wait_tx_queue_empty(trans);
-- 
1.7.0.4

