Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34546
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbXI0Tds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 15:33:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rfkill: Add support for an rfkill LED.
Date: Thu, 27 Sep 2007 21:33:12 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709272133.13138.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a LED trigger.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/include/linux/rfkill.h
===================================================================
--- wireless-2.6.orig/include/linux/rfkill.h	2007-09-26 17:22:47.000000000 +0200
+++ wireless-2.6/include/linux/rfkill.h	2007-09-27 16:21:37.000000000 +0200
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
+#include <linux/leds.h>
 
 /**
  * enum rfkill_type - type of rfkill switch.
@@ -56,6 +57,7 @@ enum rfkill_state {
  * @data: Pointer to the RF button drivers private data which will be
  *	passed along when toggling radio state.
  * @toggle_radio(): Mandatory handler to control state of the radio.
+ * @led_trigger: A LED trigger for this button's LED.
  * @dev: Device structure integrating the switch into device tree.
  * @node: Used to place switch into list of all switches known to the
  *	the system.
@@ -74,6 +76,10 @@ struct rfkill {
 	void *data;
 	int (*toggle_radio)(void *data, enum rfkill_state state);
 
+#ifdef CONFIG_RFKILL_LEDS
+	struct led_trigger led_trigger;
+#endif
+
 	struct device dev;
 	struct list_head node;
 };
@@ -86,4 +92,19 @@ void rfkill_unregister(struct rfkill *rf
 
 void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
 
+/**
+ * rfkill_get_led_name - Get the LED trigger name for the button's LED.
+ * This function might return a NULL pointer if registering of the
+ * LED trigger failed.
+ * Use this as "default_trigger" for the LED.
+ */
+static inline char *rfkill_get_led_name(struct rfkill *rfkill)
+{
+#ifdef CONFIG_RFKILL_LEDS
+	return (char *)(rfkill->led_trigger.name);
+#else
+	return NULL;
+#endif
+}
+
 #endif /* RFKILL_H */
Index: wireless-2.6/net/rfkill/rfkill.c
===================================================================
--- wireless-2.6.orig/net/rfkill/rfkill.c	2007-09-26 17:22:49.000000000 +0200
+++ wireless-2.6/net/rfkill/rfkill.c	2007-09-27 16:32:30.000000000 +0200
@@ -37,6 +37,22 @@ static DEFINE_MUTEX(rfkill_mutex);
 
 static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
 
+
+static void rfkill_led_trigger(struct rfkill *rfkill,
+			       enum rfkill_state state)
+{
+#ifdef CONFIG_RFKILL_LEDS
+	struct led_trigger *led = &rfkill->led_trigger;
+
+	if (!led->name)
+		return;
+	if (state == RFKILL_STATE_OFF)
+		led_trigger_event(led, LED_OFF);
+	else
+		led_trigger_event(led, LED_FULL);
+#endif /* CONFIG_RFKILL_LEDS */
+}
+
 static int rfkill_toggle_radio(struct rfkill *rfkill,
 				enum rfkill_state state)
 {
@@ -48,8 +64,10 @@ static int rfkill_toggle_radio(struct rf
 
 	if (state != rfkill->state) {
 		retval = rfkill->toggle_radio(rfkill->data, state);
-		if (!retval)
+		if (!retval) {
 			rfkill->state = state;
+			rfkill_led_trigger(rfkill, state);
+		}
 	}
 
 	mutex_unlock(&rfkill->mutex);
@@ -328,6 +346,26 @@ void rfkill_free(struct rfkill *rfkill)
 }
 EXPORT_SYMBOL(rfkill_free);
 
+static void rfkill_led_trigger_register(struct rfkill *rfkill)
+{
+#ifdef CONFIG_RFKILL_LEDS
+	int error;
+
+	rfkill->led_trigger.name = rfkill->dev.bus_id;
+	error = led_trigger_register(&rfkill->led_trigger);
+	if (error)
+		rfkill->led_trigger.name = NULL;
+#endif /* CONFIG_RFKILL_LEDS */
+}
+
+static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
+{
+#ifdef CONFIG_RFKILL_LEDS
+	if (rfkill->led_trigger.name)
+		led_trigger_unregister(&rfkill->led_trigger);
+#endif
+}
+
 /**
  * rfkill_register - Register a rfkill structure.
  * @rfkill: rfkill structure to be registered
@@ -357,6 +395,7 @@ int rfkill_register(struct rfkill *rfkil
 		rfkill_remove_switch(rfkill);
 		return error;
 	}
+	rfkill_led_trigger_register(rfkill);
 
 	return 0;
 }
@@ -372,6 +411,7 @@ EXPORT_SYMBOL(rfkill_register);
  */
 void rfkill_unregister(struct rfkill *rfkill)
 {
+	rfkill_led_trigger_unregister(rfkill);
 	device_del(&rfkill->dev);
 	rfkill_remove_switch(rfkill);
 	put_device(&rfkill->dev);
Index: wireless-2.6/net/rfkill/Kconfig
===================================================================
--- wireless-2.6.orig/net/rfkill/Kconfig	2007-09-26 17:22:49.000000000 +0200
+++ wireless-2.6/net/rfkill/Kconfig	2007-09-27 16:31:41.000000000 +0200
@@ -22,3 +22,10 @@ config RFKILL_INPUT
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rfkill-input.
+
+# LED trigger support
+config RFKILL_LEDS
+	bool
+	depends on RFKILL && LEDS_TRIGGERS
+	default y
+
