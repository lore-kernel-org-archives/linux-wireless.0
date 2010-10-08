Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0JHSp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:45:27 -0400
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <201010082012.07007.chunkeey@googlemail.com>
References: <201010061200.54364.chunkeey@googlemail.com>
	 <201010081842.39187.chunkeey@googlemail.com>
	 <1286556802.3612.4.camel@jlt3.sipsolutions.net>
	 <201010082012.07007.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 20:45:26 +0200
Message-ID: <1286563526.3612.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 20:12 +0200, Christian Lamparter wrote:

> But hey, wait a sec. (This one is about AP mode - It's related to
> IEEE80211_RX_RA_MATCH, but now in a different handler)

Heh.

> NULLFUNCs (set/clear PM) are not reordered and they get
> processed right away, right?

Yeah, I don't think they can be in A-MPDUs. At least not in any scenario
that actually makes sense.

> So what if the reorder release triggers and ap_sta_ps_end
> (called by ieee80211_rx_h_sta_process) accidentally resets
> the "sleeping" flag (because some old frames with a "stale"
> PSM bit was released after 100ms)?

Yeah... that can happen.

> > > Things are a little bit better with ieee80211_rx_h_sta_process.
> > > It updates some statistics and takes care of sta->last_rx
> > > (which is currently not that important giving HT BA is only supported
> > > for AP/STA operation).
> > > 
> > > In ieee80211_rx_h_data, there could be another potential problem:
> > > >	if (ieee80211_is_data(hdr->frame_control) &&
> > > >   	 !is_multicast_ether_addr(hdr->addr1) &&
> > > >		 local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> > > >			mod_timer(&local->dynamic_ps_timer, jiffies +
> > > >			msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
> > > >	}
> > > I reckon there could be a "hidden" problem. "jiffies" is now
> > > approx 100ms after the packet was received from the interface.
> > > (Sure, a similar issue was also present in the original
> > > reorder release implementation.)
> > 
> > This one's more interesting. I guess we need to bypass these things
> > somehow, maybe setting a flag if this was a "recovered" frame?

> (and check the same flag for ap_sta_ps_end/ap_sta_ps_start).
> Ok, that's doable (even for me :D)

Yeah, something like that. I guess there are more things like that and
we have to go through the RX path once -- but it shouldn't be all that
hard.

> > BHs are disabled while processing RX -- and timer is a BH itself so
> > they're also disabled, right?

> hmm, are we talking about BH or tasklets? 

RX is currently always processed in a tasklet.

> I read something about the
> occurrence of simultaneous tasklets/timers on multi-core systems?

You're right, it's local_bh_disable ... the local is there for a
reason :-)

> And from a point that all made sense:
> ---
> from kernel-hacking.DocBook:
> 
> "For this reason, tasklets are more often used: they are
> dynamically-registrable (meaning you can have as many as you want),
> and they also guarantee that any tasklet will only run on one CPU
> at any time, although different tasklets can run simultaneously."

Yeah.

> and kernel-locking.DocBook:
> "Different Tasklets/Timers:
> If another tasklet/timer wants to share data with your tasklet or timer,
> you will both need to use spin_lock() and spin_unlock() calls.
> spin_lock_bh() is unnecessary here, as you are already in a tasklet, and
> none will be run on the same CPU." <-- "same" CPU.

Indeed.

> So according to statements above, we need a lock for the stats
> too. (and I was wrong about "converting" them all to atomic.)
> 
>  * ieee80211_rx_h_sta_process
> 	sta->rx_packets++;
> 	sta->rx_fragments++;
> 	sta->rx_bytes += rx->skb->len;
> 
>  * ieee80211_rx_h_data:
>    dev->stats.rx_packets++;
>    dev->stats.rx_bytes += rx->skb->len;

Yeah. It's too bad we can't just disable the tasklet while processing
the timer -- but we can't because we might also be processing from
another context, even process context with BHs disabled, from driver
calls to ieee80211_rx() (without _irqsafe).

So we need a lock. Question then is, which one do we use? We could use
the sta lock (and get rid of the reorder lock again), that would allow
processing RX frames for STA A while we're doing timeouts for STA B --
as long as we don't also process a frame for B which would block, but
presumably something is wrong when the timeout happens ...

But then using the sta lock could be fairly expensive. It might actually
be cheaper to simply remove the distinction between _rx() and
_rx_irqsafe() and make it all go through the tasklet -- then we can
simply disable the tasklet while doing the timer processing....

I don't like reverting these patches, but maybe we should simply comment
out the code that arms the timer, thereby disabling all of it, while we
work on this?

johannes

