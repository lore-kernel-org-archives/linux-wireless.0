Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43184 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbeETIPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 04:15:44 -0400
Received: by mail-wr0-f195.google.com with SMTP id r13-v6so682189wrj.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2018 01:15:43 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v2 07/18] mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete signatures
Date: Sun, 20 May 2018 10:15:11 +0200
Message-Id: <20180520081522.10163-8-lorenzo.bianconi@redhat.com> (sfid-20180520_101555_405149_94D94BF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in order to reuse mt76_rx_complete routine supporting mt76x2u based
devices add napi struct to mt76_rx_poll_complete and mt76_rx_complete
routine signatures and do not fetch it according to the rx queue index

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/dma.c      |  2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 12 +++++-------
 drivers/net/wireless/mediatek/mt76/mt76.h     |  5 +++--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index b67acc6189bf..8df0d41f7317 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -113,7 +113,7 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 	if (nframes)
 		ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work,
 					     REORDER_TIMEOUT);
-	mt76_rx_complete(dev, &frames, -1);
+	mt76_rx_complete(dev, &frames, NULL);
 
 	rcu_read_unlock();
 	local_bh_enable();
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 3518703524e7..528132c3d1cd 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -396,7 +396,7 @@ mt76_dma_rx_poll(struct napi_struct *napi, int budget)
 
 	do {
 		cur = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget - done);
-		mt76_rx_poll_complete(dev, qid);
+		mt76_rx_poll_complete(dev, qid, napi);
 		done += cur;
 	} while (cur && done < budget);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index da5254b48cf7..600db8e689aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -537,15 +537,11 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 }
 
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
-		      int queue)
+		      struct napi_struct *napi)
 {
-	struct napi_struct *napi = NULL;
 	struct ieee80211_sta *sta;
 	struct sk_buff *skb;
 
-	if (queue >= 0)
-	    napi = &dev->napi[queue];
-
 	spin_lock(&dev->rx_lock);
 	while ((skb = __skb_dequeue(frames)) != NULL) {
 		if (mt76_check_ccmp_pn(skb)) {
@@ -559,7 +555,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 	spin_unlock(&dev->rx_lock);
 }
 
-void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
+void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
+			   struct napi_struct *napi)
 {
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
@@ -571,5 +568,6 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 		mt76_rx_aggr_reorder(skb, &frames);
 	}
 
-	mt76_rx_complete(dev, &frames, q);
+	mt76_rx_complete(dev, &frames, napi);
 }
+EXPORT_SYMBOL_GPL(mt76_rx_poll_complete);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a74e6eef51e9..f4144c3e70d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -439,8 +439,9 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 void mt76_tx_free(struct mt76_dev *dev);
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
-		      int queue);
-void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
+		      struct napi_struct *napi);
+void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
+			   struct napi_struct *napi);
 void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames);
 
 #endif
-- 
2.16.3
