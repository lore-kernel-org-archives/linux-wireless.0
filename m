Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753697AbXKFWND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:13:03 -0500
Date: Tue, 6 Nov 2007 22:48:45 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH 4/7] b43legacy: rewrite and fix rfkill initialization
Message-ID: <20071106224845.7735a4f1@morte> (sfid-20071106_221309_099653_A3AA17B7)
In-Reply-To: <20071106222313.31e9bcd9@morte>
References: <20071106222313.31e9bcd9@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to
b43legacy.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

----

Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
@@ -48,18 +48,21 @@ static void b43legacy_rfkill_poll(struct
 	struct b43legacy_wldev *dev = poll_dev->private;
 	struct b43legacy_wl *wl = dev->wl;
 	bool enabled;
+	bool report_change = 0;
 
 	mutex_lock(&wl->mutex);
 	B43legacy_WARN_ON(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED);
 	enabled = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
+		report_change = 1;
 		b43legacyinfo(wl, "Radio hardware status changed to %s\n",
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
@@ -69,18 +72,11 @@ static int b43legacy_rfkill_soft_toggle(
 	struct b43legacy_wl *wl = dev->wl;
 	int err = 0;
 
-	/* When RFKILL is registered, it will call back into this callback.
-	 * wl->mutex will already be locked when this happens.
-	 * So first trylock. On contention check if we are in initialization.
-	 * Silently return if that happens to avoid a deadlock. */
-	if (mutex_trylock(&wl->mutex) == 0) {
-		if (b43legacy_status(dev) < B43_STAT_INITIALIZED)
-			return 0;
-		mutex_lock(&wl->mutex);
-	}
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
-		goto out_unlock;
+	if (!wl->rfkill.registered)
+		return 0;
 
+	mutex_lock(&wl->mutex);
+	B43legacy_WARN_ON(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED);
 	switch (state) {
 	case RFKILL_STATE_ON:
 		if (!dev->radio_hw_enable) {
Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/rfkill.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
@@ -16,14 +16,14 @@ struct b43legacy_rfkill {
 	struct rfkill *rfkill;
 	/* The poll device for the RFKILL input button */
 	struct input_polled_dev *poll_dev;
+	/* Did initialization succeed? Used for freeing. */
+	bool registered;
 	/* The unique name of this rfkill switch */
-	char name[32];
+	char name[sizeof("b43legacy-phy4294967295")];
 };
 
-/* All the init functions return void, because we are not interested
+/* The init function returns void, because we are not interested
  * in failing the b43 init process when rfkill init failed. */
-void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev);
-void b43legacy_rfkill_free(struct b43legacy_wldev *dev);
 void b43legacy_rfkill_init(struct b43legacy_wldev *dev);
 void b43legacy_rfkill_exit(struct b43legacy_wldev *dev);

Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -3360,7 +3381,6 @@ static int b43legacy_setup_modes(struct b43legacy_wldev *dev,
 
 static void b43legacy_wireless_core_detach(struct b43legacy_wldev *dev)
 {
-	b43legacy_rfkill_free(dev);
 	/* We release firmware that late to not be required to re-request
 	 * is all the time when we reinit the core. */
 	b43legacy_release_firmware(dev);
@@ -3442,7 +3462,6 @@ static int b43legacy_wireless_core_attach(struct b43legacy_wldev *dev)
 	if (!wl->current_dev)
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43legacy_chip_reset);
-	b43legacy_rfkill_alloc(dev);
 
 	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_switch_analog(dev, 0);



-- 
Ciao
Stefano
