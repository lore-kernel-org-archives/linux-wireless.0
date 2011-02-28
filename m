Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1B1NH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 08:07:26 -0500
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight
 bufferbloat
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>, nbd@openwrt.org
In-Reply-To: <20110221190601.GF9650@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
	 <1298302086.3707.13.camel@jlt3.sipsolutions.net>
	 <20110221190601.GF9650@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 14:07:23 +0100
Message-ID: <1298898443.3750.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-21 at 14:06 -0500, John W. Linville wrote:

> > Yeah, I had that idea as well. Could unify the existing skb_orphan()
> > call though :-)
> 
> The one in ieee80211_skb_resize?  Any idea how that would look?

Yeah. I think it'd have to be moved out of _skb_resize and made
unconditional in that path, since eventually with this patch you'd do it
anyway.

> As in my reply to Nathaniel, please notice that the timing estimate
> (and the max_enqueued calculation) only happens for frames that result
> in a tx status report -- at least for now...

Oops, right.

> However, if this were generalized beyond mac80211 then we wouldn't
> be able to rely on tx status reports.  I can see that dropping frames
> in the driver would lead to timing estimates that would cascade into
> a wide-open queue size.  But I'm not sure that would be a big deal,
> since in the long run those dropped frames should still result in IP
> cwnd reductions, etc...?

I don't think we can generically rely on skb_orphan() in the network
stack since that will make socket buffer limits meaningless. In fact, it
pains me a bit that we had to do this in wireless before buffering the
skb, and doing it unconditionally may be worse?

> How do you think the time spent handling URBs in the USB stack relates
> to the time spent transmitting frames?  At what point do those SKBs
> get freed?

I honestly don't know. I would hope they are only freed when the URB was
processed (i.e. at least DMA'd to the target device) but I suppose a
driver might also copy the TX frame completely.

> Yeah, I'm still not sure we all have our heads around these issues.
> I mean, on the one hand it seems wrong to limit queueing for one
> stream or station just because some other stream or station is
> higher latency.  But on the other hand, it seems to me that those
> streams/stations still have to share the same link and that higher
> real latency for one stream/station could still result in a higher
> perceived latency for another stream/station sharing the same link,
> since they still have to share the same air...no?

Yeah, but retries (robustness) and aggregation (throughput) will
invariably affect latency for everybody else using the shared medium. I
suppose it would be better if queueing would be limited to a certain
amount of air time use *per peer station*, so that each connection can
have fairly low latency. However, this seems much harder to do. But what
could happen here is that bursty traffic to a far-away (slow) station
severely affects latency for and because there's also high traffic to a
closer station that caused a buffering increase.

johannes

