Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab0JHQxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:53:24 -0400
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <201010081842.39187.chunkeey@googlemail.com>
References: <201010061200.54364.chunkeey@googlemail.com>
	 <20101006202106.GL2472@tuxdriver.com>
	 <1286485393.20974.40.camel@jlt3.sipsolutions.net>
	 <201010081842.39187.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 18:53:22 +0200
Message-ID: <1286556802.3612.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 18:42 +0200, Christian Lamparter wrote:

> Sure, a little bit. The code itself is fine but as you said
> the rx_handler code wasn't written for concurrent/delayed
> release timer mechanism.

But it should be fine now, no? What data does it still access that's not
safe?

> for example:
> 
> Because we can't set IEEE80211_RX_RA_MATCH (since 
> it interferes with scanning (as explained in
> "mac80211: fix release_reorder_timeout in scan").

That I don't understand.

> We will experience strange results with "ieee80211_rx_h_decrypt":
> 
> line: 878
> >	/*
> >	 * No point in finding a key and decrypting if the frame is neither
> >	 * addressed to us nor a multicast frame.
> >	 */
> >	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))

> no software decryption there - not nice but the HW probably does
> the decryption for us. - That being said, the stack should be able
> to do the software decryption "just in case".

But note that the rx_flags are in the *status* now, which is part of the
SKB, and no longer on the stack.

> Things are a little bit better with ieee80211_rx_h_sta_process.
> It updates some statistics and takes care of sta->last_rx
> (which is currently not that important giving HT BA is only supported
> for AP/STA operation).
> 
> In ieee80211_rx_h_data, there could be another potential problem:
> >	if (ieee80211_is_data(hdr->frame_control) &&
> >   	 !is_multicast_ether_addr(hdr->addr1) &&
> >		 local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> >			mod_timer(&local->dynamic_ps_timer, jiffies +
> >			msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
> >	}
> I reckon there could be a "hidden" problem. "jiffies" is now
> approx 100ms after the packet was received from the interface.
> (Sure, a similar issue was also present in the original
> reorder release implementation.)

This one's more interesting. I guess we need to bypass these things
somehow, maybe setting a flag if this was a "recovered" frame?

> In order the fix this/my mess we would need to:
>  1. move the software decryption before the reordering
>    (802.11n-spec (page 11, Figure 6-1) allows this)
> 
> (Or:
> 1. introduce an additional rx_flag for the reorder release case?)
> 
> (2. maybe cache the original skb jiffie at some place?)
> 
> (3. make a few counters atomic_t, so concurrent tasklets
>     can update the stats. Or disable the BHs while processing,
>     any rx frames (which is probably what we're going to do, right?))

BHs are disabled while processing RX -- and timer is a BH itself so
they're also disabled, right?

johannes

