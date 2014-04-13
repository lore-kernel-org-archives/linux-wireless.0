Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56227 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaDMTU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:28 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so7279897wgh.31
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:26 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/47] iwlwifi: pcie: clarify TX queue need_update handling
Date: Sun, 13 Apr 2014 22:19:26 +0300
Message-Id: <1397416802-32403-11-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_306565_DFE2F3E6)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Similar to the recent RX queue patch, this changes the need_update
handling for the TX queues to be clearer and only done when needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  7 +----
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 44 ++++++++++++++++------------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 1261a41..1b95d85 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -365,7 +365,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
-void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq);
+void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 			    struct iwl_rx_cmd_buffer *rxb, int handler_status);
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 152c763..0937f84 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -889,7 +889,6 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 	u32 inta = 0;
 	u32 handled = 0;
-	u32 i;
 
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
@@ -1042,11 +1041,7 @@ irqreturn_t iwl_pcie_irq_handler(int irq, void *dev_id)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
 		iwl_pcie_rxq_check_wrptr(trans);
-		for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-			spin_lock(&trans_pcie->txq[i].lock);
-			iwl_pcie_txq_inc_wr_ptr(trans, &trans_pcie->txq[i]);
-			spin_unlock(&trans_pcie->txq[i].lock);
-		}
+		iwl_pcie_txq_check_wrptrs(trans);
 
 		isr_stats->wakeup++;
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 6c7dca1..78a6ff2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -287,14 +287,14 @@ static void iwl_pcie_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 /*
  * iwl_pcie_txq_inc_wr_ptr - Send new write index to hardware
  */
-void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
+static void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans,
+				    struct iwl_txq *txq)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 reg = 0;
 	int txq_id = txq->q.id;
 
-	if (!txq->need_update)
-		return;
+	lockdep_assert_held(&txq->lock);
 
 	/*
 	 * explicitly wake up the NIC if:
@@ -317,6 +317,7 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 				       txq_id, reg);
 			iwl_set_bit(trans, CSR_GP_CNTRL,
 				    CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+			txq->need_update = true;
 			return;
 		}
 	}
@@ -327,8 +328,23 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 	 */
 	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->q.write_ptr);
 	iwl_write32(trans, HBUS_TARG_WRPTR, txq->q.write_ptr | (txq_id << 8));
+}
 
-	txq->need_update = false;
+void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i;
+
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
+		struct iwl_txq *txq = &trans_pcie->txq[i];
+
+		spin_lock(&txq->lock);
+		if (trans_pcie->txq[i].need_update) {
+			iwl_pcie_txq_inc_wr_ptr(trans, txq);
+			trans_pcie->txq[i].need_update = false;
+		}
+		spin_unlock(&txq->lock);
+	}
 }
 
 static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
@@ -1393,8 +1409,6 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		kfree(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
-	txq->need_update = true;
-
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr);
 
 	/* start timer if queue currently empty */
@@ -1664,7 +1678,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
 	void *tb1_addr;
 	u16 len, tb1_len, tb2_len;
-	bool wait_write_ptr = false;
+	bool wait_write_ptr;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
 	u16 wifi_seq;
@@ -1765,12 +1779,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	trace_iwlwifi_dev_tx_data(trans->dev, skb,
 				  skb->data + hdr_len, tb2_len);
 
-	if (!ieee80211_has_morefrags(fc)) {
-		txq->need_update = true;
-	} else {
-		wait_write_ptr = true;
-		txq->need_update = false;
-	}
+	wait_write_ptr = ieee80211_has_morefrags(fc);
 
 	/* start timer if queue currently empty */
 	if (txq->need_update && q->read_ptr == q->write_ptr &&
@@ -1779,19 +1788,18 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_pcie_txq_inc_wr_ptr(trans, txq);
+	if (!wait_write_ptr)
+		iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
 	/*
 	 * At this point the frame is "transmitted" successfully
 	 * and we will get a TX status notification eventually.
 	 */
 	if (iwl_queue_space(q) < q->high_mark) {
-		if (wait_write_ptr) {
-			txq->need_update = true;
+		if (wait_write_ptr)
 			iwl_pcie_txq_inc_wr_ptr(trans, txq);
-		} else {
+		else
 			iwl_stop_queue(trans, txq);
-		}
 	}
 	spin_unlock(&txq->lock);
 	return 0;
-- 
1.8.3.2

