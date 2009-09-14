Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41305 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbZINVWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 17:22:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Don't abuse wl->current_dev in the led work
Date: Mon, 14 Sep 2009 23:22:08 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909142322.09152.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't abuse wl->current_dev in the LED work for checking whether we're
going down. Add an explicit variable.
This fixes a crash on rmmod dereferencing the wl->current_dev NULL pointer
in various other places of the driver.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Note to self: Don't try to safe a byte of memory :)


Index: wireless-testing/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.c	2009-09-14 22:42:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.c	2009-09-14 23:15:39.000000000 +0200
@@ -112,10 +112,7 @@ static void b43_led_brightness_set(struc
 	struct b43_led *led = container_of(led_dev, struct b43_led, led_dev);
 	struct b43_wl *wl = led->wl;
 
-	/* The check for current_dev is only needed while unregistering,
-	 * so it is sequencial and does not race. But we must not dereference
-	 * current_dev here. */
-	if (likely(wl->current_dev)) {
+	if (likely(!wl->leds.stop)) {
 		atomic_set(&led->state, brightness);
 		ieee80211_queue_work(wl->hw, &wl->leds.work);
 	}
@@ -314,6 +311,8 @@ void b43_leds_init(struct b43_wldev *dev
 			break;
 		}
 	}
+
+	dev->wl->leds.stop = 0;
 }
 
 void b43_leds_exit(struct b43_wldev *dev)
Index: wireless-testing/drivers/net/wireless/b43/leds.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.h	2009-09-14 22:42:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/leds.h	2009-09-14 23:13:38.000000000 +0200
@@ -35,6 +35,7 @@ struct b43_leds {
 	struct b43_led led_radio;
 	struct b43_led led_assoc;
 
+	bool stop;
 	struct work_struct work;
 };
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-14 23:11:17.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-14 23:14:39.000000000 +0200
@@ -4987,7 +4987,7 @@ static void b43_remove(struct ssb_device
 		 * might have modified it. Restoring is important, so the networking
 		 * stack can properly free resources. */
 		wl->hw->queues = wl->mac80211_initially_registered_queues;
-		wl->current_dev = NULL;
+		wl->leds.stop = 1;
 		cancel_work_sync(&wl->leds.work);
 		ieee80211_unregister_hw(wl->hw);
 	}

-- 
Greetings, Michael.
