Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:59076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbdDGSxR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 14:53:17 -0400
Date: Fri, 07 Apr 2017 11:53:15 -0700 (PDT)
Message-Id: <20170407.115315.23470877439489670.davem@davemloft.net> (sfid-20170407_205320_621296_ABD561C2)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170407182620.6438-1-johannes@sipsolutions.net>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  7 Apr 2017 20:26:17 +0200

> So this is my first draft of what we'd talked about at netconf.
> I'm not super happy with the way we have to pass the extended
> error struct, but I don't see a way to implement reporting any
> dynamic information (like error offsets) in any other way.
> 
> Alexander Shishkin had a nice way of reporting static extended
> error data, but that isn't really suitable for reporting the
> offset or even reporting the broken attribute from nla_parse().
> 
> Speaking of nla_parse(), that'll be somewhat complicated to do
> since we'll have to track the offsets of where we're parsing,
> but it might be possible since the nlattrs are just pointers
> into the message, so (optionally?) passing the skb as well can
> allow us to fill the offset information.

I like it, nice work.

I know people want dynamically generated strings and stuff, and we can
get there, but I prefer that the first thing we commit is super simple.

Someone gave me a hard time about the fact that we've been talking
about this idea for years but nothing ever happens.

I'm tempted to apply this as-is just to show that person that things
do in fact happen.... eventually :-)
