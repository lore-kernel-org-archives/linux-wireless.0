Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51576 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbeDCOpj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 10:45:39 -0400
Received: by mail-wm0-f65.google.com with SMTP id v21so34377522wmc.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 07:45:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix tssi initialization for 5GHz band
Date: Tue,  3 Apr 2018 16:45:31 +0200
Message-Id: <53d9322f1b5cafb832163b8ef93118aecc1ef3f1.1522766285.git.lorenzo.bianconi@redhat.com> (sfid-20180403_164542_827372_E0497CE3)
In-Reply-To: <cover.1522766285.git.lorenzo.bianconi@redhat.com>
References: <cover.1522766285.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix mcu initial configuration for tssi calibration on 5GHz band

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index fcc37eb7ce0b..f28c55746cea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -180,7 +180,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
 	if (mt76x2_channel_silent(dev))
 		return false;
 
-	if (chan->band == NL80211_BAND_2GHZ)
+	if (chan->band == NL80211_BAND_5GHZ)
 		flag |= BIT(0);
 
 	if (mt76x2_ext_pa_enabled(dev, chan->band))
-- 
2.14.3
