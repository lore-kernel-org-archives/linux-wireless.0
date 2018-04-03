Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52329 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbeDCOwi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 10:52:38 -0400
Received: by mail-wm0-f68.google.com with SMTP id g8so10402887wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 07:52:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
Date: Tue,  3 Apr 2018 16:52:15 +0200
Message-Id: <b38ac7608bc8d7cba2a9b7178bd755fae0fc7c6b.1522766852.git.lorenzo.bianconi@redhat.com> (sfid-20180403_165249_405034_AC9111A9)
In-Reply-To: <cover.1522766852.git.lorenzo.bianconi@redhat.com>
References: <cover.1522766852.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary MT_TX_ALC_CFG_4 configuration since register value
has already set to 0 on 5GHz band

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index f28c55746cea..cbf185e9f707 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -294,7 +294,6 @@ mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev, enum nl80211_band band)
 		} else {
 			mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x383c023c);
 			mt76_wr(dev, MT_TX1_RF_GAIN_CORR, 0x24282e28);
-			mt76_wr(dev, MT_TX_ALC_CFG_4, 0);
 		}
 	}
 }
-- 
2.14.3
