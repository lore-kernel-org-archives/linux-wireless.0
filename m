Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37957 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbeDDIXx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 04:23:53 -0400
Received: by mail-wr0-f193.google.com with SMTP id m13so21161466wrj.5
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2018 01:23:52 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix tx_alc_enabled check
Date: Wed,  4 Apr 2018 10:23:46 +0200
Message-Id: <8143b57af86d4bdd5764f86cf53a0cfdcbfe9bea.1522828102.git.lorenzo.bianconi@redhat.com> (sfid-20180404_102358_200935_C3A92B52)
In-Reply-To: <cover.1522828102.git.lorenzo.bianconi@redhat.com>
References: <cover.1522828102.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix mt76x2_temp_tx_alc_enabled routine since in order to enable tx_alc
temperature compensation it necessary to take into account BIT(15) of
MT_EE_TX_POWER_EXT_PA_5G eeprom info

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 6 +-----
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h | 6 ++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 5bb50027c1e8..95d5f7d888f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -609,17 +609,13 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 
 	memset(t, 0, sizeof(*t));
 
-	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
-	if (!(val & MT_EE_NIC_CONF_1_TEMP_TX_ALC))
+	if (!mt76x2_temp_tx_alc_enabled(dev))
 		return -EINVAL;
 
 	if (!mt76x2_ext_pa_enabled(dev, band))
 		return -EINVAL;
 
 	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
-	if (!(val & BIT(7)))
-		return -EINVAL;
-
 	t->temp_25_ref = val & 0x7f;
 	if (band == NL80211_BAND_5GHZ) {
 		slope = mt76x2_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_5G);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index d79122728dca..aa0b0c040375 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -159,6 +159,12 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
 static inline bool
 mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
 {
+	u16 val;
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+	if (!(val & BIT(15)))
+		return false;
+
 	return mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) &
 	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
 }
-- 
2.14.3
