Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYIRFH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 01:07:59 -0400
Date: Thu, 18 Sep 2008 00:07:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> (sfid-20080918_070826_146131_7B70EAC6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The changes below, along with Henriques patch "[PATCH] rfkill: update
LEDs for all state changes", and the reversion of commit bc19d6e make
the wireless LED toggle correctly.

I'll let the experts discuss whether the changes below have problems
of the sort that were discussed in the context of the regression I
found.

Larry

Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -44,13 +44,11 @@ static bool b43_is_hw_radio_enabled(stru
 	return 0;
 }
 
-/* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
+static void b43_rfkill_update(struct b43_wldev *dev)
 {
-	struct b43_wldev *dev = poll_dev->private;
 	struct b43_wl *wl = dev->wl;
 	bool enabled;
-	bool report_change = 0;
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
@@ -60,18 +58,40 @@ static void b43_rfkill_poll(struct input
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
-		report_change = 1;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
+		if (!enabled)
+			rfkill_force_state(rfk->rfkill,
+					   RFKILL_STATE_HARD_BLOCKED);
+		else {
+			if (!dev->phy.radio_on)
+				rfkill_force_state(rfk->rfkill,
+						   RFKILL_STATE_SOFT_BLOCKED);
+			else
+				rfkill_force_state(rfk->rfkill,
+						   RFKILL_STATE_UNBLOCKED);
+		}
 	}
 	mutex_unlock(&wl->mutex);
+}
 
-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+static void b43_rfkill_poll(unsigned long data)
+{
+	struct b43_rfkill *rfkill = (struct b43_rfkill *)data;
+	schedule_work(&rfkill->poll_queue);
+}
+
+static void b43_rfkill_work(struct work_struct *work)
+{
+	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
+					      poll_queue);
+	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
+	struct b43_wldev *dev = wl->current_dev;
+
+	b43_rfkill_update(dev);
+	rfk->poll_timer.function = b43_rfkill_poll;
+	rfk->poll_timer.expires = round_jiffies(jiffies + HZ);
+	add_timer(&rfk->poll_timer);
 }
 
 /* Called when the RFKILL toggled in software. */
@@ -141,48 +161,23 @@ void b43_rfkill_init(struct b43_wldev *d
 	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
 	rfk->rfkill->user_claim_unsupported = 1;
 
-	rfk->poll_dev = input_allocate_polled_device();
-	if (!rfk->poll_dev) {
-		rfkill_free(rfk->rfkill);
-		goto err_freed_rfk;
-	}
-
-	rfk->poll_dev->private = dev;
-	rfk->poll_dev->poll = b43_rfkill_poll;
-	rfk->poll_dev->poll_interval = 1000; /* msecs */
-
-	rfk->poll_dev->input->name = rfk->name;
-	rfk->poll_dev->input->id.bustype = BUS_HOST;
-	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
-	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
-
 	err = rfkill_register(rfk->rfkill);
 	if (err)
-		goto err_free_polldev;
+		goto err_free_rfk;
 
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
-	if (err)
-		b43warn(wl, "Failed to load the rfkill-input module. "
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
+	rfk->registered = 1;
 
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+	INIT_WORK(&rfk->poll_queue, b43_rfkill_work);
 
-	rfk->registered = 1;
+	init_timer(&rfk->poll_timer);
+	rfk->poll_timer.function = b43_rfkill_poll;
+	rfk->poll_timer.expires = round_jiffies(jiffies + HZ);
+	rfk->poll_timer.data = (unsigned long)rfk;
+	add_timer(&rfk->poll_timer);
 
 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-err_freed_rfk:
+err_free_rfk:
+	rfkill_free(rfk->rfkill);
 	rfk->rfkill = NULL;
 out_error:
 	rfk->registered = 0;
@@ -197,9 +192,8 @@ void b43_rfkill_exit(struct b43_wldev *d
 		return;
 	rfk->registered = 0;
 
-	input_unregister_polled_device(rfk->poll_dev);
+	del_timer(&rfk->poll_timer);
+
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
 	rfk->rfkill = NULL;
 }
Index: wireless-testing/drivers/net/wireless/b43/rfkill.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.h
+++ wireless-testing/drivers/net/wireless/b43/rfkill.h
@@ -7,14 +7,14 @@ struct b43_wldev;
 #ifdef CONFIG_B43_RFKILL
 
 #include <linux/rfkill.h>
-#include <linux/input-polldev.h>
-
 
 struct b43_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
+	/* The timer list for the RFKILL polling */
+	struct timer_list poll_timer;
+	/* Workqueue for the RFKILL polling */
+	struct work_struct poll_queue;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */
