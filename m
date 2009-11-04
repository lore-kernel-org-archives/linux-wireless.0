Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55667 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbZKDPaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 10:30:22 -0500
Received: by ewy3 with SMTP id 3so3208473ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2009 07:30:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when LEDS enabled (Bugzilla #14539)
Date: Wed, 4 Nov 2009 16:30:19 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com>
In-Reply-To: <20091104151132.GD12965@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911041630.20122.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 16:11:33 John W. Linville wrote:
> On Wed, Nov 04, 2009 at 12:00:25AM -0600, Larry Finger wrote:
> > As reported by Rick Farina (sidhayn@gmail.com), removing the RTL8187 USB
> > stick, or unloading the driver rtl8187 using rmmod will cause a kernel oops.
> > There are at least two forms of the failure, (1) BUG: Scheduling while atomic,
> > and (2) a fatal kernel page fault. This problem is reported in Bugzilla #14539.
> > 
> > This problem does not occur for kernel 2.6.31, but does for 2.6.32-rc2, thus
> > it is technically a regression; however, bisection did not locate any faulty
> > patch. The fix was found by comparing the faulty code in rtl8187 with p54usb.
> > My interpretation is that the handling of work queues in mac80211 changed
> > enough to the LEDs to be unregistered before tasks on the work queues are
> > cancelled. Previously, these actions could be done in either order.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Reported-and-tested by: Rick Farina <sidhayn@gmail.com>
> > ---
> > 
> > John,
> > 
> > This is 2.6.32 material. Sorry to take so long to get a patch, but it was
> > difficult for me to locate the problem. Fortunately, I had the postings of the
> > two flame wars to amuse me while all the kernel compilations were happening.
> > 
> > Larry
> > ---
> > 
> > Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > @@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_
> >  
> >  	/* turn the LED off before exiting */
> >  	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> > -	cancel_delayed_work_sync(&priv->led_off);
> > -	cancel_delayed_work_sync(&priv->led_on);
> >  	rtl8187_unregister_led(&priv->led_rx);
> >  	rtl8187_unregister_led(&priv->led_tx);
> > +	cancel_delayed_work_sync(&priv->led_off);
> > +	cancel_delayed_work_sync(&priv->led_on);
> >  }
> >  #endif /* def CONFIG_RTL8187_LED */
> >  
> 
> This seems like a band-aid.  If anything, the original order would
> seem to make more sense.

really?

take this code from led-class.c

void led_classdev_unregister(struct led_classdev *led_cdev)
{
        device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
        device_remove_file(led_cdev->dev, &dev_attr_brightness);
#ifdef CONFIG_LEDS_TRIGGERS
        device_remove_file(led_cdev->dev, &dev_attr_trigger);
        down_write(&led_cdev->trigger_lock);
        if (led_cdev->trigger)
                led_trigger_set(led_cdev, NULL);
        up_write(&led_cdev->trigger_lock);
#endif

        device_unregister(led_cdev->dev);

        down_write(&leds_list_lock);
        list_del(&led_cdev->node);
        up_write(&leds_list_lock);
}

as you can see the led is switched-off right before the device is unregistered.
but rtl8187, p54 & ar9170 led-triggers are timed & asynchronous. So
we really need a cancel_delayed_work_sync after the unregister routine
finished... else the timed trigger might fire when the device/module
is _faded_ from memory.
 
