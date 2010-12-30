Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0L3SwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 13:52:20 -0500
Subject: Re: [PATCH net-2.6] bridge: fix br_multicast_ipv6_rcv for paged
 skbs
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20101230104656.6c5a4b4e@nehalam>
References: <AANLkTi=XQ2DE==ggJHfokUE1=opDVOFxQNeqwY1xZN_8@mail.gmail.com>
	 <1293708753-17728-1-git-send-email-tomas.winkler@intel.com>
	 <20101230104656.6c5a4b4e@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Dec 2010 19:52:14 +0100
Message-ID: <1293735134.21956.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-30 at 10:46 -0800, Stephen Hemminger wrote:

> This doesn't look correct. The calculation of the offset doesn't look correct.
> Just following the skb_clone(), the skb_pull value is "offset".
> Also, the other checks return -EINVAL for incorrectly formed packet.
> 
> --- a/net/bridge/br_multicast.c	2010-12-30 10:29:58.579510488 -0800
> +++ b/net/bridge/br_multicast.c	2010-12-30 10:43:27.273386691 -0800
> @@ -1464,6 +1464,9 @@ static int br_multicast_ipv6_rcv(struct
>  	if (offset < 0 || nexthdr != IPPROTO_ICMPV6)
>  		return 0;
>  
> +	if (!pskb_may_pull(skb, offset))
> +		return -EINVAL;
> +
>  	/* Okay, we found ICMPv6 header */
>  	skb2 = skb_clone(skb, GFP_ATOMIC);
>  	if (!skb2)

Wouldn't that make more sense after the clone anyway? But if you look at
my email, you'll find that there's potentially, and conditionally, more
stuff that will be read from the skb's header, which hasn't necessarily
been pulled in, so I think this still won't fix all the issues.

Seeing how this only affects some ICMPv6 packets, maybe we should just
use skb_copy() instead?

johannes

