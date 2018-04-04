Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34997 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeDDIim (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 04:38:42 -0400
Received: by mail-wm0-f68.google.com with SMTP id r82so40491350wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2018 01:38:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: set default values in TX_ALC_CFG_{1,2} for tempetaure compensation
Date: Wed,  4 Apr 2018 10:38:32 +0200
Message-Id: <cca4a0d4fbe58e6ecf0f05b953b2df11e30e75b1.1522830473.git.lorenzo.bianconi@redhat.com> (sfid-20180404_103847_155386_4AED4551)
In-Reply-To: <cover.1522830473.git.lorenzo.bianconi@redhat.com>
References: <cover.1522830473.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize default values for temperature compensation in TX_ALC_CFG_{1,2}
if tssi has been enabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 42414c5fa01e..daecc7ea900a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -660,6 +660,14 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 	memcpy(dev->cal.agc_gain_cur, dev->cal.agc_gain_init,
 	       sizeof(dev->cal.agc_gain_cur));
 
+	/* init default values for temp compensation */
+	if (mt76x2_tssi_enabled(dev)) {
+		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
+			       0x38);
+		mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
+			       0x38);
+	}
+
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 
-- 
2.14.3
