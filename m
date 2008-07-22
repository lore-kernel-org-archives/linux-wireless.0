Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:39505 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbYGVAS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 20:18:29 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Michael Buesch <mb@bu3sch.de>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH 2/6] rfkill: fix led-trigger unregister order in error unwind
Date: Mon, 21 Jul 2008 21:18:18 -0300
Message-Id: <1216685902-9373-3-git-send-email-hmh@hmh.eng.br> (sfid-20080722_021835_739214_97FC8445)
In-Reply-To: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill needs to unregister the led trigger AFTER a call to
rfkill_remove_switch(), otherwise it will not update the LED state,
possibly leaving it ON when it should be OFF.

To make led-trigger unregistering safer, guard against unregistering a
trigger twice, and also against issuing trigger events to a led trigger
that was unregistered.  This makes the error unwind paths more resilient.

Refer to commit 8a8f1c0437a77cce29c1cb6089f01f22a6d9ca6e,
"rfkill: Register LED triggers before registering switch".

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 net/rfkill/rfkill.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 022fe50..fc3a4fd 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -590,8 +590,10 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
 static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 {
 #ifdef CONFIG_RFKILL_LEDS
-	if (rfkill->led_trigger.name)
+	if (rfkill->led_trigger.name) {
 		led_trigger_unregister(&rfkill->led_trigger);
+		rfkill->led_trigger.name = NULL;
+	}
 #endif
 }
 
@@ -627,8 +629,8 @@ int rfkill_register(struct rfkill *rfkill)
 
 	error = device_add(dev);
 	if (error) {
-		rfkill_led_trigger_unregister(rfkill);
 		rfkill_remove_switch(rfkill);
+		rfkill_led_trigger_unregister(rfkill);
 		return error;
 	}
 
-- 
1.5.6.2

