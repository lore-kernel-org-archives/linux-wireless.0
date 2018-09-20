Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34197 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id j25-v6so978445wmc.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:40 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 15/20] mt76: move mt76x02_eeprom_parse_hw_cap in mt76x02-lib module
Date: Thu, 20 Sep 2018 11:12:02 +0200
Message-Id: <47b4bab5725f91f5c689fb079912a5435971eb62.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112417_831364_6215B132)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x02_eeprom_parse_hw_cap utility routine in mt76x02-lib
module in order to be reused in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 19 +++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  6 ++++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 21 +------------------
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    |  6 ------
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  2 +-
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index 2377c758da5d..d3efeb8a72b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -71,6 +71,25 @@ int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_efuse_data);
 
+void mt76x02_eeprom_parse_hw_cap(struct mt76_dev *dev)
+{
+	u16 val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
+
+	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, val)) {
+	case BOARD_TYPE_5GHZ:
+		dev->cap.has_5ghz = true;
+		break;
+	case BOARD_TYPE_2GHZ:
+		dev->cap.has_2ghz = true;
+		break;
+	default:
+		dev->cap.has_2ghz = true;
+		dev->cap.has_5ghz = true;
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_eeprom_parse_hw_cap);
+
 bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band)
 {
 	u16 conf0 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 995aebbcc194..119813960fe7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -132,6 +132,11 @@ enum mt76x02_eeprom_modes {
 	MT_EE_PHYSICAL_READ,
 };
 
+enum mt76x02_board_type {
+	BOARD_TYPE_2GHZ = 1,
+	BOARD_TYPE_5GHZ = 2,
+};
+
 static inline bool mt76x02_field_valid(u8 val)
 {
 	return val != 0 && val != 0xff;
@@ -165,5 +170,6 @@ void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
 u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan);
+void mt76x02_eeprom_parse_hw_cap(struct mt76_dev *dev);
 
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index b9641e2408ee..d295851cf2f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -40,25 +40,6 @@ mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
 	return 0;
 }
 
-void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
-{
-	u16 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
-
-	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, val)) {
-	case BOARD_TYPE_5GHZ:
-		dev->mt76.cap.has_5ghz = true;
-		break;
-	case BOARD_TYPE_2GHZ:
-		dev->mt76.cap.has_2ghz = true;
-		break;
-	default:
-		dev->mt76.cap.has_2ghz = true;
-		dev->mt76.cap.has_5ghz = true;
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(mt76x2_eeprom_parse_hw_cap);
-
 static bool
 mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
 {
@@ -563,7 +544,7 @@ int mt76x2_eeprom_init(struct mt76x2_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76x2_eeprom_parse_hw_cap(dev);
+	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
 	mt76x2_eeprom_get_macaddr(dev);
 	mt76_eeprom_override(&dev->mt76);
 	dev->mt76.macaddr[0] &= ~BIT(1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index da476aad65fb..ad98a52ec69f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -19,11 +19,6 @@
 
 #include "mt76x02_eeprom.h"
 
-enum mt76x2_board_type {
-	BOARD_TYPE_2GHZ = 1,
-	BOARD_TYPE_5GHZ = 2,
-};
-
 enum mt76x2_cal_channel_group {
 	MT_CH_5G_JAPAN,
 	MT_CH_5G_UNII_1,
@@ -64,7 +59,6 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 			   struct ieee80211_channel *chan);
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
 void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
-void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev);
 
 static inline bool
 mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 89cfacfb276c..7a9ebc8985f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -129,7 +129,7 @@ static int mt76x2u_init_eeprom(struct mt76x2_dev *dev)
 		put_unaligned_le32(val, dev->mt76.eeprom.data + i);
 	}
 
-	mt76x2_eeprom_parse_hw_cap(dev);
+	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
 	return 0;
 }
 
-- 
2.17.1
