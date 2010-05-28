Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0E1PIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 11:08:20 -0400
Subject: Re: Iwlwifi and LEDS?
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Gregy <p.gregy@gmail.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <1275058729.24079.1488.camel@rex>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	 <1274465242.12391.0.camel@abhi-desktop>
	 <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
	 <1274740231.2091.15472.camel@rchatre-DESK>
	 <AANLkTilfa4YPPiroX5yfJ2BNRUVZH6imTvG4I8ukGjBC@mail.gmail.com>
	 <1275025163.2091.20502.camel@rchatre-DESK>
	 <AANLkTim86ILiQu0BNzUAkUV6lg1-mXt5UBJ0C9gGcgaI@mail.gmail.com>
	 <1275045779.3909.90.camel@jlt3.sipsolutions.net>
	 <1275058729.24079.1488.camel@rex>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 17:08:14 +0200
Message-ID: <1275059294.3909.112.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 15:58 +0100, Richard Purdie wrote:

> > The proper way to do this now would be to rewrite the LED code in
> > iwlwifi to:
> > 
> > 1) register an LED again, which implements the blink_set() callback and
> > programs the hw accordingly. This is essentially implementing
> > iwl_led_pattern(), but with on_time/off_time parameters.
> > 
> > 2) Convert the current caller of iwl_led_pattern() to be an LED trigger
> > that registers with the LED system. It would call the blink_set() for
> > the LED it is connected to. Ideally, there should be some common
> > software emulation if the LED has no blink_set(). Richard, is there a
> > "make LED blink" callback that would start a timer for that LED? The
> > timer trigger uses it but doesn't seem to be usable itself for other
> > triggers?
> > 
> > 3) start the LED on device start, stop it on device stop
> > 
> > 4) depending on the module's led_mode, connect the LED to the
> > appropriate default trigger, e.g. mac80211's assoc trigger or normally
> > of course the new iwlwifi-blink trigger.
> 
> I have to admit I don't fully understand what the capabilities of your
> hardware are.

Sorry, I didn't mean to confuse you with the hardware details. The
hardware can blink, essentially.

> Certainly registering a trigger with the LED system, maybe only
> appearing for this specific hardware sounds like the way to go. Since
> this will only appear as a trigger for this hardware, the trigger can
> then poke whatever it needs into the hardware to work as a traffic
> indication?

Yes, that would be one way. However, that would seem to unduly restrict
the trigger's use. It can be used with any LED that has a blink_set()
callback since it doesn't need to poke the hardware directly.

What I was wondering is if there is (or should be) a common "blink
emulation" for LEDs that don't have a blink_set, so instead of calling
	led->blink_set(...)
I would call
	led_blink_set(...)
and that would start the timer etc.

johannes

