Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37068 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeFJKvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 06:51:38 -0400
Received: by mail-wr0-f193.google.com with SMTP id d8-v6so17442778wro.4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2018 03:51:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v3 04/19] mt76x2: introduce mt76x2_init_device routine
Date: Sun, 10 Jun 2018 12:51:11 +0200
Message-Id: <20180610105126.28425-5-lorenzo.bianconi@redhat.com> (sfid-20180610_125144_891400_3A1EDC41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x2_init_device routine in order to reuse common pcie/usb mac80211
initialization code supporting mt76x2u based device

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  1 +
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 58 ++++++++++---------
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index ee22dd4b4e19..52d70a9b9b6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -213,6 +213,7 @@ extern const struct ieee80211_ops mt76x2_ops;
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x2_dev *dev);
 void mt76x2_init_debugfs(struct mt76x2_dev *dev);
+void mt76x2_init_device(struct mt76x2_dev *dev);
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
 void mt76x2_phy_power_on(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 6a7db3f88153..9c6d180da294 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -539,11 +539,6 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
-	dev->chainmask = 0x202;
-	dev->global_wcid.idx = 255;
-	dev->global_wcid.hw_key_idx = -1;
-	dev->slottime = 9;
-
 	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
 	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
 	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
@@ -770,6 +765,34 @@ mt76x2_init_txpower(struct mt76x2_dev *dev,
 	}
 }
 
+void mt76x2_init_device(struct mt76x2_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+
+	hw->queues = 4;
+	hw->max_rates = 1;
+	hw->max_report_rates = 7;
+	hw->max_rate_tries = 1;
+	hw->extra_tx_headroom = 2;
+
+	hw->sta_data_size = sizeof(struct mt76x2_sta);
+	hw->vif_data_size = sizeof(struct mt76x2_vif);
+
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+
+	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
+	dev->chainmask = 0x202;
+	dev->global_wcid.idx = 255;
+	dev->global_wcid.hw_key_idx = -1;
+	dev->slottime = 9;
+
+	/* init antenna configuration */
+	dev->mt76.antenna_mask = 3;
+}
+
 int mt76x2_register_device(struct mt76x2_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
@@ -784,20 +807,15 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 		return -ENOMEM;
 
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
+
+	mt76x2_init_device(dev);
 
 	ret = mt76x2_init_hardware(dev);
 	if (ret)
 		return ret;
 
-	hw->queues = 4;
-	hw->max_rates = 1;
-	hw->max_report_rates = 7;
-	hw->max_rate_tries = 1;
-	hw->extra_tx_headroom = 2;
-
-	hw->sta_data_size = sizeof(struct mt76x2_sta);
-	hw->vif_data_size = sizeof(struct mt76x2_vif);
-
 	for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
 		u8 *addr = dev->macaddr_list[i].addr;
 
@@ -819,24 +837,12 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
-	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
-	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
-
-	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
-
-	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
-	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
-
 	mt76x2_dfs_init_detector(dev);
 
 	/* init led callbacks */
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
 	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
 
-	/* init antenna configuration */
-	dev->mt76.antenna_mask = 3;
-
 	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
 				   ARRAY_SIZE(mt76x2_rates));
 	if (ret)
-- 
2.17.1
