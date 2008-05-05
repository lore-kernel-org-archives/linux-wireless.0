Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751045AbYEEAav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 20:30:51 -0400
Date: Sun, 04 May 2008 17:30:51 -0700 (PDT)
Message-Id: <20080504.173051.133197507.davem@davemloft.net> (sfid-20080505_023036_543159_8E09684F)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209936745.7304.16.camel@johannes.berg>
References: <1209936253.7304.10.camel@johannes.berg>
	<1209936745.7304.16.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 04 May 2008 23:32:25 +0200

> --- everything.orig/net/mac80211/iface.c	2008-05-04 23:24:17.000000000 +0200
> +++ everything/net/mac80211/iface.c	2008-05-04 23:31:46.000000000 +0200
> @@ -53,6 +53,15 @@ int ieee80211_if_add(struct net_device *
>  	if (!ndev)
>  		return -ENOMEM;
>  
> +	ndev->needed_headroom = local->tx_headroom +
> +				4*6 /* four MAC addresses */
> +				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
> +				+ 6 /* mesh */
> +				+ 8 /* rfc1042/bridge tunnel */
> +				- ETH_HLEN /* ethernet hard_header_len */
> +				+ IEEE80211_ENCRYPT_HEADROOM;
> +	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
> +
>  	ret = dev_alloc_name(ndev, ndev->name);
>  	if (ret < 0)
>  		goto fail;

Where is the patch that adds these new members to struct netdevice,
and where is the code that uses these new values?

I even searched the netdev archives and couldn't find it.

Anyways I see your basic idea and this may be the best way to handle
the problem.  The invariants would be:

1) LL_MAX_HEADER has to include all of these bits.

2) LL_RESERVED_SPACE*() has to take the new needed_headroom
   into account.

Your patch which I can't find, which adds netdev->needed_*, probably
does all of that.  But I'm just making sure :-)

Note that what would be really nice is if we could assert, in
dev_queue_xmit, that the SKB has all of the necessary headroom, and
give a WARN_ON_ONCE() backtrace if not.

If we can ensure that, things like mac80211 and others will not need
to skb_realloc_headroom() or anything like that unless they need to
modify packet contents after skb->data and the packet is shared
(ie. the pskb_expand_headroom(skb, 0, 0, GFP_*) case the TSO drivers
use).
