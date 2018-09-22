Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53709 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbeIVRjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id b19-v6so5436937wme.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:57 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] mt76x0: phy: introduce mt76x0_phy_set_txpower routine
Date: Sat, 22 Sep 2018 13:45:37 +0200
Message-Id: <20180922114537.24004-10-lorenzo.bianconi@redhat.com> (sfid-20180922_134907_614896_58347834)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x0_phy_set_txpower routine in order to configure
base and per rate tx power gain. Moreover take into account
txpower_conf in order to limit the tx power gain according to
the bound provided by mac80211

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  7 +++++++
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 19 ++++++++++++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index c84e00abfac9..66e12802953c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -66,6 +66,13 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 		ieee80211_wake_queues(hw);
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		dev->mt76.txpower_conf = hw->conf.power_level * 2;
+
+		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+			mt76x0_phy_set_txpower(dev);
+	}
+
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index e0b349c921b1..7e131241344b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -147,6 +147,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev);
 int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi);
 void mt76x0_phy_con_cal_onoff(struct mt76x0_dev *dev,
 			       struct ieee80211_bss_conf *info);
+void mt76x0_phy_set_txpower(struct mt76x0_dev *dev);
 
 /* MAC */
 void mt76x0_mac_work(struct work_struct *work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 9c9c55cc05e9..d11fcf6c8967 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -21,6 +21,7 @@
 #include "phy.h"
 #include "initvals.h"
 #include "initvals_phy.h"
+#include "../mt76x02_phy.h"
 
 #include <linux/etherdevice.h>
 
@@ -578,15 +579,20 @@ mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
 	mt76x02_mcu_function_select(&dev->mt76, BW_SETTING, bw, false);
 }
 
-static void mt76x0_phy_set_chan_pwr(struct mt76x0_dev *dev)
+void mt76x0_phy_set_txpower(struct mt76x0_dev *dev)
 {
+	struct mt76_rate_power *t = &dev->mt76.rate_power;
 	u8 info[2];
 
 	mt76x0_get_power_info(dev, info);
-	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0,
-		       info[0]);
-	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1,
-		       info[1]);
+	mt76x0_get_tx_power_per_rate(dev);
+
+	mt76x02_add_rate_power_offset(t, info[0]);
+	mt76x02_limit_rate_power(t, dev->mt76.txpower_conf);
+	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(t);
+	mt76x02_add_rate_power_offset(t, -info[0]);
+
+	mt76x02_phy_set_txpower(&dev->mt76, info[0], info[1]);
 }
 
 static int
@@ -663,7 +669,6 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
 	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
-	mt76x0_get_tx_power_per_rate(dev);
 	mt76x0_read_rx_gain(dev);
 
 	/* set Japan Tx filter at channel 14 */
@@ -683,7 +688,7 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	if (scan)
 		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 1, false);
 
-	mt76x0_phy_set_chan_pwr(dev);
+	mt76x0_phy_set_txpower(dev);
 
 	return 0;
 }
-- 
2.18.0
