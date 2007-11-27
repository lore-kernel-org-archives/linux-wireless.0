Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36917
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000AbXK0RGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 12:06:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC/T] b43: Fix Radio On/Off LED action
Date: Tue, 27 Nov 2007 18:05:09 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de> <474C45B1.3050909@lwfinger.net>
In-Reply-To: <474C45B1.3050909@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200711271805.09304.mb@bu3sch.de> (sfid-20071127_170705_877542_EB9B20CC)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007 17:28:33 Larry Finger wrote:
> Michael Buesch wrote:
> > On Tuesday 27 November 2007 17:03:57 Larry Finger wrote:
> > This is not how led triggers work.
> > You are shortcutting the whole thing here. So you could as well
> > remove the whole rfkill and LEDs code.
> 
> It just plain doesn't work now. What I'm trying to do is get something to the users that will
> restore the behavior they want while we work out the details of the rfkill and LEDs code.

Well, ok. But we don't apply this to mainline. As
a temporary patch for users it's OK.

> > Please properly register the LED in the leds code and
> > add a default LED trigger for the rfkill trigger.
> > This has several advantages to the user, among the possiblility to
> > reassign a LED to a different trigger.
> 
> How do I do that?

Well, what you basically have to do it restore the old
mapping in b43_map_led().
Look at the "case B43_LED_RADIO_ALL" (and below) statement.
It maps these LEDs to the rfkill trigger.
So you have to find out which behaviour value your LED has and
map that to the rfkill trigger in this function.

So when the rfkill LED trigger triggers, it will enable/disable this LED.
That's all done behind the scenes.

> >> @@ -70,11 +75,13 @@ static int b43_rfkill_soft_toggle(void *
> >>  	struct b43_wldev *dev = data;
> >>  	struct b43_wl *wl = dev->wl;
> >>  	int err = 0;
> >> +	int lock = mutex_is_locked(&wl->mutex);
> >>  
> >>  	if (!wl->rfkill.registered)
> >>  		return 0;
> >>  
> >> -	mutex_lock(&wl->mutex);
> >> +	if (!lock)
> >> +		mutex_lock(&wl->mutex);
> > 
> > Nah, it shouldn't be locked by "current" in the first place, here.
> > (I guess that's what you are trying to check here).
> > That's what the !registered check above is for.
> > This !lock check is racy.
> 
> If you recall my message from yesterday, I got a locking error. That is what I'm trying to prevent.
> I know it is racy, but I don't know the correct way to do it.

I think RFkill has a bad design regarding this.
It does synchronously call back into the driver from a call made by
the driver. That is broken by design. Maybe it's best to fix this
in rfkill and let it asynchronously call back on rfkill_init.
Synchronous callbacks from calls made by drivers are broken by design
and will lead to recursive lockings. We can not fix this in the driver,
nor work around it in a sane way. We can hack around it, though, which
is what the !registered flag tries to do. Though, it seems it doesn't
work. :)

-- 
Greetings Michael.
