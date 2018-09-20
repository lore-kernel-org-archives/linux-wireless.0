Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53758 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id b19-v6so9132098wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 14/20] mt76x0: unify freq offset parsing
Date: Thu, 20 Sep 2018 11:12:01 +0200
Message-Id: <3a1d075efd810e114233f941b7b15b3c88955c8f.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112420_990000_D5690651)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify frequency offset parsing with mt76x2 driver using
eeprom utility routines available in mt76x02-lib module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  3 ++-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 26 +++++++++----------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  3 +--
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  3 ++-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  5 ++++
 5 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index d138ed3bda17..39c2c846f808 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -102,7 +102,8 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	u16 val;
 	int i;
 
-	seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
+	seq_printf(file, "RF freq offset: %hhx\n",
+		   dev->caldata.freq_offset);
 	seq_printf(file, "RSSI offset: %hhx %hhx\n",
 		   dev->caldata.rssi_offset[0], dev->caldata.rssi_offset[1]);
 	seq_printf(file, "Temperature offset: %hhx\n",
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index ae7c11519b0a..70dd96051e77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -103,23 +103,21 @@ static void mt76x0_set_temp_offset(struct mt76x0_dev *dev)
 		dev->caldata.temp_offset = -10;
 }
 
-static void
-mt76x0_set_rf_freq_off(struct mt76x0_dev *dev, u8 *eeprom)
+static void mt76x0_set_freq_offset(struct mt76x0_dev *dev)
 {
-	u8 comp;
+	struct mt76x0_caldata *caldata = &dev->caldata;
+	u8 val;
 
-	comp = eeprom[MT_EE_FREQ_OFFSET_COMPENSATION];
-	if (!mt76x02_field_valid(comp))
-		comp = 0;
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_FREQ_OFFSET);
+	if (!mt76x02_field_valid(val))
+		val = 0;
+	caldata->freq_offset = val;
 
-	dev->ee->rf_freq_off = eeprom[MT_EE_FREQ_OFFSET];
-	if (!mt76x02_field_valid(dev->ee->rf_freq_off))
-		dev->ee->rf_freq_off = 0;
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TSSI_BOUND4) >> 8;
+	if (!mt76x02_field_valid(val))
+		val = 0;
 
-	if (comp & BIT(7))
-		dev->ee->rf_freq_off -= comp & 0x7f;
-	else
-		dev->ee->rf_freq_off += comp;
+	caldata->freq_offset -= mt76x02_sign_extend(val, 8);
 }
 
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
@@ -286,7 +284,7 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 
 	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev, eeprom);
-	mt76x0_set_rf_freq_off(dev, eeprom);
+	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
 	dev->chainmask = 0x0101;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 55e624cf7f2a..8006d08cba45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -33,11 +33,10 @@ struct mt76x0_caldata {
 	s8 lna_gain;
 
 	s16 temp_offset;
+	u8 freq_offset;
 };
 
 struct mt76x0_eeprom_params {
-	u8 rf_freq_off;
-
 	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
 	u32 tx_pwr_cfg_2g[5][2];
 	u32 tx_pwr_cfg_5g[5][2];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index dbe9e2ee5def..c3db4c1cd4fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -942,7 +942,8 @@ mt76x0_rf_init(struct mt76x0_dev *dev)
 	   E1: B0.R22<6:0>: xo_cxo<6:0>
 	   E2: B0.R21<0>: xo_cxo<0>, B0.R22<7:0>: xo_cxo<8:1>
 	 */
-	rf_wr(dev, MT_RF(0, 22), min_t(u8, dev->ee->rf_freq_off, 0xBF));
+	rf_wr(dev, MT_RF(0, 22),
+	      min_t(u8, dev->caldata.freq_offset, 0xbf));
 	val = rf_rr(dev, MT_RF(0, 22));
 
 	/*
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 2132af9f8c94..995aebbcc194 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -74,7 +74,12 @@ enum mt76x02_eeprom_field {
 
 	MT_EE_2G_TARGET_POWER =			0x0d0,
 	MT_EE_TEMP_OFFSET =			0x0d1,
+	MT_EE_TSSI_BOUND1 =			0x0d4,
+	MT_EE_TSSI_BOUND2 =			0x0d6,
+	MT_EE_TSSI_BOUND3 =			0x0d8,
+	MT_EE_TSSI_BOUND4 =			0x0da,
 	MT_EE_FREQ_OFFSET_COMPENSATION =	0x0db,
+	MT_EE_TSSI_BOUND5 =			0x0dc,
 	MT_EE_TX_POWER_BYRATE_BASE =		0x0de,
 
 	MT_EE_RF_TEMP_COMP_SLOPE_5G =		0x0f2,
-- 
2.17.1
