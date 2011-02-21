Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37923 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1BUTPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:15:34 -0500
Date: Mon, 21 Feb 2011 14:06:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>, nbd@openwrt.org
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
Message-ID: <20110221190601.GF9650@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
 <1298302086.3707.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298302086.3707.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 04:28:06PM +0100, Johannes Berg wrote:
> On Fri, 2011-02-18 at 16:21 -0500, John W. Linville wrote:
> > This is an implementation of the eBDP algorithm as documented in
> > Section IV of "Buffer Sizing for 802.11 Based Networks" by Tianji Li,
> > et al.
> > 
> > 	http://www.hamilton.ie/tianji_li/buffersizing.pdf
> > 
> > This implementation timestamps an skb before handing it to the
> > hardware driver, then computes the service time when the frame is
> > freed by the driver.  An exponentially weighted moving average of per
> > fragment service times is used to restrict queueing delays in hopes
> > of achieving a target fragment transmission latency.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > v1 -> v2:
> > - execute algorithm separately for each WMM queue
> > - change ewma scaling parameters
> > - calculate max queue len only when new latency data is received
> > - stop queues when occupancy limit is reached rather than dropping
> > - use skb->destructor for tracking queue occupancy
> > 
> > Johannes' comment about tx status reporting being unreliable (and what
> > he was really saying) finally sunk-in.  So, this version uses
> > skb->destructor to track in-flight fragments.  That should handle
> > fragments that get silently dropped in the driver for whatever reason
> > without leaking queue capacity.  Correct me if I'm wrong!
> 
> Yeah, I had that idea as well. Could unify the existing skb_orphan()
> call though :-)

The one in ieee80211_skb_resize?  Any idea how that would look?
 
> However, Nathaniel is right -- if the skb is freed right away during
> tx() you kinda estimate its queue time to be virtually zero. That
> doesn't make a lot of sense and might in certain conditions exacerbate
> the problem, for example if the system is out of memory more packets
> might be allowed through than in normal operation etc.

As in my reply to Nathaniel, please notice that the timing estimate
(and the max_enqueued calculation) only happens for frames that result
in a tx status report -- at least for now...

However, if this were generalized beyond mac80211 then we wouldn't
be able to rely on tx status reports.  I can see that dropping frames
in the driver would lead to timing estimates that would cascade into
a wide-open queue size.  But I'm not sure that would be a big deal,
since in the long run those dropped frames should still result in IP
cwnd reductions, etc...?

> Also, for some USB drivers I believe SKB lifetime has no relation to
> queue size at all because the data is just shuffled into an URB. I'm not
> sure we can solve this generically. I'm not really sure how this works
> for USB drivers, I think they queue up frames with the HCI controller
> rather than directly with the device.

How do you think the time spent handling URBs in the USB stack relates
to the time spent transmitting frames?  At what point do those SKBs
get freed?

> Finally, this isn't taking into account any of the issues about
> aggregation and AP mode. Remember that both with multiple streams (on
> different ACs) and even more so going to different stations
> (AP/IBSS/mesh modes, and likely soon even in STA mode with (T)DLS, and
> let's not forget 11ac/ad) there may be vast differences in the time
> different frames spend on a queue which are not just due to bloated
> queues. I'm concerned about this since none of it has been taken into
> account in the paper you're basing this on, all evaluations seem to be
> pretty much based on a single traffic stream.

Yeah, I'm still not sure we all have our heads around these issues.
I mean, on the one hand it seems wrong to limit queueing for one
stream or station just because some other stream or station is
higher latency.  But on the other hand, it seems to me that those
streams/stations still have to share the same link and that higher
real latency for one stream/station could still result in a higher
perceived latency for another stream/station sharing the same link,
since they still have to share the same air...no?

> Overall, I think there should be some more research first. This might
> help in some cases, but do we know it won't completely break throughput
> in other cases?

That's why it is posted RFC, of course. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
