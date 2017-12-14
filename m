Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45522 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753077AbdLNPjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 05/14] mt76x2: increase OFDM SIFS time
Date: Thu, 14 Dec 2017 16:39:09 +0100
Message-Id: <20171214153918.43774-6-nbd@nbd.name> (sfid-20171214_163926_068268_8991849B)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes throughput issues in combination with LDPC

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 126497172284..fe3a4b6a19cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -325,8 +325,7 @@ mt76x2_configure_tx_delay(struct mt76x2_dev *dev, enum nl80211_band band, u8 bw)
 	mt76_wr(dev, MT_TX_SW_CFG0, cfg0);
 	mt76_wr(dev, MT_TX_SW_CFG1, cfg1);
 
-	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_CCK_SIFS,
-		       13 + (bw ? 1 : 0));
+	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_OFDM_SIFS, 15);
 }
 
 static void
@@ -559,7 +558,6 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 	u8 bw, bw_index;
 	int freq, freq1;
 	int ret;
-	u8 sifs = 13;
 
 	dev->cal.channel_cal_done = false;
 	freq = chandef->chan->center_freq;
@@ -611,11 +609,6 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 		  MT_EXT_CCA_CFG_CCA_MASK),
 		 ext_cca_chan[ch_group_index]);
 
-	if (chandef->width >= NL80211_CHAN_WIDTH_40)
-		sifs++;
-
-	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_OFDM_SIFS, sifs);
-
 	ret = mt76x2_mcu_set_channel(dev, channel, bw, bw_index, scan);
 	if (ret)
 		return ret;
-- 
2.14.2
