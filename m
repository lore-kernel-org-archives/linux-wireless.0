Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36677 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id j192-v6so10093136wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 11/20] mt76x0: unify lna_gain parsing
Date: Thu, 20 Sep 2018 11:11:58 +0200
Message-Id: <697986870ee86c266689c8387b20803255bd5d5d.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112419_437388_917DDC18)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify lna gain parsing with mt76x2 driver using eeprom utility
routines available in mt76x02-lib module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  5 +---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 26 +++++++------------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  7 +++--
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 ++
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 24 +++++------------
 5 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 932c0e41196c..566ed0b61035 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -109,10 +109,7 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 		   dev->ee->rssi_offset_5ghz[0], dev->ee->rssi_offset_5ghz[1],
 		   dev->ee->rssi_offset_5ghz[2]);
 	seq_printf(file, "Temperature offset: %hhx\n", dev->ee->temp_off);
-	seq_printf(file, "LNA gain 2Ghz: %hhx\n", dev->ee->lna_gain_2ghz);
-	seq_printf(file, "LNA gain 5Ghz: %hhx %hhx %hhx\n",
-		   dev->ee->lna_gain_5ghz[0], dev->ee->lna_gain_5ghz[1],
-		   dev->ee->lna_gain_5ghz[2]);
+	seq_printf(file, "LNA gain: %x\n", dev->caldata.lna_gain);
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
 	seq_printf(file, "Power Amplifier type %lx\n",
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 5d08a7bb16ce..20a9f8fb20da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -122,25 +122,18 @@ mt76x0_set_rf_freq_off(struct mt76x0_dev *dev, u8 *eeprom)
 		dev->ee->rf_freq_off += comp;
 }
 
-static void
-mt76x0_set_lna_gain(struct mt76x0_dev *dev, u8 *eeprom)
+void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
 {
-	u8 gain;
-
-	dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN];
-	dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN + 1];
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	struct mt76x0_caldata *caldata = &dev->caldata;
+	s8 lna_5g[3], lna_2g;
+	u16 rssi_offset;
 
-	gain = eeprom[MT_EE_LNA_GAIN_5GHZ_1];
-	if (gain == 0xff || gain == 0)
-		dev->ee->lna_gain_5ghz[1] = dev->ee->lna_gain_5ghz[0];
-	else
-		dev->ee->lna_gain_5ghz[1] = gain;
+	mt76x02_get_rx_gain(&dev->mt76, chan->band, &rssi_offset,
+			    &lna_2g, lna_5g);
+	caldata->lna_gain = mt76x02_get_lna_gain(&dev->mt76, &lna_2g,
+						 lna_5g, chan);
 
-	gain = eeprom[MT_EE_LNA_GAIN_5GHZ_2];
-	if (gain == 0xff || gain == 0)
-		dev->ee->lna_gain_5ghz[2] = dev->ee->lna_gain_5ghz[0];
-	else
-		dev->ee->lna_gain_5ghz[2] = gain;
 }
 
 static void
@@ -318,7 +311,6 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x0_set_chip_cap(dev, eeprom);
 	mt76x0_set_rf_freq_off(dev, eeprom);
 	mt76x0_set_temp_offset(dev, eeprom);
-	mt76x0_set_lna_gain(dev, eeprom);
 	mt76x0_set_rssi_offset(dev, eeprom);
 	dev->chainmask = 0x0101;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index dbfcbfa71291..e62c61d91505 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -28,13 +28,15 @@ struct reg_channel_bounds {
 	u8 num;
 };
 
+struct mt76x0_caldata {
+	s8 lna_gain;
+};
+
 struct mt76x0_eeprom_params {
 	u8 rf_freq_off;
 	s16 temp_off;
 	s8 rssi_offset_2ghz[2];
 	s8 rssi_offset_5ghz[3];
-	s8 lna_gain_2ghz;
-	s8 lna_gain_5ghz[3];
 
 	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
 	u32 tx_pwr_cfg_2g[5][2];
@@ -44,6 +46,7 @@ struct mt76x0_eeprom_params {
 };
 
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
+void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
 
 static inline u32 s6_validate(u32 reg)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 6aaa9a5b51db..99d48fa96fd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -28,6 +28,7 @@
 #include "../mt76.h"
 #include "../mt76x02_regs.h"
 #include "../mt76x02_mac.h"
+#include "eeprom.h"
 
 #define MT_CALIBRATE_INTERVAL		(4 * HZ)
 
@@ -89,6 +90,7 @@ struct mt76x0_dev {
 	const u16 *beacon_offsets;
 
 	struct mt76x0_eeprom_params *ee;
+	struct mt76x0_caldata caldata;
 
 	struct mutex reg_atomic_mutex;
 	struct mutex hw_atomic_mutex;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ba0e68b33ae7..08041ea70a1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -228,18 +228,17 @@ mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
 
 int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi)
 {
-	s8 lna_gain, rssi_offset;
+	struct mt76x0_caldata *caldata = &dev->caldata;
+	s8 rssi_offset;
 	int val;
 
 	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ) {
-		lna_gain = dev->ee->lna_gain_2ghz;
 		rssi_offset = dev->ee->rssi_offset_2ghz[0];
 	} else {
-		lna_gain = dev->ee->lna_gain_5ghz[0];
 		rssi_offset = dev->ee->rssi_offset_5ghz[0];
 	}
 
-	val = rxwi->rssi[0] + rssi_offset - lna_gain;
+	val = rxwi->rssi[0] + rssi_offset - caldata->lna_gain;
 
 	return val;
 }
@@ -545,20 +544,10 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_ban
 
 		if (pair->reg == MT_BBP(AGC, 8)) {
 			u32 val = pair->value;
-			u8 gain = FIELD_GET(MT_BBP_AGC_GAIN, val);
-
-			if (channel > 14) {
-				if (channel < 100)
-					gain -= dev->ee->lna_gain_5ghz[0]*2;
-				else if (channel < 137)
-					gain -= dev->ee->lna_gain_5ghz[1]*2;
-				else
-					gain -= dev->ee->lna_gain_5ghz[2]*2;
-
-			} else {
-				gain -= dev->ee->lna_gain_2ghz*2;
-			}
+			u8 gain;
 
+			gain = FIELD_GET(MT_BBP_AGC_GAIN, val);
+			gain -= dev->caldata.lna_gain * 2;
 			val &= ~MT_BBP_AGC_GAIN;
 			val |= FIELD_PREP(MT_BBP_AGC_GAIN, gain);
 			mt76_wr(dev, pair->reg, val);
@@ -737,6 +726,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
 	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
+	mt76x0_read_rx_gain(dev);
 
 	/* set Japan Tx filter at channel 14 */
 	val = mt76_rr(dev, MT_BBP(CORE, 1));
-- 
2.17.1
