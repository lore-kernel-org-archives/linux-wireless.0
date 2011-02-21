Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1BUP2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 10:28:08 -0500
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight
 bufferbloat
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>, nbd@openwrt.org
In-Reply-To: <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 16:28:06 +0100
Message-ID: <1298302086.3707.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 16:21 -0500, John W. Linville wrote:
> This is an implementation of the eBDP algorithm as documented in
> Section IV of "Buffer Sizing for 802.11 Based Networks" by Tianji Li,
> et al.
> 
> 	http://www.hamilton.ie/tianji_li/buffersizing.pdf
> 
> This implementation timestamps an skb before handing it to the
> hardware driver, then computes the service time when the frame is
> freed by the driver.  An exponentially weighted moving average of per
> fragment service times is used to restrict queueing delays in hopes
> of achieving a target fragment transmission latency.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> v1 -> v2:
> - execute algorithm separately for each WMM queue
> - change ewma scaling parameters
> - calculate max queue len only when new latency data is received
> - stop queues when occupancy limit is reached rather than dropping
> - use skb->destructor for tracking queue occupancy
> 
> Johannes' comment about tx status reporting being unreliable (and what
> he was really saying) finally sunk-in.  So, this version uses
> skb->destructor to track in-flight fragments.  That should handle
> fragments that get silently dropped in the driver for whatever reason
> without leaking queue capacity.  Correct me if I'm wrong!

Yeah, I had that idea as well. Could unify the existing skb_orphan()
call though :-)

However, Nathaniel is right -- if the skb is freed right away during
tx() you kinda estimate its queue time to be virtually zero. That
doesn't make a lot of sense and might in certain conditions exacerbate
the problem, for example if the system is out of memory more packets
might be allowed through than in normal operation etc.

Also, for some USB drivers I believe SKB lifetime has no relation to
queue size at all because the data is just shuffled into an URB. I'm not
sure we can solve this generically. I'm not really sure how this works
for USB drivers, I think they queue up frames with the HCI controller
rather than directly with the device.

Finally, this isn't taking into account any of the issues about
aggregation and AP mode. Remember that both with multiple streams (on
different ACs) and even more so going to different stations
(AP/IBSS/mesh modes, and likely soon even in STA mode with (T)DLS, and
let's not forget 11ac/ad) there may be vast differences in the time
different frames spend on a queue which are not just due to bloated
queues. I'm concerned about this since none of it has been taken into
account in the paper you're basing this on, all evaluations seem to be
pretty much based on a single traffic stream.

Overall, I think there should be some more research first. This might
help in some cases, but do we know it won't completely break throughput
in other cases?

johannes

