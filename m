Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41720 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387475AbeITOzH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id j15-v6so4504070wrt.8
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 12/20] mt76x0: unify rssi_offset parsing
Date: Thu, 20 Sep 2018 11:11:59 +0200
Message-Id: <bf40ebf801fb9af46430de56a45b109eebdaa3e0.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112420_822410_82AF3FF4)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify rssi_offset parsing with mt76x2 driver using eeprom utility
routines available in mt76x02-lib module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  7 +---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 38 ++++---------------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  3 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 12 +-----
 4 files changed, 11 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 566ed0b61035..b6f467e7ee8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -103,11 +103,8 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	int i;
 
 	seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
-	seq_printf(file, "RSSI offset 2GHz: %hhx %hhx\n",
-		   dev->ee->rssi_offset_2ghz[0], dev->ee->rssi_offset_2ghz[1]);
-	seq_printf(file, "RSSI offset 5GHz: %hhx %hhx %hhx\n",
-		   dev->ee->rssi_offset_5ghz[0], dev->ee->rssi_offset_5ghz[1],
-		   dev->ee->rssi_offset_5ghz[2]);
+	seq_printf(file, "RSSI offset: %hhx %hhx\n",
+		   dev->caldata.rssi_offset[0], dev->caldata.rssi_offset[1]);
 	seq_printf(file, "Temperature offset: %hhx\n", dev->ee->temp_off);
 	seq_printf(file, "LNA gain: %x\n", dev->caldata.lna_gain);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 20a9f8fb20da..6c24274d23f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -126,44 +126,21 @@ void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	struct mt76x0_caldata *caldata = &dev->caldata;
-	s8 lna_5g[3], lna_2g;
+	s8 val, lna_5g[3], lna_2g;
 	u16 rssi_offset;
+	int i;
 
 	mt76x02_get_rx_gain(&dev->mt76, chan->band, &rssi_offset,
 			    &lna_2g, lna_5g);
 	caldata->lna_gain = mt76x02_get_lna_gain(&dev->mt76, &lna_2g,
 						 lna_5g, chan);
 
-}
-
-static void
-mt76x0_set_rssi_offset(struct mt76x0_dev *dev, u8 *eeprom)
-{
-	int i;
-	s8 *rssi_offset = dev->ee->rssi_offset_2ghz;
-
-	for (i = 0; i < 2; i++) {
-		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_2G_0 + i];
+	for (i = 0; i < ARRAY_SIZE(caldata->rssi_offset); i++) {
+		val = rssi_offset >> (8 * i);
+		if (val < -10 || val > 10)
+			val = 0;
 
-		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
-			dev_warn(dev->mt76.dev,
-				 "Warning: EEPROM RSSI is invalid %02hhx\n",
-				 rssi_offset[i]);
-			rssi_offset[i] = 0;
-		}
-	}
-
-	rssi_offset = dev->ee->rssi_offset_5ghz;
-
-	for (i = 0; i < 3; i++) {
-		rssi_offset[i] = eeprom[MT_EE_RSSI_OFFSET_5G_0 + i];
-
-		if (rssi_offset[i] < -10 || rssi_offset[i] > 10) {
-			dev_warn(dev->mt76.dev,
-				 "Warning: EEPROM RSSI is invalid %02hhx\n",
-				 rssi_offset[i]);
-			rssi_offset[i] = 0;
-		}
+		caldata->rssi_offset[i] = val;
 	}
 }
 
@@ -311,7 +288,6 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x0_set_chip_cap(dev, eeprom);
 	mt76x0_set_rf_freq_off(dev, eeprom);
 	mt76x0_set_temp_offset(dev, eeprom);
-	mt76x0_set_rssi_offset(dev, eeprom);
 	dev->chainmask = 0x0101;
 
 	mt76x0_set_tx_power_per_rate(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index e62c61d91505..dd9cb0d2de41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -29,14 +29,13 @@ struct reg_channel_bounds {
 };
 
 struct mt76x0_caldata {
+	s8 rssi_offset[2];
 	s8 lna_gain;
 };
 
 struct mt76x0_eeprom_params {
 	u8 rf_freq_off;
 	s16 temp_off;
-	s8 rssi_offset_2ghz[2];
-	s8 rssi_offset_5ghz[3];
 
 	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
 	u32 tx_pwr_cfg_2g[5][2];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 08041ea70a1c..72d0ddc381b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -229,18 +229,8 @@ mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
 int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi)
 {
 	struct mt76x0_caldata *caldata = &dev->caldata;
-	s8 rssi_offset;
-	int val;
 
-	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ) {
-		rssi_offset = dev->ee->rssi_offset_2ghz[0];
-	} else {
-		rssi_offset = dev->ee->rssi_offset_5ghz[0];
-	}
-
-	val = rxwi->rssi[0] + rssi_offset - caldata->lna_gain;
-
-	return val;
+	return rxwi->rssi[0] + caldata->rssi_offset[0] - caldata->lna_gain;
 }
 
 static void mt76x0_vco_cal(struct mt76x0_dev *dev, u8 channel)
-- 
2.17.1
