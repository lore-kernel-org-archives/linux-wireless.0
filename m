Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:49832 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755715AbeARNPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:15:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] [wireless-next] mt76: fix building without CONFIG_LEDS_CLASS
Date: Thu, 18 Jan 2018 14:14:11 +0100
Message-Id: <20180118131524.817297-1-arnd@arndb.de> (sfid-20180118_141619_764641_DECE6613)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_LEDS_CLASS is disabled, or it is a loadable module while
mt76 is built-in, we run into a link error:

drivers/net/wireless/mediatek/mt76/mac80211.o: In function `mt76_register_device':
mac80211.c:(.text+0xb78): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `devm_of_led_classdev_register'

We don't really need a hard dependency here as the driver can presumably
work just fine without LEDs, so this follows the iwlwifi example and
adds a separate Kconfig option for the LED support, this will be available
whenever it will link, and otherwise the respective code gets left out from
the driver object.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/Kconfig       | 5 +++++
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 8 +++++---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 6 ++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index fc05d79c80d0..9d12c1f5284e 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -8,3 +8,8 @@ config MT76x2E
 	depends on PCI
 	---help---
 	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
+
+config MT76_LEDS
+	bool "LED support for MT76"
+	depends on MT76_CORE
+	depends on LEDS_CLASS=y || MT76_CORE=LEDS_CLASS
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3acf0e175d71..144e312a9407 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -295,9 +295,11 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	mt76_check_sband(dev, NL80211_BAND_2GHZ);
 	mt76_check_sband(dev, NL80211_BAND_5GHZ);
 
-	ret = mt76_led_init(dev);
-	if (ret)
-		return ret;
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		ret = mt76_led_init(dev);
+		if (ret)
+			return ret;
+	}
 
 	return ieee80211_register_hw(hw);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 4373a2ba5143..0c9d02af205d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -849,8 +849,10 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	mt76x2_dfs_init_detector(dev);
 
 	/* init led callbacks */
-	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
-	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
+		dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
+	}
 
 	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
 				   ARRAY_SIZE(mt76x2_rates));
-- 
2.9.0
