Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55504 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932534AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 6/9] mt76: fix variable gain adjustment range
Date: Thu, 21 Jun 2018 11:17:58 +0200
Message-Id: <20180621091801.41184-6-nbd@nbd.name> (sfid-20180621_111810_530171_B5868441)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The range should only be limited to 4 for really weak signals, for all
other gain settings the range is 16.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 51fd7ddfa8f5..9c7b19ce73f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -485,7 +485,7 @@ static void
 mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
 {
 	u32 false_cca;
-	u8 limit = dev->cal.low_gain > 1 ? 4 : 16;
+	u8 limit = dev->cal.low_gain > 0 ? 16 : 4;
 
 	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS, mt76_rr(dev, MT_RX_STAT_1));
 	if (false_cca > 800 && dev->cal.agc_gain_adjust < limit)
-- 
2.17.0
