Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39374 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbeEVV3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:29:36 -0400
From: "=?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?=" <jprvita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux@endlessm.com,
        =?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] rfkill: Rename rfkill_any_led_trigger* functions
Date: Tue, 22 May 2018 14:29:31 -0700
Message-Id: <20180522212932.5357-1-jprvita@endlessm.com> (sfid-20180522_232953_388562_C8AE0BD8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename these functions to rfkill_global_led_trigger*, as they are going
to be extended to handle another global rfkill led trigger.

This commit does not change any functionality.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
---
 net/rfkill/core.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 59d0eb960275..6d64d14f4b0a 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -178,9 +178,9 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 }
 
 static struct led_trigger rfkill_any_led_trigger;
-static struct work_struct rfkill_any_work;
+static struct work_struct rfkill_global_led_trigger_work;
 
-static void rfkill_any_led_trigger_worker(struct work_struct *work)
+static void rfkill_global_led_trigger_worker(struct work_struct *work)
 {
 	enum led_brightness brightness = LED_OFF;
 	struct rfkill *rfkill;
@@ -197,28 +197,29 @@ static void rfkill_any_led_trigger_worker(struct work_struct *work)
 	led_trigger_event(&rfkill_any_led_trigger, brightness);
 }
 
-static void rfkill_any_led_trigger_event(void)
+static void rfkill_global_led_trigger_event(void)
 {
-	schedule_work(&rfkill_any_work);
+	schedule_work(&rfkill_global_led_trigger_work);
 }
 
-static void rfkill_any_led_trigger_activate(struct led_classdev *led_cdev)
+static void rfkill_global_led_trigger_activate(struct led_classdev *led_cdev)
 {
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 }
 
-static int rfkill_any_led_trigger_register(void)
+static int rfkill_global_led_trigger_register(void)
 {
-	INIT_WORK(&rfkill_any_work, rfkill_any_led_trigger_worker);
+	INIT_WORK(&rfkill_global_led_trigger_work,
+			rfkill_global_led_trigger_worker);
 	rfkill_any_led_trigger.name = "rfkill-any";
-	rfkill_any_led_trigger.activate = rfkill_any_led_trigger_activate;
+	rfkill_any_led_trigger.activate = rfkill_global_led_trigger_activate;
 	return led_trigger_register(&rfkill_any_led_trigger);
 }
 
-static void rfkill_any_led_trigger_unregister(void)
+static void rfkill_global_led_trigger_unregister(void)
 {
 	led_trigger_unregister(&rfkill_any_led_trigger);
-	cancel_work_sync(&rfkill_any_work);
+	cancel_work_sync(&rfkill_global_led_trigger_work);
 }
 #else
 static void rfkill_led_trigger_event(struct rfkill *rfkill)
@@ -234,16 +235,16 @@ static inline void rfkill_led_trigger_unregister(struct rfkill *rfkill)
 {
 }
 
-static void rfkill_any_led_trigger_event(void)
+static void rfkill_global_led_trigger_event(void)
 {
 }
 
-static int rfkill_any_led_trigger_register(void)
+static int rfkill_global_led_trigger_register(void)
 {
 	return 0;
 }
 
-static void rfkill_any_led_trigger_unregister(void)
+static void rfkill_global_led_trigger_unregister(void)
 {
 }
 #endif /* CONFIG_RFKILL_LEDS */
@@ -354,7 +355,7 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	rfkill_led_trigger_event(rfkill);
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 
 	if (prev != curr)
 		rfkill_event(rfkill);
@@ -535,7 +536,7 @@ bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
 	spin_unlock_irqrestore(&rfkill->lock, flags);
 
 	rfkill_led_trigger_event(rfkill);
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 
 	if (rfkill->registered && prev != blocked)
 		schedule_work(&rfkill->uevent_work);
@@ -579,7 +580,7 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 		schedule_work(&rfkill->uevent_work);
 
 	rfkill_led_trigger_event(rfkill);
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 
 	return blocked;
 }
@@ -629,7 +630,7 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 			schedule_work(&rfkill->uevent_work);
 
 		rfkill_led_trigger_event(rfkill);
-		rfkill_any_led_trigger_event();
+		rfkill_global_led_trigger_event();
 	}
 }
 EXPORT_SYMBOL(rfkill_set_states);
@@ -1046,7 +1047,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 #endif
 	}
 
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 	rfkill_send_events(rfkill, RFKILL_OP_ADD);
 
 	mutex_unlock(&rfkill_global_mutex);
@@ -1079,7 +1080,7 @@ void rfkill_unregister(struct rfkill *rfkill)
 	mutex_lock(&rfkill_global_mutex);
 	rfkill_send_events(rfkill, RFKILL_OP_DEL);
 	list_del_init(&rfkill->node);
-	rfkill_any_led_trigger_event();
+	rfkill_global_led_trigger_event();
 	mutex_unlock(&rfkill_global_mutex);
 
 	rfkill_led_trigger_unregister(rfkill);
@@ -1332,7 +1333,7 @@ static int __init rfkill_init(void)
 	if (error)
 		goto error_misc;
 
-	error = rfkill_any_led_trigger_register();
+	error = rfkill_global_led_trigger_register();
 	if (error)
 		goto error_led_trigger;
 
@@ -1346,7 +1347,7 @@ static int __init rfkill_init(void)
 
 #ifdef CONFIG_RFKILL_INPUT
 error_input:
-	rfkill_any_led_trigger_unregister();
+	rfkill_global_led_trigger_unregister();
 #endif
 error_led_trigger:
 	misc_deregister(&rfkill_miscdev);
@@ -1362,7 +1363,7 @@ static void __exit rfkill_exit(void)
 #ifdef CONFIG_RFKILL_INPUT
 	rfkill_handler_exit();
 #endif
-	rfkill_any_led_trigger_unregister();
+	rfkill_global_led_trigger_unregister();
 	misc_deregister(&rfkill_miscdev);
 	class_unregister(&rfkill_class);
 }
-- 
2.17.0
