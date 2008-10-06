Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYJFTXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:23:55 -0400
Date: Mon, 6 Oct 2008 15:23:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
Message-ID: <20081006192304.GF3448@tuxdriver.com> (sfid-20081006_212400_200674_041E9642)
References: <1223308831.15196.28.camel@johannes.berg> <1223309405.15196.32.camel@johannes.berg> <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com> <1223311876.15196.38.camel@johannes.berg> <1223312084.15196.41.camel@johannes.berg> <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 08:30:29PM +0200, Tomas Winkler wrote:
> On Mon, Oct 6, 2008 at 6:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-10-06 at 18:51 +0200, Johannes Berg wrote:
> >
> >> > >  * therefore, all the is_odd junk goes away
> >> > >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
> >> > >   fragments of a descriptor rather than all descriptors (this may be
> >> > >   the cause of the dma unmapping problem I reported)
> >> > >  * some more cleanups
> >> >
> >> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >> > > --
> >> >
> >> >
> >> > > Tested on 5000 hw, please apply.
> >> >
> >> > Great job,  however do not apply this before I review it I had strong
> >> > feeling this will not
> >> > work with aggregation flows.
> >>
> >> I cannot imagine why you think that, care to explain?
> 
> Yep, no connection I thought at the first glance you've thatched more code.
> >
> > Of course, I would very much appreciate you review the actual bug fix in
> > iwl_hcmd_queue_reclaim, which consist of the addition of the line
> >
> > +               bd = &txq->bd[index];
> 
> Okay I found the source of the evil, with your big pointer :)
> The bug caused by this memory optimization juggling we've done and
> very  bad cut and paste coding
> We moved for command buffers from pcI_alloc consitent to kmalloc which
> required pci mapping that that was coded wrongly. Now this kmalloc
> stuff is not good as well since we have this 36 bit memory limitation
> on 64 bit platforms.
> This is the issue I'm trying to address recently I'm not sure what yet
> what allocation schema would be best yet.

What if we just revert that patch?

---

From: John W. Linville <linville@tuxdriver.com>
Date: Mon, 6 Oct 2008 15:22:27 -0400
Subject: [PATCH] Revert "iwlwifi: memory allocation optimization"

This reverts commit da99c4b6c25964b90c79f19beccda208df1a865a.

Conflicts:

	drivers/net/wireless/iwlwifi/iwl-tx.c
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   94 +++++++++----------------------
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b08036a..429f839 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -938,8 +938,8 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 
 	if (txq_id != IWL_CMD_QUEUE_NUM) {
-		sta = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+		sta = txq->cmd[txq->q.write_ptr].cmd.tx.sta_id;
+		sec_ctl = txq->cmd[txq->q.write_ptr].cmd.tx.sec_ctl;
 
 		switch (sec_ctl & TX_CMD_SEC_MSK) {
 		case TX_CMD_SEC_CCM:
@@ -978,7 +978,7 @@ static void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 	u8 sta = 0;
 
 	if (txq_id != IWL_CMD_QUEUE_NUM)
-		sta = txq->cmd[txq->q.read_ptr]->cmd.tx.sta_id;
+		sta = txq->cmd[txq->q.read_ptr].cmd.tx.sta_id;
 
 	shared_data->queues_byte_cnt_tbls[txq_id].tfd_offset[txq->q.read_ptr].
 					val = cpu_to_le16(1 | (sta << 12));
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cdfb343..8416cab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -135,7 +135,8 @@ struct iwl_tx_info {
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	struct iwl_tfd_frame *bd;
-	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
+	struct iwl_cmd *cmd;
+	dma_addr_t dma_addr_cmd;
 	struct iwl_tx_info *txb;
 	int need_update;
 	int sched_retry;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 2eb03ee..986d79c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -227,7 +227,7 @@ cancel:
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source). */
-		qcmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
+		qcmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
 		qcmd->meta.flags &= ~CMD_WANT_SKB;
 	}
 fail:
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 78b1a7a..fa88d8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -208,12 +208,11 @@ EXPORT_SYMBOL(iwl_txq_update_write_ptr);
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
+static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int i, slots_num, len;
+	int len;
 
 	if (q->n_bd == 0)
 		return;
@@ -228,12 +227,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 		len += IWL_MAX_SCAN_SIZE;
 
 	/* De-alloc array of command/tx buffers */
-	slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
-			TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-	for (i = 0; i < slots_num; i++)
-		kfree(txq->cmd[i]);
-	if (txq_id == IWL_CMD_QUEUE_NUM)
-		kfree(txq->cmd[slots_num]);
+	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
@@ -405,8 +399,9 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			     int slots_num, u32 txq_id)
 {
-	int i, len;
-	int ret;
+	struct pci_dev *dev = priv->pci_dev;
+	int len;
+	int rc = 0;
 
 	/*
 	 * Alloc buffer array for commands (Tx or other types of commands).
@@ -416,24 +411,19 @@ static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl_cmd);
-	for (i = 0; i <= slots_num; i++) {
-		if (i == slots_num) {
-			if (txq_id == IWL_CMD_QUEUE_NUM)
-				len += IWL_MAX_SCAN_SIZE;
-			else
-				continue;
-		}
-
-		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
-		if (!txq->cmd[i])
-			goto err;
-	}
+	len = sizeof(struct iwl_cmd) * slots_num;
+	if (txq_id == IWL_CMD_QUEUE_NUM)
+		len +=  IWL_MAX_SCAN_SIZE;
+	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
+	if (!txq->cmd)
+		return -ENOMEM;
 
 	/* Alloc driver data array and TFD circular buffer */
-	ret = iwl_tx_queue_alloc(priv, txq, txq_id);
-	if (ret)
-		goto err;
+	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
+	if (rc) {
+		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+		return -ENOMEM;
+	}
 
 	txq->need_update = 0;
 
@@ -448,17 +438,6 @@ static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	iwl_hw_tx_queue_init(priv, txq);
 
 	return 0;
-err:
-	for (i = 0; i < slots_num; i++) {
-		kfree(txq->cmd[i]);
-		txq->cmd[i] = NULL;
-	}
-
-	if (txq_id == IWL_CMD_QUEUE_NUM) {
-		kfree(txq->cmd[slots_num]);
-		txq->cmd[slots_num] = NULL;
-	}
-	return -ENOMEM;
 }
 /**
  * iwl_hw_txq_ctx_free - Free TXQ Context
@@ -471,7 +450,7 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_free(priv, txq_id);
+		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
 
 	/* Keep-warm buffer */
 	iwl_kw_free(priv);
@@ -878,7 +857,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq->txb[q->write_ptr].skb[0] = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = txq->cmd[idx];
+	out_cmd = &txq->cmd[idx];
 	tx_cmd = &out_cmd->cmd.tx;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
@@ -918,9 +897,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev, out_cmd,
-				sizeof(struct iwl_cmd), PCI_DMA_TODEVICE);
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
+		     offsetof(struct iwl_cmd, hdr);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -1021,7 +999,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	struct iwl_cmd *out_cmd;
 	dma_addr_t phys_addr;
 	unsigned long flags;
-	int len, ret;
+	int ret;
 	u32 idx;
 	u16 fix_size;
 
@@ -1051,7 +1029,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
-	out_cmd = txq->cmd[idx];
+	out_cmd = &txq->cmd[idx];
 
 	out_cmd->hdr.cmd = cmd->id;
 	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
@@ -1065,11 +1043,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
-	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd, len,
-						PCI_DMA_TODEVICE);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
+
+	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
+			offsetof(struct iwl_cmd, hdr);
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
@@ -1134,9 +1110,6 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd_frame *bd = &txq->bd[index];
-	dma_addr_t dma_addr;
-	int is_odd, buf_len;
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
@@ -1154,19 +1127,6 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
-		is_odd = (index/2) & 0x1;
-		if (is_odd) {
-			dma_addr = IWL_GET_BITS(bd->pa[index], tb2_addr_lo16) |
-					(IWL_GET_BITS(bd->pa[index],
-							tb2_addr_hi20) << 16);
-			buf_len = IWL_GET_BITS(bd->pa[index], tb2_len);
-		} else {
-			dma_addr = le32_to_cpu(bd->pa[index].tb1_addr);
-			buf_len = IWL_GET_BITS(bd->pa[index], tb1_len);
-		}
-
-		pci_unmap_single(priv->pci_dev, dma_addr, buf_len,
-				 PCI_DMA_TODEVICE);
 		nfreed++;
 	}
 }
@@ -1198,7 +1158,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+	cmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
 
 	/* Input error checking is done when commands are added to queue. */
 	if (cmd->meta.flags & CMD_WANT_SKB) {
-- 
1.5.4.3

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
