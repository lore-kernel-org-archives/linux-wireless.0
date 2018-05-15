Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47416 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752695AbeEOMd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 08:33:26 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/2] mt76: fix sending encrypted broadcast packets for secondary interfaces
Date: Tue, 15 May 2018 14:33:22 +0200
Message-Id: <20180515123323.24702-1-nbd@nbd.name> (sfid-20180515_143332_164030_E54A00DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For encryption to work properly, the BSS index needs to be initialized
for the WCID entry used for the interface.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a5d1255e4b9c..dc12bbdbb2ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -39,6 +39,9 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
+#define MT_MAX_VIFS		8
+#define MT_VIF_WCID(_n)		(254 - ((_n) & 7))
+
 #include "mt76.h"
 #include "mt76x2_regs.h"
 #include "mt76x2_mac.h"
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index dd4c1127797e..aeee0b3de136 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -296,6 +296,9 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 	for (i = 0; i < 256; i++)
 		mt76x2_mac_wcid_setup(dev, i, 0, NULL);
 
+	for (i = 0; i < MT_MAX_VIFS; i++)
+		mt76x2_mac_wcid_setup(dev, MT_VIF_WCID(i), i, NULL);
+
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
 			mt76x2_mac_shared_key_setup(dev, i, k, NULL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 81c58f865c64..5c0d1e1260fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -104,7 +104,7 @@ mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		idx += 8;
 
 	mvif->idx = idx;
-	mvif->group_wcid.idx = 254 - idx;
+	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
 	mt76x2_txq_init(dev, vif->txq);
 
-- 
2.17.0
