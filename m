Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:43122 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZKEAOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 19:14:52 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rtl8187: Fix kernel oops when device is removed when LEDS enabled (Bugzilla #14539)
Date: Wed, 4 Nov 2009 22:14:54 -0200
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>, sidhayn@gmail.com,
	linux-wireless@vger.kernel.org
References: <4af11879./IumKJ+RAbw7Zkq6%Larry.Finger@lwfinger.net> <200911041630.20122.chunkeey@googlemail.com> <20091104164938.GG12965@tuxdriver.com>
In-Reply-To: <20091104164938.GG12965@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911042214.54230.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 04 Nov 2009, às 14:49:38, John W. Linville escreveu:
> On Wed, Nov 04, 2009 at 04:30:19PM +0100, Christian Lamparter wrote:
> > On Wednesday 04 November 2009 16:11:33 John W. Linville wrote:
> 
> > > This seems like a band-aid.  If anything, the original order would
> > > seem to make more sense.
> > 
> > really?
> > 
> > take this code from led-class.c
> > 
> > void led_classdev_unregister(struct led_classdev *led_cdev)
> > {
> >         device_remove_file(led_cdev->dev, &dev_attr_max_brightness);
> >         device_remove_file(led_cdev->dev, &dev_attr_brightness);
> > #ifdef CONFIG_LEDS_TRIGGERS
> >         device_remove_file(led_cdev->dev, &dev_attr_trigger);
> >         down_write(&led_cdev->trigger_lock);
> >         if (led_cdev->trigger)
> >                 led_trigger_set(led_cdev, NULL);
> >         up_write(&led_cdev->trigger_lock);
> > #endif
> > 
> >         device_unregister(led_cdev->dev);
> > 
> >         down_write(&leds_list_lock);
> >         list_del(&led_cdev->node);
> >         up_write(&leds_list_lock);
> > }
> > 
> > as you can see the led is switched-off right before the device is unregistered.
> > but rtl8187, p54 & ar9170 led-triggers are timed & asynchronous. So
> > we really need a cancel_delayed_work_sync after the unregister routine
> > finished... else the timed trigger might fire when the device/module
> > is _faded_ from memory.
> 
> OK, I got it...the unregister can queue-up more work.  Thanks for
> the explanation.

Hi, I checked here and the code above in led_classdev_unregister is the same in
2.6.31, so I think the patch from Larry should also be applied/sent to 2.6.31.x
stable, as the bug could happen there too.

> 
> John
> 

-- 
[]'s
Herton
