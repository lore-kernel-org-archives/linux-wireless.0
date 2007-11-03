Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56254
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbXKCNhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2007 09:37:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite and fix rfkill init
Date: Sat, 3 Nov 2007 14:34:32 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711031434.32541.mb@bu3sch.de> (sfid-20071103_133803_695526_26755617)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rfkill subsystem doesn't like code like that
rfkill_allocate();
rfkill_register();
rfkill_unregister();
rfkill_register(); /* <- This will crash */

This sequence happens with
modprobe b43
ifconfig wlanX up
ifconfig wlanX down
ifconfig wlanX up

Fix this by always re-allocating the rfkill stuff before register.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Note that this has to be ported to b43legacy.
Some volunteers? :)


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-11-03 14:19:21.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-11-03 14:26:39.000000000 +0100
@@ -3686,7 +3686,6 @@ static int b43_setup_modes(struct b43_wl
 
 static void b43_wireless_core_detach(struct b43_wldev *dev)
 {
-	b43_rfkill_free(dev);
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43_release_firmware(dev);
@@ -3772,7 +3771,6 @@ static int b43_wireless_core_attach(stru
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
-	b43_rfkill_alloc(dev);
 
 	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c	2007-11-02 20:16:14.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c	2007-11-03 14:19:38.000000000 +0100
@@ -47,18 +47,21 @@ static void b43_rfkill_poll(struct input
 	struct b43_wldev *dev = poll_dev->private;
 	struct b43_wl *wl = dev->wl;
 	bool enabled;
+	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
 	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
+		report_change = 1;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
-		mutex_unlock(&wl->mutex);
+	}
+	mutex_unlock(&wl->mutex);
+
+	if (unlikely(report_change))
 		input_report_key(poll_dev->input, KEY_WLAN, enabled);
-	} else
-		mutex_unlock(&wl->mutex);
 }
 
 /* Called when the RFKILL toggled in software. */
@@ -68,18 +71,11 @@ static int b43_rfkill_soft_toggle(void *
 	struct b43_wl *wl = dev->wl;
 	int err = 0;
 
-	/* When RFKILL is registered, it will call back into this callback.
-	 * wl->mutex will already be locked when this happens.
-	 * So first trylock. On contention check if we are in initialization.
-	 * Silently return if that happens to avoid a deadlock. */
-	if (mutex_trylock(&wl->mutex) == 0) {
-		if (b43_status(dev) < B43_STAT_INITIALIZED)
-			return 0;
-		mutex_lock(&wl->mutex);
-	}
-	if (b43_status(dev) < B43_STAT_INITIALIZED)
-		goto out_unlock;
+	if (!wl->rfkill.registered)
+		return 0;
 
+	mutex_lock(&wl->mutex);
+	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
 	switch (state) {
 	case RFKILL_STATE_ON:
 		if (!dev->radio_hw_enable) {
@@ -104,11 +100,11 @@ out_unlock:
 
 char * b43_rfkill_led_name(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
-	if (!wl->rfkill.rfkill)
+	if (!rfk->registered)
 		return NULL;
-	return rfkill_get_led_name(wl->rfkill.rfkill);
+	return rfkill_get_led_name(rfk->rfkill);
 }
 
 void b43_rfkill_init(struct b43_wldev *dev)
@@ -117,53 +113,13 @@ void b43_rfkill_init(struct b43_wldev *d
 	struct b43_rfkill *rfk = &(wl->rfkill);
 	int err;
 
-	if (rfk->rfkill) {
-		err = rfkill_register(rfk->rfkill);
-		if (err) {
-			b43warn(wl, "Failed to register RF-kill button\n");
-			goto err_free_rfk;
-		}
-	}
-	if (rfk->poll_dev) {
-		err = input_register_polled_device(rfk->poll_dev);
-		if (err) {
-			b43warn(wl, "Failed to register RF-kill polldev\n");
-			goto err_free_polldev;
-		}
-	}
-
-	return;
-err_free_rfk:
-	rfkill_free(rfk->rfkill);
-	rfk->rfkill = NULL;
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
-}
-
-void b43_rfkill_exit(struct b43_wldev *dev)
-{
-	struct b43_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (rfk->poll_dev)
-		input_unregister_polled_device(rfk->poll_dev);
-	if (rfk->rfkill)
-		rfkill_unregister(rfk->rfkill);
-}
-
-void b43_rfkill_alloc(struct b43_wldev *dev)
-{
-	struct b43_wl *wl = dev->wl;
-	struct b43_rfkill *rfk = &(wl->rfkill);
+	rfk->registered = 0;
 
+	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
+	if (!rfk->rfkill)
+		goto out_error;
 	snprintf(rfk->name, sizeof(rfk->name),
 		 "b43-%s", wiphy_name(wl->hw->wiphy));
-
-	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
-	if (!rfk->rfkill) {
-		b43warn(wl, "Failed to allocate RF-kill button\n");
-		return;
-	}
 	rfk->rfkill->name = rfk->name;
 	rfk->rfkill->state = RFKILL_STATE_ON;
 	rfk->rfkill->data = dev;
@@ -171,18 +127,45 @@ void b43_rfkill_alloc(struct b43_wldev *
 	rfk->rfkill->user_claim_unsupported = 1;
 
 	rfk->poll_dev = input_allocate_polled_device();
-	if (rfk->poll_dev) {
-		rfk->poll_dev->private = dev;
-		rfk->poll_dev->poll = b43_rfkill_poll;
-		rfk->poll_dev->poll_interval = 1000; /* msecs */
-	} else
-		b43warn(wl, "Failed to allocate RF-kill polldev\n");
+	if (!rfk->poll_dev)
+		goto err_free_rfk;
+	rfk->poll_dev->private = dev;
+	rfk->poll_dev->poll = b43_rfkill_poll;
+	rfk->poll_dev->poll_interval = 1000; /* msecs */
+
+	err = rfkill_register(rfk->rfkill);
+	if (err)
+		goto err_free_polldev;
+	err = input_register_polled_device(rfk->poll_dev);
+	if (err)
+		goto err_unreg_rfk;
+
+	rfk->registered = 1;
+
+	return;
+err_unreg_rfk:
+	rfkill_unregister(rfk->rfkill);
+err_free_polldev:
+	input_free_polled_device(rfk->poll_dev);
+	rfk->poll_dev = NULL;
+err_free_rfk:
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+out_error:
+	rfk->registered = 0;
+	b43warn(wl, "RF-kill button init failed\n");
 }
 
-void b43_rfkill_free(struct b43_wldev *dev)
+void b43_rfkill_exit(struct b43_wldev *dev)
 {
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
+	if (!rfk->registered)
+		return;
+	rfk->registered = 0;
+
+	input_unregister_polled_device(rfk->poll_dev);
+	rfkill_unregister(rfk->rfkill);
 	input_free_polled_device(rfk->poll_dev);
 	rfk->poll_dev = NULL;
 	rfkill_free(rfk->rfkill);
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.h	2007-10-27 13:28:16.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.h	2007-11-03 14:19:38.000000000 +0100
@@ -15,14 +15,14 @@ struct b43_rfkill {
 	struct rfkill *rfkill;
 	/* The poll device for the RFKILL input button */
 	struct input_polled_dev *poll_dev;
+	/* Did initialization succeed? Used for freeing. */
+	bool registered;
 	/* The unique name of this rfkill switch */
-	char name[32];
+	char name[sizeof("b43-phy4294967295")];
 };
 
-/* All the init functions return void, because we are not interested
+/* The init function returns void, because we are not interested
  * in failing the b43 init process when rfkill init failed. */
-void b43_rfkill_alloc(struct b43_wldev *dev);
-void b43_rfkill_free(struct b43_wldev *dev);
 void b43_rfkill_init(struct b43_wldev *dev);
 void b43_rfkill_exit(struct b43_wldev *dev);
 
@@ -36,12 +36,6 @@ struct b43_rfkill {
 	/* empty */
 };
 
-static inline void b43_rfkill_alloc(struct b43_wldev *dev)
-{
-}
-static inline void b43_rfkill_free(struct b43_wldev *dev)
-{
-}
 static inline void b43_rfkill_init(struct b43_wldev *dev)
 {
 }
