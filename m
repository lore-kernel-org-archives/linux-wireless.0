Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45558 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753344AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 14/14] mt76x2: init: fix rx filter default value during init
Date: Thu, 14 Dec 2017 16:39:18 +0100
Message-Id: <20171214153918.43774-15-nbd@nbd.name> (sfid-20171214_163937_971656_B434E0B4)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

mt76x2_mac_start writes dev->rxfilter to the hardware. It also happens
during init, before dev->rxfilter is filled with the initval register
value, leading to issues like promisc mode being enabled
unconditionally.

Fix this by reading the default value into dev->rxfilter earlier

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index ad17f9462358..62d702164dfe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -583,6 +583,8 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 	if (ret)
 		return ret;
 
+	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+
 	ret = mt76x2_dma_init(dev);
 	if (ret)
 		return ret;
@@ -597,7 +599,6 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 		return ret;
 
 	mt76x2_mac_stop(dev, false);
-	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	return 0;
 }
-- 
2.14.2
