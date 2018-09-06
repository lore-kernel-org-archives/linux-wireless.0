Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:46 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 29/42] mt76: move mt76 rate definitions in mt76x02-lib module
Date: Thu,  6 Sep 2018 11:18:45 +0200
Message-Id: <1536225538-16454-30-git-send-email-sgruszka@redhat.com> (sfid-20180906_112021_768723_13C4F82F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Move mt76x2_rate definition in mt76x02-lib module and rename it in
mt76x02_rates in order to be reused in mt76x0 driver.
Moreover remove unused mt76_rate definition

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 32 ++--------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 29 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  5 ++--
 .../wireless/mediatek/mt76/mt76x2_init_common.c    | 29 --------------------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |  4 +--
 7 files changed, 38 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 5b819a224d33..ca70b62442a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -559,34 +559,6 @@ static const struct ieee80211_channel mt76_channels_5ghz[] = {
 	CHAN5G(140, 5700),
 };
 
-#define CCK_RATE(_idx, _rate) {					\
-	.bitrate = _rate,					\
-	.flags = IEEE80211_RATE_SHORT_PREAMBLE,			\
-	.hw_value = (MT_PHY_TYPE_CCK << 8) | _idx,		\
-	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (8 + _idx),	\
-}
-
-#define OFDM_RATE(_idx, _rate) {				\
-	.bitrate = _rate,					\
-	.hw_value = (MT_PHY_TYPE_OFDM << 8) | _idx,		\
-	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | _idx,	\
-}
-
-static struct ieee80211_rate mt76_rates[] = {
-	CCK_RATE(0, 10),
-	CCK_RATE(1, 20),
-	CCK_RATE(2, 55),
-	CCK_RATE(3, 110),
-	OFDM_RATE(0, 60),
-	OFDM_RATE(1, 90),
-	OFDM_RATE(2, 120),
-	OFDM_RATE(3, 180),
-	OFDM_RATE(4, 240),
-	OFDM_RATE(5, 360),
-	OFDM_RATE(6, 480),
-	OFDM_RATE(7, 540),
-};
-
 static int
 mt76_init_sband(struct mt76x0_dev *dev, struct ieee80211_supported_band *sband,
 		const struct ieee80211_channel *chan, int n_chan,
@@ -634,7 +606,7 @@ mt76_init_sband_2g(struct mt76x0_dev *dev)
 
 	return mt76_init_sband(dev, &dev->mt76.sband_2g.sband,
 			       mt76_channels_2ghz, ARRAY_SIZE(mt76_channels_2ghz),
-			       mt76_rates, ARRAY_SIZE(mt76_rates));
+			       mt76x02_rates, ARRAY_SIZE(mt76x02_rates));
 }
 
 static int
@@ -644,7 +616,7 @@ mt76_init_sband_5g(struct mt76x0_dev *dev)
 
 	return mt76_init_sband(dev, &dev->mt76.sband_5g.sband,
 			       mt76_channels_5ghz, ARRAY_SIZE(mt76_channels_5ghz),
-			       mt76_rates + 4, ARRAY_SIZE(mt76_rates) - 4);
+			       mt76x02_rates + 4, ARRAY_SIZE(mt76x02_rates) - 4);
 }
 
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 432c3661312e..f44c149aa6ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -20,6 +20,35 @@
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
 
+#define CCK_RATE(_idx, _rate) {					\
+	.bitrate = _rate,					\
+	.flags = IEEE80211_RATE_SHORT_PREAMBLE,			\
+	.hw_value = (MT_PHY_TYPE_CCK << 8) | _idx,		\
+	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (8 + _idx),	\
+}
+
+#define OFDM_RATE(_idx, _rate) {				\
+	.bitrate = _rate,					\
+	.hw_value = (MT_PHY_TYPE_OFDM << 8) | _idx,		\
+	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | _idx,	\
+}
+
+struct ieee80211_rate mt76x02_rates[] = {
+	CCK_RATE(0, 10),
+	CCK_RATE(1, 20),
+	CCK_RATE(2, 55),
+	CCK_RATE(3, 110),
+	OFDM_RATE(0, 60),
+	OFDM_RATE(1, 90),
+	OFDM_RATE(2, 120),
+	OFDM_RATE(3, 180),
+	OFDM_RATE(4, 240),
+	OFDM_RATE(5, 360),
+	OFDM_RATE(6, 480),
+	OFDM_RATE(7, 540),
+};
+EXPORT_SYMBOL_GPL(mt76x02_rates);
+
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
 			     unsigned int *total_flags, u64 multicast)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 383031b9b6d8..b6ba7e6c2748 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -18,6 +18,8 @@
 #ifndef __MT76X02_UTIL_H
 #define __MT76X02_UTIL_H
 
+extern struct ieee80211_rate mt76x02_rates[12];
+
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
 			     unsigned int *total_flags, u64 multicast);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index efed3c0a82ce..87b805637ff8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -175,8 +175,6 @@ static inline bool wait_for_wpdma(struct mt76x2_dev *dev)
 
 extern const struct ieee80211_ops mt76x2_ops;
 
-extern struct ieee80211_rate mt76x2_rates[12];
-
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x2_dev *dev);
 void mt76x2_init_debugfs(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index c6d5e7db6edb..56a4b86bb665 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -18,6 +18,7 @@
 #include "mt76x2.h"
 #include "mt76x2_eeprom.h"
 #include "mt76x2_mcu.h"
+#include "mt76x02_util.h"
 
 static void
 mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
@@ -584,8 +585,8 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
 	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
 
-	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
-				   ARRAY_SIZE(mt76x2_rates));
+	ret = mt76_register_device(&dev->mt76, true, mt76x02_rates,
+				   ARRAY_SIZE(mt76x02_rates));
 	if (ret)
 		goto fail;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 424d77a82f06..31de3365cdb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -18,35 +18,6 @@
 #include "mt76x2.h"
 #include "mt76x2_eeprom.h"
 
-#define CCK_RATE(_idx, _rate) {					\
-	.bitrate = _rate,					\
-	.flags = IEEE80211_RATE_SHORT_PREAMBLE,			\
-	.hw_value = (MT_PHY_TYPE_CCK << 8) | _idx,		\
-	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (8 + _idx),	\
-}
-
-#define OFDM_RATE(_idx, _rate) {				\
-	.bitrate = _rate,					\
-	.hw_value = (MT_PHY_TYPE_OFDM << 8) | _idx,		\
-	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | _idx,	\
-}
-
-struct ieee80211_rate mt76x2_rates[] = {
-	CCK_RATE(0, 10),
-	CCK_RATE(1, 20),
-	CCK_RATE(2, 55),
-	CCK_RATE(3, 110),
-	OFDM_RATE(0, 60),
-	OFDM_RATE(1, 90),
-	OFDM_RATE(2, 120),
-	OFDM_RATE(3, 180),
-	OFDM_RATE(4, 240),
-	OFDM_RATE(5, 360),
-	OFDM_RATE(6, 480),
-	OFDM_RATE(7, 540),
-};
-EXPORT_SYMBOL_GPL(mt76x2_rates);
-
 static void
 mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 29f3ecaad979..2f828658f566 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -277,8 +277,8 @@ int mt76x2u_register_device(struct mt76x2_dev *dev)
 
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	err = mt76_register_device(&dev->mt76, true, mt76x2_rates,
-				   ARRAY_SIZE(mt76x2_rates));
+	err = mt76_register_device(&dev->mt76, true, mt76x02_rates,
+				   ARRAY_SIZE(mt76x02_rates));
 	if (err)
 		goto fail;
 
-- 
2.7.5
