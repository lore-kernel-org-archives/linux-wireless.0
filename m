Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758804AbXJOMlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:41:05 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: renaming last_used and first_empty
Date: Mon, 15 Oct 2007 14:40:57 +0200
Message-Id: <11924520591440-git-send-email-tomas.winkler@intel.com> (sfid-20071015_134110_561157_FB70C625)
In-Reply-To: <1192452057872-git-send-email-tomas.winkler@intel.com>
References: <1192452057872-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames queue pointers to write_ptr and read_ptr
instead of  first_empty and last_used. This is closer to technical
terminology we everyday use

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   12 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   24 +++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   61 +++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   65 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwlwifi.h      |    4 +-
 5 files changed, 84 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 1795d2b..cf0ab7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -518,14 +518,14 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 }
 
 /**
- * iwl_hw_txq_free_tfd - Free one TFD, those at index [txq->q.last_used]
+ * iwl_hw_txq_free_tfd - Free one TFD, those at index [txq->q.read_ptr]
  *
  * Does NOT advance any indexes
  */
 int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
-	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.last_used];
+	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter;
@@ -548,12 +548,12 @@ int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	for (i = 1; i < counter; i++) {
 		pci_unmap_single(dev, le32_to_cpu(bd->pa[i].addr),
 				 le32_to_cpu(bd->pa[i].len), PCI_DMA_TODEVICE);
-		if (txq->txb[txq->q.last_used].skb[0]) {
-			struct sk_buff *skb = txq->txb[txq->q.last_used].skb[0];
-			if (txq->txb[txq->q.last_used].skb[0]) {
+		if (txq->txb[txq->q.read_ptr].skb[0]) {
+			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[0];
+			if (txq->txb[txq->q.read_ptr].skb[0]) {
 				/* Can be called from interrupt context */
 				dev_kfree_skb_any(skb);
-				txq->txb[txq->q.last_used].skb[0] = NULL;
+				txq->txb[txq->q.read_ptr].skb[0] = NULL;
 			}
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9b274f9..39f5836 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1748,14 +1748,14 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 }
 
 /**
- * iwl_hw_txq_free_tfd -  Free one TFD, those at index [txq->q.last_used]
+ * iwl_hw_txq_free_tfd -  Free one TFD, those at index [txq->q.read_ptr]
  *
  * Does NOT advance any indexes
  */
 int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
-	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.last_used];
+	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter = 0;
@@ -1795,11 +1795,11 @@ int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 					 IWL_GET_BITS(bd->pa[index], tb1_len),
 					 PCI_DMA_TODEVICE);
 
-		if (txq->txb[txq->q.last_used].skb[i]) {
-			struct sk_buff *skb = txq->txb[txq->q.last_used].skb[i];
+		if (txq->txb[txq->q.read_ptr].skb[i]) {
+			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[i];
 
 			dev_kfree_skb(skb);
-			txq->txb[txq->q.last_used].skb[i] = NULL;
+			txq->txb[txq->q.read_ptr].skb[i] = NULL;
 		}
 	}
 	return 0;
@@ -2775,11 +2775,11 @@ int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
 	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-		       tfd_offset[txq->q.first_empty], byte_cnt, len);
+		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
 
-	if (txq->q.first_empty < IWL4965_MAX_WIN_SIZE)
+	if (txq->q.write_ptr < IWL4965_MAX_WIN_SIZE)
 		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
-			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.first_empty],
+			tfd_offset[IWL4965_QUEUE_SIZE + txq->q.write_ptr],
 			byte_cnt, len);
 
 	return 0;
@@ -4197,8 +4197,8 @@ static int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	iwl_set_bits_restricted_reg(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
-	priv->txq[txq_id].q.last_used = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.first_empty = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
@@ -4249,8 +4249,8 @@ static int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwl_clear_bits_restricted_reg(priv, SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
-	priv->txq[txq_id].q.last_used = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.first_empty = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d93d169..2581675 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -211,9 +211,9 @@ static void iwl_print_hex_dump(int level, void *p, u32 len)
 
 static int iwl_queue_space(const struct iwl_queue *q)
 {
-	int s = q->last_used - q->first_empty;
+	int s = q->read_ptr - q->write_ptr;
 
-	if (q->last_used > q->first_empty)
+	if (q->read_ptr > q->write_ptr)
 		s -= q->n_bd;
 
 	if (s <= 0)
@@ -239,9 +239,9 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 
 static inline int x2_queue_used(const struct iwl_queue *q, int i)
 {
-	return q->first_empty > q->last_used ?
-		(i >= q->last_used && i < q->first_empty) :
-		!(i < q->last_used && i >= q->first_empty);
+	return q->write_ptr > q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
 static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
@@ -275,7 +275,8 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	if (q->high_mark < 2)
 		q->high_mark = 2;
 
-	q->first_empty = q->last_used = 0;
+	q->write_ptr = 0; 
+	q->read_ptr = 0;
 
 	return 0;
 }
@@ -371,8 +372,8 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		return;
 
 	/* first, empty all BD's */
-	for (; q->first_empty != q->last_used;
-	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
+	for (; q->write_ptr != q->read_ptr;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
@@ -652,12 +653,12 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->bd[q->first_empty];
+	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
 	control_flags = (u32 *) tfd;
 
-	idx = get_cmd_index(q, q->first_empty, cmd->meta.flags & CMD_SIZE_HUGE);
+	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = &txq->cmd[idx];
 
 	out_cmd->hdr.cmd = cmd->id;
@@ -669,7 +670,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
-			INDEX_TO_SEQ(q->first_empty));
+			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
 
@@ -685,10 +686,10 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		     "%d bytes at %d[%d]:%d\n",
 		     get_cmd_string(out_cmd->hdr.cmd),
 		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
-		     fix_size, q->first_empty, idx, IWL_CMD_QUEUE_NUM);
+		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
@@ -2777,21 +2778,21 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	tfd = &txq->bd[q->first_empty];
+	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	control_flags = (u32 *) tfd;
-	idx = get_cmd_index(q, q->first_empty, 0);
+	idx = get_cmd_index(q, q->write_ptr, 0);
 
-	memset(&(txq->txb[q->first_empty]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->first_empty].skb[0] = skb;
-	memcpy(&(txq->txb[q->first_empty].status.control),
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
+	txq->txb[q->write_ptr].skb[0] = skb;
+	memcpy(&(txq->txb[q->write_ptr].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
 	out_cmd = &txq->cmd[idx];
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->first_empty)));
+				INDEX_TO_SEQ(q->write_ptr)));
 	/* copy frags header */
 	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
 
@@ -2859,7 +2860,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	iwl_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3345,20 +3346,20 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	if ((index >= q->n_bd) || (x2_queue_used(q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->first_empty, q->last_used);
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
 	for (index = iwl_queue_inc_wrap(index, q->n_bd);
-		q->last_used != index;
-		q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd)) {
+		q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl_txstatus_to_ieee(priv,
-					&(txq->txb[txq->q.last_used]));
+					&(txq->txb[txq->q.read_ptr]));
 			iwl_hw_txq_free_tfd(priv, txq);
 		} else if (nfreed > 1) {
 			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
-					q->first_empty, q->last_used);
+					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
 		nfreed++;
@@ -3398,12 +3399,12 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.first_empty,
-			  txq->q.last_used);
+			  index, txq->q.n_bd, txq->q.write_ptr,
+			  txq->q.read_ptr);
 		return;
 	}
 
-	tx_status = &(txq->txb[txq->q.last_used].status);
+	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
 	tx_status->queue_number = status;
@@ -4338,14 +4339,14 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		if (rc)
 			return rc;
 		iwl_write_restricted(priv, HBUS_TARG_WRPTR,
-				     txq->q.first_empty | (txq_id << 8));
+				     txq->q.write_ptr | (txq_id << 8));
 		iwl_release_restricted_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
 	} else
 		iwl_write32(priv, HBUS_TARG_WRPTR,
-			    txq->q.first_empty | (txq_id << 8));
+			    txq->q.write_ptr | (txq_id << 8));
 
 	txq->need_update = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9cd8dcb..8b6bb49 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -210,9 +210,9 @@ static void iwl_print_hex_dump(int level, void *p, u32 len)
 
 static int iwl_queue_space(const struct iwl_queue *q)
 {
-	int s = q->last_used - q->first_empty;
+	int s = q->read_ptr - q->write_ptr;
 
-	if (q->last_used > q->first_empty)
+	if (q->read_ptr > q->write_ptr)
 		s -= q->n_bd;
 
 	if (s <= 0)
@@ -238,9 +238,9 @@ static inline int iwl_queue_dec_wrap(int index, int n_bd)
 
 static inline int x2_queue_used(const struct iwl_queue *q, int i)
 {
-	return q->first_empty > q->last_used ?
-		(i >= q->last_used && i < q->first_empty) :
-		!(i < q->last_used && i >= q->first_empty);
+	return q->write_ptr > q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
 }
 
 static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
@@ -274,7 +274,8 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	if (q->high_mark < 2)
 		q->high_mark = 2;
 
-	q->first_empty = q->last_used = 0;
+	q->write_ptr = 0;
+	q->read_ptr = 0;
 
 	return 0;
 }
@@ -370,8 +371,8 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		return;
 
 	/* first, empty all BD's */
-	for (; q->first_empty != q->last_used;
-	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
+	for (; q->write_ptr != q->read_ptr;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
@@ -653,12 +654,12 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->bd[q->first_empty];
+	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
 	control_flags = (u32 *) tfd;
 
-	idx = get_cmd_index(q, q->first_empty, cmd->meta.flags & CMD_SIZE_HUGE);
+	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = &txq->cmd[idx];
 
 	out_cmd->hdr.cmd = cmd->id;
@@ -670,7 +671,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
-			INDEX_TO_SEQ(q->first_empty));
+			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
 
@@ -682,11 +683,11 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		     "%d bytes at %d[%d]:%d\n",
 		     get_cmd_string(out_cmd->hdr.cmd),
 		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
-		     fix_size, q->first_empty, idx, IWL_CMD_QUEUE_NUM);
+		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
 	ret = iwl4965_tx_queue_update_wr_ptr(priv, txq, 0);
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_tx_queue_update_write_ptr(priv, txq);
 
 	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
@@ -2866,21 +2867,21 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	tfd = &txq->bd[q->first_empty];
+	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	control_flags = (u32 *) tfd;
-	idx = get_cmd_index(q, q->first_empty, 0);
+	idx = get_cmd_index(q, q->write_ptr, 0);
 
-	memset(&(txq->txb[q->first_empty]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->first_empty].skb[0] = skb;
-	memcpy(&(txq->txb[q->first_empty].status.control),
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
+	txq->txb[q->write_ptr].skb[0] = skb;
+	memcpy(&(txq->txb[q->write_ptr].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
 	out_cmd = &txq->cmd[idx];
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->first_empty)));
+				INDEX_TO_SEQ(q->write_ptr)));
 	/* copy frags header */
 	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
 
@@ -2946,7 +2947,7 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 
 	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
 
-	q->first_empty = iwl_queue_inc_wrap(q->first_empty, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -3433,20 +3434,20 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	if ((index >= q->n_bd) || (x2_queue_used(q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->first_empty, q->last_used);
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
 	for (index = iwl_queue_inc_wrap(index, q->n_bd);
-		q->last_used != index;
-		q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd)) {
+		q->read_ptr != index;
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl_txstatus_to_ieee(priv,
-					&(txq->txb[txq->q.last_used]));
+					&(txq->txb[txq->q.read_ptr]));
 			iwl_hw_txq_free_tfd(priv, txq);
 		} else if (nfreed > 1) {
 			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
-					q->first_empty, q->last_used);
+					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
 		nfreed++;
@@ -3534,7 +3535,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d \n",
 				   agg->frame_count, agg->start_idx);
 
-		tx_status = &(priv->txq[txq_id].txb[txq->q.last_used].status);
+		tx_status = &(priv->txq[txq_id].txb[txq->q.read_ptr].status);
 		tx_status->retry_count = tx_resp->failure_frame;
 		tx_status->queue_number = status & 0xff;
 		tx_status->queue_length = tx_resp->bt_kill_count;
@@ -3639,8 +3640,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	if ((index >= txq->q.n_bd) || (x2_queue_used(&txq->q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq_id (%d) index %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.first_empty,
-			  txq->q.last_used);
+			  index, txq->q.n_bd, txq->q.write_ptr,
+			  txq->q.read_ptr);
 		return;
 	}
 
@@ -3675,7 +3676,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 			/* TODO: send BAR */
 		}
 
-		if ((txq->q.last_used != (scd_ssn & 0xff))) {
+		if ((txq->q.read_ptr != (scd_ssn & 0xff))) {
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
@@ -3684,7 +3685,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	} else {
 #endif /* CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
-	tx_status = &(txq->txb[txq->q.last_used].status);
+	tx_status = &(txq->txb[txq->q.read_ptr].status);
 
 	tx_status->retry_count = tx_resp->failure_frame;
 	tx_status->queue_number = status;
@@ -4662,14 +4663,14 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 		if (rc)
 			return rc;
 		iwl_write_restricted(priv, HBUS_TARG_WRPTR,
-				     txq->q.first_empty | (txq_id << 8));
+				     txq->q.write_ptr | (txq_id << 8));
 		iwl_release_restricted_access(priv);
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
 	} else
 		iwl_write32(priv, HBUS_TARG_WRPTR,
-			    txq->q.first_empty | (txq_id << 8));
+			    txq->q.write_ptr | (txq_id << 8));
 
 	txq->need_update = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index a6983bf..70e106f 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -149,8 +149,8 @@ struct iwl_rt_tx_hdr {
  */
 struct iwl_queue {
 	int n_bd;              /* number of BDs in this queue */
-	int first_empty;       /* 1-st empty entry (index) host_w*/
-	int last_used;         /* last used entry (index) host_r*/
+	int write_ptr;       /* 1-st empty entry (index) host_w*/
+	int read_ptr;         /* last used entry (index) host_r*/
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
