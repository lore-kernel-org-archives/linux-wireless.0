Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64472 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZHZUU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:20:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 13:21:00 -0700
Date: Wed, 26 Aug 2009 13:20:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	<Jouni.Malinen@atheros.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
Message-ID: <20090826202058.GA7096@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
 <20090825185842.GA7357@mosca>
 <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
 <20090825233827.GA10998@mosca>
 <b6c5339f0908260708l38208046o43330d9eda808b1e@mail.gmail.com>
 <20090826162941.GA4417@mosca>
 <b6c5339f0908261003g40ed910amc347305e4604ee4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b6c5339f0908261003g40ed910amc347305e4604ee4a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:03:09AM -0700, Bob Copeland wrote:
> On Wed, Aug 26, 2009 at 12:29 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
> 
> > Not sure I follow. Let me explain the logic here a little better.
> > ath5k_reset() had a check to see if we switched channels. The check
> > is above, and I moved it ath5k_chan_set() called by the config callback.
> > Reason for this is channel change *only* occurs through the config callback
> > so we can be certain no other path will call reset with a channel change
> > request.
> 
> But previously we did all this stuff for _every_ reset except the first
> one, 

Actually we did it in every ath5k_reset() if and only if chan was not NULL.
We called ath5k_reset() from 3 places:

  * Init
  * Channel change
  * Reset tasklet for hw issues

chan was only null upon init as you point out, so you are right in that
I overlooked that we currently do this also upon hw issues.

> now we only do it for channel change resets.  It may make sense your
> way, but I'd rather see that as a separate patch rather than part of a
> cleanup.

Absolutely, I overlooked this, thanks for picking that up.

> (Also, chan_change is used to skip a bunch of phy register writes
> that we only need to do once, not sure if that changes here).

Yeah since I also used ath5k_reset_init() on the reset hw issue tasklet and
that does pass false for channel_change this patch would have changed that
as well, so I'll fix that.

> >> There's just no synchronization of this stuff, not too surprising there
> >> are races.
> >
> > config calls for reset seem to be with sc->lock. ath9k uses a mutex to
> > protect races between mac80211 callback calls, ath5k seems to use the
> > sc->lock *sometimes*, a good review of that may help but for channel
> > change this seems protected unless I missed something. Since channel
> > change goes through the config callback and since the callback protects
> > through sc->lock I can't see how we'd race against changing channels.
> 
> rx_tasklet doesn't (can't) take the mutex though.  Here's the race:
> 
> cpu 1                       cpu 2
>                             1mbit packet received, ack intr and queue it
> client changes to 5ghz band
> hw->conf.channel = 36
>                             ath5k_rx_tasklet runs
>                             hmm, we got 1mbit packet on channel 36, wtf
> ath5k_chan_change()
> 
> This is still racy with curband variables of course, but IMO the
> proposed change actually makes the race wider (in current code, we only
> update the band after we disable the interrupts, but the tasklet can
> still run on queued packets).

I don't want to bother looking ath ath5k solutions to the race, I rather
we try to fix this if possible with a generic solution on mac80211. I suspect
ath5k is not the only one with this possible race.

> The right thing to do is either process or drop all of those packets

Would be nice if we did not have to, those packets can be very valuable
considering we now support spreading our scan over time.

> with interrupts disabled before updating the band/channel (rx_drainq),

That would be nice, so prior to channel change we need to ensure we:

  * Disable interrupts
  * Disable RX
  * Process all pending frames in RX queue

It is the last part that it seems we are missing. Running tasklet_schedule()
will ensure we can schedule the tasklet but it does not ensure we will
wait until it has run at least once. Johill pointed out tasklet_disable()
followed by a tasklet_enable() would do it, but seems rather odd.

But do we need this?

In the rx tasklet we need band to access the right rate table -- this is
how we got into this conversation but if you think about it you also need
to ensure your harware hasn't already flipped to another band otherwise
you can start sending mac80211 frames for a different band. This certainly
matters for rate control but haven't reviewed all the details of where
inconsistancy between the hw->conf.channel and the skbs received by
mac80211 are.

Processing RXd frames prior to switching channels seems like a good idea
regardless.

>From what I see Atheros RX descriptors do not have the frequency on which the
frame was received on so you do need some sort of house keeping.
mac80211/cfg80211 does this for us so I'd like to try to avoid doing more
on drivers if possible.

Since cfg80211 modifies hw->conf.channel prior to calling drv_config() it
is possible for the driver to not reliably use this variable either right now.

So how about a generic rx_drain() callback for mac80211 drivers and document
that on it we need disable RXing frames, disable interrupts for RX,
and then either have the driver drop pending frames (worst case) or process them.
mac80211 could then use this prior to drv_config() if we are changing channels.

> or protect that channel info with a spinlock.   Or perhaps we can
> figure it out directly from the rx descriptor -- I looked at this
> briefly and didn't think there was enough info there, but didn't spend
> much time on it.

I looked too and did not find it. I can't find a reason to have it in
hardware descriptors though, given that you could just drain rx prior to
a switch.

Only argument I can see which may affect draining RX prior to channel
change is it could delay the time it takes for you to switch. Either way
this seems just a lot cleaner to support.

Thoughts?

  Luis
