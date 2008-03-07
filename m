Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43419 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbYCGBkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 20:40:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/4] iwlwifi: queue functions cleanup
Date: Thu,  6 Mar 2008 17:36:53 -0800
Message-Id: <1204853816-8964-2-git-send-email-reinette.chatre@intel.com> (sfid-20080307_014027_882556_51C70F62)
In-Reply-To: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com>
References: <1204853816-8964-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves
1. iwl_queue_inc_wrap and int iwl_queue_dec_wrap
into  iwl-helpers.h these two functions are identical to common
for both iwl3956 and iwl4965
2. renames x2_queue_used to iwl3945_x2_queue_used
3. exports iwl3945_queue_space out of iwl3964-base.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   20 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   45 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   37 +++++----------------
 4 files changed, 45 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a238e83..0ab22d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -116,6 +116,9 @@ struct iwl3945_queue {
 				* space less than this */
 } __attribute__ ((packed));
 
+int iwl3945_queue_space(const struct iwl3945_queue *q);
+int iwl3945_x2_queue_used(const struct iwl3945_queue *q, int i);
+
 #define MAX_NUM_OF_TBS          (20)
 
 /* One for each TFD */
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 8993cca..736b888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -254,6 +254,26 @@ static inline u8 iwl_get_dma_hi_address(dma_addr_t addr)
 	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
 }
 
+/**
+ * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_inc_wrap(int index, int n_bd)
+{
+	return ++index & (n_bd - 1);
+}
+
+/**
+ * iwl_queue_dec_wrap - decrement queue index, wrap back to end
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int iwl_queue_dec_wrap(int index, int n_bd)
+{
+	return --index & (n_bd - 1);
+}
+
 /* TODO: Move fw_desc functions to iwl-pci.ko */
 static inline void iwl_free_fw_desc(struct pci_dev *pci_dev,
 				    struct fw_desc *desc)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4aaced0..39fd544 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -183,7 +183,7 @@ static const char *iwl3945_escape_essid(const char *essid, u8 essid_len)
  * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
  ***************************************************/
 
-static int iwl3945_queue_space(const struct iwl3945_queue *q)
+int iwl3945_queue_space(const struct iwl3945_queue *q)
 {
 	int s = q->read_ptr - q->write_ptr;
 
@@ -199,33 +199,14 @@ static int iwl3945_queue_space(const struct iwl3945_queue *q)
 	return s;
 }
 
-/**
- * iwl3945_queue_inc_wrap - increment queue index, wrap back to beginning
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl3945_queue_inc_wrap(int index, int n_bd)
-{
-	return ++index & (n_bd - 1);
-}
-
-/**
- * iwl3945_queue_dec_wrap - increment queue index, wrap back to end
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl3945_queue_dec_wrap(int index, int n_bd)
-{
-	return --index & (n_bd - 1);
-}
-
-static inline int x2_queue_used(const struct iwl3945_queue *q, int i)
+int iwl3945_x2_queue_used(const struct iwl3945_queue *q, int i)
 {
 	return q->write_ptr > q->read_ptr ?
 		(i >= q->read_ptr && i < q->write_ptr) :
 		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
+
 static inline u8 get_cmd_index(struct iwl3945_queue *q, u32 index, int is_huge)
 {
 	/* This is for scan command, the big buffer at end of command array */
@@ -246,8 +227,8 @@ static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q
 	q->n_window = slots_num;
 	q->id = id;
 
-	/* count must be power-of-two size, otherwise iwl3945_queue_inc_wrap
-	 * and iwl3945_queue_dec_wrap are broken. */
+	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
+	 * and iwl_queue_dec_wrap are broken. */
 	BUG_ON(!is_power_of_2(count));
 
 	/* slots_num must be power-of-two size, otherwise
@@ -347,7 +328,7 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
 	txq->need_update = 0;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl3945_queue_inc_wrap and iwl3945_queue_dec_wrap are broken. */
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue high/low-water, head/tail indexes */
@@ -378,7 +359,7 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
 
 	/* first, empty all BD's */
 	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl3945_queue_inc_wrap(q->read_ptr, q->n_bd))
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl3945_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl3945_cmd) * q->n_window;
@@ -717,7 +698,7 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 	txq->need_update = 1;
 
 	/* Increment and update queue's write index */
-	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
@@ -2797,7 +2778,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 			   ieee80211_get_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3189,16 +3170,16 @@ static int iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv, int txq_id, int i
 	struct iwl3945_queue *q = &txq->q;
 	int nfreed = 0;
 
-	if ((index >= q->n_bd) || (x2_queue_used(q, index) == 0)) {
+	if ((index >= q->n_bd) || (iwl3945_x2_queue_used(q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
-	for (index = iwl3945_queue_inc_wrap(index, q->n_bd);
+	for (index = iwl_queue_inc_wrap(index, q->n_bd);
 		q->read_ptr != index;
-		q->read_ptr = iwl3945_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl3945_txstatus_to_ieee(priv,
 					&(txq->txb[txq->q.read_ptr]));
@@ -3245,7 +3226,7 @@ static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 
-	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
+	if ((index >= txq->q.n_bd) || (iwl3945_x2_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
 			  index, txq->q.n_bd, txq->q.write_ptr,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af95626..28c64c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -194,25 +194,6 @@ int iwl4965_queue_space(const struct iwl4965_queue *q)
 	return s;
 }
 
-/**
- * iwl4965_queue_inc_wrap - increment queue index, wrap back to beginning
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl4965_queue_inc_wrap(int index, int n_bd)
-{
-	return ++index & (n_bd - 1);
-}
-
-/**
- * iwl4965_queue_dec_wrap - decrement queue index, wrap back to end
- * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
- */
-static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
-{
-	return --index & (n_bd - 1);
-}
 
 static inline int x2_queue_used(const struct iwl4965_queue *q, int i)
 {
@@ -241,8 +222,8 @@ static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q
 	q->n_window = slots_num;
 	q->id = id;
 
-	/* count must be power-of-two size, otherwise iwl4965_queue_inc_wrap
-	 * and iwl4965_queue_dec_wrap are broken. */
+	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
+	 * and iwl_queue_dec_wrap are broken. */
 	BUG_ON(!is_power_of_2(count));
 
 	/* slots_num must be power-of-two size, otherwise
@@ -342,7 +323,7 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
 	txq->need_update = 0;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl4965_queue_inc_wrap and iwl4965_queue_dec_wrap are broken. */
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
@@ -373,7 +354,7 @@ void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *t
 
 	/* first, empty all BD's */
 	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl4965_queue_inc_wrap(q->read_ptr, q->n_bd))
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl4965_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl4965_cmd) * q->n_window;
@@ -714,7 +695,7 @@ static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_c
 	ret = iwl4965_tx_queue_update_wr_ptr(priv, txq, 0);
 
 	/* Increment and update queue's write index */
-	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl4965_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
@@ -2897,7 +2878,7 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
 
 	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl4965_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3291,9 +3272,9 @@ int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index)
 		return 0;
 	}
 
-	for (index = iwl4965_queue_inc_wrap(index, q->n_bd);
+	for (index = iwl_queue_inc_wrap(index, q->n_bd);
 		q->read_ptr != index;
-		q->read_ptr = iwl4965_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl4965_txstatus_to_ieee(priv,
 					&(txq->txb[txq->q.read_ptr]));
@@ -3538,7 +3519,7 @@ static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			int freed;
-			index = iwl4965_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
+			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
 			freed = iwl4965_tx_queue_reclaim(priv, txq_id, index);
-- 
1.5.3.4

