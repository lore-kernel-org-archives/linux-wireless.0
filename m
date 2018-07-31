Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46678 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbeGaJsk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id h14-v6so15606706wrw.13
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 07/19] mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete signatures
Date: Tue, 31 Jul 2018 10:09:08 +0200
Message-Id: <0c0924eb76aeef8014b9fc08d92fc27db6a65738.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100936_606638_DB88F363)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
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
index 1e8cdce919d9..73c8b2805c97 100644
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
index 3dbedcedc2c4..872b1c53e246 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -400,7 +400,7 @@ mt76_dma_rx_poll(struct napi_struct *napi, int budget)
 
 	do {
 		cur = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget - done);
-		mt76_rx_poll_complete(dev, qid);
+		mt76_rx_poll_complete(dev, qid, napi);
 		done += cur;
 	} while (cur && done < budget);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 6a0b6f4403a8..029d54bce9e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -583,15 +583,11 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
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
@@ -605,7 +601,8 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 	spin_unlock(&dev->rx_lock);
 }
 
-void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
+void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
+			   struct napi_struct *napi)
 {
 	struct sk_buff_head frames;
 	struct sk_buff *skb;
@@ -617,5 +614,6 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 		mt76_rx_aggr_reorder(skb, &frames);
 	}
 
-	mt76_rx_complete(dev, &frames, q);
+	mt76_rx_complete(dev, &frames, napi);
 }
+EXPORT_SYMBOL_GPL(mt76_rx_poll_complete);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 96e9798bb8a0..eb0fd602b9cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -456,8 +456,9 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
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
2.17.1
