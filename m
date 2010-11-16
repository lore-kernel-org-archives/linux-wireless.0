Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17196 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab0KPQGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/18] iwlwifi: always build swq_id as virtual queue ID
Date: Tue, 16 Nov 2010 08:01:43 -0800
Message-Id: <1289923311-14920-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Previously, we used the swq_id's mechanism
to have AC and HW queue different only for
aggregation queues. To be able to fix a bug
with iPAN simply always build the swq_id as
ac | (hwq << 2) and remove the flag bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 ++-----
 drivers/net/wireless/iwlwifi/iwl-helpers.h |   28 +++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   11 +++++------
 5 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index eef90b5..881475c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -449,7 +449,6 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 				iwl_wake_queue(priv, txq);
 		}
 	} else {
-		BUG_ON(txq_id != txq->swq_id);
 		iwlagn_set_tx_status(priv, info, tx_resp, txq_id, false);
 		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 179a9c8..330852c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1012,7 +1012,7 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	tid_data = &priv->stations[sta_id].tid[tid];
 	*ssn = SEQ_TO_SN(tid_data->seq_number);
 	tid_data->agg.txq_id = txq_id;
-	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(get_ac_from_tid(tid), txq_id);
+	iwl_set_swq_id(&priv->txq[txq_id], get_ac_from_tid(tid), txq_id);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 4876e26..3cc5842 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -992,11 +992,8 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 				" swq_id=%#.2x (ac %d/hwq %d)\n",
 				cnt, q->read_ptr, q->write_ptr,
 				!!test_bit(cnt, priv->queue_stopped),
-				txq->swq_id,
-				txq->swq_id & 0x80 ? txq->swq_id & 3 :
-				txq->swq_id,
-				txq->swq_id & 0x80 ? (txq->swq_id >> 2) &
-				0x1f : txq->swq_id);
+				txq->swq_id, txq->swq_id & 3,
+				(txq->swq_id >> 2) & 0x1f);
 		if (cnt >= 4)
 			continue;
 		/* for the ACs, display the stop count too */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 23fa8e8..e53cd7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -104,29 +104,24 @@ static inline int iwl_alloc_fw_desc(struct pci_dev *pci_dev,
  * | | | | | | | |
  * | | | | | | +-+-------- AC queue (0-3)
  * | | | | | |
- * | +-+-+-+-+------------ HW A-MPDU queue
+ * | +-+-+-+-+------------ HW queue ID
  * |
- * +---------------------- indicates agg queue
+ * +---------------------- unused
  */
-static inline u8 iwl_virtual_agg_queue_num(u8 ac, u8 hwq)
+static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
 {
 	BUG_ON(ac > 3);   /* only have 2 bits */
-	BUG_ON(hwq > 31); /* only have 5 bits */
+	BUG_ON(hwq > 31); /* only use 5 bits */
 
-	return 0x80 | (hwq << 2) | ac;
+	txq->swq_id = (hwq << 2) | ac;
 }
 
 static inline void iwl_wake_queue(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq)
 {
 	u8 queue = txq->swq_id;
-	u8 ac = queue;
-	u8 hwq = queue;
-
-	if (queue & 0x80) {
-		ac = queue & 3;
-		hwq = (queue >> 2) & 0x1f;
-	}
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
 
 	if (test_and_clear_bit(hwq, priv->queue_stopped))
 		if (atomic_dec_return(&priv->queue_stop_count[ac]) <= 0)
@@ -137,13 +132,8 @@ static inline void iwl_stop_queue(struct iwl_priv *priv,
 				  struct iwl_tx_queue *txq)
 {
 	u8 queue = txq->swq_id;
-	u8 ac = queue;
-	u8 hwq = queue;
-
-	if (queue & 0x80) {
-		ac = queue & 3;
-		hwq = (queue >> 2) & 0x1f;
-	}
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
 
 	if (!test_and_set_bit(hwq, priv->queue_stopped))
 		if (atomic_inc_return(&priv->queue_stop_count[ac]) > 0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index feaa367..90659bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -359,13 +359,12 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	txq->need_update = 0;
 
 	/*
-	 * Aggregation TX queues will get their ID when aggregation begins;
-	 * they overwrite the setting done here. The command FIFO doesn't
-	 * need an swq_id so don't set one to catch errors, all others can
-	 * be set up to the identity mapping.
+	 * For the default queues 0-3, set up the swq_id
+	 * already -- all others need to get one later
+	 * (if they need one at all).
 	 */
-	if (txq_id != priv->cmd_queue)
-		txq->swq_id = txq_id;
+	if (txq_id < 4)
+		iwl_set_swq_id(txq, txq_id, txq_id);
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-- 
1.7.0.4

