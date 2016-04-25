Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:58386 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752632AbcDYHvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 03:51:14 -0400
From: Lucas Stach <dev@lynxeye.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH RFC] b43: stop hardcoding LED behavior
Date: Mon, 25 Apr 2016 09:40:51 +0200
Message-Id: <1461570051-3950-1-git-send-email-dev@lynxeye.de> (sfid-20160425_095136_224587_68C15A96)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code to hardcode the LED behavior is basically unchanged from when it
was first merged in 2007. It is likely wrong for many modern systems using
the b43 driver.

On my system the SPROM correctly defines the only wired LED (radio) but
skips all others, leading to the hardcode to register LEDs with RX and TX
triggers. These triggers cause many uneccesary CPU wakeups to drive LEDs
that aren't even present in the system, reducing battery runtime.

Remove the hardcode to stop it from doing any harm. If this code is useful
for others it should probably be reworked as a quirk table triggering only
for individual systems that need it.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 drivers/net/wireless/broadcom/b43/leds.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wireless/broadcom/b43/leds.c
index d79ab2a..77d2dad 100644
--- a/drivers/net/wireless/broadcom/b43/leds.c
+++ b/drivers/net/wireless/broadcom/b43/leds.c
@@ -224,31 +224,9 @@ static void b43_led_get_sprominfo(struct b43_wldev *dev,
 
 	if (sprom[led_index] == 0xFF) {
 		/* There is no LED information in the SPROM
-		 * for this LED. Hardcode it here. */
+		 * for this LED. Keep it disabled. */
 		*activelow = false;
-		switch (led_index) {
-		case 0:
-			*behaviour = B43_LED_ACTIVITY;
-			*activelow = true;
-			if (dev->dev->board_vendor == PCI_VENDOR_ID_COMPAQ)
-				*behaviour = B43_LED_RADIO_ALL;
-			break;
-		case 1:
-			*behaviour = B43_LED_RADIO_B;
-			if (dev->dev->board_vendor == PCI_VENDOR_ID_ASUSTEK)
-				*behaviour = B43_LED_ASSOC;
-			break;
-		case 2:
-			*behaviour = B43_LED_RADIO_A;
-			break;
-		case 3:
-			*behaviour = B43_LED_OFF;
-			break;
-		default:
-			*behaviour = B43_LED_OFF;
-			B43_WARN_ON(1);
-			return;
-		}
+		*behaviour = B43_LED_OFF;
 	} else {
 		*behaviour = sprom[led_index] & B43_LED_BEHAVIOUR;
 		*activelow = !!(sprom[led_index] & B43_LED_ACTIVELOW);
-- 
2.5.5

