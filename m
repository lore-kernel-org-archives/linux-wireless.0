Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:55817 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbXK0UDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 15:03:04 -0500
Message-ID: <474C77E7.9030202@lwfinger.net> (sfid-20071127_211141_559489_7B7CAF3D)
Date: Tue, 27 Nov 2007 14:02:47 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC/T V2] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de>
In-Reply-To: <200711271713.02698.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I'm getting a little closer. The problem I discovered now is that b43_leds_init() was being called
before b43_rfkill_init(), which prevented registration of the "radio" LED. Now, the LED is flashed
on for about 1 second, then it goes off. Changing the switch does nothing.

This version uses mutex_trylock() to see if the mutex is already locked. It should do until rfkill
is fixed.

Note to testers: This version does not work. I'm sending it out to get comments.

Larry


Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
@@ -70,11 +70,12 @@ static int b43_rfkill_soft_toggle(void *
 	struct b43_wldev *dev = data;
 	struct b43_wl *wl = dev->wl;
 	int err = 0;
+	int have_lock;

 	if (!wl->rfkill.registered)
 		return 0;

-	mutex_lock(&wl->mutex);
+	have_lock = mutex_trylock(&wl->mutex);
 	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
 	switch (state) {
 	case RFKILL_STATE_ON:
@@ -93,7 +94,8 @@ static int b43_rfkill_soft_toggle(void *
 		break;
 	}
 out_unlock:
-	mutex_unlock(&wl->mutex);
+	if (have_lock)
+		mutex_unlock(&wl->mutex);

 	return err;
 }
@@ -133,6 +135,12 @@ void b43_rfkill_init(struct b43_wldev *d
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
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c
+++ wireless-2.6/drivers/net/wireless/b43/main.c
@@ -2184,7 +2184,6 @@ static int b43_chip_init(struct b43_wlde
 	err = b43_gpio_init(dev);
 	if (err)
 		goto out;	/* firmware is released later */
-	b43_leds_init(dev);

 	err = b43_upload_initvals(dev);
 	if (err)
@@ -3411,6 +3410,7 @@ static int b43_wireless_core_init(struct
 	b43_security_init(dev);
 	b43_rfkill_init(dev);
 	b43_rng_init(wl);
+	b43_leds_init(dev);

 	b43_set_status(dev, B43_STAT_INITIALIZED);



======
