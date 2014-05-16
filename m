Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49600 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaEPJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 05:18:05 -0400
Message-ID: <1400231795.4112.21.camel@jlt4.sipsolutions.net> (sfid-20140516_111812_067715_5ABA2D9E)
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
From: Johannes Berg <johannes@sipsolutions.net>
To: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
Cc: jouni@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 May 2014 11:16:35 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for the code. It's always good to have a proof-of-concept to
discuss the system. Before I go into the general discussion, let me ask
a few specific questions.

> +void sta_info_ipv4hash_add_sta(struct sta_info *sta,
> +			       __be32 ipv4_addr) __acquires(RCU)

> +int sta_info_ipv4hash_remove_sta(struct sta_info *sta) __acquires(RCU)

Those sparse locking annotations clearly seem wrong - does that point to
the annotations being superfluous or the implementation doing something
else than you wanted?

> +static inline int ieee80211_proxyarp_arp(struct ieee80211_sub_if_data *sdata,
> +					 struct sk_buff *skb)
> +{
...
> +	if (arp->ar_op == htons(ARPOP_REQUEST)) {
> +		struct sta_info *ssta, *tsta;
> +
> +		/* Proxy ARP request for the STAs within the BSS */
> +		tsta = sta_info_get_ipv4(sdata, tip);
> +		if (tsta && !tsta->ipv4_lease_timeout &&
> +		    time_after(jiffies, tsta->ipv4_lease_timeout)) {
...
> +		} else if (tsta && !ether_addr_equal(tsta->sta.addr, sha)) {
...
> +			return 1;
> +		}
...
> +		/* Suppress ARP Request within the BSS */
> +		return 1;
> +

All code paths within the REQUEST return 1 - is that intentional? It
seems to me that there might be a requirement to actually pass the frame
if you don't know a response? OTOH, maybe you don't actually need this
since you don't necessarily want the stations communicating anyway (at
least in a HS2 scenario)

I think this code path:

> +       } else if (arp->ar_op == htons(ARPOP_REPLY)) {
> +               if (is_multicast_ether_addr(eh->h_dest))
> +                       return 1;

is also implementing something else - not this particular feature, no?


Overall though, I can't say I like this. I can understand how it's very
tempting to just stick all the code into the wireless stack and be done
with it, but it's quite a bit of code that needs to parse all the frames
etc. and I'm sure it will only get more complicated with the addition of
IPv6. It's also not clear to me that parsing DHCP is actually the best
course of action - if, for example, the DHCP server is colocated with
the AP then it should be simple to actually listen to events coming from
the DHCP server instead of piggy-backing on the actual frames.
Additionally, even listening to those frames in userspace shouldn't be
more complicated than a simple packet socket (with appropriate BPF.)
Similar for ARP (which you seem to be using for some hash table updates)
of course.

If we assume then that this is done, the second part we have is actually
replying to these frames. This is obviously complicated by the fact that

 a) we need to look at frames that are re-transmitted within the AP
context (e.g.
    broadcast from a STA to the DS, and potentially STA-to-STA frames)
 b) we need to drop ARP requests (all in your patch, but maybe only
handled
    ones?) - this also applies to the ones in (a)

Actually (a) might also affect the first part where we build the
database? The whole "use ARP frames to build database" part isn't very
clear to me.

Since we're moving to have more things like this, and more high-level
protocol integration, I think we should instead extend ip/eb/nftables.
It seems that much of this can be implemented in userspace already, with
the exception of the two complications above (at least (b) - (a) might
not be an issue depending on what we need.)

johannes

