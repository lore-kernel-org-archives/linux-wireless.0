Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51960 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeETFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 01:43:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/5] mt76: move ieee80211_hw allocation to common core
Date: Sun, 20 May 2018 07:43:47 +0200
Message-Id: <20180520054349.49422-3-nbd@nbd.name> (sfid-20180520_074406_012586_BA2DF188)
In-Reply-To: <20180520054349.49422-1-nbd@nbd.name>
References: <20180520054349.49422-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allows it to be shared between different drivers and locks to be
initialized earlier

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 22 +++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 14 +++++-------
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d862e5efd094..d1044e5b25db 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -268,6 +268,26 @@ mt76_check_sband(struct mt76_dev *dev, int band)
 	dev->hw->wiphy->bands[band] = NULL;
 }
 
+struct mt76_dev *
+mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
+{
+	struct ieee80211_hw *hw;
+	struct mt76_dev *dev;
+
+	hw = ieee80211_alloc_hw(size, ops);
+	if (!hw)
+		return NULL;
+
+	dev = hw->priv;
+	dev->hw = hw;
+	spin_lock_init(&dev->rx_lock);
+	spin_lock_init(&dev->lock);
+	spin_lock_init(&dev->cc_lock);
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(mt76_alloc_device);
+
 int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates)
 {
@@ -277,8 +297,6 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 
 	dev_set_drvdata(dev->dev, dev);
 
-	spin_lock_init(&dev->lock);
-	spin_lock_init(&dev->cc_lock);
 	INIT_LIST_HEAD(&dev->txwi_cache);
 
 	SET_IEEE80211_DEV(hw, dev->dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2d098fac6147..bb158f867d7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -377,6 +377,8 @@ mt76_channel_state(struct mt76_dev *dev, struct ieee80211_channel *c)
 	return &msband->chan[idx];
 }
 
+struct mt76_dev *mt76_alloc_device(unsigned int size,
+				   const struct ieee80211_ops *ops);
 int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index aeee0b3de136..7096256c7f50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -635,20 +635,18 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
 	};
-	struct ieee80211_hw *hw;
 	struct mt76x2_dev *dev;
+	struct mt76_dev *mdev;
 
-	hw = ieee80211_alloc_hw(sizeof(*dev), &mt76x2_ops);
-	if (!hw)
+	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2_ops);
+	if (!mdev)
 		return NULL;
 
-	dev = hw->priv;
-	dev->mt76.dev = pdev;
-	dev->mt76.hw = hw;
-	dev->mt76.drv = &drv_ops;
+	dev = container_of(mdev, struct mt76x2_dev, mt76);
+	mdev->dev = pdev;
+	mdev->drv = &drv_ops;
 	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->irq_lock);
-	spin_lock_init(&dev->mt76.rx_lock);
 
 	return dev;
 }
-- 
2.17.0
