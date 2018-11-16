Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F9BC070C3
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF5F2084A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 11:12:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Gp4Lkwx1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EF5F2084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389592AbeKPVYc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 16:24:32 -0500
Received: from nbd.name ([46.4.11.11]:34390 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbeKPVYa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wxN7YxxuHuZ08LINxhWudqpsLVZG95PAKthBTIxowIs=; b=Gp4Lkwx1j6mDIKQlt0KG8x8Emp
        0InzT1uucfbJi/MKdzs5IbbsFtTxC5Ua+y9xQpxzJbqqq6qw0uYIjv0PGE6gry24KCuDCQdBv/ypm
        9cReM9RdesDud6WLoq14ARGHC9E+kd25r/ZJ4H9Em7jQem58rSwD+GFQAFAnPl0JqXCQ=;
Received: by maeck.local (Postfix, from userid 501)
        id 70615463F115; Fri, 16 Nov 2018 12:12:35 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/7] mt76: avoid queue/status spinlocks while passing tx status to mac80211
Date:   Fri, 16 Nov 2018 12:12:29 +0100
Message-Id: <20181116111235.86347-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is some code in the mac80211 tx status processing code that could
potentially call back into the tx codepath.
To avoid deadlocks, make sure that no tx related spinlocks are taken
during the ieee80211_tx_status call.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 11 ++--
 drivers/net/wireless/mediatek/mt76/mac80211.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     | 30 ++++------
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 11 ++--
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       | 58 ++++++++++++++++---
 6 files changed, 76 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 2d7bd26875c6..d62f8d9f2ea1 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -157,17 +157,20 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 		if (entry.schedule)
 			q->swq_queued--;
 
-		if (entry.skb)
+		q->tail = (q->tail + 1) % q->ndesc;
+		q->queued--;
+
+		if (entry.skb) {
+			spin_unlock_bh(&q->lock);
 			dev->drv->tx_complete_skb(dev, q, &entry, flush);
+			spin_lock_bh(&q->lock);
+		}
 
 		if (entry.txwi) {
 			mt76_put_txwi(dev, entry.txwi);
 			wake = true;
 		}
 
-		q->tail = (q->tail + 1) % q->ndesc;
-		q->queued--;
-
 		if (!flush && q->tail == last)
 			last = ioread32(&q->regs->dma_idx);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 85e05a825b5d..3be73b021d27 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -359,7 +359,7 @@ void mt76_unregister_device(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 
-	mt76_tx_status_flush(dev, NULL);
+	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
 	mt76_tx_free(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e1d89163ee6b..ea74ba00aebc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -648,28 +648,22 @@ void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 
 void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			 struct ieee80211_key_conf *key);
+
+void mt76_tx_status_lock(struct mt76_dev *dev, struct sk_buff_head *list)
+			 __acquires(&dev->status_list.lock);
+void mt76_tx_status_unlock(struct mt76_dev *dev, struct sk_buff_head *list)
+			   __releases(&dev->status_list.lock);
+
 int mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			   struct sk_buff *skb);
 struct sk_buff *mt76_tx_status_skb_get(struct mt76_dev *dev,
-				       struct mt76_wcid *wcid, int pktid);
-void mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb);
+				       struct mt76_wcid *wcid, int pktid,
+				       struct sk_buff_head *list);
+void mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb,
+			     struct sk_buff_head *list);
 void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb);
-
-static inline void
-mt76_tx_status_check(struct mt76_dev *dev)
-{
-	spin_lock_bh(&dev->status_list.lock);
-	mt76_tx_status_skb_get(dev, NULL, 0);
-	spin_unlock_bh(&dev->status_list.lock);
-}
-
-static inline void
-mt76_tx_status_flush(struct mt76_dev *dev, struct mt76_wcid *wcid)
-{
-	spin_lock_bh(&dev->status_list.lock);
-	mt76_tx_status_skb_get(dev, wcid, -1);
-	spin_unlock_bh(&dev->status_list.lock);
-}
+void mt76_tx_status_check(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			  bool flush);
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 59b336e34cb5..4c35d3f7fb15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -438,12 +438,13 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	struct mt76_wcid *wcid = NULL;
 	struct mt76x02_sta *msta = NULL;
 	struct mt76_dev *mdev = &dev->mt76;
+	struct sk_buff_head list;
 
 	if (stat->pktid == MT_PACKET_ID_NO_ACK)
 		return;
 
 	rcu_read_lock();
-	spin_lock_bh(&mdev->status_list.lock);
+	mt76_tx_status_lock(mdev, &list);
 
 	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
 		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
@@ -459,7 +460,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	if (wcid) {
 		if (stat->pktid)
 			status.skb = mt76_tx_status_skb_get(mdev, wcid,
-							    stat->pktid);
+							    stat->pktid, &list);
 		if (status.skb)
 			status.info = IEEE80211_SKB_CB(status.skb);
 	}
@@ -490,12 +491,12 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	}
 
 	if (status.skb)
-		mt76_tx_status_skb_done(mdev, status.skb);
+		mt76_tx_status_skb_done(mdev, status.skb, &list);
 	else
 		ieee80211_tx_status_ext(mt76_hw(dev), &status);
 
 out:
-	spin_unlock_bh(&mdev->status_list.lock);
+	mt76_tx_status_unlock(mdev, &list);
 	rcu_read_unlock();
 }
 
@@ -818,7 +819,7 @@ void mt76x02_mac_work(struct work_struct *work)
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
-	mt76_tx_status_check(&dev->mt76);
+	mt76_tx_status_check(&dev->mt76, NULL, false);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 48f2f5382b57..d2ac1a84668c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -217,7 +217,7 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int i;
 
 	mutex_lock(&dev->mt76.mutex);
-	mt76_tx_status_flush(&dev->mt76, &msta->wcid);
+	mt76_tx_status_check(&dev->mt76, &msta->wcid, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index e6cd583aafd3..e42a24628e4f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -103,8 +103,33 @@ mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
 }
 
+void
+mt76_tx_status_lock(struct mt76_dev *dev, struct sk_buff_head *list)
+		   __acquires(&dev->status_list.lock)
+{
+	__skb_queue_head_init(list);
+	spin_lock_bh(&dev->status_list.lock);
+	__acquire(&dev->status_list.lock);
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_lock);
+
+void
+mt76_tx_status_unlock(struct mt76_dev *dev, struct sk_buff_head *list)
+		      __releases(&dev->status_list.unlock)
+{
+	struct sk_buff *skb;
+
+	spin_unlock_bh(&dev->status_list.lock);
+	__release(&dev->status_list.unlock);
+
+	while ((skb = __skb_dequeue(list)) != NULL)
+		ieee80211_tx_status(dev->hw, skb);
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_unlock);
+
 static void
-__mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags)
+__mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags,
+			  struct sk_buff_head *list)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
@@ -125,13 +150,14 @@ __mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags)
 		info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	ieee80211_tx_status(dev->hw, skb);
+	__skb_queue_tail(list, skb);
 }
 
 void
-mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb)
+mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb,
+			struct sk_buff_head *list)
 {
-	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_TXS_DONE);
+	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_TXS_DONE, list);
 }
 EXPORT_SYMBOL_GPL(mt76_tx_status_skb_done);
 
@@ -173,7 +199,8 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 EXPORT_SYMBOL_GPL(mt76_tx_status_skb_add);
 
 struct sk_buff *
-mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid)
+mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid,
+		       struct sk_buff_head *list)
 {
 	struct sk_buff *skb, *tmp;
 
@@ -194,23 +221,36 @@ mt76_tx_status_skb_get(struct mt76_dev *dev, struct mt76_wcid *wcid, int pktid)
 			continue;
 
 		__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_TXS_FAILED |
-						    MT_TX_CB_TXS_DONE);
+						    MT_TX_CB_TXS_DONE, list);
 	}
 
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(mt76_tx_status_skb_get);
 
+void
+mt76_tx_status_check(struct mt76_dev *dev, struct mt76_wcid *wcid, bool flush)
+{
+	struct sk_buff_head list;
+
+	mt76_tx_status_lock(dev, &list);
+	mt76_tx_status_skb_get(dev, wcid, flush ? -1 : 0, &list);
+	mt76_tx_status_unlock(dev, &list);
+}
+EXPORT_SYMBOL_GPL(mt76_tx_status_check);
+
 void mt76_tx_complete_skb(struct mt76_dev *dev, struct sk_buff *skb)
 {
+	struct sk_buff_head list;
+
 	if (!skb->prev) {
 		ieee80211_free_txskb(dev->hw, skb);
 		return;
 	}
 
-	spin_lock_bh(&dev->status_list.lock);
-	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_DMA_DONE);
-	spin_unlock_bh(&dev->status_list.lock);
+	mt76_tx_status_lock(dev, &list);
+	__mt76_tx_status_skb_done(dev, skb, MT_TX_CB_DMA_DONE, &list);
+	mt76_tx_status_unlock(dev, &list);
 }
 EXPORT_SYMBOL_GPL(mt76_tx_complete_skb);
 
-- 
2.17.0

