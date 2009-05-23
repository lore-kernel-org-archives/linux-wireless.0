Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:33876 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZEWSa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 14:30:59 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ar9170: fix LED power state handling
Date: Sat, 23 May 2009 20:30:59 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200905232030.59356.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a minor visual bug in the led code, which
left the LED in the wrong power state when it was toggled
in a _unexpected_ way (e.g: enabling the LED twice).

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
index 341cead..ebb1c3e 100644
--- a/drivers/net/wireless/ath/ar9170/led.c
+++ b/drivers/net/wireless/ath/ar9170/led.c
@@ -81,10 +81,10 @@ static void ar9170_update_leds(struct work_struct *work)
 			if (tmp < blink_delay)
 				blink_delay = tmp;
 
-			if (ar->leds[i].toggled > 1)
-				ar->leds[i].toggled = 0;
+			if (ar->leds[i].l.brightness == LED_OFF)
+				rerun = true;
 
-			rerun = true;
+			ar->leds[i].toggled = !!ar->leds[i].l.brightness;
 		}
 
 	ar9170_set_leds_state(ar, led_val);
@@ -103,7 +103,7 @@ static void ar9170_led_brightness_set(struct led_classdev *led,
 
 	arl->toggled++;
 
-	if (likely(IS_ACCEPTING_CMD(ar) && brightness))
+	if (likely(IS_ACCEPTING_CMD(ar)))
 		queue_delayed_work(ar->hw->workqueue, &ar->led_work, HZ/10);
 }
 
