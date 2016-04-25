Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:58737 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754800AbcDYSVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 14:21:42 -0400
Message-ID: <1461608496.2364.36.camel@lynxeye.de> (sfid-20160425_202148_759165_22E00AF4)
Subject: Re: [PATCH RFC] b43: stop hardcoding LED behavior
From: Lucas Stach <dev@lynxeye.de>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Date: Mon, 25 Apr 2016 20:21:36 +0200
In-Reply-To: <20160425175326.407eba27@wiggum>
References: <1461570051-3950-1-git-send-email-dev@lynxeye.de>
	 <20160425175326.407eba27@wiggum>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, den 25.04.2016, 17:53 +0200 schrieb Michael Büsch:
> On Mon, 25 Apr 2016 09:40:51 +0200
> Lucas Stach <dev@lynxeye.de> wrote:
> 
> > 
> > On my system the SPROM correctly defines the only wired LED (radio)
> > but
> > skips all others, leading to the hardcode to register LEDs with RX
> > and TX
> > triggers.
> Hm ok. It probably is a good idea to change the condition from
> 
> if (sprom[led_index] == 0xFF)
> 
> to
> 
> if ((sprom[0] & sprom[1] & sprom[2] & sprom[3]) == 0xFF)
> 
> So the hardcoding only happens if there is no LED configured in the
> SPROM. (I think my card does this (see below), but I can check that
> later)
> 
> 
> > 
> > These triggers cause many uneccesary CPU wakeups to drive LEDs
> > that aren't even present in the system, reducing battery runtime.
> 
> Numbers please. Did you measure that is actually causes more
> _wakeups_?
> How many?
> The led work is placed in the mac80211 workqueue and LED updates only
> happen on behalf of mac80211 activities (by default). It only causes
> additional wakeups, if there's nothing else scheduled on the
> workqueue
> anyways (which might well be the case. So we need numbers. :)
> 
The blinking LEDs use a timer to enforce a constant blink rate at a
50ms on/off interval. While they are only triggered if there is some
RX/TX activity in the system, they cause up to 20 wakeups/second/led.
As the timers used for LED activity aren't deferrable, this hardcode is
causing 40 unnecessary CPU wakeups/s in my system.

> 
> > 
> > Remove the hardcode to stop it from doing any harm. If this code is
> > useful
> > for others it should probably be reworked as a quirk table
> > triggering only
> > for individual systems that need it.
> 
> There are cards that need it. I don't know how many that are, but I
> own
> an older 4306 PC-Card card that needs this.
> 
> So this effectively is a regression for this card.
> 
> So I don't think this is acceptable.
> You should at least make this configurable via module parameter or
> such.
> Or maybe the change from above already is enough. It should work for
> your case.
> 
There are some people that find those kinds of blinking LEDs
distracting, so a module parameter to disable them altogether might be
a good thing to have. Causing CPU wakeups in a system where those LEDs
aren't even physically populated is clearly undesired behavior.

If checking that the SPROM doesn't define any LED behavior is enough to
not regress your use case, I would be glad to rework the patch
accordingly.

Regards,
Lucas
> 
> > 
> > Signed-off-by: Lucas Stach <dev@lynxeye.de>
> > ---
> >  drivers/net/wireless/broadcom/b43/leds.c | 26 ++----------------
> > --------
> >  1 file changed, 2 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/b43/leds.c
> > b/drivers/net/wireless/broadcom/b43/leds.c
> > index d79ab2a..77d2dad 100644
> > --- a/drivers/net/wireless/broadcom/b43/leds.c
> > +++ b/drivers/net/wireless/broadcom/b43/leds.c
> > @@ -224,31 +224,9 @@ static void b43_led_get_sprominfo(struct
> > b43_wldev *dev,
> >  
> >  	if (sprom[led_index] == 0xFF) {
> >  		/* There is no LED information in the SPROM
> > -		 * for this LED. Hardcode it here. */
> > +		 * for this LED. Keep it disabled. */
> >  		*activelow = false;
> > -		switch (led_index) {
> > -		case 0:
> > -			*behaviour = B43_LED_ACTIVITY;
> > -			*activelow = true;
> > -			if (dev->dev->board_vendor ==
> > PCI_VENDOR_ID_COMPAQ)
> > -				*behaviour = B43_LED_RADIO_ALL;
> > -			break;
> > -		case 1:
> > -			*behaviour = B43_LED_RADIO_B;
> > -			if (dev->dev->board_vendor ==
> > PCI_VENDOR_ID_ASUSTEK)
> > -				*behaviour = B43_LED_ASSOC;
> > -			break;
> > -		case 2:
> > -			*behaviour = B43_LED_RADIO_A;
> > -			break;
> > -		case 3:
> > -			*behaviour = B43_LED_OFF;
> > -			break;
> > -		default:
> > -			*behaviour = B43_LED_OFF;
> > -			B43_WARN_ON(1);
> > -			return;
> > -		}
> > +		*behaviour = B43_LED_OFF;
> >  	} else {
> >  		*behaviour = sprom[led_index] & B43_LED_BEHAVIOUR;
> >  		*activelow = !!(sprom[led_index] &
> > B43_LED_ACTIVELOW);
> 
> 
> 
