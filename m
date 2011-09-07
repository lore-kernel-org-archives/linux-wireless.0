Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50559 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab1IGSLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:11:45 -0400
Received: by eyx24 with SMTP id 24so5210512eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 11:11:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] rt2x00: Remove incorrect led blink
Date: Wed, 7 Sep 2011 20:10:45 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201109072010.04023.IvDoorn@gmail.com> <201109072010.25836.IvDoorn@gmail.com>
In-Reply-To: <201109072010.25836.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109072010.45905.IvDoorn@gmail.com> (sfid-20110907_201147_525276_6C07203F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

rt2800 devices are not capable of configuring arbitrary LED on/off
periods. The LED_CFG register fields ON_PERIOD and OFF_PERIOD are only
used by the hw when the LED mode is set to "blink upon TX".

Hence, remove the blink callback. This will result in software emulation
for LED blinking.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ba626a9..877b1e7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -897,28 +897,12 @@ static void rt2800_brightness_set(struct led_classdev *led_cdev,
 	}
 }
 
-static int rt2800_blink_set(struct led_classdev *led_cdev,
-			    unsigned long *delay_on, unsigned long *delay_off)
-{
-	struct rt2x00_led *led =
-	    container_of(led_cdev, struct rt2x00_led, led_dev);
-	u32 reg;
-
-	rt2800_register_read(led->rt2x00dev, LED_CFG, &reg);
-	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, *delay_on);
-	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, *delay_off);
-	rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
-
-	return 0;
-}
-
 static void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
 		     struct rt2x00_led *led, enum led_type type)
 {
 	led->rt2x00dev = rt2x00dev;
 	led->type = type;
 	led->led_dev.brightness_set = rt2800_brightness_set;
-	led->led_dev.blink_set = rt2800_blink_set;
 	led->flags = LED_INITIALIZED;
 }
 #endif /* CONFIG_RT2X00_LIB_LEDS */
-- 
1.7.3.4
