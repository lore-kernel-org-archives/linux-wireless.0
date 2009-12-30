Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:59440 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZL3Kgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/6] rt2x00: Make rt2800_init_led static and don't export it.
Date: Wed, 30 Dec 2009 11:36:34 +0100
Message-Id: <1262169394-11647-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-6-git-send-email-gwingerde@gmail.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only used within the rt2800lib module itself.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ca700a4..529a373 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -366,7 +366,7 @@ static int rt2800_blink_set(struct led_classdev *led_cdev,
 	return 0;
 }
 
-void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
+static void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
 		     struct rt2x00_led *led, enum led_type type)
 {
 	led->rt2x00dev = rt2x00dev;
@@ -375,7 +375,6 @@ void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
 	led->led_dev.blink_set = rt2800_blink_set;
 	led->flags = LED_INITIALIZED;
 }
-EXPORT_SYMBOL_GPL(rt2800_init_led);
 #endif /* CONFIG_RT2X00_LIB_LEDS */
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 9adb343..ebabeae 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -114,8 +114,6 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 extern const struct rt2x00debug rt2800_rt2x00debug;
 
 int rt2800_rfkill_poll(struct rt2x00_dev *rt2x00dev);
-void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
-		     struct rt2x00_led *led, enum led_type type);
 int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 			     struct rt2x00lib_crypto *crypto,
 			     struct ieee80211_key_conf *key);
-- 
1.6.6

