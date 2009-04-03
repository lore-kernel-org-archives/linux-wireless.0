Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37252 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDCEh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 00:37:58 -0400
Subject: Re: How does rfkill work?
From: Marcel Holtmann <marcel@holtmann.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Kay Sievers <kay.sievers@vrfy.org>
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
Date: Fri, 03 Apr 2009 06:37:54 +0200
Message-Id: <1238733474.19390.2.camel@violet> (sfid-20090403_063802_954300_2479ECBC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> > On Thu, 2009-04-02 at 20:48 +0200, Johannes Berg wrote:
> > 
> > Could you try something for me?
> > 
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
> 
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
> 
> The name is being truncated by "#define BUS_ID_SIZE 20" in
> include/linux/device.h. As changing that define would be pretty invasive, I plan
> to use a shorter name when the LED is registered.

I am under the impression that all these limitations are going away. Did
you talk to Kay or Greg about this?

Regards

Marcel


