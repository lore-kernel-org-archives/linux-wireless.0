Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:42520 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZEYTvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 15:51:21 -0400
From: Christian Lamparter <chunkeey@web.de>
Date: Mon, 25 May 2009 21:51:19 +0200
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4 v2] ar9170: fix LED power state handling
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905252151.19880.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a minor visual bug in the led code, which
left the LED in the wrong power state when it was toggled
in a _unexpected_ way (e.g: enabling the LED twice).

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 1247dcb..396b240 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -91,6 +91,7 @@ struct ar9170_led {
 	struct led_classdev l;
 	char name[32];
 	unsigned int toggled;
+	bool last_state;
 	bool registered;
 };
 
diff --git a/drivers/net/wireless/ath/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
index 341cead..3c8a572 100644
--- a/drivers/net/wireless/ath/ar9170/led.c
+++ b/drivers/net/wireless/ath/ar9170/led.c
@@ -101,9 +101,12 @@ static void ar9170_led_brightness_set(struct led_classdev *led,
 	struct ar9170_led *arl = container_of(led, struct ar9170_led, l);
 	struct ar9170 *ar = arl->ar;
 
-	arl->toggled++;
+	if (arl->last_state != !!brightness) {
+		arl->toggled++;
+		arl->last_state = !!brightness;
+	}
 
-	if (likely(IS_ACCEPTING_CMD(ar) && brightness))
+	if (likely(IS_ACCEPTING_CMD(ar) && arl->toggled))
 		queue_delayed_work(ar->hw->workqueue, &ar->led_work, HZ/10);
 }
 
