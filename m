Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:33720 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbXKRXrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 18:47:16 -0500
Date: Sun, 18 Nov 2007 15:47:01 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] b43: multiple MAC addresses support
Message-ID: <20071118234700.GC8672@jm.kir.nu> (sfid-20071118_234735_190795_5AC29834)
References: <1194572631.4793.64.camel@johannes.berg> <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu> <1194868951.5229.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1194868951.5229.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 12, 2007 at 01:02:31PM +0100, Johannes Berg wrote:

> That's the point I wasn't quite sure on, would it be valid to send the
> frames in the order beacon1, beacon2, beacon3, mc1, mc1, ..., mc2, ...,
> mc3, ...?

Well, the multicast/broadcast frames would be sent after DTIM beacon
using normal frame transmission rules, so this would be possible order.
Though, this might not be that likely if one were to consider a case
where these APs are on separate radios (i.e., multiple STAs contenting
for the medium) should there be large number of buffered frames.

While this may end up being the easiest and cleanest way of implementing
multi-BSS support, this has somewhat unfortunate drawbacks for power
save stations (e.g., STAs associated with the AP1 would need to remain
awake for the extra time needed to send beacon2 and beacon3; and STAs
associated with the AP3 would need to remain awake while mc1..mc2 frames
are sent).


> On Broadcom hardware, I'm pretty sure that the transmit engine updates
> the timestamp only during transmission so that shouldn't be a problem.

OK. This will allow the STAs to remain in sync.

> Time zero is defined as TBTT, so this means we need to send the frame as
> close to TU "Beacon Interval" * N where N is a non-negative number. Is
> my interpretation correct here? If so, and because we only have a single
> TSF, doesn't this mean that we should send the beacons all together as
> quickly as possible? If we tried spreading them out we'd be sending them
> at something like "Beacon Interval" * (N + 0.25) which isn't something
> we should do, no?

TBTT could (and well, should) be separate for each BSS. In other words,
if there are four virtual BSSes using one radio (BSS1 .. BSS4), TBTT
should be different for each. If the beacon frames are send out as a
burst, TBTT2 should be TBTT1 + <time needed to send beacon1> and so on..
Similarly, there should be independent TSF for each BSS. However,
implementing this for virtual BSS (single radio) designs is going to be
quite difficult since the hardware/firmware is unlikely to support
something like this..

Consequently, the only realistic mechanism may end up being to try to
send the beacon frames as close to each other as possible. I'm not sure
whether non-AP STAs would be able to handle offset from the N *
beacon_int TUs time and still sleep properly. In theory, they could try
to sync with previous beacons, but this would be difficult to do since
beacon transmission times can vary a bit. This would be simple if we
would not need to think about power saving, but reality is likely to be
much more complex and the safest solution would to just try to send the
frame as close as possible after the N * beacon_int time.

> Another thing that I just realised is that I'm not sure whether we
> update the TSF in probe responses correctly or at all because as far as
> I can tell it's only done for the probe response microcode offload.
> We'll have to look into this.

This should be done in the same way as for Beacons, i.e., by whatever
low-level functionality is available in the transmitting path.

> Actually, what we can do is adjust the offset for each of the beacons
> differently. So when we're sending a beacon at TSF "interval * (N+.25)"
> we can round that up to "interval * (N+1)" by adjusting the TSF write
> offset. This means that stations will adopt a TSF that is larger than
> ours by a bit. If we'd do the same for probe responses (which should be
> fairly easy), would the timing work out? I'm not entirely clear about
> CFP operation etc.

Where would the TSF be adjusted? Some of these tricks could be doable in
the low-level firmware/microcode (if one is used), but this may be
difficult to do without access to such low-level location.

> > I've done some
> > experiments with configuring the hardware to use beacon interval divided
> > by number of BSSes, but ended up using burst of beacon frames instead
> > (and all BSSes were forced to use the same beacon interval).
> 
> Do you remember any reason?

Nope.. There were some issues in getting the implementation to be
stable, so that may have been the main reason. Setting the beacon
interval and related interrupts to very small values was probably not
expected in the original design.

-- 
Jouni Malinen                                            PGP id EFC895FA
