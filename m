Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36088 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbeDYJL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 05:11:27 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/4] mt76: fix concurrent rx calls on A-MPDU release
Date: Wed, 25 Apr 2018 11:11:21 +0200
Message-Id: <20180425091124.909-1-nbd@nbd.name> (sfid-20180425_111139_696377_C72133B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a spinlock in mt76_rx_complete. Without this, multiple stats updates
could happen in parallel, which can lead to deadlocks. There are
probably more corner cases fixed by this change.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76.h        | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index eb49e0a6758c..915e61733131 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -561,6 +561,7 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 	if (queue >= 0)
 	    napi = &dev->napi[queue];
 
+	spin_lock(&dev->rx_lock);
 	while ((skb = __skb_dequeue(frames)) != NULL) {
 		if (mt76_check_ccmp_pn(skb)) {
 			dev_kfree_skb(skb);
@@ -570,6 +571,7 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		sta = mt76_rx_convert(skb);
 		ieee80211_rx_napi(dev->hw, sta, skb, napi);
 	}
+	spin_unlock(&dev->rx_lock);
 }
 
 void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 065ff78059c3..a74e6eef51e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -241,6 +241,7 @@ struct mt76_dev {
 	struct device *dev;
 
 	struct net_device napi_dev;
+	spinlock_t rx_lock;
 	struct napi_struct napi[__MT_RXQ_MAX];
 	struct sk_buff_head rx_skb[__MT_RXQ_MAX];
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 359b105235b3..d21e4a7c1bb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -645,6 +645,7 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 	dev->mt76.drv = &drv_ops;
 	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->irq_lock);
+	spin_lock_init(&dev->mt76.rx_lock);
 
 	return dev;
 }
-- 
2.14.2
