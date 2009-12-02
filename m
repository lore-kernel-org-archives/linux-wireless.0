Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZLBKVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 05:21:02 -0500
Subject: [PATCH] b43: fix two warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 11:20:36 +0100
Message-ID: <1259749236.32171.151.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My gcc appears to be able to see past the function
boundary and notices that the variable 'behaviour'
could be used uninitialised:

drivers/net/wireless/b43/leds.c: In function ‘b43_leds_register’:
drivers/net/wireless/b43/leds.c:339: warning: ‘behaviour’ may be used uninitialized in this function
drivers/net/wireless/b43/leds.c: In function ‘b43_leds_init’:
drivers/net/wireless/b43/leds.c:262: warning: ‘behaviour’ may be used uninitialized in this function

because b43_led_get_sprominfo() didn't initialise
it in all cases.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/leds.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/b43/leds.c	2009-12-02 11:15:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/leds.c	2009-12-02 11:16:26.000000000 +0100
@@ -246,6 +246,7 @@ static void b43_led_get_sprominfo(struct
 			*behaviour = B43_LED_OFF;
 			break;
 		default:
+			*behaviour = B43_LED_OFF;
 			B43_WARN_ON(1);
 			return;
 		}


