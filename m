Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53706 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbeIVRjN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id b19-v6so5436863wme.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
Date: Sat, 22 Sep 2018 13:45:34 +0200
Message-Id: <20180922114537.24004-7-lorenzo.bianconi@redhat.com> (sfid-20180922_134905_283519_E4E01B1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to unify eeprom parsing between mt76x0 and mt76x2 drivers,
remove eeprom pointer dependency from mt76x0_set_tx_power_per_rate.
Moreover use mt76_rate_power to store power vs rate calibration data.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |  32 ++--
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 142 +++++++++---------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  32 +---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |   3 +-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   4 +-
 5 files changed, 102 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 39c2c846f808..eb7e0db61e56 100644
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
+	mt76_seq_puts_array(file, "CCK", dev->mt76.rate_power.cck,
+			    ARRAY_SIZE(dev->mt76.rate_power.cck));
+	mt76_seq_puts_array(file, "OFDM", dev->mt76.rate_power.ofdm,
+			    ARRAY_SIZE(dev->mt76.rate_power.ofdm));
+	mt76_seq_puts_array(file, "STBC", dev->mt76.rate_power.stbc,
+			    ARRAY_SIZE(dev->mt76.rate_power.stbc));
+	mt76_seq_puts_array(file, "HT", dev->mt76.rate_power.ht,
+			    ARRAY_SIZE(dev->mt76.rate_power.ht));
+	mt76_seq_puts_array(file, "VHT", dev->mt76.rate_power.vht,
+			    ARRAY_SIZE(dev->mt76.rate_power.vht));
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
index f9d917a7f3f5..22837d7191d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -20,6 +20,7 @@
 #include <asm/unaligned.h>
 #include "mt76x0.h"
 #include "eeprom.h"
+#include "../mt76x02_phy.h"
 
 #define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
 static int
@@ -125,82 +126,88 @@ void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
 	}
 }
 
-static u32
-calc_bw40_power_rate(u32 value, int delta)
+static s8 mt76x0_get_delta(struct mt76_dev *dev)
 {
-	u32 ret = 0;
-	int i, tmp;
-
-	for (i = 0; i < 4; i++) {
-		tmp = s6_to_int((value >> i*8) & 0xff) + delta;
-		ret |= (u32)(int_to_s6(tmp)) << i*8;
-	}
+	struct cfg80211_chan_def *chandef = &dev->chandef;
+	u8 val;
 
-	return ret;
-}
+	if (mt76x02_tssi_enabled(dev))
+		return 0;
 
-static s8
-get_delta(u8 val)
-{
-	s8 ret;
+	if (chandef->width == NL80211_CHAN_WIDTH_80) {
+		val = mt76x02_eeprom_get(dev, MT_EE_5G_TARGET_POWER) >> 8;
+	} else if (chandef->width == NL80211_CHAN_WIDTH_40) {
+		u16 data;
 
-	if (!mt76x02_field_valid(val) || !(val & BIT(7)))
+		data = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
+		if (chandef->chan->band == NL80211_BAND_5GHZ)
+			val = data >> 8;
+		else
+			val = data;
+	} else {
 		return 0;
+	}
 
-	ret = val & 0x1f;
-	if (ret > 8)
-		ret = 8;
-	if (val & BIT(6))
-		ret = -ret;
-
-	return ret;
+	return mt76x02_rate_power_val(val);
 }
 
-static void
-mt76x0_set_tx_power_per_rate(struct mt76x0_dev *dev, u8 *eeprom)
+void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev)
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
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	bool is_2ghz = chan->band == NL80211_BAND_2GHZ;
+	struct mt76_rate_power *t = &dev->mt76.rate_power;
+	s8 delta = mt76x0_get_delta(&dev->mt76);
+	u16 val, addr;
+
+	memset(t, 0, sizeof(*t));
+
+	/* cck 1M, 2M, 5.5M, 11M */
+	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_TX_POWER_BYRATE_BASE);
+	t->cck[0] = t->cck[1] = s6_to_s8(val);
+	t->cck[2] = t->cck[3] = s6_to_s8(val >> 8);
+
+	/* ofdm 6M, 9M, 12M, 18M */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 2 : 0x120;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->ofdm[0] = t->ofdm[1] = s6_to_s8(val);
+	t->ofdm[2] = t->ofdm[3] = s6_to_s8(val >> 8);
+
+	/* ofdm 24M, 36M, 48M, 54M */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 4 : 0x122;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->ofdm[4] = t->ofdm[5] = s6_to_s8(val);
+	t->ofdm[6] = t->ofdm[7] = s6_to_s8(val >> 8);
+
+	/* ht-vht mcs 1ss 0, 1, 2, 3 */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 6 : 0x124;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->ht[0] = t->ht[1] = t->vht[0] = t->vht[1] = s6_to_s8(val);
+	t->ht[2] = t->ht[3] = t->vht[2] = t->vht[3] = s6_to_s8(val >> 8);
+
+	/* ht-vht mcs 1ss 4, 5, 6 */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 8 : 0x126;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->ht[4] = t->ht[5] = t->vht[4] = t->vht[5] = s6_to_s8(val);
+	t->ht[6] = t->vht[6] = s6_to_s8(val >> 8);
+
+	/* ht-vht mcs 1ss 0, 1, 2, 3 stbc */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 14 : 0xec;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->stbc[0] = t->stbc[1] = s6_to_s8(val);
+	t->stbc[2] = t->stbc[3] = s6_to_s8(val >> 8);
+
+	/* ht-vht mcs 1ss 4, 5, 6 stbc */
+	addr = is_2ghz ? MT_EE_TX_POWER_BYRATE_BASE + 16 : 0xee;
+	val = mt76x02_eeprom_get(&dev->mt76, addr);
+	t->stbc[4] = t->stbc[5] = s6_to_s8(val);
+	t->stbc[6] = t->stbc[7] = s6_to_s8(val >> 8);
+
+	/* vht mcs 8, 9 5GHz */
+	val = mt76x02_eeprom_get(&dev->mt76, 0x132);
+	t->vht[7] = s6_to_s8(val);
+	t->vht[8] = s6_to_s8(val >> 8);
+
+	mt76x02_add_rate_power_offset(t, delta);
 }
 
 static void
@@ -271,7 +278,6 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	mt76x0_set_temp_offset(dev);
 	dev->chainmask = 0x0101;
 
-	mt76x0_set_tx_power_per_rate(dev, eeprom);
 	mt76x0_set_tx_power_per_chan(dev, eeprom);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 8006d08cba45..d556ee37fa14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -37,41 +37,21 @@ struct mt76x0_caldata {
 };
 
 struct mt76x0_eeprom_params {
-	/* TX_PWR_CFG_* values from EEPROM for 20 and 40 Mhz bandwidths. */
-	u32 tx_pwr_cfg_2g[5][2];
-	u32 tx_pwr_cfg_5g[5][2];
 
 	u8 tx_pwr_per_chan[58];
 };
 
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
+void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev);
 
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
-
-	return s6;
-}
-
-static inline u32 int_to_s6(int val)
-{
-	if (val < -0x20)
-		return 0x20;
-	if (val > 0x1f)
-		return 0x1f;
+	s8 ret = val & GENMASK(5, 0);
 
-	return val & 0x3f;
+	if (ret & BIT(5))
+		ret -= BIT(6);
+	return ret;
 }
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 99446fc4503e..dea68f5d91f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -641,6 +641,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	freq1 = chandef->center_freq1;
 	channel = chandef->chan->hw_value;
 	rf_bw_band = (channel <= 14) ? RF_G_BAND : RF_A_BAND;
+	dev->mt76.chandef = *chandef;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_40:
@@ -678,6 +679,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
 	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
+	mt76x0_get_tx_power_per_rate(dev);
 	mt76x0_read_rx_gain(dev);
 
 	/* set Japan Tx filter at channel 14 */
@@ -699,7 +701,6 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 
 	mt76x0_phy_set_chan_pwr(dev, channel);
 
-	dev->mt76.chandef = *chandef;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index c3d8920a8127..b45e2afeadd0 100644
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
2.18.0
