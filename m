Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36571 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeEOKId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 06:08:33 -0400
Received: by mail-wr0-f196.google.com with SMTP id p4-v6so15384130wrh.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 03:08:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, luca.bisti@gmail.com,
        gaetano.catalli@gmail.com
Subject: [PATCH] mt76x2: apply coverage class on slot time too
Date: Tue, 15 May 2018 12:08:14 +0200
Message-Id: <20180515100814.491-1-lorenzo.bianconi@redhat.com> (sfid-20180515_120837_453949_F1CCCADF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2007 17.3.8.6 (slot time), the slot time should
be increased by 3 us * coverage class. Taking into account coverage
class in slot time configuration allows to increase by an order of
magnitude the throughput on a 4Km link in a noisy environment

Tested-by: Luca Bisti <luca.bisti@gmail.com>
Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index d21e4a7c1bb9..9eeb1d7631c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -482,7 +482,10 @@ void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
 {
 	u8 ackto, sifs, slottime = dev->slottime;
 
+	/* As defined by IEEE 802.11-2007 17.3.8.6 */
 	slottime += 3 * dev->coverage_class;
+	mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
+		       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
 
 	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
 			      MT_XIFS_TIME_CFG_OFDM_SIFS);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 81c58f865c64..539dda8a59e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -247,8 +247,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		int slottime = info->use_short_slot ? 9 : 20;
 
 		dev->slottime = slottime;
-		mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
-			       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
+		mt76x2_set_tx_ackto(dev);
 	}
 
 	mutex_unlock(&dev->mutex);
-- 
2.16.3
