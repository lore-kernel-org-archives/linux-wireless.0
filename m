Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38690 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbeIVRjL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id t25-v6so5719404wmi.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] mt76x0: remove mt76x0_phy_set_tx_power and mt76x0_extra_power_over_mac
Date: Sat, 22 Sep 2018 13:45:33 +0200
Message-Id: <20180922114537.24004-6-lorenzo.bianconi@redhat.com> (sfid-20180922_134904_073895_770F5177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_extra_power_over_mac and mt76x0_phy_set_tx_power routines
since they are not actually used and tx power handling will be unified
with mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 38 -------------------
 1 file changed, 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index c3db4c1cd4fe..99446fc4503e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -547,44 +547,6 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_ban
 	}
 }
 
-#if 0
-static void
-mt76x0_extra_power_over_mac(struct mt76x0_dev *dev)
-{
-	u32 val;
-
-	val = ((mt76_rr(dev, MT_TX_PWR_CFG_1) & 0x00003f00) >> 8);
-	val |= ((mt76_rr(dev, MT_TX_PWR_CFG_2) & 0x00003f00) << 8);
-	mt76_wr(dev, MT_TX_PWR_CFG_7, val);
-
-	/* TODO: fix VHT */
-	val = ((mt76_rr(dev, MT_TX_PWR_CFG_3) & 0x0000ff00) >> 8);
-	mt76_wr(dev, MT_TX_PWR_CFG_8, val);
-
-	val = ((mt76_rr(dev, MT_TX_PWR_CFG_4) & 0x0000ff00) >> 8);
-	mt76_wr(dev, MT_TX_PWR_CFG_9, val);
-}
-
-static void
-mt76x0_phy_set_tx_power(struct mt76x0_dev *dev, u8 channel, u8 rf_bw_band)
-{
-	u32 val;
-	int i;
-	int bw = (rf_bw_band & RF_BW_20) ? 0 : 1;
-
-	for (i = 0; i < 4; i++) {
-		if (channel <= 14)
-			val = dev->ee->tx_pwr_cfg_2g[i][bw];
-		else
-			val = dev->ee->tx_pwr_cfg_5g[i][bw];
-
-		mt76_wr(dev, MT_TX_PWR_CFG_0 + 4*i, val);
-	}
-
-	mt76x0_extra_power_over_mac(dev);
-}
-#endif
-
 static void
 mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
 {
-- 
2.18.0
