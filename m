Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45566 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 12/14] mt76x2: init: disable APCLI by default
Date: Thu, 14 Dec 2017 16:39:16 +0100
Message-Id: <20171214153918.43774-13-nbd@nbd.name> (sfid-20171214_163938_520428_B68B20BE)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

It is no longer necessary for client mode operation, vif index entries
8-16 are no longer used

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 818164d1ed7a..ad17f9462358 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -307,8 +307,6 @@ int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 	for (i = 0; i < 16; i++)
 		mt76_rr(dev, MT_TX_STAT_FIFO);
 
-	mt76_set(dev, MT_MAC_APC_BSSID_H(0), MT_MAC_APC_BSSID0_H_EN);
-
 	mt76_wr(dev, MT_CH_TIME_CFG,
 		MT_CH_TIME_CFG_TIMER_EN |
 		MT_CH_TIME_CFG_TX_AS_BUSY |
-- 
2.14.2
