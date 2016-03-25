Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36006 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbcCYJg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 05:36:58 -0400
Received: by mail-lb0-f176.google.com with SMTP id qe11so45472893lbc.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 02:36:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] ath10k: implement dql for htt tx
Date: Fri, 25 Mar 2016 10:39:03 +0100
Message-Id: <1458898743-21118-1-git-send-email-michal.kazior@tieto.com> (sfid-20160325_103701_877203_BE3F46C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements a very naive dynamic queue limits
on the flat HTT Tx. In some of my tests (using
flent) it seems to reduce induced latency by
orders of magnitude (e.g. when enforcing 6mbps
tx rates 2500ms -> 150ms). But at the same time it
introduces TCP throughput buildup over time
(instead of immediate bump to max). More
importantly I didn't observe it to make things
much worse (yet).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

I'm not sure yet if it's worth to consider this
patch for merging per se. My motivation was to
have something to prove mac80211 fq works and to
see if DQL can learn the proper queue limit in
face of wireless rate control at all.

I'll do a follow up post with flent test results
and some notes.


 drivers/net/wireless/ath/ath10k/core.h   |  2 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 ++++++++----
 drivers/net/wireless/ath/ath10k/htt_tx.c |  8 +++++++-
 drivers/net/wireless/ath/ath10k/mac.c    | 26 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/txrx.c   |  6 +++++-
 drivers/net/wireless/ath/ath10k/txrx.h   |  3 ++-
 6 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b6c157ef705a..d8eebcd2b0b0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -630,6 +630,8 @@ struct ath10k {
 	struct device *dev;
 	u8 mac_addr[ETH_ALEN];
 
+	struct dql dql;
+
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
 	u32 chip_id;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2da8ccf3da05..38bc8bf46b67 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1679,7 +1679,8 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 }
 
 static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
-				       struct sk_buff *skb)
+				       struct sk_buff *skb,
+				       unsigned int *completed)
 {
 	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
@@ -1712,7 +1713,7 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
 		msdu_id = resp->data_tx_completion.msdus[i];
 		tx_done.msdu_id = __le16_to_cpu(msdu_id);
-		ath10k_txrx_tx_unref(htt, &tx_done);
+		ath10k_txrx_tx_unref(htt, &tx_done, completed);
 	}
 }
 
@@ -2354,7 +2355,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		status = ath10k_txrx_tx_unref(htt, &tx_done);
+		status = ath10k_txrx_tx_unref(htt, &tx_done, NULL);
 		if (!status) {
 			spin_lock_bh(&htt->tx_lock);
 			ath10k_htt_tx_mgmt_dec_pending(htt);
@@ -2482,6 +2483,7 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct htt_resp *resp;
 	struct sk_buff *skb;
 	unsigned long flags;
+	unsigned int completed = 0;
 
 	__skb_queue_head_init(&tx_q);
 	__skb_queue_head_init(&rx_q);
@@ -2505,10 +2507,12 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	spin_unlock_irqrestore(&htt->tx_fetch_ind_q.lock, flags);
 
 	while ((skb = __skb_dequeue(&tx_q))) {
-		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
+		ath10k_htt_rx_frm_tx_compl(htt->ar, skb, &completed);
 		dev_kfree_skb_any(skb);
 	}
 
+	dql_completed(&htt->ar->dql, completed);
+
 	while ((skb = __skb_dequeue(&tx_ind_q))) {
 		ath10k_htt_rx_tx_fetch_ind(ar, skb);
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b2ae122381ca..2b7f7802f9f1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -367,7 +367,7 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.discard = 1;
 	tx_done.msdu_id = msdu_id;
 
-	ath10k_txrx_tx_unref(htt, &tx_done);
+	ath10k_txrx_tx_unref(htt, &tx_done, NULL);
 
 	return 0;
 }
@@ -378,6 +378,7 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 
 	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
 	idr_destroy(&htt->pending_tx);
+	dql_reset(&htt->ar->dql);
 
 	if (htt->txbuf.vaddr) {
 		size = htt->max_num_pending_tx *
@@ -839,6 +840,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	u16 freq = 0;
 	u32 frags_paddr = 0;
 	u32 txbuf_paddr;
+	size_t skb_len;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
 
 	spin_lock_bh(&htt->tx_lock);
@@ -1000,12 +1002,16 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	sg_items[1].paddr = skb_cb->paddr;
 	sg_items[1].len = prefetch_len;
 
+	skb_len = msdu->len;
+
 	res = ath10k_hif_tx_sg(htt->ar,
 			       htt->ar->htc.endpoint[htt->eid].ul_pipe_id,
 			       sg_items, ARRAY_SIZE(sg_items));
 	if (res)
 		goto err_unmap_msdu;
 
+	dql_queued(&ar->dql, skb_len);
+
 	return 0;
 
 err_unmap_msdu:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ed00853ea9cc..c848049ffdf3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3755,23 +3755,35 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_txq *txq;
 	struct ath10k_txq *artxq;
-	struct ath10k_txq *last;
 	int ret;
 	int max;
 
 	spin_lock_bh(&ar->txqs_lock);
 	rcu_read_lock();
 
-	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
-	while (!list_empty(&ar->txqs)) {
+	for (;;) {
+		if (list_empty(&ar->txqs))
+			break;
+
+		if (dql_avail(&ar->dql) < 0)
+			break;
+
 		artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
 		txq = container_of((void *)artxq, struct ieee80211_txq,
 				   drv_priv);
 
-		/* Prevent aggressive sta/tid taking over tx queue */
 		max = 16;
 		ret = 0;
-		while (ath10k_mac_tx_can_push(hw, txq) && max--) {
+		for (;;) {
+			if (!max--)
+				break;
+
+			if (!ath10k_mac_tx_can_push(hw, txq))
+				break;
+
+			if (dql_avail(&ar->dql) < 0)
+				break;
+
 			ret = ath10k_mac_tx_push_txq(hw, txq);
 			if (ret < 0)
 				break;
@@ -3783,7 +3795,7 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 
 		ath10k_htt_tx_txq_update(hw, txq);
 
-		if (artxq == last || (ret < 0 && ret != -ENOENT))
+		if (ret < 0 && ret != -ENOENT)
 			break;
 	}
 
@@ -4331,6 +4343,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 
+	dql_init(&ar->dql, HZ);
+
 	switch (ar->state) {
 	case ATH10K_STATE_OFF:
 		ar->state = ATH10K_STATE_ON;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 48e26cdfe9a5..122c8edf10a1 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -50,7 +50,8 @@ out:
 }
 
 int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
-			 const struct htt_tx_done *tx_done)
+			 const struct htt_tx_done *tx_done,
+			 unsigned int *completed)
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
@@ -87,6 +88,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (txq)
 		artxq->num_fw_queued--;
 
+	if (completed)
+		*completed += msdu->len;
+
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
index e7ea1ae1c438..3a655270bcc5 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.h
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -20,7 +20,8 @@
 #include "htt.h"
 
 int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
-			 const struct htt_tx_done *tx_done);
+			 const struct htt_tx_done *tx_done,
+			 unsigned int *completed);
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr);
-- 
2.1.4

