Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53076 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbeDCUaZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 16:30:25 -0400
Received: by mail-wm0-f68.google.com with SMTP id g8so12282107wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 13:30:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
Date: Tue,  3 Apr 2018 22:30:19 +0200
Message-Id: <20180403203019.8988-1-lorenzo.bianconi@redhat.com> (sfid-20180403_223237_768337_443161EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary MT_TX_ALC_CFG_4 configuration since the register value
will be properly set according to the usage of an external power amplifier

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- remove first initialization in order to have the writes to that register
  grouped together in the same if/else chunk
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index f28c55746cea..42414c5fa01e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -257,7 +257,6 @@ mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev, enum nl80211_band band)
 			mt76_wr(dev, MT_TX_ALC_CFG_2, 0x1b0f0400);
 			mt76_wr(dev, MT_TX_ALC_CFG_3, 0x1b0f0476);
 		}
-		mt76_wr(dev, MT_TX_ALC_CFG_4, 0);
 
 		if (mt76x2_ext_pa_enabled(dev, band))
 			pa_mode_adj = 0x04000000;
-- 
2.16.3
