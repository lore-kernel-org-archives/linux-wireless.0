Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39019 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387433AbeITOzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id q8-v6so10069987wmq.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:45 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 19/20] mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_chan
Date: Thu, 20 Sep 2018 11:12:06 +0200
Message-Id: <818313ec8e94d1ebcefdcd5b778b6634909e7719.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112418_974421_14601803)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to unify eeprom parsing between mt76x0 and mt76x2 drivers,
remove eeprom pointer dependency from mt76x0_set_tx_power_per_chan
routine.
Remove mt76x0_eeprom_params since it is now an empty structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  4 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 92 +++++++++++--------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  7 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  2 +-
 5 files changed, 58 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 46327cc90797..a34feead2cc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -115,9 +115,9 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 		   val & MT_EE_NIC_CONF_0_PA_TYPE);
 
 	seq_puts(file, "Per channel power:\n");
-	for (i = 0; i < 58; i++)
+	for (i = 0; i < MT76X0_NUM_CHANS; i++)
 		seq_printf(file, "\t%d chan:%d pwr:%d\n", i, i,
-			   dev->ee->tx_pwr_per_chan[i]);
+			   dev->caldata.tx_pwr_per_chan[i]);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 1406e88141de..6db4610f5839 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -224,38 +224,57 @@ void mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev,
 	t->vht[8] = mt76x0_get_power_rate(val >> 8, delta);
 }
 
-static void
-mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev, u8 *eeprom)
+static void mt76x0_set_tx_power_per_chan(struct mt76x0_dev *dev)
 {
+	struct mt76x0_caldata *caldata = &dev->caldata;
+	u8 val, addr;
+	u16 data;
 	int i;
-	u8 tx_pwr;
 
-	for (i = 0; i < 14; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_DELTA_BW80 + i];
-		if (tx_pwr <= 0x3f && tx_pwr > 0)
-			dev->ee->tx_pwr_per_chan[i] = tx_pwr;
+	for (i = 0; i < 14; i += 2) {
+		addr = MT_EE_TX_POWER_DELTA_BW80 + i;
+		data = mt76x02_eeprom_get(&dev->mt76, addr);
+
+		val = data;
+		if (val <= 0x3f && val > 0)
+			caldata->tx_pwr_per_chan[i] = val;
+		else
+			caldata->tx_pwr_per_chan[i] = 5;
+
+		val = data >> 8;
+		if (val <= 0x3f && val > 0)
+			caldata->tx_pwr_per_chan[i + 1] = val;
 		else
-			dev->ee->tx_pwr_per_chan[i] = 5;
+			caldata->tx_pwr_per_chan[i + 1] = 5;
 	}
 
-	for (i = 0; i < 40; i++) {
-		tx_pwr = eeprom[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + i];
-		if (tx_pwr <= 0x3f && tx_pwr > 0)
-			dev->ee->tx_pwr_per_chan[14 + i] = tx_pwr;
+	for (i = 0; i < 40; i += 2) {
+		addr = MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE + 2 + i;
+		data = mt76x02_eeprom_get(&dev->mt76, addr);
+
+		val = data;
+		if (val <= 0x3f && val > 0)
+			caldata->tx_pwr_per_chan[14 + i] = val;
+		else
+			caldata->tx_pwr_per_chan[14 + i] = 5;
+
+		val = data >> 8;
+		if (val <= 0x3f && val > 0)
+			caldata->tx_pwr_per_chan[15 + i] = val;
 		else
-			dev->ee->tx_pwr_per_chan[14 + i] = 5;
+			caldata->tx_pwr_per_chan[15 + i] = 5;
 	}
 
-	dev->ee->tx_pwr_per_chan[54] = dev->ee->tx_pwr_per_chan[22];
-	dev->ee->tx_pwr_per_chan[55] = dev->ee->tx_pwr_per_chan[28];
-	dev->ee->tx_pwr_per_chan[56] = dev->ee->tx_pwr_per_chan[34];
-	dev->ee->tx_pwr_per_chan[57] = dev->ee->tx_pwr_per_chan[44];
+	caldata->tx_pwr_per_chan[54] = caldata->tx_pwr_per_chan[22];
+	caldata->tx_pwr_per_chan[55] = caldata->tx_pwr_per_chan[28];
+	caldata->tx_pwr_per_chan[56] = caldata->tx_pwr_per_chan[34];
+	caldata->tx_pwr_per_chan[57] = caldata->tx_pwr_per_chan[44];
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
@@ -266,37 +285,32 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
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
+	mt76x0_set_tx_power_per_chan(dev);
 
-	mt76x0_set_tx_power_per_chan(dev, eeprom);
+	dev->chainmask = 0x0101;
 
-out:
-	kfree(eeprom);
-	return ret;
+	return 0;
 }
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 88e31186c317..23b83a5ca098 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -28,6 +28,7 @@ struct reg_channel_bounds {
 	u8 num;
 };
 
+#define MT76X0_NUM_CHANS	58
 struct mt76x0_caldata {
 	s8 rssi_offset[2];
 	s8 lna_gain;
@@ -35,14 +36,10 @@ struct mt76x0_caldata {
 	s16 temp_offset;
 	u8 freq_offset;
 
+	u8 tx_pwr_per_chan[MT76X0_NUM_CHANS];
 	struct mt76_rate_power rate_power;
 };
 
-struct mt76x0_eeprom_params {
-
-	u8 tx_pwr_per_chan[58];
-};
-
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
 void mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev,
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
index 52cd39fbfd49..8f428f6c5333 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -633,7 +633,7 @@ mt76x0_phy_set_chan_pwr(struct mt76x0_dev *dev, u8 channel)
 
 	val = mt76_rr(dev, MT_TX_ALC_CFG_0);
 	val &= ~0x3f3f;
-	val |= dev->ee->tx_pwr_per_chan[i];
+	val |= dev->caldata.tx_pwr_per_chan[i];
 	val |= 0x2f2f << 16;
 	mt76_wr(dev, MT_TX_ALC_CFG_0, val);
 }
-- 
2.17.1
