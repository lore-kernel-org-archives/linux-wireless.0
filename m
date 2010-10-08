Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59489 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab0JHQpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:45:54 -0400
Received: by fxm14 with SMTP id 14so593805fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 09:45:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: hoist sta->lock from reorder release timer
Date: Fri, 8 Oct 2010 18:42:38 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Ming Lei <tom.leiming@gmail.com>
References: <201010061200.54364.chunkeey@googlemail.com> <20101006202106.GL2472@tuxdriver.com> <1286485393.20974.40.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286485393.20974.40.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010081842.39187.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 October 2010 23:03:13 Johannes Berg wrote:
> On Wed, 2010-10-06 at 16:21 -0400, John W. Linville wrote:
> 
> > > I think it's probably easier to fix than to revert now? There are only a
> > > handful of fields, and it seemed to me that most of them can easily be
> > > moved under the reorder lock.
> > 
> > I would prefer a fix on top rather than a series of reverts...
> 
> I think this should fix it. Somebody review please?
> 
> johannes
> 
Sure, a little bit. The code itself is fine but as you said
the rx_handler code wasn't written for concurrent/delayed
release timer mechanism.

for example:

Because we can't set IEEE80211_RX_RA_MATCH (since 
it interferes with scanning (as explained in
"mac80211: fix release_reorder_timeout in scan").

We will experience strange results with "ieee80211_rx_h_decrypt":

line: 878
>	/*
>	 * No point in finding a key and decrypting if the frame is neither
>	 * addressed to us nor a multicast frame.
>	 */
>	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
>		return RX_CONTINUE;
>
>	/* start without a key */
>	rx->key = NULL;
no software decryption there - not nice but the HW probably does
the decryption for us. - That being said, the stack should be able
to do the software decryption "just in case".

Things are a little bit better with ieee80211_rx_h_sta_process.
It updates some statistics and takes care of sta->last_rx
(which is currently not that important giving HT BA is only supported
for AP/STA operation).

In ieee80211_rx_h_data, there could be another potential problem:
>	if (ieee80211_is_data(hdr->frame_control) &&
>   	 !is_multicast_ether_addr(hdr->addr1) &&
>		 local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
>			mod_timer(&local->dynamic_ps_timer, jiffies +
>			msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>	}
I reckon there could be a "hidden" problem. "jiffies" is now
approx 100ms after the packet was received from the interface.
(Sure, a similar issue was also present in the original
reorder release implementation.)

In order the fix this/my mess we would need to:
 1. move the software decryption before the reordering
   (802.11n-spec (page 11, Figure 6-1) allows this)

(Or:
1. introduce an additional rx_flag for the reorder release case?)

(2. maybe cache the original skb jiffie at some place?)

(3. make a few counters atomic_t, so concurrent tasklets
    can update the stats. Or disable the BHs while processing,
    any rx frames (which is probably what we're going to do, right?))

Regards,
	Christian

Unfortunately, I have to do some other "high priority" right now,
so I'm short of time to do "that" now :-/.
