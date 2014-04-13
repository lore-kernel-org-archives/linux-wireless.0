Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59573 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbaDMTUY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:24 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so7396469wgh.29
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/47] iwlwifi: pcie: use bool for TX queue where appropriate
Date: Sun, 13 Apr 2014 22:19:24 +0300
Message-Id: <1397416802-32403-9-git-send-email-egrumbach@gmail.com> (sfid-20140413_212227_051268_2B3D989F)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using u8 to hold logic values, use bool.

Also fix a comment, the return value is no longer relevant.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 22 ++++++++++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 477ac36..1261a41 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -231,7 +231,7 @@ struct iwl_txq {
 	spinlock_t lock;
 	struct timer_list stuck_timer;
 	struct iwl_trans_pcie *trans_pcie;
-	u8 need_update;
+	bool need_update;
 	u8 active;
 	bool ampdu;
 };
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 0368609..6c7dca1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -293,7 +293,7 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 	u32 reg = 0;
 	int txq_id = txq->q.id;
 
-	if (txq->need_update == 0)
+	if (!txq->need_update)
 		return;
 
 	/*
@@ -328,7 +328,7 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 	IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id, txq->q.write_ptr);
 	iwl_write32(trans, HBUS_TARG_WRPTR, txq->q.write_ptr | (txq_id << 8));
 
-	txq->need_update = 0;
+	txq->need_update = false;
 }
 
 static inline dma_addr_t iwl_pcie_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
@@ -542,7 +542,7 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 {
 	int ret;
 
-	txq->need_update = 0;
+	txq->need_update = false;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
@@ -1393,7 +1393,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		kfree(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
-	txq->need_update = 1;
+	txq->need_update = true;
 
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr);
 
@@ -1664,7 +1664,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	dma_addr_t tb0_phys, tb1_phys, scratch_phys;
 	void *tb1_addr;
 	u16 len, tb1_len, tb2_len;
-	u8 wait_write_ptr = 0;
+	bool wait_write_ptr = false;
 	__le16 fc = hdr->frame_control;
 	u8 hdr_len = ieee80211_hdrlen(fc);
 	u16 wifi_seq;
@@ -1766,10 +1766,10 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 				  skb->data + hdr_len, tb2_len);
 
 	if (!ieee80211_has_morefrags(fc)) {
-		txq->need_update = 1;
+		txq->need_update = true;
 	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
+		wait_write_ptr = true;
+		txq->need_update = false;
 	}
 
 	/* start timer if queue currently empty */
@@ -1783,13 +1783,11 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/*
 	 * At this point the frame is "transmitted" successfully
-	 * and we will get a TX status notification eventually,
-	 * regardless of the value of ret. "ret" only indicates
-	 * whether or not we should update the write pointer.
+	 * and we will get a TX status notification eventually.
 	 */
 	if (iwl_queue_space(q) < q->high_mark) {
 		if (wait_write_ptr) {
-			txq->need_update = 1;
+			txq->need_update = true;
 			iwl_pcie_txq_inc_wr_ptr(trans, txq);
 		} else {
 			iwl_stop_queue(trans, txq);
-- 
1.8.3.2

