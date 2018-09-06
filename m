Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbeIFNyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:21 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 19/42] mt76x0: remove unused stat work_queue
Date: Thu,  6 Sep 2018 11:18:35 +0200
Message-Id: <1536225538-16454-20-git-send-email-sgruszka@redhat.com> (sfid-20180906_111953_490363_E0584360)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Remove unused tx_status workqueue since now tx feedbacks are
processed by mt76-usb layer

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  7 -----
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 30 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 --
 4 files changed, 41 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 9c4029b3d0ae..5be4c48936e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -511,12 +511,6 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	spin_lock_init(&dev->con_mon_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
 
-	dev->stat_wq = alloc_workqueue("mt76x0", WQ_UNBOUND, 0);
-	if (!dev->stat_wq) {
-		ieee80211_free_hw(mdev->hw);
-		return NULL;
-	}
-
 	return dev;
 }
 
@@ -715,7 +709,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	dev->mt76.chandef.chan = &dev->mt76.sband_2g.sband.channels[0];
 
 	INIT_DELAYED_WORK(&dev->mac_work, mt76x0_mac_work);
-	INIT_DELAYED_WORK(&dev->stat_work, mt76x0_tx_stat);
 
 	ret = ieee80211_register_hw(hw);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 974ca932333c..f63c44999bdd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -132,7 +132,6 @@ struct mt76x0_dev {
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-	struct workqueue_struct *stat_wq;
 	struct delayed_work stat_work;
 
 	spinlock_t mac_lock;
@@ -237,7 +236,6 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
 void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb);
-void mt76x0_tx_stat(struct work_struct *work);
 
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 2b7ca7cd48c1..de12c769b353 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -126,33 +126,3 @@ void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	mt76_rx(&dev->mt76, q, skb);
 }
 
-void mt76x0_tx_stat(struct work_struct *work)
-{
-	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
-					       stat_work.work);
-	struct mt76x02_tx_status stat;
-	unsigned long flags;
-	int cleaned = 0;
-	u8 update = 1;
-
-	while (!test_bit(MT76_REMOVED, &dev->mt76.state)) {
-		if (!mt76x02_mac_load_tx_status(&dev->mt76, &stat))
-			break;
-
-		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
-
-		cleaned++;
-	}
-	trace_mt76x0_tx_status_cleaned(&dev->mt76, cleaned);
-
-	spin_lock_irqsave(&dev->tx_lock, flags);
-	if (cleaned)
-		queue_delayed_work(dev->stat_wq, &dev->stat_work,
-				   msecs_to_jiffies(10));
-	else if (test_and_clear_bit(MT76_MORE_STATS, &dev->mt76.state))
-		queue_delayed_work(dev->stat_wq, &dev->stat_work,
-				   msecs_to_jiffies(20));
-	else
-		clear_bit(MT76_READING_STATS, &dev->mt76.state);
-	spin_unlock_irqrestore(&dev->tx_lock, flags);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index a5ca74594290..219524c233ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -107,7 +107,6 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
 
-	destroy_workqueue(dev->stat_wq);
 	ieee80211_free_hw(dev->mt76.hw);
 	return ret;
 }
@@ -126,7 +125,6 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
 
-	destroy_workqueue(dev->stat_wq);
 	ieee80211_free_hw(dev->mt76.hw);
 }
 
-- 
2.7.5
