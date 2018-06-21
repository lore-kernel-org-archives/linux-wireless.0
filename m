Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55500 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932887AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/9] mt76: adjust AGC control register 26 based on gain for VHT80
Date: Thu, 21 Jun 2018 11:17:56 +0200
Message-Id: <20180621091801.41184-4-nbd@nbd.name> (sfid-20180621_111816_402528_3DA569AD)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use values based on the vendor driver

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index a510f116d52a..a2c3f0e35f86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -525,10 +525,17 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 
 	dev->cal.low_gain = low_gain;
 
-	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
+	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80) {
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560211);
-	else
+		val = mt76_rr(dev, MT_BBP(AGC, 26)) & ~0xf;
+		if (low_gain == 2)
+			val |= 0x3;
+		else
+			val |= 0x5;
+		mt76_wr(dev, MT_BBP(AGC, 26), val);
+	} else {
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
+	}
 
 	if (low_gain == 2) {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
-- 
2.17.0
