Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50776 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZFAUtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 16:49:24 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170: cancel led worker properly on exit
Date: Mon, 1 Jun 2009 22:49:25 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200906012249.25984.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"[PATCH 3/4 v2] ar9170: fix LED power state handling" revealed
a bug which can cause a ugly crash.

The delayed worker is canceled before the LED class functions are
unregistered... So, if something manages to update the LEDs 
while unregister routine is running the timer could fire _after_ the
module has been unloaded.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
index 3c8a572..63fda6c 100644
--- a/drivers/net/wireless/ath/ar9170/led.c
+++ b/drivers/net/wireless/ath/ar9170/led.c
@@ -74,7 +74,7 @@ static void ar9170_update_leds(struct work_struct *work)
 
 	mutex_lock(&ar->mutex);
 	for (i = 0; i < AR9170_NUM_LEDS; i++)
-		if (ar->leds[i].toggled) {
+		if (ar->leds[i].registered && ar->leds[i].toggled) {
 			led_val |= 1 << i;
 
 			tmp = 70 + 200 / (ar->leds[i].toggled);
@@ -101,6 +101,9 @@ static void ar9170_led_brightness_set(struct led_classdev *led,
 	struct ar9170_led *arl = container_of(led, struct ar9170_led, l);
 	struct ar9170 *ar = arl->ar;
 
+	if (unlikely(!arl->registered))
+		return ;
+
 	if (arl->last_state != !!brightness) {
 		arl->toggled++;
 		arl->last_state = !!brightness;
@@ -139,13 +142,14 @@ void ar9170_unregister_leds(struct ar9170 *ar)
 {
 	int i;
 
-	cancel_delayed_work_sync(&ar->led_work);
-
 	for (i = 0; i < AR9170_NUM_LEDS; i++)
 		if (ar->leds[i].registered) {
 			led_classdev_unregister(&ar->leds[i].l);
 			ar->leds[i].registered = false;
+			ar->leds[i].toggled = 0;
 		}
+
+	cancel_delayed_work_sync(&ar->led_work);
 }
 
 int ar9170_register_leds(struct ar9170 *ar)
