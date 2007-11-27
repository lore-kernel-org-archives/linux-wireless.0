Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56667 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbXK0QEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:04:00 -0500
Date: Tue, 27 Nov 2007 10:03:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC/T] b43: Fix Radio On/Off LED action
Message-ID: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> (sfid-20071127_160404_538571_2317E263)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since addition of the rfkill callback, the LED associated with the off
switch on the radio has not worked because essential data in the rfkill
structure was missing. This hack adds the necessary data and places direct
calls to turn the leds on/off.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
@@ -23,6 +23,7 @@
 */
 
 #include "rfkill.h"
+#include "leds.h"
 #include "b43.h"
 
 
@@ -57,6 +58,10 @@ static void b43_rfkill_poll(struct input
 		report_change = 1;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
+		if (enabled)
+			b43_led_turn_on(dev, 1, 1);
+		else
+			b43_led_turn_off(dev, 1, 1);
 	}
 	mutex_unlock(&wl->mutex);
 
@@ -70,11 +75,13 @@ static int b43_rfkill_soft_toggle(void *
 	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
 	int err = 0;
+	int lock = mutex_is_locked(&wl->mutex);
 
 	if (!wl->rfkill.registered)
 		return 0;
 
-	mutex_lock(&wl->mutex);
+	if (!lock)
+		mutex_lock(&wl->mutex);
 	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
 	switch (state) {
 	case RFKILL_STATE_ON:
@@ -93,7 +100,8 @@ static int b43_rfkill_soft_toggle(void *
 		break;
 	}
 out_unlock:
-	mutex_unlock(&wl->mutex);
+	if (!lock)
+		mutex_unlock(&wl->mutex);
 
 	return err;
 }
@@ -133,6 +141,12 @@ void b43_rfkill_init(struct b43_wldev *d
 	rfk->poll_dev->poll = b43_rfkill_poll;
 	rfk->poll_dev->poll_interval = 1000; /* msecs */
 
+	rfk->poll_dev->input->name = rfk->name;
+	rfk->poll_dev->input->id.bustype = BUS_HOST;
+	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
+	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
+
 	err = rfkill_register(rfk->rfkill);
 	if (err)
 		goto err_free_polldev;
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
+++ wireless-2.6/drivers/net/wireless/b43/leds.c
@@ -30,7 +30,7 @@
 #include "leds.h"
 
 
-static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
+void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
 			    bool activelow)
 {
 	struct b43_wl *wl = dev->wl;
@@ -47,7 +47,7 @@ static void b43_led_turn_on(struct b43_w
 	spin_unlock_irqrestore(&wl->leds_lock, flags);
 }
 
-static void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
+void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
 			     bool activelow)
 {
 	struct b43_wl *wl = dev->wl;
Index: wireless-2.6/drivers/net/wireless/b43/leds.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.h
+++ wireless-2.6/drivers/net/wireless/b43/leds.h
@@ -44,7 +44,10 @@ enum b43_led_behaviour {
 
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
-
+void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
+			     bool activelow);
+void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
+			     bool activelow);
 
 #else /* CONFIG_B43_LEDS */
 /* LED support disabled */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -2799,6 +2799,8 @@ static int b43_op_config(struct ieee8021
 	b43_interrupt_enable(dev, savedirqs);
 	mmiowb();
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	if (dev->radio_hw_enable)
+		b43_led_turn_on(dev, 1, 1);
       out_unlock_mutex:
 	mutex_unlock(&wl->mutex);
 
