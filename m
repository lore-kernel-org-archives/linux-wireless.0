Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:19880 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbGaNLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 09:11:38 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH -next 3/4] mt7601u: fix tx status reporting contexts
Date: Fri, 31 Jul 2015 15:04:48 +0200
Message-Id: <1438347889-14669-3-git-send-email-moorray3@wp.pl> (sfid-20150731_151142_066717_820105FD)
In-Reply-To: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
References: <1438347889-14669-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

mac80211 requires that rx path does not run concurrently with
tx status reporting.  Since rx path is run in driver tasklet,
tx status cannot be reported directly from interrupt context
(there would be no way to lock it out).

Add tasklet for tx and move all possible code from irq handler
there.

Note: tx tasklet is needed because workqueue is queued very
      rarely and that kills TCP performance.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c     | 30 +++++++++++++++++++++----
 drivers/net/wireless/mediatek/mt7601u/init.c    |  1 +
 drivers/net/wireless/mediatek/mt7601u/mac.c     |  4 ++++
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  2 ++
 4 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index fb183e369d92..63c485443a38 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -236,23 +236,42 @@ static void mt7601u_complete_tx(struct urb *urb)
 	skb = q->e[q->start].skb;
 	trace_mt_tx_dma_done(dev, skb);
 
-	mt7601u_tx_status(dev, skb);
+	__skb_queue_tail(&dev->tx_skb_done, skb);
+	tasklet_schedule(&dev->tx_tasklet);
 
 	if (q->used == q->entries - q->entries / 8)
 		ieee80211_wake_queue(dev->hw, skb_get_queue_mapping(skb));
 
 	q->start = (q->start + 1) % q->entries;
 	q->used--;
+out:
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+}
 
-	if (urb->status)
-		goto out;
+static void mt7601u_tx_tasklet(unsigned long data)
+{
+	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
+	struct sk_buff_head skbs;
+	unsigned long flags;
+
+	__skb_queue_head_init(&skbs);
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
 
 	set_bit(MT7601U_STATE_MORE_STATS, &dev->state);
 	if (!test_and_set_bit(MT7601U_STATE_READING_STATS, &dev->state))
 		queue_delayed_work(dev->stat_wq, &dev->stat_work,
 				   msecs_to_jiffies(10));
-out:
+
+	skb_queue_splice_init(&dev->tx_skb_done, &skbs);
+
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+	while (!skb_queue_empty(&skbs)) {
+		struct sk_buff *skb = __skb_dequeue(&skbs);
+
+		mt7601u_tx_status(dev, skb);
+	}
 }
 
 static int mt7601u_dma_submit_tx(struct mt7601u_dev *dev,
@@ -475,6 +494,7 @@ int mt7601u_dma_init(struct mt7601u_dev *dev)
 {
 	int ret = -ENOMEM;
 
+	tasklet_init(&dev->tx_tasklet, mt7601u_tx_tasklet, (unsigned long) dev);
 	tasklet_init(&dev->rx_tasklet, mt7601u_rx_tasklet, (unsigned long) dev);
 
 	ret = mt7601u_alloc_tx(dev);
@@ -502,4 +522,6 @@ void mt7601u_dma_cleanup(struct mt7601u_dev *dev)
 
 	mt7601u_free_rx(dev);
 	mt7601u_free_tx(dev);
+
+	tasklet_kill(&dev->tx_tasklet);
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index df3dd56199a7..38eb20ba6e58 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -456,6 +456,7 @@ struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
 	spin_lock_init(&dev->lock);
 	spin_lock_init(&dev->con_mon_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
+	skb_queue_head_init(&dev->tx_skb_done);
 
 	dev->stat_wq = alloc_workqueue("mt7601u", WQ_UNBOUND, 0);
 	if (!dev->stat_wq) {
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index 7514bce1ac91..e3928cfa3d63 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -181,7 +181,11 @@ void mt76_send_tx_status(struct mt7601u_dev *dev, struct mt76_tx_status *stat)
 	}
 
 	mt76_mac_fill_tx_status(dev, &info, stat);
+
+	local_bh_disable();
 	ieee80211_tx_status_noskb(dev->hw, sta, &info);
+	local_bh_enable();
+
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index 6bdfc1103fcc..bc5e294feb8c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -199,7 +199,9 @@ struct mt7601u_dev {
 
 	/* TX */
 	spinlock_t tx_lock;
+	struct tasklet_struct tx_tasklet;
 	struct mt7601u_tx_queue *tx_q;
+	struct sk_buff_head tx_skb_done;
 
 	atomic_t avg_ampdu_len;
 
-- 
2.1.0

