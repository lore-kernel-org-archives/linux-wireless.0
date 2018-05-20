Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51964 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbeETFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 01:43:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/5] mt76: wait for pending tx to complete before switching channel
Date: Sun, 20 May 2018 07:43:48 +0200
Message-Id: <20180520054349.49422-4-nbd@nbd.name> (sfid-20180520_074405_416775_1376A160)
In-Reply-To: <20180520054349.49422-1-nbd@nbd.name>
References: <20180520054349.49422-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduces interruption caused by scanning

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  4 ++++
 drivers/net/wireless/mediatek/mt76/mac80211.c | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 3518703524e7..3dbedcedc2c4 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -178,6 +178,10 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 		mt76_dma_sync_idx(dev, q);
 
 	wake = wake && qid < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+
+	if (!q->queued)
+		wake_up(&dev->tx_wait);
+
 	spin_unlock_bh(&q->lock);
 
 	if (wake)
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d1044e5b25db..fcd079a96782 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -283,6 +283,7 @@ mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
 	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->lock);
 	spin_lock_init(&dev->cc_lock);
+	init_waitqueue_head(&dev->tx_wait);
 
 	return dev;
 }
@@ -377,18 +378,33 @@ void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76_rx);
 
+static bool mt76_has_tx_pending(struct mt76_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
+		if (dev->q_tx[i].queued)
+			return true;
+	}
+
+	return false;
+}
+
 void mt76_set_channel(struct mt76_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->hw;
 	struct cfg80211_chan_def *chandef = &hw->conf.chandef;
 	struct mt76_channel_state *state;
 	bool offchannel = hw->conf.flags & IEEE80211_CONF_OFFCHANNEL;
+	int timeout = HZ / 5;
 
 	if (offchannel)
 		set_bit(MT76_OFFCHANNEL, &dev->state);
 	else
 		clear_bit(MT76_OFFCHANNEL, &dev->state);
 
+	wait_event_timeout(dev->tx_wait, !mt76_has_tx_pending(dev), timeout);
+
 	if (dev->drv->update_survey)
 		dev->drv->update_survey(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index bb158f867d7c..d2166fbf50ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -251,6 +251,8 @@ struct mt76_dev {
 	struct mt76_queue q_rx[__MT_RXQ_MAX];
 	const struct mt76_queue_ops *queue_ops;
 
+	wait_queue_head_t tx_wait;
+
 	u8 macaddr[ETH_ALEN];
 	u32 rev;
 	unsigned long state;
-- 
2.17.0
