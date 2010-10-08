Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64372 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab0JHSMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:12:12 -0400
Received: by fxm14 with SMTP id 14so651219fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 11:12:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
Date: Fri, 8 Oct 2010 20:12:06 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
References: <201010061200.54364.chunkeey@googlemail.com> <201010081842.39187.chunkeey@googlemail.com> <1286556802.3612.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286556802.3612.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010082012.07007.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 October 2010 18:53:22 Johannes Berg wrote:
> On Fri, 2010-10-08 at 18:42 +0200, Christian Lamparter wrote:
> 
> > Sure, a little bit. The code itself is fine but as you said
> > the rx_handler code wasn't written for concurrent/delayed
> > release timer mechanism.
> 
> But it should be fine now, no? What data does it still access that's not
> safe?
that's what I'm asking myself.

> > for example:
> > 
> > Because we can't set IEEE80211_RX_RA_MATCH (since 
> > it interferes with scanning (as explained in
> > "mac80211: fix release_reorder_timeout in scan").
> 
> That I don't understand.
> 
> > We will experience strange results with "ieee80211_rx_h_decrypt":
> > 
> > line: 878
> > >	/*
> > >	 * No point in finding a key and decrypting if the frame is neither
> > >	 * addressed to us nor a multicast frame.
> > >	 */
> > >	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
> 
> > no software decryption there - not nice but the HW probably does
> > the decryption for us. - That being said, the stack should be able
> > to do the software decryption "just in case".
> 
> But note that the rx_flags are in the *status* now, which is part of the
> SKB, and no longer on the stack.
oops, you are right, my fault.

But hey, wait a sec. (This one is about AP mode - It's related to
IEEE80211_RX_RA_MATCH, but now in a different handler)

NULLFUNCs (set/clear PM) are not reordered and they get
processed right away, right?
So what if the reorder release triggers and ap_sta_ps_end
(called by ieee80211_rx_h_sta_process) accidentally resets
the "sleeping" flag (because some old frames with a "stale"
PSM bit was released after 100ms)?

> > Things are a little bit better with ieee80211_rx_h_sta_process.
> > It updates some statistics and takes care of sta->last_rx
> > (which is currently not that important giving HT BA is only supported
> > for AP/STA operation).
> > 
> > In ieee80211_rx_h_data, there could be another potential problem:
> > >	if (ieee80211_is_data(hdr->frame_control) &&
> > >   	 !is_multicast_ether_addr(hdr->addr1) &&
> > >		 local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> > >			mod_timer(&local->dynamic_ps_timer, jiffies +
> > >			msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
> > >	}
> > I reckon there could be a "hidden" problem. "jiffies" is now
> > approx 100ms after the packet was received from the interface.
> > (Sure, a similar issue was also present in the original
> > reorder release implementation.)
> 
> This one's more interesting. I guess we need to bypass these things
> somehow, maybe setting a flag if this was a "recovered" frame?
(and check the same flag for ap_sta_ps_end/ap_sta_ps_start).
Ok, that's doable (even for me :D)

> > In order the fix this/my mess we would need to:
> >  1. move the software decryption before the reordering
> >    (802.11n-spec (page 11, Figure 6-1) allows this)
> > 
> > (Or:
> > 1. introduce an additional rx_flag for the reorder release case?)
> > 
> > (2. maybe cache the original skb jiffie at some place?)
> > 
> > (3. make a few counters atomic_t, so concurrent tasklets
> >     can update the stats. Or disable the BHs while processing,
> >     any rx frames (which is probably what we're going to do, right?))
> 
> BHs are disabled while processing RX -- and timer is a BH itself so
> they're also disabled, right?
hmm, are we talking about BH or tasklets? I read something about the
occurrence of simultaneous tasklets/timers on multi-core systems?
And from a point that all made sense:
---
from kernel-hacking.DocBook:

"For this reason, tasklets are more often used: they are
dynamically-registrable (meaning you can have as many as you want),
and they also guarantee that any tasklet will only run on one CPU
at any time, although different tasklets can run simultaneously."
---
and kernel-locking.DocBook:
"Different Tasklets/Timers:
If another tasklet/timer wants to share data with your tasklet or timer,
you will both need to use spin_lock() and spin_unlock() calls.
spin_lock_bh() is unnecessary here, as you are already in a tasklet, and
none will be run on the same CPU." <-- "same" CPU.

---
http://www.makelinux.net/ldd3/chp-5-sect-7.shtml:
"Normally, even a simple operation such as:

n_op++;

would require locking. Some processors might perform that
sort of increment in an atomic manner, but you can't count on it." 
---

So according to statements above, we need a lock for the stats
too. (and I was wrong about "converting" them all to atomic.)

 * ieee80211_rx_h_sta_process
	sta->rx_packets++;
	sta->rx_fragments++;
	sta->rx_bytes += rx->skb->len;

 * ieee80211_rx_h_data:
   dev->stats.rx_packets++;
   dev->stats.rx_bytes += rx->skb->len;

Regards,
	Chr
