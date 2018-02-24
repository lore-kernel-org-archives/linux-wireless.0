Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32848 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeBXPyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 10:54:24 -0500
Received: by mail-wr0-f196.google.com with SMTP id s5so16976600wra.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Feb 2018 07:54:24 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: initialize available_antennas_{tx,rx} info
Date: Sat, 24 Feb 2018 16:54:12 +0100
Message-Id: <20180224155414.31063-2-lorenzo.bianconi@redhat.com> (sfid-20180224_165427_858638_430FC2C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize available_antennas related info in wiphy data structure
according to antenna_mask field; antenna_mask info is initialized
in device specific code and will be used in mac80211 {set,get}_antenna
callbacks

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76.h        | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 85f8d324ebf8..ec94b86a37fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -262,6 +262,9 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
+	wiphy->available_antennas_tx = dev->antenna_mask;
+	wiphy->available_antennas_rx = dev->antenna_mask;
+
 	hw->txq_data_size = sizeof(struct mt76_txq);
 	hw->max_tx_fragments = 16;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d2ce15093edd..15009d5b0531 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -253,6 +253,8 @@ struct mt76_dev {
 	u32 rev;
 	unsigned long state;
 
+	u8 antenna_mask;
+
 	struct mt76_sband sband_2g;
 	struct mt76_sband sband_5g;
 	struct debugfs_blob_wrapper eeprom;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 9dbf94947324..934c331d995e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -857,6 +857,9 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
 	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
 
+	/* init antenna configuration */
+	dev->mt76.antenna_mask = 3;
+
 	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
 				   ARRAY_SIZE(mt76x2_rates));
 	if (ret)
-- 
2.16.2
