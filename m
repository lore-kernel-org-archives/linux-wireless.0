Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B303C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111862085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551432147;
	bh=e2OC1c1eL4mlPvHF90fSI//xJJAMUa4hQ43TXgouBqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=K8z1jZz8gmqY6YkAUGv9FRwbkBa1kP7rCDpYAg36kwtm6EipudHRvFwORe8H79Urf
	 qCyH0GcaVd7p5mNVJNhhWG31t8fGA8dzMgBvB5F6u+qFikz3IiZjUnnT5N2Oc/ZZCa
	 e8fpyxlMNpSa+Khoku3B3pILDlj4OQi5E+ugQgoY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbfCAJW0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfCAJW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 04:22:26 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DAB2085A;
        Fri,  1 Mar 2019 09:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551432144;
        bh=e2OC1c1eL4mlPvHF90fSI//xJJAMUa4hQ43TXgouBqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGpkiJAauIipN6w2qwCrEyuiOG4fnm/dl1L/4Y4LHC+0o/losz6Q2gG9Ox1Ifw5tm
         EA97DsaHl/0+4tA3L9A6cA7oR1ACqJyNfV4oPXPmW3Ngqr1f72qzQ2+1trYXOxqgHE
         ZZN4DRshbKlxq3dEmDzvbYnDuWwDfazfg5mgnKs4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
        roychl666@gmail.com, lorenzo.bianconi@redhat.com
Subject: [RFC 1/2] mt76: rename mt76_queue pointer occurrences from hwq to q
Date:   Fri,  1 Mar 2019 10:22:03 +0100
Message-Id: <4885f3f4c04363baa27cddba5f70b8d1a9085348.1551431791.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551431791.git.lorenzo@kernel.org>
References: <cover.1551431791.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a preliminary patch for the introduction on mt76_hw_queue
structure needed to properly support new chipsets (e.g. mt7615)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 +-
 drivers/net/wireless/mediatek/mt76/tx.c   | 71 +++++++++++------------
 2 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 29409f0871b7..5a87bb03cf05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -212,7 +212,7 @@ struct mt76_wcid {
 
 struct mt76_txq {
 	struct list_head list;
-	struct mt76_queue *hwq;
+	struct mt76_queue *q;
 	struct mt76_wcid *wcid;
 
 	struct sk_buff_head retry_q;
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5a349fe3e576..8babda95d283 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -324,7 +324,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *) sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
+	struct mt76_queue *q = &dev->q_tx[MT_TXQ_PSD];
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
 	if (last)
@@ -332,7 +332,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	mt76_skb_set_moredata(skb, !last);
-	dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
 }
 
 void
@@ -343,10 +343,10 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 {
 	struct mt76_dev *dev = hw->priv;
 	struct sk_buff *last_skb = NULL;
-	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
+	struct mt76_queue *q = &dev->q_tx[MT_TXQ_PSD];
 	int i;
 
-	spin_lock_bh(&hwq->lock);
+	spin_lock_bh(&q->lock);
 	for (i = 0; tids && nframes; i++, tids >>= 1) {
 		struct ieee80211_txq *txq = sta->txq[i];
 		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
@@ -373,14 +373,14 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 	if (last_skb) {
 		mt76_queue_ps_skb(dev, sta, last_skb, true);
-		dev->queue_ops->kick(dev, hwq);
+		dev->queue_ops->kick(dev, q);
 	}
-	spin_unlock_bh(&hwq->lock);
+	spin_unlock_bh(&q->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_release_buffered_frames);
 
 static int
-mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
+mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *q,
 		    struct mt76_txq *mtxq, bool *empty)
 {
 	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
@@ -417,7 +417,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	if (ampdu)
 		mt76_check_agg_ssn(mtxq, skb);
 
-	idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+	idx = dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, txq->sta);
 
 	if (idx < 0)
 		return idx;
@@ -452,7 +452,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (cur_ampdu)
 			mt76_check_agg_ssn(mtxq, skb);
 
-		idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid,
+		idx = dev->queue_ops->tx_queue_skb(dev, q, skb, wcid,
 						   txq->sta);
 		if (idx < 0)
 			return idx;
@@ -461,24 +461,24 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	} while (n_frames < limit);
 
 	if (!probe) {
-		hwq->swq_queued++;
-		hwq->entry[idx].schedule = true;
+		q->swq_queued++;
+		q->entry[idx].schedule = true;
 	}
 
-	dev->queue_ops->kick(dev, hwq);
+	dev->queue_ops->kick(dev, q);
 
 	return n_frames;
 }
 
 static int
-mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
+mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *q)
 {
 	struct mt76_txq *mtxq, *mtxq_last;
 	int len = 0;
 
 restart:
-	mtxq_last = list_last_entry(&hwq->swq, struct mt76_txq, list);
-	while (!list_empty(&hwq->swq)) {
+	mtxq_last = list_last_entry(&q->swq, struct mt76_txq, list);
+	while (!list_empty(&q->swq)) {
 		bool empty = false;
 		int cur;
 
@@ -486,7 +486,7 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 		    test_bit(MT76_RESET, &dev->state))
 			return -EBUSY;
 
-		mtxq = list_first_entry(&hwq->swq, struct mt76_txq, list);
+		mtxq = list_first_entry(&q->swq, struct mt76_txq, list);
 		if (mtxq->send_bar && mtxq->aggr) {
 			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 			struct ieee80211_sta *sta = txq->sta;
@@ -495,17 +495,17 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 			u8 tid = txq->tid;
 
 			mtxq->send_bar = false;
-			spin_unlock_bh(&hwq->lock);
+			spin_unlock_bh(&q->lock);
 			ieee80211_send_bar(vif, sta->addr, tid, agg_ssn);
-			spin_lock_bh(&hwq->lock);
+			spin_lock_bh(&q->lock);
 			goto restart;
 		}
 
 		list_del_init(&mtxq->list);
 
-		cur = mt76_txq_send_burst(dev, hwq, mtxq, &empty);
+		cur = mt76_txq_send_burst(dev, q, mtxq, &empty);
 		if (!empty)
-			list_add_tail(&mtxq->list, &hwq->swq);
+			list_add_tail(&mtxq->list, &q->swq);
 
 		if (cur < 0)
 			return cur;
@@ -519,16 +519,16 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 	return len;
 }
 
-void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq)
+void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *q)
 {
 	int len;
 
 	rcu_read_lock();
 	do {
-		if (hwq->swq_queued >= 4 || list_empty(&hwq->swq))
+		if (q->swq_queued >= 4 || list_empty(&q->swq))
 			break;
 
-		len = mt76_txq_schedule_list(dev, hwq);
+		len = mt76_txq_schedule_list(dev, q);
 	} while (len > 0);
 	rcu_read_unlock();
 }
@@ -562,45 +562,42 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
 
-		spin_lock_bh(&mtxq->hwq->lock);
+		spin_lock_bh(&mtxq->q->lock);
 		mtxq->send_bar = mtxq->aggr && send_bar;
 		if (!list_empty(&mtxq->list))
 			list_del_init(&mtxq->list);
-		spin_unlock_bh(&mtxq->hwq->lock);
+		spin_unlock_bh(&mtxq->q->lock);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
+	struct mt76_txq *mtxq = (struct mt76_txq *)txq->drv_priv;
 	struct mt76_dev *dev = hw->priv;
-	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
-	struct mt76_queue *hwq = mtxq->hwq;
 
-	spin_lock_bh(&hwq->lock);
+	spin_lock_bh(&mtxq->q->lock);
 	if (list_empty(&mtxq->list))
-		list_add_tail(&mtxq->list, &hwq->swq);
-	mt76_txq_schedule(dev, hwq);
-	spin_unlock_bh(&hwq->lock);
+		list_add_tail(&mtxq->list, &mtxq->q->swq);
+	mt76_txq_schedule(dev, mtxq->q);
+	spin_unlock_bh(&mtxq->q->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 {
 	struct mt76_txq *mtxq;
-	struct mt76_queue *hwq;
 	struct sk_buff *skb;
 
 	if (!txq)
 		return;
 
-	mtxq = (struct mt76_txq *) txq->drv_priv;
-	hwq = mtxq->hwq;
+	mtxq = (struct mt76_txq *)txq->drv_priv;
 
-	spin_lock_bh(&hwq->lock);
+	spin_lock_bh(&mtxq->q->lock);
 	if (!list_empty(&mtxq->list))
 		list_del_init(&mtxq->list);
-	spin_unlock_bh(&hwq->lock);
+	spin_unlock_bh(&mtxq->q->lock);
 
 	while ((skb = skb_dequeue(&mtxq->retry_q)) != NULL)
 		ieee80211_free_txskb(dev->hw, skb);
@@ -614,7 +611,7 @@ void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 	INIT_LIST_HEAD(&mtxq->list);
 	skb_queue_head_init(&mtxq->retry_q);
 
-	mtxq->hwq = &dev->q_tx[mt76_txq_get_qid(txq)];
+	mtxq->q = &dev->q_tx[mt76_txq_get_qid(txq)];
 }
 EXPORT_SYMBOL_GPL(mt76_txq_init);
 
-- 
2.20.1

