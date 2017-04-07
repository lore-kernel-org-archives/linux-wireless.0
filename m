Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51660 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934392AbdDGTGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:06:37 -0400
Message-ID: <1491591988.5800.5.camel@sipsolutions.net> (sfid-20170407_210700_491341_44722DBF)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 07 Apr 2017 21:06:28 +0200
In-Reply-To: <20170407190204.GA22810@salvia>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
         <20170407.115315.23470877439489670.davem@davemloft.net>
         <20170407190204.GA22810@salvia>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 21:02 +0200, Pablo Neira Ayuso wrote:
> 
> > I'm tempted to apply this as-is just to show that person that
> > things do in fact happen.... eventually :-)
> 
> We can just send follow up patches to refine, I think it's a good
> start, Johannes?

I guess we can. Like I just said though - I do have a plan to make
nla_parse() work but the week's been exhausting enough that I don't
feel entirely comfortable saying that will definitely work.

OTOH, arguably this is something that seems to work - as evidenced by
the nl80211 changes - for at least some error reporting, so I guess we
can continue to refine it, and the only thing we're really locking in
to is the ABI, which is TLVs now, so that should be safe.

That said, the nl80211 patch really should be bigger, and I've not even
tested this at all yet, so I really need to do that first.

Also, I'd like to point to the genl_info change, does that seem like a
reasonable way to pass it around in genetlink? I'm much less familiar
with the "regular" netlink to say how to pass it around there beyond
what I already did.

johannes
