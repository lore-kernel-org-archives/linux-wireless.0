Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37811 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id n11-v6so10014957wmc.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 17/20] mt76: move mt76x2_tssi_enabled in mt76x02_eeprom.h
Date: Thu, 20 Sep 2018 11:12:04 +0200
Message-Id: <c0f2851cd37842add121a0086dec6c387bf94ba6.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112418_806491_30C8E0AF)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2_tssi_enabled and mt76x02_temp_tx_alc_enabled in
mt76x02_eeprom.h in order to be reused in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 21 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    |  4 ++--
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    | 21 -------------------
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  |  2 +-
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 119813960fe7..9339514fb073 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -162,6 +162,27 @@ mt76x02_eeprom_get(struct mt76_dev *dev,
 	return get_unaligned_le16(dev->eeprom.data + field);
 }
 
+static inline bool
+mt76x02_temp_tx_alc_enabled(struct mt76_dev *dev)
+{
+	u16 val;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+	if (!(val & BIT(15)))
+		return false;
+
+	return mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
+}
+
+static inline bool
+mt76x02_tssi_enabled(struct mt76_dev *dev)
+{
+	return !mt76x02_temp_tx_alc_enabled(dev) &&
+	       (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+		MT_EE_NIC_CONF_1_TX_ALC_EN);
+}
+
 bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band);
 int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index d295851cf2f9..21b8fb2e0e28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -490,7 +490,7 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 					 MT_EE_TX_POWER_1_START_2G);
 	}
 
-	if (mt76x2_tssi_enabled(dev) ||
+	if (mt76x02_tssi_enabled(&dev->mt76) ||
 	    !mt76x02_field_valid(t->target_power))
 		t->target_power = t->chain[0].target_power;
 
@@ -507,7 +507,7 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 
 	memset(t, 0, sizeof(*t));
 
-	if (!mt76x2_temp_tx_alc_enabled(dev))
+	if (!mt76x02_temp_tx_alc_enabled(&dev->mt76))
 		return -EINVAL;
 
 	if (!mt76x02_ext_pa_enabled(&dev->mt76, band))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index ad98a52ec69f..650f9564f0f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -60,27 +60,6 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
 void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
 
-static inline bool
-mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
-{
-	u16 val;
-
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_EXT_PA_5G);
-	if (!(val & BIT(15)))
-		return false;
-
-	return mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1) &
-	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
-}
-
-static inline bool
-mt76x2_tssi_enabled(struct mt76x2_dev *dev)
-{
-	return !mt76x2_temp_tx_alc_enabled(dev) &&
-	       (mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1) &
-		MT_EE_NIC_CONF_1_TX_ALC_EN);
-}
-
 static inline bool
 mt76x2_has_ext_lna(struct mt76x2_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 3f786596e586..22e66006a5f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -25,7 +25,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u32 flag = 0;
 
-	if (!mt76x2_tssi_enabled(dev))
+	if (!mt76x02_tssi_enabled(&dev->mt76))
 		return false;
 
 	if (mt76x2_channel_silent(dev))
@@ -390,7 +390,7 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 	       sizeof(dev->cal.agc_gain_cur));
 
 	/* init default values for temp compensation */
-	if (mt76x2_tssi_enabled(dev)) {
+	if (mt76x02_tssi_enabled(&dev->mt76)) {
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
index 1cd9b2468ef0..b3ec56d35e7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
@@ -235,7 +235,7 @@ int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
 	if (scan)
 		return 0;
 
-	if (mt76x2_tssi_enabled(dev)) {
+	if (mt76x02_tssi_enabled(&dev->mt76)) {
 		/* init default values for temp compensation */
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
-- 
2.17.1
