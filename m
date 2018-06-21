Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55520 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932898AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 9/9] mt76: improve gain adjustment in noisy environments
Date: Thu, 21 Jun 2018 11:18:01 +0200
Message-Id: <20180621091801.41184-9-nbd@nbd.name> (sfid-20180621_111821_155971_2B1281BC)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When switching between low gain (high RSSI) and high gain settings, it
can take a few seconds to adjust to the current environment.
This can lead to short periods of time with extreme packet loss.

When switching from low_gain=1 to low_gain=2, start with the same gain
adjustment value instead of the lowest to avoid spikes of huge numbers
of false CCA events

Also avoid resetting adjustment values on switching between low_gain
values 0 and 1, since it affects only the upper limit of vga adjustment

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 14aedc3ef731..20ffa6a40d39 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -491,7 +491,8 @@ mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
 	dev->cal.false_cca = false_cca;
 	if (false_cca > 800 && dev->cal.agc_gain_adjust < limit)
 		dev->cal.agc_gain_adjust += 2;
-	else if (false_cca < 10 && dev->cal.agc_gain_adjust > 0)
+	else if ((false_cca < 10 && dev->cal.agc_gain_adjust > 0) ||
+		 (dev->cal.agc_gain_adjust >= limit && false_cca < 500))
 		dev->cal.agc_gain_adjust -= 2;
 	else
 		return;
@@ -550,7 +551,8 @@ static void
 mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 {
 	u8 *gain = dev->cal.agc_gain_init;
-	u8 gain_delta;
+	u8 low_gain_delta, gain_delta;
+	bool gain_change;
 	int low_gain;
 	u32 val;
 
@@ -559,13 +561,14 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	low_gain = (dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x2_get_low_rssi_gain_thresh(dev));
 
-	if (dev->cal.low_gain == low_gain) {
+	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
+	dev->cal.low_gain = low_gain;
+
+	if (!gain_change) {
 		mt76x2_phy_adjust_vga_gain(dev);
 		return;
 	}
 
-	dev->cal.low_gain = low_gain;
-
 	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80) {
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560211);
 		val = mt76_rr(dev, MT_BBP(AGC, 26)) & ~0xf;
@@ -578,14 +581,17 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
 	}
 
+	if (mt76x2_has_ext_lna(dev))
+		low_gain_delta = 10;
+	else
+		low_gain_delta = 14;
+
 	if (low_gain == 2) {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
 		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
 		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
-		if (mt76x2_has_ext_lna(dev))
-			gain_delta = 10;
-		else
-			gain_delta = 14;
+		gain_delta = low_gain_delta;
+		dev->cal.agc_gain_adjust = 0;
 	} else {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
 		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
@@ -594,11 +600,11 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 			mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
 		mt76_wr(dev, MT_BBP(AGC, 37), 0x2121262C);
 		gain_delta = 0;
+		dev->cal.agc_gain_adjust = low_gain_delta;
 	}
 
 	dev->cal.agc_gain_cur[0] = gain[0] - gain_delta;
 	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
-	dev->cal.agc_gain_adjust = 0;
 	mt76x2_phy_set_gain_val(dev);
 
 	/* clear false CCA counters */
-- 
2.17.0
