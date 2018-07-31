Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40608 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbeGaJsh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15-v6so15592817wrs.7
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:28 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 04/19] mt76x2: introduce mt76x2_init_device routine
Date: Tue, 31 Jul 2018 10:09:05 +0200
Message-Id: <716ea7694f13cd60aa66a5776bdb357fee6ab06f.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100934_865093_98BCFE89)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
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
index e9d9e8228e89..896549c2fcbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -221,6 +221,7 @@ extern const struct ieee80211_ops mt76x2_ops;
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x2_dev *dev);
 void mt76x2_init_debugfs(struct mt76x2_dev *dev);
+void mt76x2_init_device(struct mt76x2_dev *dev);
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
 void mt76x2_phy_power_on(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 347cccfc74bb..c3ecc1c206bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -545,11 +545,6 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
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
@@ -776,6 +771,34 @@ mt76x2_init_txpower(struct mt76x2_dev *dev,
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
@@ -790,20 +813,15 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
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
 
@@ -825,24 +843,12 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
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
