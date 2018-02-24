Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38109 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbeBXPye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 10:54:34 -0500
Received: by mail-wm0-f67.google.com with SMTP id z9so9742995wmb.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Feb 2018 07:54:33 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x2: add mac80211 {set,get}_antenna callbacks
Date: Sat, 24 Feb 2018 16:54:14 +0100
Message-Id: <20180224155414.31063-4-lorenzo.bianconi@redhat.com> (sfid-20180224_165445_173373_F6141E88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add capability to select tx/rx antennas. Possible values are:
 - 1: to use only the first antenna
 - 2: to use only the second antenna
 - 3: to use both of them

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    |  9 ++++
 drivers/net/wireless/mediatek/mt76/mt76.h        |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 36 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c  | 55 +++++++++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h |  2 +
 6 files changed, 88 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index a2a382a13466..4f30cdcd2b53 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -156,6 +156,15 @@ static void mt76_init_stream_cap(struct mt76_dev *dev,
 	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
 }
 
+void mt76_set_stream_caps(struct mt76_dev *dev, bool vht)
+{
+	if (dev->cap.has_2ghz)
+		mt76_init_stream_cap(dev, &dev->sband_2g.sband, false);
+	if (dev->cap.has_5ghz)
+		mt76_init_stream_cap(dev, &dev->sband_5g.sband, vht);
+}
+EXPORT_SYMBOL_GPL(mt76_set_stream_caps);
+
 static int
 mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
 		const struct ieee80211_channel *chan, int n_chan,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 15009d5b0531..065ff78059c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -425,6 +425,7 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 void mt76_set_channel(struct mt76_dev *dev);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
+void mt76_set_stream_caps(struct mt76_dev *dev, bool vht);
 
 int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
 		       u16 ssn, u8 size);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index e62131b88102..783b8122ec3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -180,6 +180,7 @@ int mt76x2_eeprom_init(struct mt76x2_dev *dev);
 int mt76x2_apply_calibration_data(struct mt76x2_dev *dev, int channel);
 void mt76x2_set_tx_ackto(struct mt76x2_dev *dev);
 
+void mt76x2_phy_set_antenna(struct mt76x2_dev *dev);
 int mt76x2_phy_start(struct mt76x2_dev *dev);
 int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 			 struct cfg80211_chan_def *chandef);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 205043b470b2..25f4cebef26d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -549,6 +549,40 @@ mt76x2_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 	return 0;
 }
 
+static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
+			      u32 rx_ant)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	if (!tx_ant || tx_ant > 3 || tx_ant != rx_ant)
+		return -EINVAL;
+
+	mutex_lock(&dev->mutex);
+
+	dev->chainmask = (tx_ant == 3) ? 0x202 : 0x101;
+	dev->mt76.antenna_mask = tx_ant;
+
+	mt76_set_stream_caps(&dev->mt76, true);
+	mt76x2_phy_set_antenna(dev);
+
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+
+static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
+			      u32 *rx_ant)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+	*tx_ant = dev->mt76.antenna_mask;
+	*rx_ant = dev->mt76.antenna_mask;
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+
 const struct ieee80211_ops mt76x2_ops = {
 	.tx = mt76x2_tx,
 	.start = mt76x2_start,
@@ -573,5 +607,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.set_coverage_class = mt76x2_set_coverage_class,
 	.get_survey = mt76_get_survey,
 	.set_tim = mt76x2_set_tim,
+	.set_antenna = mt76x2_set_antenna,
+	.get_antenna = mt76x2_get_antenna,
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 5b742749d5de..fcc37eb7ce0b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -361,29 +361,52 @@ mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
 		       primary_upper);
 }
 
-static void
-mt76x2_set_rx_chains(struct mt76x2_dev *dev)
+void mt76x2_phy_set_antenna(struct mt76x2_dev *dev)
 {
 	u32 val;
 
 	val = mt76_rr(dev, MT_BBP(AGC, 0));
-	val &= ~(BIT(3) | BIT(4));
+	val &= ~(BIT(4) | BIT(1));
+	switch (dev->mt76.antenna_mask) {
+	case 1:
+		/* disable mac DAC control */
+		mt76_clear(dev, MT_BBP(IBI, 9), BIT(11));
+		mt76_clear(dev, MT_BBP(TXBE, 5), 3);
+		mt76_rmw_field(dev, MT_TX_PIN_CFG, MT_TX_PIN_CFG_TXANT, 0x3);
+		mt76_rmw_field(dev, MT_BBP(CORE, 32), GENMASK(21, 20), 2);
+		/* disable DAC 1 */
+		mt76_rmw_field(dev, MT_BBP(CORE, 33), GENMASK(12, 9), 4);
 
-	if (dev->chainmask & BIT(1))
-		val |= BIT(3);
+		val &= ~(BIT(3) | BIT(0));
+		break;
+	case 2:
+		/* disable mac DAC control */
+		mt76_clear(dev, MT_BBP(IBI, 9), BIT(11));
+		mt76_rmw_field(dev, MT_BBP(TXBE, 5), 3, 1);
+		mt76_rmw_field(dev, MT_TX_PIN_CFG, MT_TX_PIN_CFG_TXANT, 0xc);
+		mt76_rmw_field(dev, MT_BBP(CORE, 32), GENMASK(21, 20), 1);
+		/* disable DAC 0 */
+		mt76_rmw_field(dev, MT_BBP(CORE, 33), GENMASK(12, 9), 1);
+
+		val &= ~BIT(3);
+		val |= BIT(0);
+		break;
+	case 3:
+	default:
+		/* enable mac DAC control */
+		mt76_set(dev, MT_BBP(IBI, 9), BIT(11));
+		mt76_set(dev, MT_BBP(TXBE, 5), 3);
+		mt76_rmw_field(dev, MT_TX_PIN_CFG, MT_TX_PIN_CFG_TXANT, 0xf);
+		mt76_clear(dev, MT_BBP(CORE, 32), GENMASK(21, 20));
+		mt76_clear(dev, MT_BBP(CORE, 33), GENMASK(12, 9));
 
+		val &= ~BIT(0);
+		val |= BIT(3);
+		break;
+	}
 	mt76_wr(dev, MT_BBP(AGC, 0), val);
 }
 
-static void
-mt76x2_set_tx_dac(struct mt76x2_dev *dev)
-{
-	if (dev->chainmask & BIT(1))
-		mt76_set(dev, MT_BBP(TXBE, 5), 3);
-	else
-		mt76_clear(dev, MT_BBP(TXBE, 5), 3);
-}
-
 static void
 mt76x2_get_agc_gain(struct mt76x2_dev *dev, u8 *dest)
 {
@@ -585,10 +608,8 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 	mt76x2_configure_tx_delay(dev, band, bw);
 	mt76x2_phy_set_txpower(dev);
 
-	mt76x2_set_rx_chains(dev);
 	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
 	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
-	mt76x2_set_tx_dac(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
@@ -604,6 +625,8 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 
 	mt76x2_mcu_init_gain(dev, channel, dev->cal.rx.mcu_gain, true);
 
+	mt76x2_phy_set_antenna(dev);
+
 	/* Enable LDPC Rx */
 	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
 		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
index ce3ab85c8b0f..b9c334d9e5b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
@@ -321,6 +321,8 @@
 #define MT_TX_PWR_CFG_2			0x131c
 #define MT_TX_PWR_CFG_3			0x1320
 #define MT_TX_PWR_CFG_4			0x1324
+#define MT_TX_PIN_CFG			0x1328
+#define MT_TX_PIN_CFG_TXANT		GENMASK(3, 0)
 
 #define MT_TX_BAND_CFG			0x132c
 #define MT_TX_BAND_CFG_UPPER_40M	BIT(0)
-- 
2.16.2
