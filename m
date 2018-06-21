Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55496 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932666AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/9] mt76: fix swapped values for RXO-18 in gain control
Date: Thu, 21 Jun 2018 11:17:55 +0200
Message-Id: <20180621091801.41184-3-nbd@nbd.name> (sfid-20180621_111812_217987_CFEC1DB7)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lowest bit should be set to 0 only for strong links, not for weak
ones.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 4ed6641c3a32..a510f116d52a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -531,7 +531,7 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
 
 	if (low_gain == 2) {
-		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
+		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
 		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
 		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
 		if (mt76x2_has_ext_lna(dev))
@@ -539,7 +539,7 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 		else
 			gain_delta = 14;
 	} else {
-		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a990);
+		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
 		if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
 			mt76_wr(dev, MT_BBP(AGC, 35), 0x10101014);
 		else
-- 
2.17.0
