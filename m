Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:56808 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab0E1PGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 11:06:04 -0400
Subject: Re: Iwlwifi and LEDS?
From: Richard Purdie <rpurdie@rpsys.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gregy <p.gregy@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <1275045779.3909.90.camel@jlt3.sipsolutions.net>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	 <1274465242.12391.0.camel@abhi-desktop>
	 <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
	 <1274740231.2091.15472.camel@rchatre-DESK>
	 <AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
	 <1275025163.2091.20502.camel@rchatre-DESK>
	 <AANLkTim86ILiQu0BNzUAkUV6lg1-mXt5UBJ0C9gGcgaI@mail.gmail.com>
	 <1275045779.3909.90.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 15:58:49 +0100
Message-ID: <1275058729.24079.1488.camel@rex>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 13:22 +0200, Johannes Berg wrote:
> Richard, please see below after the *** -- I have a question for you.
> 
> On Fri, 2010-05-28 at 13:01 +0200, Gregy wrote:
> > > If you want to be able to manipulate the LED in other ways than the
> > > driver supports you could look into adding a debugfs file that
> > > manipulates the driver's led variables (allow_blinking,
> > > last_blink_time, ...). There is already a readable led file in debugfs,
> > > but not writable.
> > >
> > > Reinette
> > 
> > Ok, I have tried that with partial success. It allows me to change led
> > status "mid-flight" but if led is blinking it sometimes works only
> > after second try. Also my understanding of C and kernel programming is
> > very limited so I probably made some mistakes. Could you please look
> > at it?
> 
> I don't think this is the correct approach. I guess since the patch you
> referenced is mine, I should comment.
> 
> Prior to my patch, iwlwifi would register LEDs in the LED subsystem, but
> it didn't really properly do that since a lot of internal code just
> updates the LEDs. Additionally, by default the requirement is that the
> LED blinks according to traffic. Also, the blinking itself is done by
> the device, it is not done by the host CPU.
> 
> At the time of the patch, the LED subsystem didn't support blinking.
> This has changed now, I think, but previously it was not possible to set
> the LED to "blinking" like we need to have it. Additionally the LED
> trigger registration code that I removed was way more code for much less
> functionality than it should have been.
> 
> There's one proper way to fix this, but it is somewhat involved. Yes, I
> could have implemented that, but under the given time constraints, I
> opted for the cleanup that simply removed functionality that wasn't
> fully functional.
> 
> (*** mark for Richard)
> 
> The proper way to do this now would be to rewrite the LED code in
> iwlwifi to:
> 
> 1) register an LED again, which implements the blink_set() callback and
> programs the hw accordingly. This is essentially implementing
> iwl_led_pattern(), but with on_time/off_time parameters.
> 
> 2) Convert the current caller of iwl_led_pattern() to be an LED trigger
> that registers with the LED system. It would call the blink_set() for
> the LED it is connected to. Ideally, there should be some common
> software emulation if the LED has no blink_set(). Richard, is there a
> "make LED blink" callback that would start a timer for that LED? The
> timer trigger uses it but doesn't seem to be usable itself for other
> triggers?
> 
> 3) start the LED on device start, stop it on device stop
> 
> 4) depending on the module's led_mode, connect the LED to the
> appropriate default trigger, e.g. mac80211's assoc trigger or normally
> of course the new iwlwifi-blink trigger.

I have to admit I don't fully understand what the capabilities of your
hardware are.

Certainly registering a trigger with the LED system, maybe only
appearing for this specific hardware sounds like the way to go. Since
this will only appear as a trigger for this hardware, the trigger can
then poke whatever it needs into the hardware to work as a traffic
indication?

Cheers,

Richard



