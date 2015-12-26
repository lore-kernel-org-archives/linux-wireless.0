Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:32809 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbLZPFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2015 10:05:16 -0500
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>
Subject: [PATCH] net/rfkill: Create "airplane mode" LED trigger
Date: Sat, 26 Dec 2015 10:05:03 -0500
Message-Id: <1451142303-1872-2-git-send-email-jprvita@endlessm.com> (sfid-20151226_160639_136600_2B5A8332)
In-Reply-To: <1451142303-1872-1-git-send-email-jprvita@endlessm.com>
References: <1451142303-1872-1-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For platform drivers to be able to correctly drive the "Airplane Mode"
indicative LED there needs to be a RFKill LED trigger tied to the global
state of RFKILL_TYPE_ALL (instead of to a specific RFKill) and that
works in an inverted manner of regular RFKill LED triggers, that is, the
LED is ON when the state is blocked, and OFF otherwise.

This commit implements such a trigger, which will be used by the
asus-wireless x86 platform driver.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index b41e9ea..3effc29 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -124,6 +124,26 @@ static bool rfkill_epo_lock_active;
 
 
 #ifdef CONFIG_RFKILL_LEDS
+static void airplane_mode_led_trigger_activate(struct led_classdev *led);
+
+static struct led_trigger airplane_mode_led_trigger = {
+	.name     = "rfkill-airplane-mode",
+	.activate = airplane_mode_led_trigger_activate,
+};
+
+static void airplane_mode_led_trigger_event(void)
+{
+	if (rfkill_global_states[RFKILL_TYPE_ALL].cur & RFKILL_BLOCK_ANY)
+		led_trigger_event(&airplane_mode_led_trigger, LED_FULL);
+	else
+		led_trigger_event(&airplane_mode_led_trigger, LED_OFF);
+}
+
+static void airplane_mode_led_trigger_activate(struct led_classdev *led)
+{
+	airplane_mode_led_trigger_event();
+}
+
 static void rfkill_led_trigger_event(struct rfkill *rfkill)
 {
 	struct led_trigger *trigger;
@@ -175,6 +195,10 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 	led_trigger_unregister(&rfkill->led_trigger);
 }
 #else
+static void airplane_mode_led_trigger_event(void)
+{
+}
+
 static void rfkill_led_trigger_event(struct rfkill *rfkill)
 {
 }
@@ -346,6 +370,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
 
 		for (i = 0; i < NUM_RFKILL_TYPES; i++)
 			rfkill_global_states[i].cur = blocked;
+		airplane_mode_led_trigger_event();
 	} else {
 		rfkill_global_states[type].cur = blocked;
 	}
@@ -1177,6 +1202,7 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
 			enum rfkill_type i;
 			for (i = 0; i < NUM_RFKILL_TYPES; i++)
 				rfkill_global_states[i].cur = ev.soft;
+			airplane_mode_led_trigger_event();
 		} else {
 			rfkill_global_states[ev.type].cur = ev.soft;
 		}
@@ -1293,6 +1319,10 @@ static int __init rfkill_init(void)
 	}
 #endif
 
+#ifdef CONFIG_RFKILL_LEDS
+	led_trigger_register(&airplane_mode_led_trigger);
+#endif
+
  out:
 	return error;
 }
-- 
2.5.0

