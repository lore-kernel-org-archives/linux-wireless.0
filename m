Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48660 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933953AbeAXPTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 6/8] mt76: split mt76_rx_complete
Date: Wed, 24 Jan 2018 16:19:15 +0100
Message-Id: <20180124151917.70962-6-nbd@nbd.name> (sfid-20180124_161933_036508_F311672F)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a separate function for processing frames after A-MPDU reordering,
reduce code duplication

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c   |  8 +-------
 drivers/net/wireless/mediatek/mt76/dma.c      |  2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 24 ++++++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt76.h     |  5 +++--
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index ecd0bcd149e5..8027bb7c03c2 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -97,9 +97,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 	struct mt76_rx_tid *tid = container_of(work, struct mt76_rx_tid,
 					       reorder_work.work);
 	struct mt76_dev *dev = tid->dev;
-	struct ieee80211_sta *sta;
 	struct sk_buff_head frames;
-	struct sk_buff *skb;
 
 	__skb_queue_head_init(&frames);
 
@@ -110,11 +108,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 	spin_unlock(&tid->lock);
 
 	ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work, REORDER_TIMEOUT);
-
-	while ((skb = __skb_dequeue(&frames)) != NULL) {
-		sta = mt76_rx_convert(skb);
-		ieee80211_rx_napi(dev->hw, sta, skb, NULL);
-	}
+	mt76_rx_complete(dev, &frames, -1);
 
 	local_bh_enable();
 }
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index fd8bea144973..3518703524e7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -396,7 +396,7 @@ mt76_dma_rx_poll(struct napi_struct *napi, int budget)
 
 	do {
 		cur = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget - done);
-		mt76_rx_complete(dev, qid);
+		mt76_rx_poll_complete(dev, qid);
 		done += cur;
 	} while (cur && done < budget);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5978e5b0a2fe..77f1be161009 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -384,7 +384,7 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(mt76_get_survey);
 
-struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
+static struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mt76_rx_status mstat;
@@ -410,9 +410,24 @@ struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 	return wcid_to_sta(mstat.wcid);
 }
 
-void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
+void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
+		      int queue)
 {
+	struct napi_struct *napi = NULL;
 	struct ieee80211_sta *sta;
+	struct sk_buff *skb;
+
+	if (queue >= 0)
+	    napi = &dev->napi[queue];
+
+	while ((skb = __skb_dequeue(frames)) != NULL) {
+		sta = mt76_rx_convert(skb);
+		ieee80211_rx_napi(dev->hw, sta, skb, napi);
+	}
+}
+
+void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
+{
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
 
@@ -421,8 +436,5 @@ void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL)
 		mt76_rx_aggr_reorder(skb, &frames);
 
-	while ((skb = __skb_dequeue(&frames)) != NULL) {
-		sta = mt76_rx_convert(skb);
-		ieee80211_rx_napi(dev->hw, sta, skb, &dev->napi[q]);
-	}
+	mt76_rx_complete(dev, &frames, q);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index cde199ed3f57..af98bc65c2e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -416,8 +416,9 @@ void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
-void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
+void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
+		      int queue);
+void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
 void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames);
-struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
 #endif
-- 
2.14.2
