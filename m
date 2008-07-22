Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:35217 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYGVKWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 06:22:12 -0400
Received: by mu-out-0910.google.com with SMTP id w8so1129081mue.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 03:22:11 -0700 (PDT)
Date: Tue, 22 Jul 2008 14:21:59 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>, akpm@linux-foundation.org
Subject: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Message-ID: <20080722102159.GA32682@doriath.ww600.siemens.net> (sfid-20080722_122216_175312_2B4BBDFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide default activate function to set the state of the led
when the led becomes bound to the trigger

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
-- 
 This patch depends on the patch "leds: make sure led->trigger is set
 earlier" which was staged in -mm for some time and recently got merged
 into leds tree.
---
 net/rfkill/rfkill.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index b247677..e9010ff 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -57,6 +57,16 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
 #endif /* CONFIG_RFKILL_LEDS */
 }
 
+#ifdef CONFIG_RFKILL_LEDS
+static void rfkill_led_trigger_activate(struct led_classdev *led)
+{
+	struct rfkill *rfkill = container_of(led->trigger,
+			struct rfkill, led_trigger);
+
+	rfkill_led_trigger(rfkill, rfkill->state);
+}
+#endif /* CONFIG_RFKILL_LEDS */
+
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state)
 {
@@ -357,6 +367,8 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
 
 	if (!rfkill->led_trigger.name)
 		rfkill->led_trigger.name = rfkill->dev.bus_id;
+	if (!rfkill->led_trigger.activate)
+		rfkill->led_trigger.activate = rfkill_led_trigger_activate;
 	error = led_trigger_register(&rfkill->led_trigger);
 	if (error)
 		rfkill->led_trigger.name = NULL;
-- 
1.5.6.2


-- 
With best wishes
Dmitry

