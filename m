Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4406 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbbCLNGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/49] iwlwifi: pcie: allow the op_mode to freeze the stuck queue timer
Date: Thu, 12 Mar 2015 15:04:25 +0200
Message-Id: <1426165474-25586-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_705702_8AF4BF85)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the op_mode to let the transport know that a
queue is currently frozen and that its timer should be
stopped.
When the queue is unfrozen, its timer should be set to
expire after the remainder of the timeout has elapsed.
This can be used when stations go to sleep. When a station
goes to sleep, the op_mode can freeze the timer so that the
queue will never be considered as stuck. When the station
wakes up, the queue will be unfrozen.
This is meant to avoid false positives that would happen if
a buggy station goes to sleep for a very long time. In case
we have a dedicated queue for this station (BA agreement)
and it goes to sleep for a very long time, the queue would
rightfully be stopped during all that time. In this case,
the stuck queue timer could fire and that would be a false
positive.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 15 +++++++
 drivers/net/wireless/iwlwifi/pcie/internal.h |  4 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 61 ++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 12 ++++++
 4 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 542a681..11ac5c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -458,6 +458,8 @@ struct iwl_trans_txq_scd_cfg {
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
  * @wait_tx_queue_empty: wait until tx queues are empty. May sleep.
+ * @freeze_txq_timer: prevents the timer of the queue from firing until the
+ *	queue is set to awake. Must be atomic.
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
  *	automatically deleted.
  * @write8: write a u8 to a register at offset ofs from the BAR
@@ -517,6 +519,8 @@ struct iwl_trans_ops {
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans, u32 txq_bm);
+	void (*freeze_txq_timer)(struct iwl_trans *trans, unsigned long txqs,
+				 bool freeze);
 
 	void (*write8)(struct iwl_trans *trans, u32 ofs, u8 val);
 	void (*write32)(struct iwl_trans *trans, u32 ofs, u32 val);
@@ -873,6 +877,17 @@ void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue, int fifo,
 	iwl_trans_txq_enable_cfg(trans, queue, 0, &cfg, queue_wdg_timeout);
 }
 
+static inline void iwl_trans_freeze_txq_timer(struct iwl_trans *trans,
+					      unsigned long txqs,
+					      bool freeze)
+{
+	if (unlikely(trans->state != IWL_TRANS_FW_ALIVE))
+		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
+
+	if (trans->ops->freeze_txq_timer)
+		trans->ops->freeze_txq_timer(trans, txqs, freeze);
+}
+
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans,
 						u32 txqs)
 {
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index cae0eb8..01996c9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -217,6 +217,8 @@ struct iwl_pcie_txq_scratch_buf {
  * @active: stores if queue is active
  * @ampdu: true if this queue is an ampdu queue for an specific RA/TID
  * @wd_timeout: queue watchdog timeout (jiffies) - per queue
+ * @frozen: tx stuck queue timer is frozen
+ * @frozen_expiry_remainder: remember how long until the timer fires
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
@@ -228,9 +230,11 @@ struct iwl_txq {
 	dma_addr_t scratchbufs_dma;
 	struct iwl_pcie_txq_entry *entries;
 	spinlock_t lock;
+	unsigned long frozen_expiry_remainder;
 	struct timer_list stuck_timer;
 	struct iwl_trans_pcie *trans_pcie;
 	bool need_update;
+	bool frozen;
 	u8 active;
 	bool ampdu;
 	unsigned long wd_timeout;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 9ce5e61..dc24732 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1504,6 +1504,60 @@ static int iwl_trans_pcie_write_mem(struct iwl_trans *trans, u32 addr,
 	return ret;
 }
 
+static void iwl_trans_pcie_freeze_txq_timer(struct iwl_trans *trans,
+					    unsigned long txqs,
+					    bool freeze)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int queue;
+
+	for_each_set_bit(queue, &txqs, BITS_PER_LONG) {
+		struct iwl_txq *txq = &trans_pcie->txq[queue];
+		unsigned long now;
+
+		spin_lock_bh(&txq->lock);
+
+		now = jiffies;
+
+		if (txq->frozen == freeze)
+			goto next_queue;
+
+		IWL_DEBUG_TX_QUEUES(trans, "%s TXQ %d\n",
+				    freeze ? "Freezing" : "Waking", queue);
+
+		txq->frozen = freeze;
+
+		if (txq->q.read_ptr == txq->q.write_ptr)
+			goto next_queue;
+
+		if (freeze) {
+			if (unlikely(time_after(now,
+						txq->stuck_timer.expires))) {
+				/*
+				 * The timer should have fired, maybe it is
+				 * spinning right now on the lock.
+				 */
+				goto next_queue;
+			}
+			/* remember how long until the timer fires */
+			txq->frozen_expiry_remainder =
+				txq->stuck_timer.expires - now;
+			del_timer(&txq->stuck_timer);
+			goto next_queue;
+		}
+
+		/*
+		 * Wake a non-empty queue -> arm timer with the
+		 * remainder before it froze
+		 */
+		mod_timer(&txq->stuck_timer,
+			  now + txq->frozen_expiry_remainder);
+
+next_queue:
+		spin_unlock_bh(&txq->lock);
+	}
+}
+
 #define IWL_FLUSH_WAIT_MS	2000
 
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
@@ -1755,7 +1809,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int ret;
 	size_t bufsz;
 
-	bufsz = sizeof(char) * 64 * trans->cfg->base_params->num_of_queues;
+	bufsz = sizeof(char) * 75 * trans->cfg->base_params->num_of_queues;
 
 	if (!trans_pcie->txq)
 		return -EAGAIN;
@@ -1768,11 +1822,11 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u use=%d stop=%d need_update=%d%s\n",
+				"hwq %.2d: read=%u write=%u use=%d stop=%d need_update=%d frozen=%d%s\n",
 				cnt, q->read_ptr, q->write_ptr,
 				!!test_bit(cnt, trans_pcie->queue_used),
 				 !!test_bit(cnt, trans_pcie->queue_stopped),
-				 txq->need_update,
+				 txq->need_update, txq->frozen,
 				 (cnt == trans_pcie->cmd_queue ? " HCMD" : ""));
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
@@ -2348,6 +2402,7 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_txq_empty,
+	.freeze_txq_timer = iwl_trans_pcie_freeze_txq_timer,
 
 	.write8 = iwl_trans_pcie_write8,
 	.write32 = iwl_trans_pcie_write32,
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 26e6dd0..06952aa 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -929,10 +929,19 @@ error:
 
 static inline void iwl_pcie_txq_progress(struct iwl_txq *txq)
 {
+	lockdep_assert_held(&txq->lock);
+
 	if (!txq->wd_timeout)
 		return;
 
 	/*
+	 * station is asleep and we send data - that must
+	 * be uAPSD or PS-Poll. Don't rearm the timer.
+	 */
+	if (txq->frozen)
+		return;
+
+	/*
 	 * if empty delete timer, otherwise move timer forward
 	 * since we're making progress on this queue
 	 */
@@ -1265,6 +1274,9 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 	static const u32 zero_val[4] = {};
 
+	trans_pcie->txq[txq_id].frozen_expiry_remainder = 0;
+	trans_pcie->txq[txq_id].frozen = false;
+
 	/*
 	 * Upon HW Rfkill - we stop the device, and then stop the queues
 	 * in the op_mode. Just for the sake of the simplicity of the op_mode,
-- 
1.9.1

