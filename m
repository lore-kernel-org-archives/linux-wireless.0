Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55524 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932902AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/9] mt76: fix threshold for gain adjustment
Date: Thu, 21 Jun 2018 11:17:54 +0200
Message-Id: <20180621091801.41184-2-nbd@nbd.name> (sfid-20180621_111817_850481_A84E1642)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The gain should be reduced only for very strong connections, not for mid
range.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index c1c38ca3330a..4ed6641c3a32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -530,7 +530,7 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	else
 		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
 
-	if (low_gain) {
+	if (low_gain == 2) {
 		mt76_wr(dev, MT_BBP(RXO, 18), 0xf000a991);
 		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
 		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
-- 
2.17.0
