Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZDBUu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 16:50:58 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D521BF.2080301@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
	 <1238698084.7630.3.camel@johannes.local>
	 (sfid-20090402_204842_882765_82560824) <1238698667.7630.7.camel@johannes.local>
	 <49D521BF.2080301@lwfinger.net>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 22:50:20 +0200
Message-Id: <1238705420.8363.14.camel@johannes.local> (sfid-20090402_225103_528998_5C4277AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-04-02 at 15:36 -0500, Larry Finger wrote:

> > In drivers/leds/led-triggers.c in led_trigger_show you have
> > 
> >         list_for_each_entry(trig, &trigger_list, next_trig) {
> > +		printk(KERN_DEBUG "available trigger: %s\n", trig->name);
> >                 if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
> >                                                         trig->name))
> >                         len += sprintf(buf+len, "[%s] ", trig->name);
> >                 else
> >                         len += sprintf(buf+len, "%s ", trig->name);
> >         }
> > 
> > could you do the modification, with a kernel that has the TRIG_NAME_MAX
> > set to 50, and see what it prints? I'm completely confused by this
> > failure mode since the garbage you get is actually put into brackets, so
> > it seems the strcmp() is returning 0 which seems odd.
> 
> Have I told you that I hate things that appear to be intermittent?

I share that feeling.

> I added the printk, returned TRIG_NAME_MAX to 50, rebuilt and rebooted. This
> time I got
> 
> ~/wireless-testing> cat /sys/class/leds/b43legacy-phy0\:\:rad/trigger
> none ide-disk ADP1-online BAT0-charging-or-full BAT0-charging BAT0-full phy0rx
> phy0tx phy0assoc phy0radio [rfkill0]
> ~/wireless-testing> dmesg | grep available
> available trigger: ide-disk
> available trigger: ADP1-online
> available trigger: BAT0-charging-or-full
> available trigger: BAT0-charging
> available trigger: BAT0-full
> available trigger: phy0rx
> available trigger: phy0tx
> available trigger: phy0assoc
> available trigger: phy0radio
> available trigger: rfkill0
> 
> I'll leave the printk in place for the moment.

Fun.

> The name is being truncated by "#define BUS_ID_SIZE 20" in
> include/linux/device.h. As changing that define would be pretty invasive, I plan
> to use a shorter name when the LED is registered.
> 
> The bad news is that the set brightness callback routine is still not being
> called even though I tried BUS_ID_SIZE of 30..

Ah, yes. Using a shorter name is probably a good idea then. I don't
think changing that define makes too much sense.

On my test with iwlwifi the rfkill LED trigger is definitely called -- I
cannot pinpoint why it shouldn't be on your setup. :(

Actually. Are you positive it works without my patch? The confusing this
is that this code never seems to call led_trigger_event() outside of
rfkill_led_trigger_activate() which is only called once... Can you try
this patch please?

johannes

---
 net/rfkill/core.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/rfkill/core.c	2009-04-02 22:47:05.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-04-02 22:49:53.000000000 +0200
@@ -83,12 +83,10 @@ static bool rfkill_epo_lock_active;
 
 
 #ifdef CONFIG_RFKILL_LEDS
-static void rfkill_led_trigger_activate(struct led_classdev *led)
+static void rfkill_led_trigger_event(struct rfkill *rfkill)
 {
-	struct rfkill *rfkill;
 	struct led_trigger *trigger;
 
-	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
 	trigger = &rfkill->led_trigger;
 
 	if (rfkill->blocked)
@@ -97,6 +95,15 @@ static void rfkill_led_trigger_activate(
 		led_trigger_event(trigger, LED_FULL);
 }
 
+static void rfkill_led_trigger_activate(struct led_classdev *led)
+{
+	struct rfkill *rfkill;
+
+	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
+
+	rfkill_led_trigger_event(rfkill);
+}
+
 const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
 {
 	return rfkill->led_trigger.name;
@@ -124,6 +131,10 @@ static void rfkill_led_trigger_unregiste
 	led_trigger_unregister(&rfkill->led_trigger);
 }
 #else
+static void rfkill_led_trigger_event(struct rfkill *rfkill)
+{
+}
+
 static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
 {
 	return 0;
@@ -158,6 +169,8 @@ static bool __rfkill_set_hw_state(struct
 
 	*change = prev != blocked;
 
+	rfkill_led_trigger_event(rfkill);
+
 	return blocked || !!test_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
 }
 
@@ -214,6 +227,7 @@ static void rfkill_set_block(struct rfki
 			clear_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
 	}
 
+	rfkill_led_trigger_event(rfkill);
 	rfkill_uevent(rfkill);
 }
 
@@ -400,6 +414,8 @@ bool rfkill_set_sw_state(struct rfkill *
 	if (prev != blocked && !hwblock)
 		schedule_work(&rfkill->uevent_work);
 
+	rfkill_led_trigger_event(rfkill);
+
 	return blocked || hwblock;
 }
 EXPORT_SYMBOL(rfkill_set_sw_state);


