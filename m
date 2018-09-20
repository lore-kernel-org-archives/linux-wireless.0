Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34869 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id o18-v6so10080504wmc.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 13/20] mt76x0: unify temperature offset parsing
Date: Thu, 20 Sep 2018 11:12:00 +0200
Message-Id: <fc9f2c95df42d3d7ca5bbbb4ecd9f3771cd01aa8.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112419_230214_7B720C8D)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify temperature offset parsing with mt76x2 driver using
eeprom utility routines available in mt76x02-lib module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 14 +++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |  1 +
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index b6f467e7ee8c..d138ed3bda17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -105,7 +105,8 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
 	seq_printf(file, "RSSI offset: %hhx %hhx\n",
 		   dev->caldata.rssi_offset[0], dev->caldata.rssi_offset[1]);
-	seq_printf(file, "Temperature offset: %hhx\n", dev->ee->temp_off);
+	seq_printf(file, "Temperature offset: %hhx\n",
+		   dev->caldata.temp_offset);
 	seq_printf(file, "LNA gain: %x\n", dev->caldata.lna_gain);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 6c24274d23f4..ae7c11519b0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -92,15 +92,15 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 			"Error: device has more than 1 RX/TX stream!\n");
 }
 
-static void
-mt76x0_set_temp_offset(struct mt76x0_dev *dev, u8 *eeprom)
+static void mt76x0_set_temp_offset(struct mt76x0_dev *dev)
 {
-	u8 temp = eeprom[MT_EE_TEMP_OFFSET];
+	u8 val;
 
-	if (mt76x02_field_valid(temp))
-		dev->ee->temp_off = mt76x02_sign_extend(temp, 8);
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_2G_TARGET_POWER) >> 8;
+	if (mt76x02_field_valid(val))
+		dev->caldata.temp_offset = mt76x02_sign_extend(val, 8);
 	else
-		dev->ee->temp_off = -10;
+		dev->caldata.temp_offset = -10;
 }
 
 static void
@@ -287,7 +287,7 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev, eeprom);
 	mt76x0_set_rf_freq_off(dev, eeprom);
-	mt76x0_set_temp_offset(dev, eeprom);
+	mt76x0_set_temp_offset(dev);
 	dev->chainmask = 0x0101;
 
 	mt76x0_set_tx_power_per_rate(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index dd9cb0d2de41..55e624cf7f2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -31,11 +31,12 @@ struct reg_channel_bounds {
 struct mt76x0_caldata {
 	s8 rssi_offset[2];
 	s8 lna_gain;
+
+	s16 temp_offset;
 };
 
 struct mt76x0_eeprom_params {
 	u8 rf_freq_off;
-	s16 temp_off;
 
 	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
 	u32 tx_pwr_cfg_2g[5][2];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 72d0ddc381b9..dbe9e2ee5def 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -836,7 +836,7 @@ static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
 	else
 		sval |= 0xffffff00; /* Negative */
 
-	temp = (35 * (sval - dev->ee->temp_off))/ 10 + 25;
+	temp = (35 * (sval - dev->caldata.temp_offset)) / 10 + 25;
 
 done:
 	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index c22ca507b418..2132af9f8c94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -72,6 +72,7 @@ enum mt76x02_eeprom_field {
 	MT_EE_TX_POWER_VHT_MCS4 =		0x0bc,
 	MT_EE_TX_POWER_VHT_MCS8 =		0x0be,
 
+	MT_EE_2G_TARGET_POWER =			0x0d0,
 	MT_EE_TEMP_OFFSET =			0x0d1,
 	MT_EE_FREQ_OFFSET_COMPENSATION =	0x0db,
 	MT_EE_TX_POWER_BYRATE_BASE =		0x0de,
-- 
2.17.1
