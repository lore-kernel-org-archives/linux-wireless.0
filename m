Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55618 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id f21-v6so9109286wmc.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:29 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 04/20] mt76: move eeprom utility routines in mt76x02_eeprom.h
Date: Thu, 20 Sep 2018 11:11:51 +0200
Message-Id: <d8b6dac36415f59d302aff65a4aae3f88b3efe74.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111251_570601_29C9905F)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move shared eeprom utility routines in mt76x02_eeprom.h and
remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 44 +++++--------------
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 15 +++++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 37 +++++-----------
 3 files changed, 38 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 8a8244c1cdaa..c935d98f5710 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -21,31 +21,6 @@
 #include "mt76x0.h"
 #include "eeprom.h"
 
-static bool
-field_valid(u8 val)
-{
-	return val != 0xff;
-}
-
-static s8
-field_validate(u8 val)
-{
-	if (!field_valid(val))
-		return 0;
-
-	return val;
-}
-
-static inline int
-sign_extend(u32 val, unsigned int size)
-{
-	bool sign = val & BIT(size - 1);
-
-	val &= BIT(size - 1) - 1;
-
-	return sign ? val : -val;
-}
-
 static int
 mt76x0_efuse_read(struct mt76x0_dev *dev, u16 addr, u8 *data,
 		   enum mt76x0_eeprom_access_modes mode)
@@ -137,14 +112,14 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 	dev_dbg(dev->mt76.dev, "Has 2GHZ %d 5GHZ %d\n",
 		dev->mt76.cap.has_2ghz, dev->mt76.cap.has_5ghz);
 
-	if (!field_valid(nic_conf1 & 0xff))
+	if (!mt76x02_field_valid(nic_conf1 & 0xff))
 		nic_conf1 &= 0xff00;
 
 	if (nic_conf1 & MT_EE_NIC_CONF_1_HW_RF_CTRL)
 		dev_err(dev->mt76.dev,
 			"Error: this driver does not support HW RF ctrl\n");
 
-	if (!field_valid(nic_conf0 >> 8))
+	if (!mt76x02_field_valid(nic_conf0 >> 8))
 		return;
 
 	if (FIELD_GET(MT_EE_NIC_CONF_0_RX_PATH, nic_conf0) > 1 ||
@@ -183,8 +158,8 @@ mt76x0_set_temp_offset(struct mt76x0_dev *dev, u8 *eeprom)
 {
 	u8 temp = eeprom[MT_EE_TEMP_OFFSET];
 
-	if (field_valid(temp))
-		dev->ee->temp_off = sign_extend(temp, 8);
+	if (mt76x02_field_valid(temp))
+		dev->ee->temp_off = mt76x02_sign_extend(temp, 8);
 	else
 		dev->ee->temp_off = -10;
 }
@@ -231,8 +206,13 @@ mt76x0_set_rf_freq_off(struct mt76x0_dev *dev, u8 *eeprom)
 {
 	u8 comp;
 
-	dev->ee->rf_freq_off = field_validate(eeprom[MT_EE_FREQ_OFFSET]);
-	comp = field_validate(eeprom[MT_EE_FREQ_OFFSET_COMPENSATION]);
+	comp = eeprom[MT_EE_FREQ_OFFSET_COMPENSATION];
+	if (!mt76x02_field_valid(comp))
+		comp = 0;
+
+	dev->ee->rf_freq_off = eeprom[MT_EE_FREQ_OFFSET];
+	if (!mt76x02_field_valid(dev->ee->rf_freq_off))
+		dev->ee->rf_freq_off = 0;
 
 	if (comp & BIT(7))
 		dev->ee->rf_freq_off -= comp & 0x7f;
@@ -311,7 +291,7 @@ get_delta(u8 val)
 {
 	s8 ret;
 
-	if (!field_valid(val) || !(val & BIT(7)))
+	if (!mt76x02_field_valid(val) || !(val & BIT(7)))
 		return 0;
 
 	ret = val & 0x1f;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index d50387f2ef46..1575c2352d9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -121,4 +121,19 @@ enum mt76x02_eeprom_field {
 #define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
 						 MT_EE_USAGE_MAP_START + 1)
 
+static inline bool mt76x02_field_valid(u8 val)
+{
+	return val != 0 && val != 0xff;
+}
+
+static inline int
+mt76x02_sign_extend(u32 val, unsigned int size)
+{
+	bool sign = val & BIT(size - 1);
+
+	val &= BIT(size - 1) - 1;
+
+	return sign ? val : -val;
+}
+
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 7c3d65f9d18d..2db495d9f99f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -259,28 +259,12 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 	return 0;
 }
 
-static inline int
-mt76x2_sign_extend(u32 val, unsigned int size)
-{
-	bool sign = val & BIT(size - 1);
-
-	val &= BIT(size - 1) - 1;
-
-	return sign ? val : -val;
-}
-
 static inline int
 mt76x2_sign_extend_optional(u32 val, unsigned int size)
 {
 	bool enable = val & BIT(size);
 
-	return enable ? mt76x2_sign_extend(val, size) : 0;
-}
-
-static bool
-field_valid(u8 val)
-{
-	return val != 0 && val != 0xff;
+	return enable ? mt76x02_sign_extend(val, size) : 0;
 }
 
 static void
@@ -288,14 +272,14 @@ mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
 {
 	s8 *dest = dev->cal.rx.high_gain;
 
-	if (!field_valid(val)) {
+	if (!mt76x02_field_valid(val)) {
 		dest[0] = 0;
 		dest[1] = 0;
 		return;
 	}
 
-	dest[0] = mt76x2_sign_extend(val, 4);
-	dest[1] = mt76x2_sign_extend(val >> 4, 4);
+	dest[0] = mt76x02_sign_extend(val, 4);
+	dest[1] = mt76x02_sign_extend(val >> 4, 4);
 }
 
 static void
@@ -303,7 +287,7 @@ mt76x2_set_rssi_offset(struct mt76x2_dev *dev, int chain, u8 val)
 {
 	s8 *dest = dev->cal.rx.rssi_offset;
 
-	if (!field_valid(val)) {
+	if (!mt76x02_field_valid(val)) {
 		dest[chain] = 0;
 		return;
 	}
@@ -384,10 +368,10 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 	val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_1);
 	lna_5g[2] = val >> 8;
 
-	if (!field_valid(lna_5g[1]))
+	if (!mt76x02_field_valid(lna_5g[1]))
 		lna_5g[1] = lna_5g[0];
 
-	if (!field_valid(lna_5g[2]))
+	if (!mt76x02_field_valid(lna_5g[2]))
 		lna_5g[2] = lna_5g[0];
 
 	dev->cal.rx.mcu_gain =  (lna_2g & 0xff);
@@ -413,14 +397,14 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 	if (lna == 0xff)
 		lna = 0;
 
-	dev->cal.rx.lna_gain = mt76x2_sign_extend(lna, 8);
+	dev->cal.rx.lna_gain = mt76x02_sign_extend(lna, 8);
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
 
 static s8
 mt76x2_rate_power_val(u8 val)
 {
-	if (!field_valid(val))
+	if (!mt76x02_field_valid(val))
 		return 0;
 
 	return mt76x2_sign_extend_optional(val, 7);
@@ -598,7 +582,8 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 					 MT_EE_TX_POWER_1_START_2G);
 	}
 
-	if (mt76x2_tssi_enabled(dev) || !field_valid(t->target_power))
+	if (mt76x2_tssi_enabled(dev) ||
+	    !mt76x02_field_valid(t->target_power))
 		t->target_power = t->chain[0].target_power;
 
 	t->delta_bw40 = mt76x2_rate_power_val(bw40);
-- 
2.17.1
