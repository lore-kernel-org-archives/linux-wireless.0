Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35155 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbeIHB4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 21:56:04 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so15893626wmc.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 14:13:18 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76x0: run vco calibration for each channel configuration
Date: Fri,  7 Sep 2018 23:13:12 +0200
Message-Id: <20180907211312.17918-1-lorenzo.bianconi@redhat.com> (sfid-20180907_235838_976770_E9F6F70E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to vendor sdk, vco calibration has to be executed
for each channel configuration whereas mcu calibration has to be
performed during channel scanning. This patch fixes the mt76x0
monitor mode issue since in that configuration vco calibration
was never executed

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Tested-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 5da7bfbe907f..14e8c575f6c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -757,10 +757,10 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	/* Vendor driver don't do it */
 	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
 
+	mt76x0_vco_cal(dev, channel);
 	if (scan)
-		mt76x0_vco_cal(dev, channel);
+		mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
 
-	mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
 	mt76x0_phy_set_chan_pwr(dev, channel);
 
 	dev->mt76.chandef = *chandef;
-- 
2.18.0
