Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49832 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbeDCTw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:52:58 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/7] mt76: rework tx power handling
Date: Tue,  3 Apr 2018 21:52:51 +0200
Message-Id: <20180403195254.87700-4-nbd@nbd.name> (sfid-20180403_215314_677544_12101E04)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a number of issues in the existing tx power handling code:

1. The EEPROM target power for chain 0 refers to the actual output power
after the channel and bandwidth delta have been added to the initial
channel gain. This means the delta values should not be added/subtracted
for the rate power calculation

2. When power is reduced significantly, the initial channel gain
underflows very quickly, while the per-rate power offsets are high.
This miscalculation causes effective tx power to be increased when it
should actually be lowered.

Fix this by trying to adjust the channel gain to the lowest power from
the rate table. In case of under- or overflow, compensate by adding an
appropriate delta to the rate power values.

This makes power configuration more accurate on a wider range of
configurable values

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 67 ++++++++++++++++---------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index fcc37eb7ce0b..2edc6b8b4e29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -73,16 +73,6 @@ int mt76x2_phy_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 	return rssi;
 }
 
-static u8
-mt76x2_txpower_check(int value)
-{
-	if (value < 0)
-		return 0;
-	if (value > 0x2f)
-		return 0x2f;
-	return value;
-}
-
 static void
 mt76x2_add_rate_power_offset(struct mt76_rate_power *r, int offset)
 {
@@ -102,6 +92,26 @@ mt76x2_limit_rate_power(struct mt76_rate_power *r, int limit)
 			r->all[i] = limit;
 }
 
+static int
+mt76x2_get_min_rate_power(struct mt76_rate_power *r)
+{
+	int i;
+	s8 ret = 0;
+
+	for (i = 0; i < sizeof(r->all); i++) {
+		if (!r->all[i])
+			continue;
+
+		if (ret)
+			ret = min(ret, r->all[i]);
+		else
+			ret = r->all[i];
+	}
+
+	return ret;
+}
+
+
 void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 {
 	enum nl80211_chan_width width = dev->mt76.chandef.width;
@@ -109,6 +119,7 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	struct mt76x2_tx_power_info txp;
 	int txp_0, txp_1, delta = 0;
 	struct mt76_rate_power t = {};
+	int base_power, gain;
 
 	mt76x2_get_power_info(dev, &txp, chan);
 
@@ -117,26 +128,32 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	else if (width == NL80211_CHAN_WIDTH_80)
 		delta = txp.delta_bw80;
 
-	if (txp.target_power > dev->txpower_conf)
-		delta -= txp.target_power - dev->txpower_conf;
-
 	mt76x2_get_rate_power(dev, &t, chan);
-	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power +
-				   txp.chain[0].delta);
+	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power);
 	mt76x2_limit_rate_power(&t, dev->txpower_conf);
 	dev->txpower_cur = mt76x2_get_max_rate_power(&t);
-	mt76x2_add_rate_power_offset(&t, -(txp.chain[0].target_power +
-					 txp.chain[0].delta + delta));
-	dev->target_power = txp.chain[0].target_power;
-	dev->target_power_delta[0] = txp.chain[0].delta + delta;
-	dev->target_power_delta[1] = txp.chain[1].delta + delta;
-	dev->rate_power = t;
 
-	txp_0 = mt76x2_txpower_check(txp.chain[0].target_power +
-				   txp.chain[0].delta + delta);
+	base_power = mt76x2_get_min_rate_power(&t);
+	delta += base_power - txp.chain[0].target_power;
+	txp_0 = txp.chain[0].target_power + txp.chain[0].delta + delta;
+	txp_1 = txp.chain[1].target_power + txp.chain[1].delta + delta;
+
+	gain = min(txp_0, txp_1);
+	if (gain < 0) {
+		base_power -= gain;
+		txp_0 -= gain;
+		txp_1 -= gain;
+	} else if (gain > 0x2f) {
+		base_power -= gain - 0x2f;
+		txp_0 = 0x2f;
+		txp_1 = 0x2f;
+	}
 
-	txp_1 = mt76x2_txpower_check(txp.chain[1].target_power +
-				   txp.chain[1].delta + delta);
+	mt76x2_add_rate_power_offset(&t, -base_power);
+	dev->target_power = txp.chain[0].target_power;
+	dev->target_power_delta[0] = txp_0 - txp.chain[0].target_power;
+	dev->target_power_delta[1] = txp_1 - txp.chain[0].target_power;
+	dev->rate_power = t;
 
 	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0, txp_0);
 	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1, txp_1);
-- 
2.14.2
