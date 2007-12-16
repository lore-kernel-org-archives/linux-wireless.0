Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48692 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbXLPWJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:09:26 -0500
Subject: Re: b43 problem with led trigger registration
From: Richard Purdie <rpurdie@openedhand.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200712162157.00759.mb@bu3sch.de>
References: <1197822019.4138.2.camel@johannes.berg>
	 <1197837505.6769.25.camel@johannes.berg>
	 <1197837799.4653.21.camel@localhost.localdomain>
	 <200712162157.00759.mb@bu3sch.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 22:09:22 +0000
Message-Id: <1197842962.4653.27.camel@localhost.localdomain> (sfid-20071216_220928_991580_AD41612E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-12-16 at 21:57 +0100, Michael Buesch wrote:
> On Sunday 16 December 2007 21:43:19 Richard Purdie wrote:
> > On Sun, 2007-12-16 at 21:38 +0100, Johannes Berg wrote:
> > > > > drivers/leds/led-triggers.c:led_trigger_register:
> > > > > 
> > > > > |        read_lock(&leds_list_lock);
> > > > > |        list_for_each_entry(led_cdev, &leds_list, node) {
> > > > > |                down_write(&led_cdev->trigger_lock);
> > > > > 
> > > > > introduced in
> > > > > 
> > > > > commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
> > > > > Author: Richard Purdie <rpurdie@rpsys.net>
> > > > > Date:   Sat Nov 10 13:29:04 2007 +0000
> > > > > 
> > > > >     leds: Fix led trigger locking bugs
> > > > > 
> > > > > I guess the read_lock needs to be a mutex/rw semaphore.
> > > > 
> > > > Uh, yes. Was this patch tested at all?
> > > 
> > > Not with default triggers, I guess. The code in question only triggers
> > > when a default is assigned to any LED I think.
> > 
> > Amongst other things it was tested on the Zaurus which has default
> > triggers. What is the problem you're seeing?
> 
> You are scheduling (down_write) while holding a spinlock (leds_list_lock).

Eeek, yes, its the LED core's fault.
dc47206e552c0850ad11f7e9a1fca0a3c92f5d65 is needed for various reasons
but that means the patch below is also needed. Its been compile tested,
once its runtime tested I'll push asap.

Richard

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index ba8b04b..64c66b3 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -106,9 +106,9 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 		goto err_out;
 
 	/* add to the list of leds */
-	write_lock(&leds_list_lock);
+	down_write(&leds_list_lock);
 	list_add_tail(&led_cdev->node, &leds_list);
-	write_unlock(&leds_list_lock);
+	up_write(&leds_list_lock);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
@@ -155,9 +155,9 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
 
 	device_unregister(led_cdev->dev);
 
-	write_lock(&leds_list_lock);
+	down_write(&leds_list_lock);
 	list_del(&led_cdev->node);
-	write_unlock(&leds_list_lock);
+	up_write(&leds_list_lock);
 }
 EXPORT_SYMBOL_GPL(led_classdev_unregister);
 
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 9b015f9..5d1ca10 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -14,11 +14,11 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/rwsem.h>
 #include <linux/leds.h>
 #include "leds.h"
 
-DEFINE_RWLOCK(leds_list_lock);
+DECLARE_RWSEM(leds_list_lock);
 LIST_HEAD(leds_list);
 
 EXPORT_SYMBOL_GPL(leds_list);
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 0bdb786..13c9026 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -169,7 +169,7 @@ int led_trigger_register(struct led_trigger *trigger)
 	up_write(&triggers_list_lock);
 
 	/* Register with any LEDs that have this as a default trigger */
-	read_lock(&leds_list_lock);
+	down_read(&leds_list_lock);
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		down_write(&led_cdev->trigger_lock);
 		if (!led_cdev->trigger && led_cdev->default_trigger &&
@@ -177,7 +177,7 @@ int led_trigger_register(struct led_trigger *trigger)
 			led_trigger_set(led_cdev, trigger);
 		up_write(&led_cdev->trigger_lock);
 	}
-	read_unlock(&leds_list_lock);
+	up_read(&leds_list_lock);
 
 	return 0;
 }
@@ -212,14 +212,14 @@ void led_trigger_unregister(struct led_trigger *trigger)
 	up_write(&triggers_list_lock);
 
 	/* Remove anyone actively using this trigger */
-	read_lock(&leds_list_lock);
+	down_read(&leds_list_lock);
 	list_for_each_entry(led_cdev, &leds_list, node) {
 		down_write(&led_cdev->trigger_lock);
 		if (led_cdev->trigger == trigger)
 			led_trigger_set(led_cdev, NULL);
 		up_write(&led_cdev->trigger_lock);
 	}
-	read_unlock(&leds_list_lock);
+	up_read(&leds_list_lock);
 }
 
 void led_trigger_unregister_simple(struct led_trigger *trigger)
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index f2f3884..12b6fe9 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -14,6 +14,7 @@
 #define __LEDS_H_INCLUDED
 
 #include <linux/device.h>
+#include <linux/rwsem.h>
 #include <linux/leds.h>
 
 static inline void led_set_brightness(struct led_classdev *led_cdev,
@@ -26,7 +27,7 @@ static inline void led_set_brightness(struct led_classdev *led_cdev,
 		led_cdev->brightness_set(led_cdev, value);
 }
 
-extern rwlock_t leds_list_lock;
+extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
 
 #ifdef CONFIG_LEDS_TRIGGERS

