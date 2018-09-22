Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35096 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbeIVRjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id o18-v6so5766941wmc.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] mt76: move mt76x02_rate_power_val in mt76x02-lib module
Date: Sat, 22 Sep 2018 13:45:32 +0200
Message-Id: <20180922114537.24004-5-lorenzo.bianconi@redhat.com> (sfid-20180922_134904_685460_BD575C50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x02_rate_power_val and mt76x2_sign_extend_optional utility
routines in mt76x02_eeprom.h in order to reuse them in mt76x0 eeprom
parsing

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 16 +++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 65 +++++++------------
 2 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 9339514fb073..c3d8920a8127 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -152,6 +152,22 @@ mt76x02_sign_extend(u32 val, unsigned int size)
 	return sign ? val : -val;
 }
 
+static inline int
+mt76x02_sign_extend_optional(u32 val, unsigned int size)
+{
+	bool enable = val & BIT(size);
+
+	return enable ? mt76x02_sign_extend(val, size) : 0;
+}
+
+static inline s8 mt76x02_rate_power_val(u8 val)
+{
+	if (!mt76x02_field_valid(val))
+		return 0;
+
+	return mt76x02_sign_extend_optional(val, 7);
+}
+
 static inline int
 mt76x02_eeprom_get(struct mt76_dev *dev,
 		   enum mt76x02_eeprom_field field)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 4e287d5e2137..8c8ba3ee6da5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -195,14 +195,6 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 	return 0;
 }
 
-static inline int
-mt76x2_sign_extend_optional(u32 val, unsigned int size)
-{
-	bool enable = val & BIT(size);
-
-	return enable ? mt76x02_sign_extend(val, size) : 0;
-}
-
 static void
 mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
 {
@@ -228,7 +220,7 @@ mt76x2_set_rssi_offset(struct mt76x2_dev *dev, int chain, u8 val)
 		return;
 	}
 
-	dest[chain] = mt76x2_sign_extend_optional(val, 7);
+	dest[chain] = mt76x02_sign_extend_optional(val, 7);
 }
 
 static enum mt76x2_cal_channel_group
@@ -305,15 +297,6 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
 
-static s8
-mt76x2_rate_power_val(u8 val)
-{
-	if (!mt76x02_field_valid(val))
-		return 0;
-
-	return mt76x2_sign_extend_optional(val, 7);
-}
-
 void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan)
 {
@@ -325,8 +308,8 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	memset(t, 0, sizeof(*t));
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_CCK);
-	t->cck[0] = t->cck[1] = mt76x2_rate_power_val(val);
-	t->cck[2] = t->cck[3] = mt76x2_rate_power_val(val >> 8);
+	t->cck[0] = t->cck[1] = mt76x02_rate_power_val(val);
+	t->cck[2] = t->cck[3] = mt76x02_rate_power_val(val >> 8);
 
 	if (is_5ghz)
 		val = mt76x02_eeprom_get(&dev->mt76,
@@ -334,8 +317,8 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	else
 		val = mt76x02_eeprom_get(&dev->mt76,
 					 MT_EE_TX_POWER_OFDM_2G_6M);
-	t->ofdm[0] = t->ofdm[1] = mt76x2_rate_power_val(val);
-	t->ofdm[2] = t->ofdm[3] = mt76x2_rate_power_val(val >> 8);
+	t->ofdm[0] = t->ofdm[1] = mt76x02_rate_power_val(val);
+	t->ofdm[2] = t->ofdm[3] = mt76x02_rate_power_val(val >> 8);
 
 	if (is_5ghz)
 		val = mt76x02_eeprom_get(&dev->mt76,
@@ -343,37 +326,37 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	else
 		val = mt76x02_eeprom_get(&dev->mt76,
 					 MT_EE_TX_POWER_OFDM_2G_24M);
-	t->ofdm[4] = t->ofdm[5] = mt76x2_rate_power_val(val);
-	t->ofdm[6] = t->ofdm[7] = mt76x2_rate_power_val(val >> 8);
+	t->ofdm[4] = t->ofdm[5] = mt76x02_rate_power_val(val);
+	t->ofdm[6] = t->ofdm[7] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS0);
-	t->ht[0] = t->ht[1] = mt76x2_rate_power_val(val);
-	t->ht[2] = t->ht[3] = mt76x2_rate_power_val(val >> 8);
+	t->ht[0] = t->ht[1] = mt76x02_rate_power_val(val);
+	t->ht[2] = t->ht[3] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS4);
-	t->ht[4] = t->ht[5] = mt76x2_rate_power_val(val);
-	t->ht[6] = t->ht[7] = mt76x2_rate_power_val(val >> 8);
+	t->ht[4] = t->ht[5] = mt76x02_rate_power_val(val);
+	t->ht[6] = t->ht[7] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS8);
-	t->ht[8] = t->ht[9] = mt76x2_rate_power_val(val);
-	t->ht[10] = t->ht[11] = mt76x2_rate_power_val(val >> 8);
+	t->ht[8] = t->ht[9] = mt76x02_rate_power_val(val);
+	t->ht[10] = t->ht[11] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_HT_MCS12);
-	t->ht[12] = t->ht[13] = mt76x2_rate_power_val(val);
-	t->ht[14] = t->ht[15] = mt76x2_rate_power_val(val >> 8);
+	t->ht[12] = t->ht[13] = mt76x02_rate_power_val(val);
+	t->ht[14] = t->ht[15] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS0);
-	t->vht[0] = t->vht[1] = mt76x2_rate_power_val(val);
-	t->vht[2] = t->vht[3] = mt76x2_rate_power_val(val >> 8);
+	t->vht[0] = t->vht[1] = mt76x02_rate_power_val(val);
+	t->vht[2] = t->vht[3] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS4);
-	t->vht[4] = t->vht[5] = mt76x2_rate_power_val(val);
-	t->vht[6] = t->vht[7] = mt76x2_rate_power_val(val >> 8);
+	t->vht[4] = t->vht[5] = mt76x02_rate_power_val(val);
+	t->vht[6] = t->vht[7] = mt76x02_rate_power_val(val >> 8);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_VHT_MCS8);
 	if (!is_5ghz)
 		val >>= 8;
-	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
+	t->vht[8] = t->vht[9] = mt76x02_rate_power_val(val >> 8);
 
 	memcpy(t->stbc, t->ht, sizeof(t->stbc[0]) * 8);
 	t->stbc[8] = t->vht[8];
@@ -402,7 +385,7 @@ mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 	t->chain[chain].tssi_slope = data[0];
 	t->chain[chain].tssi_offset = data[1];
 	t->chain[chain].target_power = data[2];
-	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
+	t->chain[chain].delta = mt76x02_sign_extend_optional(data[delta_idx], 7);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
 	t->target_power = val >> 8;
@@ -451,7 +434,7 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 	t->chain[chain].tssi_slope = data[0];
 	t->chain[chain].tssi_offset = data[1];
 	t->chain[chain].target_power = data[2];
-	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
+	t->chain[chain].delta = mt76x02_sign_extend_optional(data[delta_idx], 7);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_RF_2G_RX_HIGH_GAIN);
 	t->target_power = val & 0xff;
@@ -485,8 +468,8 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 	    !mt76x02_field_valid(t->target_power))
 		t->target_power = t->chain[0].target_power;
 
-	t->delta_bw40 = mt76x2_rate_power_val(bw40);
-	t->delta_bw80 = mt76x2_rate_power_val(bw80);
+	t->delta_bw40 = mt76x02_rate_power_val(bw40);
+	t->delta_bw80 = mt76x02_rate_power_val(bw80);
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_power_info);
 
-- 
2.18.0
