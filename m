Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45562 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753343AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 07/14] mt76x2: initialize channel power limits at probe time
Date: Thu, 14 Dec 2017 16:39:11 +0100
Message-Id: <20171214153918.43774-8-nbd@nbd.name> (sfid-20171214_163941_781060_63BF6990)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user space to query the real hardware limits directly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 11 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 30 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 14 +---------
 4 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 8fef400cb58e..9c9bf3e785ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -483,6 +483,17 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
 }
 
+int mt76x2_get_max_rate_power(struct mt76_rate_power *r)
+{
+	int i;
+	s8 ret = 0;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		ret = max(ret, r->all[i]);
+
+	return ret;
+}
+
 static void
 mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 		         struct ieee80211_channel *chan, int chain, int offset)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 6db2c6e47569..d79122728dca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -148,6 +148,7 @@ mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field)
 
 void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan);
+int mt76x2_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x2_get_power_info(struct mt76x2_dev *dev,
 			   struct mt76x2_tx_power_info *t,
 			   struct ieee80211_channel *chan);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index d3f03a8aee90..0755b451829e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -760,6 +760,34 @@ static void mt76x2_led_set_brightness(struct led_classdev *led_cdev,
 		mt76x2_led_set_config(mt76, 0xff, 0);
 }
 
+static void
+mt76x2_init_txpower(struct mt76x2_dev *dev,
+		    struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_channel *chan;
+	struct mt76x2_tx_power_info txp;
+	struct mt76_rate_power t = {};
+	int target_power;
+	int i;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		chan = &sband->channels[i];
+
+		mt76x2_get_power_info(dev, &txp, chan);
+
+		target_power = max_t(int, (txp.chain[0].target_power +
+					   txp.chain[0].delta),
+					  (txp.chain[1].target_power +
+					   txp.chain[1].delta));
+
+		mt76x2_get_rate_power(dev, &t, chan);
+
+		chan->max_power = mt76x2_get_max_rate_power(&t) +
+				  target_power;
+		chan->max_power /= 2;
+	}
+}
+
 int mt76x2_register_device(struct mt76x2_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
@@ -828,6 +856,8 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 		goto fail;
 
 	mt76x2_init_debugfs(dev);
+	mt76x2_init_txpower(dev, &dev->mt76.sband_2g.sband);
+	mt76x2_init_txpower(dev, &dev->mt76.sband_5g.sband);
 
 	return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 81cea7e8414e..5b742749d5de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -102,18 +102,6 @@ mt76x2_limit_rate_power(struct mt76_rate_power *r, int limit)
 			r->all[i] = limit;
 }
 
-static int
-mt76x2_get_max_power(struct mt76_rate_power *r)
-{
-	int i;
-	s8 ret = 0;
-
-	for (i = 0; i < sizeof(r->all); i++)
-		ret = max(ret, r->all[i]);
-
-	return ret;
-}
-
 void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 {
 	enum nl80211_chan_width width = dev->mt76.chandef.width;
@@ -136,7 +124,7 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power +
 				   txp.chain[0].delta);
 	mt76x2_limit_rate_power(&t, dev->txpower_conf);
-	dev->txpower_cur = mt76x2_get_max_power(&t);
+	dev->txpower_cur = mt76x2_get_max_rate_power(&t);
 	mt76x2_add_rate_power_offset(&t, -(txp.chain[0].target_power +
 					 txp.chain[0].delta + delta));
 	dev->target_power = txp.chain[0].target_power;
-- 
2.14.2
