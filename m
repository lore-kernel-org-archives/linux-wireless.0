Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37940 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729017AbeIVRjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id j8-v6so11494950wrw.5
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:55 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] mt76x0: remove eeprom dependency from mt76x0_get_power_info
Date: Sat, 22 Sep 2018 13:45:35 +0200
Message-Id: <20180922114537.24004-8-lorenzo.bianconi@redhat.com> (sfid-20180922_134906_285512_CE12C287)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to unify eeprom parsing between mt76x0 and mt76x2 drivers,
remove eeprom pointer dependency from mt76x0_get_power_info routine.
Remove mt76x0_eeprom_params since it is now an empty structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |   5 -
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 109 +++++++++++-------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  11 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  32 ++---
 5 files changed, 77 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index eb7e0db61e56..75484cd0c9de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -100,7 +100,6 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 {
 	struct mt76x0_dev *dev = file->private;
 	u16 val;
-	int i;
 
 	seq_printf(file, "RF freq offset: %hhx\n",
 		   dev->caldata.freq_offset);
@@ -114,10 +113,6 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	seq_printf(file, "Power Amplifier type %lx\n",
 		   val & MT_EE_NIC_CONF_0_PA_TYPE);
 
-	seq_puts(file, "Per channel power:\n");
-	for (i = 0; i < 58; i++)
-		seq_printf(file, "\t%d chan:%d pwr:%d\n", i, i,
-			   dev->ee->tx_pwr_per_chan[i]);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 22837d7191d3..ef3b44202efe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -210,38 +210,71 @@ void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev)
 	mt76x02_add_rate_power_offset(t, delta);
 }
 
-static void
-mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev, u8 *eeprom)
+void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info)
 {
+	struct mt76x0_chan_map {
+		u8 chan;
+		u8 offset;
+	} chan_map[] = {
+		{   2,  0 }, {   4,  1 }, {   6,  2 }, {   8,  3 },
+		{  10,  4 }, {  12,  5 }, {  14,  6 }, {  38,  0 },
+		{  44,  1 }, {  48,  2 }, {  54,  3 }, {  60,  4 },
+		{  64,  5 }, { 102,  6 }, { 108,  7 }, { 112,  8 },
+		{ 118,  9 }, { 124, 10 }, { 128, 11 }, { 134, 12 },
+		{ 140, 13 }, { 151, 14 }, { 157, 15 }, { 161, 16 },
+		{ 167, 17 }, { 171, 18 }, { 173, 19 },
+	};
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	u8 offset, addr;
+	u16 data;
 	int i;
-	u8 tx_pwr;
 
-	for (i = 0; i < 14; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_DELTA_BW80 + i];
-		if (tx_pwr <= 0x3f && tx_pwr > 0)
-			dev->ee->tx_pwr_per_chan[i] = tx_pwr;
-		else
-			dev->ee->tx_pwr_per_chan[i] = 5;
+	for (i = 0; i < ARRAY_SIZE(chan_map); i++) {
+		if (chan_map[i].chan <= chan->hw_value) {
+			offset = chan_map[i].offset;
+			break;
+		}
 	}
+	if (i == ARRAY_SIZE(chan_map))
+		offset = chan_map[0].offset;
 
-	for (i = 0; i < 40; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + i];
-		if (tx_pwr <= 0x3f && tx_pwr > 0)
-			dev->ee->tx_pwr_per_chan[14 + i] = tx_pwr;
-		else
-			dev->ee->tx_pwr_per_chan[14 + i] = 5;
+	if (chan->band == NL80211_BAND_2GHZ) {
+		addr = MT_EE_TX_POWER_DELTA_BW80 + offset;
+	} else {
+		switch (chan->hw_value) {
+		case 58:
+			offset = 8;
+			break;
+		case 106:
+			offset = 14;
+			break;
+		case 112:
+			offset = 20;
+			break;
+		case 155:
+			offset = 30;
+			break;
+		default:
+			break;
+		}
+		addr = MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + offset;
 	}
 
-	dev->ee->tx_pwr_per_chan[54] = dev->ee->tx_pwr_per_chan[22];
-	dev->ee->tx_pwr_per_chan[55] = dev->ee->tx_pwr_per_chan[28];
-	dev->ee->tx_pwr_per_chan[56] = dev->ee->tx_pwr_per_chan[34];
-	dev->ee->tx_pwr_per_chan[57] = dev->ee->tx_pwr_per_chan[44];
+	data = mt76x02_eeprom_get(&dev->mt76, addr);
+
+	info[0] = data;
+	if (!info[0] || info[0] > 0x3f)
+		info[0] = 5;
+
+	info[1] = data >> 8;
+	if (!info[1] || info[1] > 0x3f)
+		info[1] = 5;
 }
 
-int
-mt76x0_eeprom_init(struct mt76x0_dev *dev)
+int mt76x0_eeprom_init(struct mt76x0_dev *dev)
 {
-	u8 *eeprom;
+	u8 version, fae;
+	u16 data;
 	int ret;
 
 	ret = mt76x0_efuse_physical_size_check(dev);
@@ -252,37 +285,31 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	if (ret < 0)
 		return ret;
 
-	dev->ee = devm_kzalloc(dev->mt76.dev, sizeof(*dev->ee), GFP_KERNEL);
-	if (!dev->ee)
-		return -ENOMEM;
-
-	eeprom = kmalloc(MT76X0_EEPROM_SIZE, GFP_KERNEL);
-	if (!eeprom)
-		return -ENOMEM;
-
-	ret = mt76x02_get_efuse_data(&dev->mt76, 0, eeprom,
+	ret = mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
 				     MT76X0_EEPROM_SIZE, MT_EE_READ);
 	if (ret)
-		goto out;
+		return ret;
+
+	data = mt76x02_eeprom_get(&dev->mt76, MT_EE_VERSION);
+	version = data >> 8;
+	fae = data;
 
-	if (eeprom[MT_EE_VERSION + 1] > MT76X0U_EE_MAX_VER)
+	if (version > MT76X0U_EE_MAX_VER)
 		dev_warn(dev->mt76.dev,
 			 "Warning: unsupported EEPROM version %02hhx\n",
-			 eeprom[MT_EE_VERSION + 1]);
+			 version);
 	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
-		 eeprom[MT_EE_VERSION + 1], eeprom[MT_EE_VERSION]);
+		 version, fae);
 
-	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
+	mt76x02_mac_setaddr(&dev->mt76,
+			    dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev);
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
-	dev->chainmask = 0x0101;
 
-	mt76x0_set_tx_power_per_chan(dev, eeprom);
+	dev->chainmask = 0x0101;
 
-out:
-	kfree(eeprom);
-	return ret;
+	return 0;
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index d556ee37fa14..4e1fafa5b8c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -23,11 +23,6 @@ struct mt76x0_dev;
 #define MT76X0U_EE_MAX_VER		0x0c
 #define MT76X0_EEPROM_SIZE		512
 
-struct reg_channel_bounds {
-	u8 start;
-	u8 num;
-};
-
 struct mt76x0_caldata {
 	s8 rssi_offset[2];
 	s8 lna_gain;
@@ -36,14 +31,10 @@ struct mt76x0_caldata {
 	u8 freq_offset;
 };
 
-struct mt76x0_eeprom_params {
-
-	u8 tx_pwr_per_chan[58];
-};
-
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
 void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev);
+void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info);
 
 static inline s8 s6_to_s8(u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 99d48fa96fd9..101332a35f40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -89,7 +89,6 @@ struct mt76x0_dev {
 
 	const u16 *beacon_offsets;
 
-	struct mt76x0_eeprom_params *ee;
 	struct mt76x0_caldata caldata;
 
 	struct mutex reg_atomic_mutex;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index dea68f5d91f6..9c9c55cc05e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -578,31 +578,15 @@ mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
 	mt76x02_mcu_function_select(&dev->mt76, BW_SETTING, bw, false);
 }
 
-static void
-mt76x0_phy_set_chan_pwr(struct mt76x0_dev *dev, u8 channel)
+static void mt76x0_phy_set_chan_pwr(struct mt76x0_dev *dev)
 {
-	static const int mt76x0_tx_pwr_ch_list[] = {
-		1,2,3,4,5,6,7,8,9,10,11,12,13,14,
-		36,38,40,44,46,48,52,54,56,60,62,64,
-		100,102,104,108,110,112,116,118,120,124,126,128,132,134,136,140,
-		149,151,153,157,159,161,165,167,169,171,173,
-		42,58,106,122,155
-	};
-	int i;
-	u32 val;
-
-	for (i = 0; i < ARRAY_SIZE(mt76x0_tx_pwr_ch_list); i++)
-		if (mt76x0_tx_pwr_ch_list[i] == channel)
-			break;
-
-	if (WARN_ON(i == ARRAY_SIZE(mt76x0_tx_pwr_ch_list)))
-		return;
+	u8 info[2];
 
-	val = mt76_rr(dev, MT_TX_ALC_CFG_0);
-	val &= ~0x3f3f;
-	val |= dev->ee->tx_pwr_per_chan[i];
-	val |= 0x2f2f << 16;
-	mt76_wr(dev, MT_TX_ALC_CFG_0, val);
+	mt76x0_get_power_info(dev, info);
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0,
+		       info[0]);
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1,
+		       info[1]);
 }
 
 static int
@@ -699,7 +683,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	if (scan)
 		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 1, false);
 
-	mt76x0_phy_set_chan_pwr(dev, channel);
+	mt76x0_phy_set_chan_pwr(dev);
 
 	return 0;
 }
-- 
2.18.0
