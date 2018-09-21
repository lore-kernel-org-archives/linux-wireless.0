Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34306 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbeIUTrc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 15:47:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id t15so5059427wrx.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 06:58:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix tx power configuration for VHT mcs 9
Date: Fri, 21 Sep 2018 15:57:50 +0200
Message-Id: <4e0f2495ae0d8effa82b8deae1c35b9abc0a5a2a.1537538173.git.lorenzo.bianconi@redhat.com> (sfid-20180921_155835_237486_73ECACD7)
In-Reply-To: <cover.1537538173.git.lorenzo.bianconi@redhat.com>
References: <cover.1537538173.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix tx power configuration for VHT 1SS/STBC mcs 9 since
in MT_TX_PWR_CFG_{8,9} mcs 8,9 bits are GENMASK(21,16) and
GENMASK(29,24) while GENMASK(15,6) are marked as reserved

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index 3b704a70fad1..a24243df0066 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -233,9 +233,9 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_TX_PWR_CFG_7,
 		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_8,
-		mt76x2_tx_power_mask(t.ht[14], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[8]));
 	mt76_wr(dev, MT_TX_PWR_CFG_9,
-		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
+		mt76x2_tx_power_mask(t.ht[6], 0, t.vht[8], t.vht[8]));
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
-- 
2.17.1
