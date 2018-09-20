Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39019 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id q8-v6so10069941wmq.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:44 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 18/20] mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
Date: Thu, 20 Sep 2018 11:12:05 +0200
Message-Id: <b6331275ffc4c4b402ca720f603fbb56848e59b7.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111301_000457_A0A2D3DF)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to unify eeprom parsing between mt76x0 and mt76x2 drivers,
remove eeprom pointer dependency from mt76x0_set_tx_power_per_rate.
Moreover use mt76_rate_power to store power vs rate calibration data.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  32 ++--
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 144 ++++++++++--------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  25 ++-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  16 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   4 +-
 5 files changed, 117 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 39c2c846f808..46327cc90797 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -118,19 +118,6 @@ mt76x0_eeprom_param_read(struct seq_file *file, void *data)
 	for (i = 0; i < 58; i++)
 		seq_printf(file, "\t%d chan:%d pwr:%d\n", i, i,
 			   dev->ee->tx_pwr_per_chan[i]);
-
-	seq_puts(file, "Per rate power 2GHz:\n");
-	for (i = 0; i < 5; i++)
-		seq_printf(file, "\t %d bw20:%d bw40:%d\n",
-			   i, dev->ee->tx_pwr_cfg_2g[i][0],
-			      dev->ee->tx_pwr_cfg_5g[i][1]);
-
-	seq_puts(file, "Per rate power 5GHz:\n");
-	for (i = 0; i < 5; i++)
-		seq_printf(file, "\t %d bw20:%d bw40:%d\n",
-			   i, dev->ee->tx_pwr_cfg_5g[i][0],
-			      dev->ee->tx_pwr_cfg_5g[i][1]);
-
 	return 0;
 }
 
@@ -147,6 +134,23 @@ static const struct file_operations fops_eeprom_param = {
 	.release = single_release,
 };
 
+static int mt76x0_read_txpower(struct seq_file *file, void *data)
+{
+	struct mt76x0_dev *dev = dev_get_drvdata(file->private);
+
+	mt76_seq_puts_array(file, "CCK", dev->caldata.rate_power.cck,
+			    ARRAY_SIZE(dev->caldata.rate_power.cck));
+	mt76_seq_puts_array(file, "OFDM", dev->caldata.rate_power.ofdm,
+			    ARRAY_SIZE(dev->caldata.rate_power.ofdm));
+	mt76_seq_puts_array(file, "STBC", dev->caldata.rate_power.stbc,
+			    ARRAY_SIZE(dev->caldata.rate_power.stbc));
+	mt76_seq_puts_array(file, "HT", dev->caldata.rate_power.ht,
+			    ARRAY_SIZE(dev->caldata.rate_power.ht));
+	mt76_seq_puts_array(file, "VHT", dev->caldata.rate_power.vht,
+			    ARRAY_SIZE(dev->caldata.rate_power.vht));
+	return 0;
+}
+
 void mt76x0_init_debugfs(struct mt76x0_dev *dev)
 {
 	struct dentry *dir;
@@ -161,4 +165,6 @@ void mt76x0_init_debugfs(struct mt76x0_dev *dev)
 	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
 	debugfs_create_file("eeprom_param", S_IRUSR, dir, dev,
 			    &fops_eeprom_param);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
+				    mt76x0_read_txpower);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index f9d917a7f3f5..1406e88141de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -125,82 +125,103 @@ void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
 	}
 }
 
-static u32
-calc_bw40_power_rate(u32 value, int delta)
+static s8 mt76x0_get_power_rate(u8 val, s8 delta)
 {
-	u32 ret = 0;
-	int i, tmp;
-
-	for (i = 0; i < 4; i++) {
-		tmp = s6_to_int((value >> i*8) & 0xff) + delta;
-		ret |= (u32)(int_to_s6(tmp)) << i*8;
-	}
-
-	return ret;
+	return s6_to_s8(val) + delta;
 }
 
-static s8
-get_delta(u8 val)
+static s8 mt76x0_get_delta(struct mt76_dev *dev,
+			   struct cfg80211_chan_def *chandef)
 {
+	u8 val;
 	s8 ret;
 
+	if (mt76x02_tssi_enabled(dev))
+		return 0;
+
+	if (chandef->width == NL80211_CHAN_WIDTH_80) {
+		val = mt76x02_eeprom_get(dev, MT_EE_5G_TARGET_POWER) >> 8;
+	} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+		u16 data;
+
+		data = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
+		if (chandef->chan->band == NL80211_BAND_5GHZ)
+			val = data >> 8;
+		else
+			val = data;
+	} else {
+		return 0;
+	}
+
 	if (!mt76x02_field_valid(val) || !(val & BIT(7)))
 		return 0;
 
 	ret = val & 0x1f;
 	if (ret > 8)
-		ret = 8;
-	if (val & BIT(6))
-		ret = -ret;
+		return 8;
 
-	return ret;
+	return (val & BIT(6)) ? -ret : ret;
 }
 
-static void
-mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev, u8 *eeprom)
+void mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev,
+				  struct cfg80211_chan_def *chandef)
 {
-	s8 bw40_delta_2g, bw40_delta_5g;
-	u32 val;
-	int i;
-
-	bw40_delta_2g = get_delta(eeprom[MT_EE_TX_POWER_DELTA_BW40]);
-	bw40_delta_5g = get_delta(eeprom[MT_EE_TX_POWER_DELTA_BW40 + 1]);
-
-	for (i = 0; i < 5; i++) {
-		val = get_unaligned_le32(eeprom + MT_EE_TX_POWER_BYRATE(i));
-
-		/* Skip last 16 bits. */
-		if (i == 4)
-			val &= 0x0000ffff;
-
-		dev->ee->tx_pwr_cfg_2g[i][0] = val;
-		dev->ee->tx_pwr_cfg_2g[i][1] = calc_bw40_power_rate(val, bw40_delta_2g);
-	}
-
-	/* Reading per rate tx power for 5 GHz band is a bit more complex. Note
-	 * we mix 16 bit and 32 bit reads and sometimes do shifts.
-	 */
-	val = get_unaligned_le16(eeprom + 0x120);
-	val <<= 16;
-	dev->ee->tx_pwr_cfg_5g[0][0] = val;
-	dev->ee->tx_pwr_cfg_5g[0][1] = calc_bw40_power_rate(val, bw40_delta_5g);
-
-	val = get_unaligned_le32(eeprom + 0x122);
-	dev->ee->tx_pwr_cfg_5g[1][0] = val;
-	dev->ee->tx_pwr_cfg_5g[1][1] = calc_bw40_power_rate(val, bw40_delta_5g);
-
-	val = get_unaligned_le16(eeprom + 0x126);
-	dev->ee->tx_pwr_cfg_5g[2][0] = val;
-	dev->ee->tx_pwr_cfg_5g[2][1] = calc_bw40_power_rate(val, bw40_delta_5g);
-
-	val = get_unaligned_le16(eeprom + 0xec);
-	val <<= 16;
-	dev->ee->tx_pwr_cfg_5g[3][0] = val;
-	dev->ee->tx_pwr_cfg_5g[3][1] = calc_bw40_power_rate(val, bw40_delta_5g);
-
-	val = get_unaligned_le16(eeprom + 0xee);
-	dev->ee->tx_pwr_cfg_5g[4][0] = val;
-	dev->ee->tx_pwr_cfg_5g[4][1] = calc_bw40_power_rate(val, bw40_delta_5g);
+	bool is_2ghz = chandef->chan->band == NL80211_BAND_2GHZ;
+	s8 data, delta = mt76x0_get_delta(&dev->mt76, chandef);
+	struct mt76_rate_power *t = &dev->caldata.rate_power;
+	struct mt76_dev *mdev = &dev->mt76;
+	u16 val, addr;
+
+	memset(t, 0, sizeof(*t));
+
+	/* cck 1M, 2M, 5.5M, 11M */
+	val = mt76x02_eeprom_get(mdev, MT_EE_TX_POWER_BYRATE_BASE);
+	t->cck[0] = t->cck[1] = mt76x0_get_power_rate(val, delta);
+	t->cck[2] = t->cck[3] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* ofdm 6M, 9M, 12M, 18M */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 2 : 0x120;
+	val = mt76x02_eeprom_get(mdev, addr);
+	t->ofdm[0] = t->ofdm[1] = mt76x0_get_power_rate(val, delta);
+	t->ofdm[2] = t->ofdm[3] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* ofdm 24M, 36M, 48M, 54M */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 4 : 0x122;
+	val = mt76x02_eeprom_get(mdev, addr);
+	t->ofdm[4] = t->ofdm[5] = mt76x0_get_power_rate(val, delta);
+	t->ofdm[6] = t->ofdm[7] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* ht-vht mcs 1ss 0, 1, 2, 3 */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 6 : 0x124;
+	val = mt76x02_eeprom_get(mdev, addr);
+	data = mt76x0_get_power_rate(val, delta);
+	t->ht[0] = t->ht[1] = t->vht[0] = t->vht[1] = data;
+	data = mt76x0_get_power_rate(val >> 8, delta);
+	t->ht[2] = t->ht[3] = t->vht[2] = t->vht[3] = data;
+
+	/* ht-vht mcs 1ss 4, 5, 6 */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 8 : 0x126;
+	val = mt76x02_eeprom_get(mdev, addr);
+	data = mt76x0_get_power_rate(val, delta);
+	t->ht[4] = t->ht[5] = t->vht[4] = t->vht[5] = data;
+	t->ht[6] = t->vht[6] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* ht-vht mcs 1ss 0, 1, 2, 3 stbc */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 14 : 0xec;
+	val = mt76x02_eeprom_get(mdev, addr);
+	t->stbc[0] = t->stbc[1] = mt76x0_get_power_rate(val, delta);
+	t->stbc[2] = t->stbc[3] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* ht-vht mcs 1ss 4, 5, 6 stbc */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 16 : 0xee;
+	val = mt76x02_eeprom_get(mdev, addr);
+	t->stbc[4] = t->stbc[5] = mt76x0_get_power_rate(val, delta);
+	t->stbc[6] = t->stbc[7] = mt76x0_get_power_rate(val >> 8, delta);
+
+	/* vht mcs 8, 9 5GHz */
+	val = mt76x02_eeprom_get(mdev, 0x132);
+	t->vht[7] = mt76x0_get_power_rate(val, delta);
+	t->vht[8] = mt76x0_get_power_rate(val >> 8, delta);
 }
 
 static void
@@ -271,7 +292,6 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x0_set_temp_offset(dev);
 	dev->chainmask = 0x0101;
 
-	mt76x0_set_tx_power_per_rate(dev, eeprom);
 	mt76x0_set_tx_power_per_chan(dev, eeprom);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 8006d08cba45..88e31186c317 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -34,34 +34,27 @@ struct mt76x0_caldata {
 
 	s16 temp_offset;
 	u8 freq_offset;
+
+	struct mt76_rate_power rate_power;
 };
 
 struct mt76x0_eeprom_params {
-	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
-	u32 tx_pwr_cfg_2g[5][2];
-	u32 tx_pwr_cfg_5g[5][2];
 
 	u8 tx_pwr_per_chan[58];
 };
 
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
+void mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev,
+				  struct cfg80211_chan_def *chandef);
 
-static inline u32 s6_validate(u32 reg)
+static inline s8 s6_to_s8(u32 val)
 {
-	WARN_ON(reg & ~GENMASK(5, 0));
-	return reg & GENMASK(5, 0);
-}
-
-static inline int s6_to_int(u32 reg)
-{
-	int s6;
-
-	s6 = s6_validate(reg);
-	if (s6 & BIT(5))
-		s6 -= BIT(6);
+	s8 ret = val & GENMASK(5, 0);
 
-	return s6;
+	if (ret & BIT(5))
+		ret -= BIT(6);
+	return ret;
 }
 
 static inline u32 int_to_s6(int val)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index c3db4c1cd4fe..52cd39fbfd49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -566,21 +566,16 @@ mt76x0_extra_power_over_mac(struct mt76x0_dev *dev)
 }
 
 static void
-mt76x0_phy_set_tx_power(struct mt76x0_dev *dev, u8 channel, u8 rf_bw_band)
+mt76x0_phy_set_tx_power(struct mt76x0_dev *dev, u8 rf_bw_band)
 {
+	struct mt76x0_caldata *caldata = &dev->caldata;
+	int i, bw = (rf_bw_band & RF_BW_20) ? 0 : 1;
 	u32 val;
-	int i;
-	int bw = (rf_bw_band & RF_BW_20) ? 0 : 1;
 
 	for (i = 0; i < 4; i++) {
-		if (channel <= 14)
-			val = dev->ee->tx_pwr_cfg_2g[i][bw];
-		else
-			val = dev->ee->tx_pwr_cfg_5g[i][bw];
-
-		mt76_wr(dev, MT_TX_PWR_CFG_0 + 4*i, val);
+		val = caldata->tx_pwr_cfg[i][bw];
+		mt76_wr(dev, MT_TX_PWR_CFG_0 + 4 * i, val);
 	}
-
 	mt76x0_extra_power_over_mac(dev);
 }
 #endif
@@ -716,6 +711,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
 	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
+	mt76x0_set_tx_power_per_rate(dev, chandef);
 	mt76x0_read_rx_gain(dev);
 
 	/* set Japan Tx filter at channel 14 */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 9339514fb073..ca9554ac8f26 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -74,6 +74,7 @@ enum mt76x02_eeprom_field {
 
 	MT_EE_2G_TARGET_POWER =			0x0d0,
 	MT_EE_TEMP_OFFSET =			0x0d1,
+	MT_EE_5G_TARGET_POWER =			0x0d2,
 	MT_EE_TSSI_BOUND1 =			0x0d4,
 	MT_EE_TSSI_BOUND2 =			0x0d6,
 	MT_EE_TSSI_BOUND3 =			0x0d8,
@@ -121,9 +122,6 @@ enum mt76x02_eeprom_field {
 #define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
 #define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
 
-#define MT_EE_TX_POWER_BYRATE(x)		(MT_EE_TX_POWER_BYRATE_BASE + \
-						 (x) * 4)
-
 #define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
 						 MT_EE_USAGE_MAP_START + 1)
 
-- 
2.17.1
