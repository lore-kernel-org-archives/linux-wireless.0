Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:35695 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYGAKTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:19:38 -0400
Received: by fg-out-1718.google.com with SMTP id 19so925446fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 03:19:36 -0700 (PDT)
Message-ID: <6cf6b73e0807010319x88f3624x83465cc314d8962f@mail.gmail.com> (sfid-20080701_121942_177996_867193FC)
Date: Tue, 1 Jul 2008 12:19:35 +0200
From: "Adel Gadllah" <adel.gadllah@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: [PATCH/RFC v3] b43: remove input device usage for rfkill
Cc: linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>,
	stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <1214906908.7763.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com>
	 <1214906304.7763.34.camel@johannes.berg>
	 <6cf6b73e0807010305ne1c4b3bwb083c25953292f9d@mail.gmail.com>
	 <1214906908.7763.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/1 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2008-07-01 at 12:05 +0200, Adel Gadllah wrote:
>> 2008/7/1 Johannes Berg <johannes@sipsolutions.net>:
>> >
>> >> +     rfk->poll_timer->expires = jiffies + B43_RFKILL_POLL_DELAY;
>> >
>> > round_jiffies.
>>
>> v2 attached.
>
> That wasn't meant _literally_ but _conceptually_. You want that in the
> other places too.

ok, done in v3.

------------------------
This patch removes the dependency on the input device and replaces the
polldev with a timer for polling the rfkill state.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 1fa043d..af15e5c 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -91,7 +91,7 @@ config B43_LEDS
 # if it's possible.
 config B43_RFKILL
 	bool
-	depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT &&
(INPUT_POLLDEV = y || INPUT_POLLDEV = B43)
+	depends on B43 && (RFKILL = y || RFKILL = B43)
 	default y

 config B43_DEBUG
diff --git a/drivers/net/wireless/b43/rfkill.c
b/drivers/net/wireless/b43/rfkill.c
index fec5645..8a2f604 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -61,34 +61,29 @@ static void b43_rfkill_update_state(struct b43_wldev *dev)
 }

 /* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct input_polled_dev *poll_dev)
+static void b43_rfkill_poll(unsigned long data)
 {
-	struct b43_wldev *dev = poll_dev->private;
+	struct b43_wldev *dev = (struct b43_wldev *) data;
 	struct b43_wl *wl = dev->wl;
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 	bool enabled;
-	bool report_change = 0;

 	mutex_lock(&wl->mutex);
-	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
-		mutex_unlock(&wl->mutex);
-		return;
-	}
+	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED))
+		goto out;
+
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
-		report_change = 1;
 		b43_rfkill_update_state(dev);
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
 	}
-	mutex_unlock(&wl->mutex);
+out:
+	rfk->poll_timer->expires += round_jiffies(B43_RFKILL_POLL_DELAY);
+	add_timer(rfk->poll_timer);

-	/* send the radio switch event to the system - note both a key press
-	 * and a release are required */
-	if (unlikely(report_change)) {
-		input_report_key(poll_dev->input, KEY_WLAN, 1);
-		input_report_key(poll_dev->input, KEY_WLAN, 0);
-	}
+	mutex_unlock(&wl->mutex);
 }

 /* Called when the RFKILL toggled in software. */
@@ -158,51 +153,24 @@ void b43_rfkill_init(struct b43_wldev *dev)
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
+	setup_timer(rfk->poll_timer, &b43_rfkill_poll, (unsigned long) dev);
+	rfk->poll_timer->expires =
+		round_jiffies(jiffies + B43_RFKILL_POLL_DELAY);

 	err = rfkill_register(rfk->rfkill);
 	if (err)
-		goto err_free_polldev;
-
-#ifdef CONFIG_RFKILL_INPUT_MODULE
-	/* B43 RF-kill isn't useful without the rfkill-input subsystem.
-	 * Try to load the module. */
-	err = request_module("rfkill-input");
-	if (err)
-		b43warn(wl, "Failed to load the rfkill-input module. "
-			"The built-in radio LED will not work.\n");
-#endif /* CONFIG_RFKILL_INPUT */
-
-	err = input_register_polled_device(rfk->poll_dev);
-	if (err)
-		goto err_unreg_rfk;
+		goto err_freed_rfk;

 	rfk->registered = 1;
+	add_timer(rfk->poll_timer);

 	return;
-err_unreg_rfk:
-	rfkill_unregister(rfk->rfkill);
-err_free_polldev:
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
+
 err_freed_rfk:
 	rfk->rfkill = NULL;
 out_error:
 	rfk->registered = 0;
+	del_timer_sync(rfk->poll_timer);
 	b43warn(wl, "RF-kill button init failed\n");
 }

@@ -213,10 +181,7 @@ void b43_rfkill_exit(struct b43_wldev *dev)
 	if (!rfk->registered)
 		return;
 	rfk->registered = 0;
-
-	input_unregister_polled_device(rfk->poll_dev);
+	del_timer_sync(rfk->poll_timer);
 	rfkill_unregister(rfk->rfkill);
-	input_free_polled_device(rfk->poll_dev);
-	rfk->poll_dev = NULL;
 	rfk->rfkill = NULL;
 }
diff --git a/drivers/net/wireless/b43/rfkill.h
b/drivers/net/wireless/b43/rfkill.h
index adacf93..d25fbbd 100644
--- a/drivers/net/wireless/b43/rfkill.h
+++ b/drivers/net/wireless/b43/rfkill.h
@@ -7,14 +7,16 @@ struct b43_wldev;
 #ifdef CONFIG_B43_RFKILL

 #include <linux/rfkill.h>
-#include <linux/input-polldev.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>

+#define B43_RFKILL_POLL_DELAY msecs_to_jiffies(1000)

 struct b43_rfkill {
 	/* The RFKILL subsystem data structure */
 	struct rfkill *rfkill;
-	/* The poll device for the RFKILL input button */
-	struct input_polled_dev *poll_dev;
+	/* Timer for polling the rfkill state */
+	struct timer_list *poll_timer;
 	/* Did initialization succeed? Used for freeing. */
 	bool registered;
 	/* The unique name of this rfkill switch */
