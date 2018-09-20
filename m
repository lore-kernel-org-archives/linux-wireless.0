Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54688 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id c14-v6so9123356wmb.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 05/20] mt76: move mt76x2_eeprom_get in mt76x02_eeprom.h
Date: Thu, 20 Sep 2018 11:11:52 +0200
Message-Id: <b7cdecbc696ee76b4419b9476340dcface323561.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111253_017219_78E83B02)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2_eeprom_get utility routine in mt76x02_eeprom.h since
it will be used to parse mt76x0 eeprom in order to unify eeprom
support between mt76x2 and mt76x0 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 10 +++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 87 +++++++++++--------
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    | 17 +---
 .../net/wireless/mediatek/mt76/mt76x2_init.c  |  6 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu.c   |  2 +-
 .../mediatek/mt76/mt76x2_mcu_common.c         |  5 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  |  6 +-
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  |  2 +-
 9 files changed, 77 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 1575c2352d9b..85dd4f9b97a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -136,4 +136,14 @@ mt76x02_sign_extend(u32 val, unsigned int size)
 	return sign ? val : -val;
 }
 
+static inline int
+mt76x02_eeprom_get(struct mt76_dev *dev,
+		   enum mt76x02_eeprom_field field)
+{
+	if ((field & 1) || field >= __MT_EE_MAX)
+		return -1;
+
+	return get_unaligned_le16(dev->eeprom.data + field);
+}
+
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 2db495d9f99f..aea8033f13ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -42,7 +42,7 @@ mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
 
 void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
 {
-	u16 val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0);
+	u16 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
 
 	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, val)) {
 	case BOARD_TYPE_5GHZ:
@@ -319,17 +319,23 @@ mt76x2_get_5g_rx_gain(struct mt76x2_dev *dev, u8 channel)
 	group = mt76x2_get_cal_channel_group(channel);
 	switch (group) {
 	case MT_CH_5G_JAPAN:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN);
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN);
 	case MT_CH_5G_UNII_1:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN) >> 8;
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN) >> 8;
 	case MT_CH_5G_UNII_2:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN);
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN);
 	case MT_CH_5G_UNII_2E_1:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN) >> 8;
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN) >> 8;
 	case MT_CH_5G_UNII_2E_2:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN);
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN);
 	default:
-		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN) >> 8;
+		return mt76x02_eeprom_get(&dev->mt76,
+					  MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN) >> 8;
 	}
 }
 
@@ -342,30 +348,31 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 	u16 val;
 
 	if (chan->band == NL80211_BAND_2GHZ)
-		val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN) >> 8;
+		val = mt76x02_eeprom_get(&dev->mt76,
+					 MT_EE_RF_2G_RX_HIGH_GAIN) >> 8;
 	else
 		val = mt76x2_get_5g_rx_gain(dev, channel);
 
 	mt76x2_set_rx_gain_group(dev, val);
 
 	if (chan->band == NL80211_BAND_2GHZ) {
-		val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_0);
+		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_2G_0);
 		mt76x2_set_rssi_offset(dev, 0, val);
 		mt76x2_set_rssi_offset(dev, 1, val >> 8);
 	} else {
-		val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_0);
+		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_5G_0);
 		mt76x2_set_rssi_offset(dev, 0, val);
 		mt76x2_set_rssi_offset(dev, 1, val >> 8);
 	}
 
-	val = mt76x2_eeprom_get(dev, MT_EE_LNA_GAIN);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_LNA_GAIN);
 	lna_2g = val & 0xff;
 	lna_5g[0] = val >> 8;
 
-	val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_1);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_2G_1);
 	lna_5g[1] = val >> 8;
 
-	val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_1);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RSSI_OFFSET_5G_1);
 	lna_5g[2] = val >> 8;
 
 	if (!mt76x02_field_valid(lna_5g[1]))
@@ -379,7 +386,7 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 	dev->cal.rx.mcu_gain |= (lna_5g[1] & 0xff) << 16;
 	dev->cal.rx.mcu_gain |= (lna_5g[2] & 0xff) << 24;
 
-	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
 	if (val & MT_EE_NIC_CONF_1_LNA_EXT_2G)
 		lna_2g = 0;
 	if (val & MT_EE_NIC_CONF_1_LNA_EXT_5G)
@@ -420,50 +427,54 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 
 	memset(t, 0, sizeof(*t));
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_CCK);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_CCK);
 	t->cck[0] = t->cck[1] = mt76x2_rate_power_val(val);
 	t->cck[2] = t->cck[3] = mt76x2_rate_power_val(val >> 8);
 
 	if (is_5ghz)
-		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_6M);
+		val = mt76x02_eeprom_get(&dev->mt76,
+					 MT_EE_TX_POWER_OFDM_5G_6M);
 	else
-		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_6M);
+		val = mt76x02_eeprom_get(&dev->mt76,
+					 MT_EE_TX_POWER_OFDM_2G_6M);
 	t->ofdm[0] = t->ofdm[1] = mt76x2_rate_power_val(val);
 	t->ofdm[2] = t->ofdm[3] = mt76x2_rate_power_val(val >> 8);
 
 	if (is_5ghz)
-		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_24M);
+		val = mt76x02_eeprom_get(&dev->mt76,
+					 MT_EE_TX_POWER_OFDM_5G_24M);
 	else
-		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_24M);
+		val = mt76x02_eeprom_get(&dev->mt76,
+					 MT_EE_TX_POWER_OFDM_2G_24M);
 	t->ofdm[4] = t->ofdm[5] = mt76x2_rate_power_val(val);
 	t->ofdm[6] = t->ofdm[7] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS0);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS0);
 	t->ht[0] = t->ht[1] = mt76x2_rate_power_val(val);
 	t->ht[2] = t->ht[3] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS4);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS4);
 	t->ht[4] = t->ht[5] = mt76x2_rate_power_val(val);
 	t->ht[6] = t->ht[7] = mt76x2_rate_power_val(val >> 8);
 	memcpy(t->stbc, t->ht, sizeof(t->stbc));
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS8);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS8);
 	t->ht[8] = t->ht[9] = mt76x2_rate_power_val(val);
 	t->ht[10] = t->ht[11] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS12);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS12);
 	t->ht[12] = t->ht[13] = mt76x2_rate_power_val(val);
 	t->ht[14] = t->ht[15] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS0);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS0);
 	t->vht[0] = t->vht[1] = mt76x2_rate_power_val(val);
 	t->vht[2] = t->vht[3] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS4);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS4);
 	t->vht[4] = t->vht[5] = mt76x2_rate_power_val(val);
 	t->vht[6] = t->vht[7] = mt76x2_rate_power_val(val >> 8);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS8);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS8);
 	if (!is_5ghz)
 		val >>= 8;
 	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
@@ -505,7 +516,7 @@ mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 	t->chain[chain].target_power = data[2];
 	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
 	t->target_power = val >> 8;
 }
 
@@ -554,7 +565,7 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 	t->chain[chain].target_power = data[2];
 	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_RX_HIGH_GAIN);
 	t->target_power = val & 0xff;
 }
 
@@ -566,8 +577,8 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 
 	memset(t, 0, sizeof(*t));
 
-	bw40 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
-	bw80 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80);
+	bw40 = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_DELTA_BW40);
+	bw80 = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_DELTA_BW80);
 
 	if (chan->band == NL80211_BAND_5GHZ) {
 		bw40 >>= 8;
@@ -605,14 +616,18 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 	if (!mt76x2_ext_pa_enabled(dev, band))
 		return -EINVAL;
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
 	t->temp_25_ref = val & 0x7f;
 	if (band == NL80211_BAND_5GHZ) {
-		slope = mt76x2_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_5G);
-		bounds = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+		slope = mt76x02_eeprom_get(&dev->mt76,
+					   MT_EE_RF_TEMP_COMP_SLOPE_5G);
+		bounds = mt76x02_eeprom_get(&dev->mt76,
+					    MT_EE_TX_POWER_EXT_PA_5G);
 	} else {
-		slope = mt76x2_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_2G);
-		bounds = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80) >> 8;
+		slope = mt76x02_eeprom_get(&dev->mt76,
+					   MT_EE_RF_TEMP_COMP_SLOPE_2G);
+		bounds = mt76x02_eeprom_get(&dev->mt76,
+					    MT_EE_TX_POWER_DELTA_BW80) >> 8;
 	}
 
 	t->high_slope = slope & 0xff;
@@ -626,7 +641,7 @@ EXPORT_SYMBOL_GPL(mt76x2_get_temp_comp);
 
 bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band)
 {
-	u16 conf0 = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0);
+	u16 conf0 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
 
 	if (band == NL80211_BAND_5GHZ)
 		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_5G);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 64b91fb57e3b..6064ef103d2c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -56,15 +56,6 @@ struct mt76x2_temp_comp {
 	unsigned int low_slope; /* J / dB */
 };
 
-static inline int
-mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x02_eeprom_field field)
-{
-	if ((field & 1) || field >= __MT_EE_MAX)
-		return -1;
-
-	return get_unaligned_le16(dev->mt76.eeprom.data + field);
-}
-
 void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan);
 int mt76x2_get_max_rate_power(struct mt76_rate_power *r);
@@ -81,11 +72,11 @@ mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
 {
 	u16 val;
 
-	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_EXT_PA_5G);
 	if (!(val & BIT(15)))
 		return false;
 
-	return mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+	return mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1) &
 	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
 }
 
@@ -93,14 +84,14 @@ static inline bool
 mt76x2_tssi_enabled(struct mt76x2_dev *dev)
 {
 	return !mt76x2_temp_tx_alc_enabled(dev) &&
-	       (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+	       (mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1) &
 		MT_EE_NIC_CONF_1_TX_ALC_EN);
 }
 
 static inline bool
 mt76x2_has_ext_lna(struct mt76x2_dev *dev)
 {
-	u32 val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	u32 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
 
 	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ)
 		return val & MT_EE_NIC_CONF_1_LNA_EXT_2G;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 33f7fabf45c0..72005faee00e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -44,7 +44,7 @@ mt76x2_fixup_xtal(struct mt76x2_dev *dev)
 	u16 eep_val;
 	s8 offset = 0;
 
-	eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
+	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_2);
 
 	offset = eep_val & 0x7f;
 	if ((eep_val & 0xff) == 0xff)
@@ -54,7 +54,7 @@ mt76x2_fixup_xtal(struct mt76x2_dev *dev)
 
 	eep_val >>= 8;
 	if (eep_val == 0x00 || eep_val == 0xff) {
-		eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
+		eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_1);
 		eep_val &= 0xff;
 
 		if (eep_val == 0x00 || eep_val == 0xff)
@@ -65,7 +65,7 @@ mt76x2_fixup_xtal(struct mt76x2_dev *dev)
 	mt76_rmw_field(dev, MT_XO_CTRL5, MT_XO_CTRL5_C2_VAL, eep_val + offset);
 	mt76_set(dev, MT_XO_CTRL6, MT_XO_CTRL6_C2_CTRL);
 
-	eep_val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
 	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
 	case 0:
 		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index f92bebfa21fd..2b25414ed16b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -141,7 +141,7 @@ mt76pci_load_firmware(struct mt76x2_dev *dev)
 
 	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
 
-	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
 	if (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, val) == 1)
 		mt76_set(dev, MT_MCU_COM_REG0, BIT(30));
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
index 72f6bfb7a258..a3669c00ddd5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
@@ -60,6 +60,7 @@ EXPORT_SYMBOL_GPL(mt76x2_mcu_set_channel);
 int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
 		       u8 channel)
 {
+	struct mt76_dev *mdev = &dev->mt76;
 	struct sk_buff *skb;
 	struct {
 		u8 cr_mode;
@@ -76,8 +77,8 @@ int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
 	u32 val;
 
 	val = BIT(31);
-	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
-	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
+	val |= (mt76x02_eeprom_get(mdev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
+	val |= (mt76x02_eeprom_get(mdev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
 	msg.cfg = cpu_to_le32(val);
 
 	/* first set the channel without the extension channel info */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 920bb7c89af9..4477a4e184e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -360,7 +360,7 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
 
 	if (!dev->cal.init_cal_done) {
-		u8 val = mt76x2_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
+		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
 			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_R, 0, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
index 9604c6a809be..b59336110746 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
@@ -32,7 +32,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
 	s8 offset = 0;
 	u16 eep_val;
 
-	eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
+	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_2);
 
 	offset = eep_val & 0x7f;
 	if ((eep_val & 0xff) == 0xff)
@@ -42,7 +42,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
 
 	eep_val >>= 8;
 	if (eep_val == 0x00 || eep_val == 0xff) {
-		eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
+		eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_XTAL_TRIM_1);
 		eep_val &= 0xff;
 
 		if (eep_val == 0x00 || eep_val == 0xff)
@@ -67,7 +67,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
 	/* init fce */
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
-	eep_val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	eep_val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_2);
 	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
 	case 0:
 		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
index 97f40fef5559..9842ed04d764 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
@@ -209,7 +209,7 @@ int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
 		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
 
 	if (!dev->cal.init_cal_done) {
-		u8 val = mt76x2_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
+		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
 			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_R,
-- 
2.17.1
