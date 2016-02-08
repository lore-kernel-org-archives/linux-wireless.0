Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:32899 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbcBHPlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 10:41:47 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH 7/9] rfkill: Create "rfkill-airplane_mode" LED trigger
Date: Mon,  8 Feb 2016 10:41:34 -0500
Message-Id: <1454946096-9752-8-git-send-email-jprvita@endlessm.com> (sfid-20160208_164339_735216_65BE2E8C)
In-Reply-To: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This creates a new LED trigger to be used by platform drivers as a
default trigger for airplane-mode indicator LEDs.

By default this trigger will fire when RFKILL_OP_CHANGE_ALL is called
for all types (RFKILL_TYPE_ALL), setting the LED brightness to LED_FULL
when the changing the state to blocked, and to LED_OFF when the changing
the state to unblocked. In the future there will be a mechanism for
userspace to override the default policy, so it can implement its own.

This trigger will be used by the asus-wireless x86 platform driver.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 Documentation/rfkill.txt |  2 ++
 net/rfkill/core.c        | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index 1f0c270..b13025a 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -85,6 +85,8 @@ device). Don't do this unless you cannot get the event in any other way.
 
 RFKill provides per-switch LED triggers, which can be used to drive LEDs
 according to the switch state (LED_FULL when blocked, LED_OFF otherwise).
+An airplane-mode indicator LED trigger is also available, which triggers
+LED_FULL when all radios known by RFKill are blocked, and LED_OFF otherwise.
 
 
 5. Userspace support
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 8b96869..fb11547 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -126,6 +126,30 @@ static bool rfkill_epo_lock_active;
 
 
 #ifdef CONFIG_RFKILL_LEDS
+static struct led_trigger rfkill_apm_led_trigger;
+
+static void rfkill_apm_led_trigger_event(bool state)
+{
+	led_trigger_event(&rfkill_apm_led_trigger, state ? LED_FULL : LED_OFF);
+}
+
+static void rfkill_apm_led_trigger_activate(struct led_classdev *led)
+{
+	rfkill_apm_led_trigger_event(!rfkill_default_state);
+}
+
+static int rfkill_apm_led_trigger_register(void)
+{
+	rfkill_apm_led_trigger.name = "rfkill-airplane_mode";
+	rfkill_apm_led_trigger.activate = rfkill_apm_led_trigger_activate;
+	return led_trigger_register(&rfkill_apm_led_trigger);
+}
+
+static void rfkill_apm_led_trigger_unregister(void)
+{
+	led_trigger_unregister(&rfkill_apm_led_trigger);
+}
+
 static void rfkill_led_trigger_event(struct rfkill *rfkill)
 {
 	struct led_trigger *trigger;
@@ -177,6 +201,19 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 	led_trigger_unregister(&rfkill->led_trigger);
 }
 #else
+static void rfkill_apm_led_trigger_event(bool state)
+{
+}
+
+static int rfkill_apm_led_trigger_register(void)
+{
+	return 0;
+}
+
+static void rfkill_apm_led_trigger_unregister(void)
+{
+}
+
 static void rfkill_led_trigger_event(struct rfkill *rfkill)
 {
 }
@@ -313,6 +350,7 @@ static void rfkill_update_global_state(enum rfkill_type type, bool blocked)
 
 	for (i = 0; i < NUM_RFKILL_TYPES; i++)
 		rfkill_global_states[i].cur = blocked;
+	rfkill_apm_led_trigger_event(blocked);
 }
 
 #ifdef CONFIG_RFKILL_INPUT
@@ -1260,15 +1298,22 @@ static int __init rfkill_init(void)
 {
 	int error;
 
+	error = rfkill_apm_led_trigger_register();
+	if (error)
+		goto out;
+
 	rfkill_update_global_state(RFKILL_TYPE_ALL, !rfkill_default_state);
 
 	error = class_register(&rfkill_class);
-	if (error)
+	if (error) {
+		rfkill_apm_led_trigger_unregister();
 		goto out;
+	}
 
 	error = misc_register(&rfkill_miscdev);
 	if (error) {
 		class_unregister(&rfkill_class);
+		rfkill_apm_led_trigger_unregister();
 		goto out;
 	}
 
@@ -1277,6 +1322,7 @@ static int __init rfkill_init(void)
 	if (error) {
 		misc_deregister(&rfkill_miscdev);
 		class_unregister(&rfkill_class);
+		rfkill_apm_led_trigger_unregister();
 		goto out;
 	}
 #endif
@@ -1293,5 +1339,6 @@ static void __exit rfkill_exit(void)
 #endif
 	misc_deregister(&rfkill_miscdev);
 	class_unregister(&rfkill_class);
+	rfkill_apm_led_trigger_unregister();
 }
 module_exit(rfkill_exit);
-- 
2.5.0

