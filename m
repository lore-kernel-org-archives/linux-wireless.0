Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54564 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZKDRAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:00:14 -0500
Date: Wed, 4 Nov 2009 11:49:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when
	LEDS enabled (Bugzilla #14539)
Message-ID: <20091104164938.GG12965@tuxdriver.com>
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <20091104151132.GD12965@tuxdriver.com> <200911041630.20122.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911041630.20122.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 04:30:19PM +0100, Christian Lamparter wrote:
> On Wednesday 04 November 2009 16:11:33 John W. Linville wrote:

> > This seems like a band-aid.  If anything, the original order would
> > seem to make more sense.
> 
> really?
> 
> take this code from led-class.c
> 
> void led_classdev_unregister(struct led_classdev *led_cdev)
> {
>         device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
>         device_remove_file(led_cdev->dev, &dev_attr_brightness);
> #ifdef CONFIG_LEDS_TRIGGERS
>         device_remove_file(led_cdev->dev, &dev_attr_trigger);
>         down_write(&led_cdev->trigger_lock);
>         if (led_cdev->trigger)
>                 led_trigger_set(led_cdev, NULL);
>         up_write(&led_cdev->trigger_lock);
> #endif
> 
>         device_unregister(led_cdev->dev);
> 
>         down_write(&leds_list_lock);
>         list_del(&led_cdev->node);
>         up_write(&leds_list_lock);
> }
> 
> as you can see the led is switched-off right before the device is unregistered.
> but rtl8187, p54 & ar9170 led-triggers are timed & asynchronous. So
> we really need a cancel_delayed_work_sync after the unregister routine
> finished... else the timed trigger might fire when the device/module
> is _faded_ from memory.

OK, I got it...the unregister can queue-up more work.  Thanks for
the explanation.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
