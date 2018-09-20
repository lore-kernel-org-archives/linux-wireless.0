Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34847 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387420AbeITOy5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id o18-v6so10079803wmc.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:28 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 03/20] mt76: move common eeprom definitions in mt76x02-lib module
Date: Thu, 20 Sep 2018 11:11:50 +0200
Message-Id: <14b5f6a780701abd9b88ed23857059afcd38e854.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111250_937646_CF7FF4B9)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2 and mt76x0 common definitions in mt76x02_eeprom.h
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  18 +--
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  71 +---------
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 124 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    |   2 +-
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    |  85 +-----------
 5 files changed, 140 insertions(+), 160 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 79856bde1632..8a8244c1cdaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -245,8 +245,8 @@ mt76x0_set_lna_gain(struct mt76x0_dev *dev, u8 *eeprom)
 {
 	u8 gain;
 
-	dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN_2GHZ];
-	dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN_5GHZ_0];
+	dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN];
+	dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN + 1];
 
 	gain = eeprom[MT_EE_LNA_GAIN_5GHZ_1];
 	if (gain == 0xff || gain == 0)
@@ -268,7 +268,7 @@ mt76x0_set_rssi_offset(struct mt76x0_dev *dev, u8 *eeprom)
 	s8 *rssi_offset = dev->ee->rssi_offset_2ghz;
 
 	for (i = 0; i < 2; i++) {
-		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET + i];
+		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_2G_0 + i];
 
 		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
 			dev_warn(dev->mt76.dev,
@@ -281,7 +281,7 @@ mt76x0_set_rssi_offset(struct mt76x0_dev *dev, u8 *eeprom)
 	rssi_offset = dev->ee->rssi_offset_5ghz;
 
 	for (i = 0; i < 3; i++) {
-		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_5GHZ + i];
+		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_5G_0 + i];
 
 		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
 			dev_warn(dev->mt76.dev,
@@ -377,7 +377,7 @@ mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev, u8 *eeprom)
 	u8 tx_pwr;
 
 	for (i = 0; i < 14; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_OFFSET_2GHZ + i];
+		tx_pwr = eeprom[MT_EE_TX_POWER_DELTA_BW80 + i];
 		if (tx_pwr <= 0x3f && tx_pwr > 0)
 			dev->ee->tx_pwr_per_chan[i] = tx_pwr;
 		else
@@ -385,7 +385,7 @@ mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev, u8 *eeprom)
 	}
 
 	for (i = 0; i < 40; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_OFFSET_5GHZ + i];
+		tx_pwr = eeprom[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + i];
 		if (tx_pwr <= 0x3f && tx_pwr > 0)
 			dev->ee->tx_pwr_per_chan[14 + i] = tx_pwr;
 		else
@@ -422,12 +422,12 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 			goto out;
 	}
 
-	if (eeprom[MT_EE_VERSION_EE] > MT76X0U_EE_MAX_VER)
+	if (eeprom[MT_EE_VERSION + 1] > MT76X0U_EE_MAX_VER)
 		dev_warn(dev->mt76.dev,
 			 "Warning: unsupported EEPROM version %02hhx\n",
-			 eeprom[MT_EE_VERSION_EE]);
+			 eeprom[MT_EE_VERSION + 1]);
 	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
-		 eeprom[MT_EE_VERSION_EE], eeprom[MT_EE_VERSION_FAE]);
+		 eeprom[MT_EE_VERSION + 1], eeprom[MT_EE_VERSION]);
 
 	mt76x0_set_macaddr(dev, eeprom);
 	mt76x0_set_chip_cap(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index cd0f14361405..1da90f056442 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -16,75 +16,12 @@
 #ifndef __MT76X0U_EEPROM_H
 #define __MT76X0U_EEPROM_H
 
-struct mt76x0_dev;
-
-#define MT76X0U_EE_MAX_VER			0x0c
-#define MT76X0_EEPROM_SIZE			512
-
-#define MT76X0U_DEFAULT_TX_POWER		6
-
-enum mt76_eeprom_field {
-	MT_EE_CHIP_ID =				0x00,
-	MT_EE_VERSION_FAE =			0x02,
-	MT_EE_VERSION_EE =			0x03,
-	MT_EE_MAC_ADDR =			0x04,
-	MT_EE_NIC_CONF_0 =			0x34,
-	MT_EE_NIC_CONF_1 =			0x36,
-	MT_EE_COUNTRY_REGION_5GHZ =		0x38,
-	MT_EE_COUNTRY_REGION_2GHZ =		0x39,
-	MT_EE_FREQ_OFFSET =			0x3a,
-	MT_EE_NIC_CONF_2 =			0x42,
-
-	MT_EE_LNA_GAIN_2GHZ =			0x44,
-	MT_EE_LNA_GAIN_5GHZ_0 =			0x45,
-	MT_EE_RSSI_OFFSET =			0x46,
-	MT_EE_RSSI_OFFSET_5GHZ =		0x4a,
-	MT_EE_LNA_GAIN_5GHZ_1 =			0x49,
-	MT_EE_LNA_GAIN_5GHZ_2 =			0x4d,
-
-	MT_EE_TX_POWER_DELTA_BW40 =		0x50,
-
-	MT_EE_TX_POWER_OFFSET_2GHZ =		0x52,
+#include "../mt76x02_eeprom.h"
 
-	MT_EE_TX_TSSI_SLOPE =			0x6e,
-	MT_EE_TX_TSSI_OFFSET_GROUP =		0x6f,
-	MT_EE_TX_TSSI_OFFSET =			0x76,
-
-	MT_EE_TX_POWER_OFFSET_5GHZ =		0x78,
-
-	MT_EE_TEMP_OFFSET =			0xd1,
-	MT_EE_FREQ_OFFSET_COMPENSATION =	0xdb,
-	MT_EE_TX_POWER_BYRATE_BASE =		0xde,
-
-	MT_EE_TX_POWER_BYRATE_BASE_5GHZ =	0x120,
-
-	MT_EE_USAGE_MAP_START =			0x1e0,
-	MT_EE_USAGE_MAP_END =			0x1fc,
-};
+struct mt76x0_dev;
 
-#define MT_EE_NIC_CONF_0_RX_PATH		GENMASK(3, 0)
-#define MT_EE_NIC_CONF_0_TX_PATH		GENMASK(7, 4)
-#define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
-#define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
-
-#define MT_EE_NIC_CONF_1_HW_RF_CTRL		BIT(0)
-#define MT_EE_NIC_CONF_1_TEMP_TX_ALC		BIT(1)
-#define MT_EE_NIC_CONF_1_LNA_EXT_2G		BIT(2)
-#define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
-#define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
-
-#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
-#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
-#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
-#define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
-#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
-#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
-
-#define MT_EE_TX_POWER_BYRATE(i)		(MT_EE_TX_POWER_BYRATE_BASE + \
-						 (i) * 4)
-
-#define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END -	\
-						 MT_EE_USAGE_MAP_START + 1)
+#define MT76X0U_EE_MAX_VER		0x0c
+#define MT76X0_EEPROM_SIZE		512
 
 enum mt76x0_eeprom_access_modes {
 	MT_EE_READ = 0,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
new file mode 100644
index 000000000000..d50387f2ef46
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __MT76x02_EEPROM_H
+#define __MT76x02_EEPROM_H
+
+enum mt76x02_eeprom_field {
+	MT_EE_CHIP_ID =				0x000,
+	MT_EE_VERSION =				0x002,
+	MT_EE_MAC_ADDR =			0x004,
+	MT_EE_PCI_ID =				0x00A,
+	MT_EE_NIC_CONF_0 =			0x034,
+	MT_EE_NIC_CONF_1 =			0x036,
+	MT_EE_COUNTRY_REGION_5GHZ =		0x038,
+	MT_EE_COUNTRY_REGION_2GHZ =		0x039,
+	MT_EE_FREQ_OFFSET =			0x03a,
+	MT_EE_NIC_CONF_2 =			0x042,
+
+	MT_EE_XTAL_TRIM_1 =			0x03a,
+	MT_EE_XTAL_TRIM_2 =			0x09e,
+
+	MT_EE_LNA_GAIN =			0x044,
+	MT_EE_RSSI_OFFSET_2G_0 =		0x046,
+	MT_EE_RSSI_OFFSET_2G_1 =		0x048,
+	MT_EE_LNA_GAIN_5GHZ_1 =			0x049,
+	MT_EE_RSSI_OFFSET_5G_0 =		0x04a,
+	MT_EE_RSSI_OFFSET_5G_1 =		0x04c,
+	MT_EE_LNA_GAIN_5GHZ_2 =			0x04d,
+
+	MT_EE_TX_POWER_DELTA_BW40 =		0x050,
+	MT_EE_TX_POWER_DELTA_BW80 =		0x052,
+
+	MT_EE_TX_POWER_EXT_PA_5G =		0x054,
+
+	MT_EE_TX_POWER_0_START_2G =		0x056,
+	MT_EE_TX_POWER_1_START_2G =		0x05c,
+
+	/* used as byte arrays */
+#define MT_TX_POWER_GROUP_SIZE_5G		5
+#define MT_TX_POWER_GROUPS_5G			6
+	MT_EE_TX_POWER_0_START_5G =		0x062,
+
+	MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA =	0x074,
+	MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE =	0x076,
+
+	MT_EE_TX_POWER_1_START_5G =		0x080,
+
+	MT_EE_TX_POWER_CCK =			0x0a0,
+	MT_EE_TX_POWER_OFDM_2G_6M =		0x0a2,
+	MT_EE_TX_POWER_OFDM_2G_24M =		0x0a4,
+	MT_EE_TX_POWER_OFDM_5G_6M =		0x0b2,
+	MT_EE_TX_POWER_OFDM_5G_24M =		0x0b4,
+	MT_EE_TX_POWER_HT_MCS0 =		0x0a6,
+	MT_EE_TX_POWER_HT_MCS4 =		0x0a8,
+	MT_EE_TX_POWER_HT_MCS8 =		0x0aa,
+	MT_EE_TX_POWER_HT_MCS12 =		0x0ac,
+	MT_EE_TX_POWER_VHT_MCS0 =		0x0ba,
+	MT_EE_TX_POWER_VHT_MCS4 =		0x0bc,
+	MT_EE_TX_POWER_VHT_MCS8 =		0x0be,
+
+	MT_EE_TEMP_OFFSET =			0x0d1,
+	MT_EE_FREQ_OFFSET_COMPENSATION =	0x0db,
+	MT_EE_TX_POWER_BYRATE_BASE =		0x0de,
+
+	MT_EE_RF_TEMP_COMP_SLOPE_5G =		0x0f2,
+	MT_EE_RF_TEMP_COMP_SLOPE_2G =		0x0f4,
+
+	MT_EE_RF_2G_TSSI_OFF_TXPOWER =		0x0f6,
+	MT_EE_RF_2G_RX_HIGH_GAIN =		0x0f8,
+	MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN =	0x0fa,
+	MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN =	0x0fc,
+	MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN =	0x0fe,
+
+	MT_EE_BT_RCAL_RESULT =			0x138,
+	MT_EE_BT_VCDL_CALIBRATION =		0x13c,
+	MT_EE_BT_PMUCFG =			0x13e,
+
+	MT_EE_USAGE_MAP_START =			0x1e0,
+	MT_EE_USAGE_MAP_END =			0x1fc,
+
+	__MT_EE_MAX
+};
+
+#define MT_EE_NIC_CONF_0_RX_PATH		GENMASK(3, 0)
+#define MT_EE_NIC_CONF_0_TX_PATH		GENMASK(7, 4)
+#define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
+#define MT_EE_NIC_CONF_0_PA_INT_2G		BIT(8)
+#define MT_EE_NIC_CONF_0_PA_INT_5G		BIT(9)
+#define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
+
+#define MT_EE_NIC_CONF_1_HW_RF_CTRL		BIT(0)
+#define MT_EE_NIC_CONF_1_TEMP_TX_ALC		BIT(1)
+#define MT_EE_NIC_CONF_1_LNA_EXT_2G		BIT(2)
+#define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
+#define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
+
+#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
+#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
+#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
+#define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
+#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
+#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
+
+#define MT_EE_TX_POWER_BYRATE(x)		(MT_EE_TX_POWER_BYRATE_BASE + \
+						 (x) * 4)
+
+#define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
+						 MT_EE_USAGE_MAP_START + 1)
+
+#endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 807bf46e0dd9..7c3d65f9d18d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -21,7 +21,7 @@
 #define EE_FIELD(_name, _value) [MT_EE_##_name] = (_value) | 1
 
 static int
-mt76x2_eeprom_copy(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field,
+mt76x2_eeprom_copy(struct mt76x2_dev *dev, enum mt76x02_eeprom_field field,
 		   void *dest, int len)
 {
 	if (field + len > dev->mt76.eeprom.size)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 0f3e4d2f4fee..64b91fb57e3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -17,88 +17,7 @@
 #ifndef __MT76x2_EEPROM_H
 #define __MT76x2_EEPROM_H
 
-#include "mt76x2.h"
-
-enum mt76x2_eeprom_field {
-	MT_EE_CHIP_ID =				0x000,
-	MT_EE_VERSION =				0x002,
-	MT_EE_MAC_ADDR =			0x004,
-	MT_EE_PCI_ID =				0x00A,
-	MT_EE_NIC_CONF_0 =			0x034,
-	MT_EE_NIC_CONF_1 =			0x036,
-	MT_EE_NIC_CONF_2 =			0x042,
-
-	MT_EE_XTAL_TRIM_1 =			0x03a,
-	MT_EE_XTAL_TRIM_2 =			0x09e,
-
-	MT_EE_LNA_GAIN =			0x044,
-	MT_EE_RSSI_OFFSET_2G_0 =		0x046,
-	MT_EE_RSSI_OFFSET_2G_1 =		0x048,
-	MT_EE_RSSI_OFFSET_5G_0 =		0x04a,
-	MT_EE_RSSI_OFFSET_5G_1 =		0x04c,
-
-	MT_EE_TX_POWER_DELTA_BW40 =		0x050,
-	MT_EE_TX_POWER_DELTA_BW80 =		0x052,
-
-	MT_EE_TX_POWER_EXT_PA_5G =		0x054,
-
-	MT_EE_TX_POWER_0_START_2G =		0x056,
-	MT_EE_TX_POWER_1_START_2G =		0x05c,
-
-	/* used as byte arrays */
-#define MT_TX_POWER_GROUP_SIZE_5G		5
-#define MT_TX_POWER_GROUPS_5G			6
-	MT_EE_TX_POWER_0_START_5G =		0x062,
-
-	MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA =	0x074,
-	MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE =	0x076,
-
-	MT_EE_TX_POWER_1_START_5G =		0x080,
-
-	MT_EE_TX_POWER_CCK =			0x0a0,
-	MT_EE_TX_POWER_OFDM_2G_6M =		0x0a2,
-	MT_EE_TX_POWER_OFDM_2G_24M =		0x0a4,
-	MT_EE_TX_POWER_OFDM_5G_6M =		0x0b2,
-	MT_EE_TX_POWER_OFDM_5G_24M =		0x0b4,
-	MT_EE_TX_POWER_HT_MCS0 =		0x0a6,
-	MT_EE_TX_POWER_HT_MCS4 =		0x0a8,
-	MT_EE_TX_POWER_HT_MCS8 =		0x0aa,
-	MT_EE_TX_POWER_HT_MCS12 =		0x0ac,
-	MT_EE_TX_POWER_VHT_MCS0 =		0x0ba,
-	MT_EE_TX_POWER_VHT_MCS4 =		0x0bc,
-	MT_EE_TX_POWER_VHT_MCS8 =		0x0be,
-
-	MT_EE_RF_TEMP_COMP_SLOPE_5G =		0x0f2,
-	MT_EE_RF_TEMP_COMP_SLOPE_2G =		0x0f4,
-
-	MT_EE_RF_2G_TSSI_OFF_TXPOWER =		0x0f6,
-	MT_EE_RF_2G_RX_HIGH_GAIN =		0x0f8,
-	MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN =	0x0fa,
-	MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN =	0x0fc,
-	MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN =	0x0fe,
-
-	MT_EE_BT_RCAL_RESULT =			0x138,
-	MT_EE_BT_VCDL_CALIBRATION =		0x13c,
-	MT_EE_BT_PMUCFG =			0x13e,
-
-	__MT_EE_MAX
-};
-
-#define MT_EE_NIC_CONF_0_PA_INT_2G		BIT(8)
-#define MT_EE_NIC_CONF_0_PA_INT_5G		BIT(9)
-#define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
-
-#define MT_EE_NIC_CONF_1_TEMP_TX_ALC		BIT(1)
-#define MT_EE_NIC_CONF_1_LNA_EXT_2G		BIT(2)
-#define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
-#define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
-
-#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
-#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
-#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
-#define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
-#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
-#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
+#include "mt76x02_eeprom.h"
 
 enum mt76x2_board_type {
 	BOARD_TYPE_2GHZ = 1,
@@ -138,7 +57,7 @@ struct mt76x2_temp_comp {
 };
 
 static inline int
-mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field)
+mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x02_eeprom_field field)
 {
 	if ((field & 1) || field >= __MT_EE_MAX)
 		return -1;
-- 
2.17.1
