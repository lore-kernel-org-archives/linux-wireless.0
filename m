Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38450 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id t25-v6so10014432wmi.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:34 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 08/20] mt76: move mt76x2_ext_pa_enabled routine in mt76x02_eeprom.c
Date: Thu, 20 Sep 2018 11:11:55 +0200
Message-Id: <da33c3b1116d9c8966189e3c2b0711dd2629c8ff.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111254_189959_56E8C182)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2_ext_pa_enabled utility routine in mt76x02_eeprom.c
and remove duplicated code. This is a preliminary patch to
unify eeprom code between mt76x2 and mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c |  6 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c  |  7 ++++---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h  |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c     | 13 +++----------
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c | 11 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c  | 13 +------------
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h  |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c     |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c  | 12 ++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c    |  2 +-
 11 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index e7a77a886068..f9e305840176 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -99,6 +99,7 @@ static int
 mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 {
 	struct mt76x0_dev *dev = file->private;
+	u16 val;
 	int i;
 
 	seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
@@ -112,7 +113,10 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	seq_printf(file, "LNA gain 5Ghz: %hhx %hhx %hhx\n",
 		   dev->ee->lna_gain_5ghz[0], dev->ee->lna_gain_5ghz[1],
 		   dev->ee->lna_gain_5ghz[2]);
-	seq_printf(file, "Power Amplifier type %hhx\n", dev->ee->pa_type);
+
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
+	seq_printf(file, "Power Amplifier type %lx\n",
+		   val & MT_EE_NIC_CONF_0_PA_TYPE);
 	seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
 		   dev->ee->reg.start + dev->ee->reg.num - 1);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 43239a1cb1e5..6c492a21be26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -90,9 +90,6 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 	    FIELD_GET(MT_EE_NIC_CONF_0_TX_PATH, nic_conf0) > 1)
 		dev_err(dev->mt76.dev,
 			"Error: device has more than 1 RX/TX stream!\n");
-
-	dev->ee->pa_type = FIELD_GET(MT_EE_NIC_CONF_0_PA_TYPE, nic_conf0);
-	dev_dbg(dev->mt76.dev, "PA Type %d\n", dev->ee->pa_type);
 }
 
 static void
@@ -330,6 +327,10 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	if (ret)
 		return ret;
 
+	ret = mt76_eeprom_init(&dev->mt76, MT76X0_EEPROM_SIZE);
+	if (ret < 0)
+		return ret;
+
 	dev->ee = devm_kzalloc(dev->mt76.dev, sizeof(*dev->ee), GFP_KERNEL);
 	if (!dev->ee)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 1051e3216614..e58a30589aa2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -35,7 +35,6 @@ struct mt76x0_eeprom_params {
 	s8 rssi_offset_5ghz[3];
 	s8 lna_gain_2ghz;
 	s8 lna_gain_5ghz[3];
-	u8 pa_type;
 
 	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
 	u32 tx_pwr_cfg_2g[5][2];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 2b6d928aab89..ba0e68b33ae7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -340,16 +340,12 @@ mt76x0_phy_set_band(struct mt76x0_dev *dev, enum nl80211_band band)
 	}
 }
 
-#define EXT_PA_2G_5G            0x0
-#define EXT_PA_5G_ONLY          0x1
-#define EXT_PA_2G_ONLY          0x2
-#define INT_PA_2G_5G            0x3
-
 static void
 mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
 {
 	u16 rf_band = rf_bw_band & 0xff00;
 	u16 rf_bw = rf_bw_band & 0x00ff;
+	enum nl80211_band band;
 	u32 mac_reg;
 	u8 rf_val;
 	int i;
@@ -496,11 +492,8 @@ mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band
 	mac_reg &= ~0xC; /* Clear 0x518[3:2] */
 	mt76_wr(dev, MT_RF_MISC, mac_reg);
 
-	if (dev->ee->pa_type == INT_PA_2G_5G ||
-	    (dev->ee->pa_type == EXT_PA_5G_ONLY && (rf_band & RF_G_BAND)) ||
-	    (dev->ee->pa_type == EXT_PA_2G_ONLY && (rf_band & RF_A_BAND))) {
-		; /* Internal PA - nothing to do. */
-	} else {
+	band = (rf_band & RF_G_BAND) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
+	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
 		/*
 			MT_RF_MISC (offset: 0x0518)
 			[2]1'b1: enable external A band PA, 1'b0: disable external A band PA
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index 21fe7eb0652d..edb08863e4ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -70,3 +70,14 @@ int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_get_efuse_data);
+
+bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band)
+{
+	u16 conf0 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_0);
+
+	if (band == NL80211_BAND_5GHZ)
+		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_5G);
+	else
+		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_2G);
+}
+EXPORT_SYMBOL_GPL(mt76x02_ext_pa_enabled);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 852ea9b51e97..70ca2729895c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -151,6 +151,7 @@ mt76x02_eeprom_get(struct mt76_dev *dev,
 	return get_unaligned_le16(dev->eeprom.data + field);
 }
 
+bool mt76x02_ext_pa_enabled(struct mt76_dev *dev, enum nl80211_band band);
 int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 333faa44d7cc..ab52a7f19611 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -568,7 +568,7 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 	if (!mt76x2_temp_tx_alc_enabled(dev))
 		return -EINVAL;
 
-	if (!mt76x2_ext_pa_enabled(dev, band))
+	if (!mt76x02_ext_pa_enabled(&dev->mt76, band))
 		return -EINVAL;
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
@@ -594,17 +594,6 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_temp_comp);
 
-bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band)
-{
-	u16 conf0 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
-
-	if (band == NL80211_BAND_5GHZ)
-		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_5G);
-	else
-		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_2G);
-}
-EXPORT_SYMBOL_GPL(mt76x2_ext_pa_enabled);
-
 int mt76x2_eeprom_init(struct mt76x2_dev *dev)
 {
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 6064ef103d2c..da476aad65fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -63,7 +63,6 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 			   struct mt76x2_tx_power_info *t,
 			   struct ieee80211_channel *chan);
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
-bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band);
 void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
 void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 4477a4e184e9..3f786596e586 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -34,7 +34,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
 	if (chan->band == NL80211_BAND_5GHZ)
 		flag |= BIT(0);
 
-	if (mt76x2_ext_pa_enabled(dev, chan->band))
+	if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
 		flag |= BIT(8);
 
 	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TSSI, flag, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 42ca855c7579..c059305b9186 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -64,7 +64,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 		mt76_wr(dev, MT_TX_ALC_CFG_2, 0x35160a00);
 		mt76_wr(dev, MT_TX_ALC_CFG_3, 0x35160a06);
 
-		if (mt76x2_ext_pa_enabled(dev, band)) {
+		if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
 			mt76_wr(dev, MT_RF_PA_MODE_ADJ0, 0x0000ec00);
 			mt76_wr(dev, MT_RF_PA_MODE_ADJ1, 0x0000ec00);
 		} else {
@@ -75,7 +75,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 		pa_mode[0] = 0x0000ffff;
 		pa_mode[1] = 0x00ff00ff;
 
-		if (mt76x2_ext_pa_enabled(dev, band)) {
+		if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
 			mt76_wr(dev, MT_TX_ALC_CFG_2, 0x2f0f0400);
 			mt76_wr(dev, MT_TX_ALC_CFG_3, 0x2f0f0476);
 		} else {
@@ -83,7 +83,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 			mt76_wr(dev, MT_TX_ALC_CFG_3, 0x1b0f0476);
 		}
 
-		if (mt76x2_ext_pa_enabled(dev, band))
+		if (mt76x02_ext_pa_enabled(&dev->mt76, band))
 			pa_mode_adj = 0x04000000;
 		else
 			pa_mode_adj = 0;
@@ -97,7 +97,7 @@ void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 	mt76_wr(dev, MT_RF_PA_MODE_CFG0, pa_mode[0]);
 	mt76_wr(dev, MT_RF_PA_MODE_CFG1, pa_mode[1]);
 
-	if (mt76x2_ext_pa_enabled(dev, band)) {
+	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
 		u32 val;
 
 		if (band == NL80211_BAND_2GHZ)
@@ -244,7 +244,7 @@ void mt76x2_configure_tx_delay(struct mt76x2_dev *dev,
 {
 	u32 cfg0, cfg1;
 
-	if (mt76x2_ext_pa_enabled(dev, band)) {
+	if (mt76x02_ext_pa_enabled(&dev->mt76, band)) {
 		cfg0 = bw ? 0x000b0c01 : 0x00101101;
 		cfg1 = 0x00011414;
 	} else {
@@ -370,7 +370,7 @@ void mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev, bool wait)
 		dev->cal.tssi_comp_pending = false;
 		mt76x2_get_power_info(dev, &txp, chan);
 
-		if (mt76x2_ext_pa_enabled(dev, chan->band))
+		if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
 			t.pa_mode = 1;
 
 		t.cal_mode = BIT(1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
index 9842ed04d764..1cd9b2468ef0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
@@ -250,7 +250,7 @@ int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
 			chan = dev->mt76.chandef.chan;
 			if (chan->band == NL80211_BAND_5GHZ)
 				flag |= BIT(0);
-			if (mt76x2_ext_pa_enabled(dev, chan->band))
+			if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
 				flag |= BIT(8);
 			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TSSI,
 					      flag, false);
-- 
2.17.1
