Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDB8C282E5
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3838208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="IAo8W2K3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfDYIiw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:38:52 -0400
Received: from nbd.name ([46.4.11.11]:59704 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729857AbfDYIir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iRvjtXcKN7+frJceUmq95VoEBT/3cMoRq3g/KL8m+LY=; b=IAo8W2K3fpxX1+QFEVZlJXPLW6
        8MNFGPgSPLwx0xBuPbSgupMrAJhC333qCvnmycdPm9pOjE+e3BILm4DLUK8XK3tmfUpGssQp6OBJ7
        jmWQGthzU5nhPQNksiOuZizL0a4mJG/k0FPSi6b2uzjNceGQjtvbMSyxZ6d8f+fbUZAM=;
Received: from p54ae9e78.dip0.t-ipconnect.de ([84.174.158.120] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hJZu1-0002Bm-MJ
        for linux-wireless@vger.kernel.org; Thu, 25 Apr 2019 10:38:45 +0200
Received: by maeck-2.local (Postfix, from userid 501)
        id 0D6CB59A3378; Thu, 25 Apr 2019 10:38:44 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/5] mt76: use mac80211 txq scheduling
Date:   Thu, 25 Apr 2019 10:38:40 +0200
Message-Id: <20190425083844.14186-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Performance improvement and preparation for adding airtime fairness support

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |   6 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c |  15 +++
 drivers/net/wireless/mediatek/mt76/mt76.h     |   3 +-
 drivers/net/wireless/mediatek/mt76/tx.c       | 101 ++++++++----------
 drivers/net/wireless/mediatek/mt76/usb.c      |   3 +-
 5 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index cdeca22bf3a7..7145b75b6438 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -184,9 +184,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 			last = readl(&q->regs->dma_idx);
 	}
 
-	if (!flush)
-		mt76_txq_schedule(dev, sq);
-	else
+	if (flush)
 		mt76_dma_sync_idx(dev, q);
 
 	wake = wake && q->stopped &&
@@ -199,6 +197,8 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 
 	spin_unlock_bh(&q->lock);
 
+	if (!flush)
+		mt76_txq_schedule(dev, qid);
 	if (wake)
 		ieee80211_wake_queue(dev->hw, qid);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 4b63d061c2a0..60b86ca00b3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -568,6 +568,7 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 	struct ieee80211_sta *sta;
 	struct mt76_wcid *wcid = status->wcid;
 	bool ps;
+	int i;
 
 	if (ieee80211_is_pspoll(hdr->frame_control) && !wcid) {
 		sta = ieee80211_find_sta_by_ifaddr(dev->hw, hdr->addr2, NULL);
@@ -614,6 +615,20 @@ mt76_check_sta(struct mt76_dev *dev, struct sk_buff *skb)
 
 	dev->drv->sta_ps(dev, sta, ps);
 	ieee80211_sta_ps_transition(sta, ps);
+
+	if (ps)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct mt76_txq *mtxq;
+
+		if (!sta->txq[i])
+			continue;
+
+		mtxq = (struct mt76_txq *) sta->txq[i]->drv_priv;
+		if (!skb_queue_empty(&mtxq->retry_q))
+			ieee80211_schedule_txq(dev->hw, sta->txq[i]);
+	}
 }
 
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f0d34901c825..e68834ee8393 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -216,7 +216,6 @@ struct mt76_wcid {
 };
 
 struct mt76_txq {
-	struct list_head list;
 	struct mt76_sw_queue *swq;
 	struct mt76_wcid *wcid;
 
@@ -676,7 +675,7 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			 bool send_bar);
-void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_sw_queue *sq);
+void mt76_txq_schedule(struct mt76_dev *dev, enum mt76_txq_id qid);
 void mt76_txq_schedule_all(struct mt76_dev *dev);
 void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 2c82db0b5834..48f588726b3f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -479,23 +479,37 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_sw_queue *sq,
 }
 
 static int
-mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_sw_queue *sq)
+mt76_txq_schedule_list(struct mt76_dev *dev, enum mt76_txq_id qid)
 {
+	struct mt76_sw_queue *sq = &dev->q_tx[qid];
 	struct mt76_queue *hwq = sq->q;
-	struct mt76_txq *mtxq, *mtxq_last;
-	int len = 0;
+	struct ieee80211_txq *txq;
+	struct mt76_txq *mtxq;
+	struct mt76_wcid *wcid;
+	int ret = 0;
 
-restart:
-	mtxq_last = list_last_entry(&sq->swq, struct mt76_txq, list);
-	while (!list_empty(&sq->swq)) {
+	spin_lock_bh(&hwq->lock);
+	while (1) {
 		bool empty = false;
-		int cur;
+
+		if (sq->swq_queued >= 4)
+			break;
 
 		if (test_bit(MT76_OFFCHANNEL, &dev->state) ||
-		    test_bit(MT76_RESET, &dev->state))
-			return -EBUSY;
+		    test_bit(MT76_RESET, &dev->state)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		txq = ieee80211_next_txq(dev->hw, qid);
+		if (!txq)
+			break;
+
+		mtxq = (struct mt76_txq *)txq->drv_priv;
+		wcid = mtxq->wcid;
+		if (wcid && test_bit(MT_WCID_FLAG_PS, &wcid->flags))
+			continue;
 
-		mtxq = list_first_entry(&sq->swq, struct mt76_txq, list);
 		if (mtxq->send_bar && mtxq->aggr) {
 			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 			struct ieee80211_sta *sta = txq->sta;
@@ -507,38 +521,37 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_sw_queue *sq)
 			spin_unlock_bh(&hwq->lock);
 			ieee80211_send_bar(vif, sta->addr, tid, agg_ssn);
 			spin_lock_bh(&hwq->lock);
-			goto restart;
 		}
 
-		list_del_init(&mtxq->list);
-
-		cur = mt76_txq_send_burst(dev, sq, mtxq, &empty);
-		if (!empty)
-			list_add_tail(&mtxq->list, &sq->swq);
-
-		if (cur < 0)
-			return cur;
-
-		len += cur;
-
-		if (mtxq == mtxq_last)
-			break;
+		ret += mt76_txq_send_burst(dev, sq, mtxq, &empty);
+		if (skb_queue_empty(&mtxq->retry_q))
+			empty = true;
+		ieee80211_return_txq(dev->hw, txq, !empty);
 	}
+	spin_unlock_bh(&hwq->lock);
 
-	return len;
+	return ret;
 }
 
-void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_sw_queue *sq)
+void mt76_txq_schedule(struct mt76_dev *dev, enum mt76_txq_id qid)
 {
+	struct mt76_sw_queue *sq = &dev->q_tx[qid];
 	int len;
 
+	if (qid >= 4)
+		return;
+
+	if (sq->swq_queued >= 4)
+		return;
+
 	rcu_read_lock();
-	do {
-		if (sq->swq_queued >= 4 || list_empty(&sq->swq))
-			break;
 
-		len = mt76_txq_schedule_list(dev, sq);
+	do {
+		ieee80211_txq_schedule_start(dev->hw, qid);
+		len = mt76_txq_schedule_list(dev, qid);
+		ieee80211_txq_schedule_end(dev->hw, qid);
 	} while (len > 0);
+
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(mt76_txq_schedule);
@@ -547,13 +560,8 @@ void mt76_txq_schedule_all(struct mt76_dev *dev)
 {
 	int i;
 
-	for (i = 0; i <= MT_TXQ_BK; i++) {
-		struct mt76_queue *q = dev->q_tx[i].q;
-
-		spin_lock_bh(&q->lock);
-		mt76_txq_schedule(dev, &dev->q_tx[i]);
-		spin_unlock_bh(&q->lock);
-	}
+	for (i = 0; i <= MT_TXQ_BK; i++)
+		mt76_txq_schedule(dev, i);
 }
 EXPORT_SYMBOL_GPL(mt76_txq_schedule_all);
 
@@ -575,8 +583,6 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 		spin_lock_bh(&hwq->lock);
 		mtxq->send_bar = mtxq->aggr && send_bar;
-		if (!list_empty(&mtxq->list))
-			list_del_init(&mtxq->list);
 		spin_unlock_bh(&hwq->lock);
 	}
 }
@@ -585,24 +591,16 @@ EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
 	struct mt76_dev *dev = hw->priv;
-	struct mt76_txq *mtxq = (struct mt76_txq *)txq->drv_priv;
-	struct mt76_sw_queue *sq = mtxq->swq;
-	struct mt76_queue *hwq = sq->q;
 
 	if (!test_bit(MT76_STATE_RUNNING, &dev->state))
 		return;
 
-	spin_lock_bh(&hwq->lock);
-	if (list_empty(&mtxq->list))
-		list_add_tail(&mtxq->list, &sq->swq);
-	mt76_txq_schedule(dev, sq);
-	spin_unlock_bh(&hwq->lock);
+	mt76_txq_schedule(dev, txq->ac);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 {
-	struct mt76_queue *hwq;
 	struct mt76_txq *mtxq;
 	struct sk_buff *skb;
 
@@ -610,12 +608,6 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 		return;
 
 	mtxq = (struct mt76_txq *) txq->drv_priv;
-	hwq = mtxq->swq->q;
-
-	spin_lock_bh(&hwq->lock);
-	if (!list_empty(&mtxq->list))
-		list_del_init(&mtxq->list);
-	spin_unlock_bh(&hwq->lock);
 
 	while ((skb = skb_dequeue(&mtxq->retry_q)) != NULL)
 		ieee80211_free_txskb(dev->hw, skb);
@@ -626,7 +618,6 @@ void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 {
 	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
 
-	INIT_LIST_HEAD(&mtxq->list);
 	skb_queue_head_init(&mtxq->retry_q);
 
 	mtxq->swq = &dev->q_tx[mt76_txq_get_qid(txq)];
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a3acc070063a..d93dadce95ab 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -645,7 +645,6 @@ static void mt76u_tx_tasklet(unsigned long data)
 			dev->drv->tx_complete_skb(dev, i, &entry);
 			spin_lock_bh(&q->lock);
 		}
-		mt76_txq_schedule(dev, sq);
 
 		wake = q->stopped && q->queued < q->ndesc - 8;
 		if (wake)
@@ -656,6 +655,8 @@ static void mt76u_tx_tasklet(unsigned long data)
 
 		spin_unlock_bh(&q->lock);
 
+		mt76_txq_schedule(dev, i);
+
 		if (!test_and_set_bit(MT76_READING_STATS, &dev->state))
 			ieee80211_queue_delayed_work(dev->hw,
 						     &dev->usb.stat_work,
-- 
2.17.0

