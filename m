Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55512 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932670AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 5/9] mt76: clear false CCA counters after changing gain settings
Date: Thu, 21 Jun 2018 11:17:57 +0200
Message-Id: <20180621091801.41184-5-nbd@nbd.name> (sfid-20180621_111814_180310_6C47F315)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They will be read on the next calibration step without gain change and
must not count earlier events

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index a2c3f0e35f86..51fd7ddfa8f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -559,6 +559,9 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	dev->cal.agc_gain_cur[1] = gain[1] - gain_delta;
 	dev->cal.agc_gain_adjust = 0;
 	mt76x2_phy_set_gain_val(dev);
+
+	/* clear false CCA counters */
+	mt76_rr(dev, MT_RX_STAT_1);
 }
 
 int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
-- 
2.17.0
