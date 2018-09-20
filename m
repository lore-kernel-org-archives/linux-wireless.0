Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38395 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id j8-v6so4849683wrw.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 10/20] mt76: add mt76x02_get_rx_gain and mt76x02_get_lna_gain utility routines
Date: Thu, 20 Sep 2018 11:11:57 +0200
Message-Id: <4a7eb29d1cc6193b58a89de88c6b3b6af65c75f3.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112418_621396_C19F1418)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x02_get_rx_gain and mt76x02_get_lna_gain utility routines
for rx gain parsing. mt76x02_get_rx_gain and mt76x02_get_lna_gain
will be reused for eeprom parsing in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 54 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  5 ++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 47 ++--------------
 3 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index edb08863e4ba..2377c758da5d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -81,3 +81,57 @@ bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band)
 		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_2G);
 }
 EXPORT_SYMBOL_GPL(mt76x02_ext_pa_enabled);
+
+void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
+			 u16 *rssi_offset, s8 *lna_2g, s8 *lna_5g)
+{
+	u16 val;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_LNA_GAIN);
+	*lna_2g = val & 0xff;
+	lna_5g[0] = val >> 8;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_1);
+	lna_5g[1] = val >> 8;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_1);
+	lna_5g[2] = val >> 8;
+
+	if (!mt76x02_field_valid(lna_5g[1]))
+		lna_5g[1] = lna_5g[0];
+
+	if (!mt76x02_field_valid(lna_5g[2]))
+		lna_5g[2] = lna_5g[0];
+
+	if (band == NL80211_BAND_2GHZ)
+		*rssi_offset = mt76x02_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_0);
+	else
+		*rssi_offset = mt76x02_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_0);
+}
+EXPORT_SYMBOL_GPL(mt76x02_get_rx_gain);
+
+u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
+			s8 *lna_2g, s8 *lna_5g,
+			struct ieee80211_channel *chan)
+{
+	u16 val;
+	u8 lna;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	if (val & MT_EE_NIC_CONF_1_LNA_EXT_2G)
+		*lna_2g = 0;
+	if (val & MT_EE_NIC_CONF_1_LNA_EXT_5G)
+		memset(lna_5g, 0, sizeof(s8) * 3);
+
+	if (chan->band == NL80211_BAND_2GHZ)
+		lna = *lna_2g;
+	else if (chan->hw_value <= 64)
+		lna = lna_5g[0];
+	else if (chan->hw_value <= 128)
+		lna = lna_5g[1];
+	else
+		lna = lna_5g[2];
+
+	return lna != 0xff ? lna : 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_get_lna_gain);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 70ca2729895c..c22ca507b418 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -154,5 +154,10 @@ mt76x02_eeprom_get(struct mt76_dev *dev,
 bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band);
 int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode);
+void mt76x02_get_rx_gain(struct mt76_dev *dev, enum nl80211_band band,
+			 u16 *rssi_offset, s8 *lna_2g, s8 *lna_5g);
+u8 mt76x02_get_lna_gain(struct mt76_dev *dev,
+			s8 *lna_2g, s8 *lna_5g,
+			struct ieee80211_channel *chan);
 
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index ab52a7f19611..b9641e2408ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -310,55 +310,16 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 
 	mt76x2_set_rx_gain_group(dev, val);
 
-	if (chan->band == NL80211_BAND_2GHZ) {
-		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_2G_0);
-		mt76x2_set_rssi_offset(dev, 0, val);
-		mt76x2_set_rssi_offset(dev, 1, val >> 8);
-	} else {
-		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_5G_0);
-		mt76x2_set_rssi_offset(dev, 0, val);
-		mt76x2_set_rssi_offset(dev, 1, val >> 8);
-	}
-
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_LNA_GAIN);
-	lna_2g = val & 0xff;
-	lna_5g[0] = val >> 8;
-
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_2G_1);
-	lna_5g[1] = val >> 8;
-
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_5G_1);
-	lna_5g[2] = val >> 8;
-
-	if (!mt76x02_field_valid(lna_5g[1]))
-		lna_5g[1] = lna_5g[0];
-
-	if (!mt76x02_field_valid(lna_5g[2]))
-		lna_5g[2] = lna_5g[0];
+	mt76x02_get_rx_gain(&dev->mt76, chan->band, &val, &lna_2g, lna_5g);
+	mt76x2_set_rssi_offset(dev, 0, val);
+	mt76x2_set_rssi_offset(dev, 1, val >> 8);
 
 	dev->cal.rx.mcu_gain =  (lna_2g & 0xff);
 	dev->cal.rx.mcu_gain |= (lna_5g[0] & 0xff) << 8;
 	dev->cal.rx.mcu_gain |= (lna_5g[1] & 0xff) << 16;
 	dev->cal.rx.mcu_gain |= (lna_5g[2] & 0xff) << 24;
 
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
-	if (val & MT_EE_NIC_CONF_1_LNA_EXT_2G)
-		lna_2g = 0;
-	if (val & MT_EE_NIC_CONF_1_LNA_EXT_5G)
-		memset(lna_5g, 0, sizeof(lna_5g));
-
-	if (chan->band == NL80211_BAND_2GHZ)
-		lna = lna_2g;
-	else if (channel <= 64)
-		lna = lna_5g[0];
-	else if (channel <= 128)
-		lna = lna_5g[1];
-	else
-		lna = lna_5g[2];
-
-	if (lna == 0xff)
-		lna = 0;
-
+	lna = mt76x02_get_lna_gain(&dev->mt76, &lna_2g, lna_5g, chan);
 	dev->cal.rx.lna_gain = mt76x02_sign_extend(lna, 8);
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
-- 
2.17.1
