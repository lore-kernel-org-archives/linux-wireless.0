Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:34051 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751848AbcFCVPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:15:05 -0400
From: Lucas Stach <dev@lynxeye.de>
To: Kalle Valo <kvalo@codeaurora.org>, Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH] b43: only hardcode LED behavior if SPROM doesn't encode any
Date: Fri,  3 Jun 2016 23:04:03 +0200
Message-Id: <1464987843-6928-1-git-send-email-dev@lynxeye.de> (sfid-20160603_231510_815993_68D93379)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only hardcode the LED behavior if the SROM doesn't provide any for all
LEDs of the card. This avoids instantiating LED triggers for unconnected
LEDs, while (hopefully) keeping things working for old cards with a
blank SROM.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 drivers/net/wireless/broadcom/b43/leds.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireless/broadcom/b43/leds.c
index d79ab2a..cb987c2 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -222,7 +222,7 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 	sprom[2] = dev->dev->bus_sprom->gpio2;
 	sprom[3] = dev->dev->bus_sprom->gpio3;
 
-	if (sprom[led_index] == 0xFF) {
+	if ((sprom[0] & sprom[1] & sprom[2] & sprom[3]) == 0xff) {
 		/* There is no LED information in the SPROM
 		 * for this LED. Hardcode it here. */
 		*activelow = false;
@@ -250,7 +250,11 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 			return;
 		}
 	} else {
-		*behaviour = sprom[led_index] & B43_LED_BEHAVIOUR;
+		/* keep LED disabled if no mapping is defined */
+		if (sprom[led_index] == 0xff)
+			*behaviour = B43_LED_OFF;
+		else
+			*behaviour = sprom[led_index] & B43_LED_BEHAVIOUR;
 		*activelow = !!(sprom[led_index] & B43_LED_ACTIVELOW);
 	}
 }
-- 
2.5.5

