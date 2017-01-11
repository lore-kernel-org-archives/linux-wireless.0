Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59216 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762901AbdAKJSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 04:18:09 -0500
Message-ID: <1484126278.23671.3.camel@sipsolutions.net> (sfid-20170111_101833_651107_865D9000)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Date: Wed, 11 Jan 2017 10:17:58 +0100
In-Reply-To: <20170109231203.GC5513@otheros>
References: <20170109231203.GC5513@otheros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Exactly. My point is that this is breaking the expectation that
> > hosts are actually able to drop such packets.
> 
> [readding CCs I removed earlier]
> 
> Ah! Thanks. I was worried about creating packetloss :D.

Ah, well, no - at least not in this case.

> Hm, for this other other way round, I think it does not apply for
> the bridge multicast-to-unicast patch if I'm not misreading the
> bridge code:
> 
> For a packet with a link-layer multicast address but a unicast IP
> destination, the bridge MDB lookup will fail.
> (http://lxr.free-electrons.com/source/net/bridge/br_multicast.c?v=4.8
> #L178
>  returns NULL)
> 
> Case A): No multicast router on port:
> -> bridge, br_multicast_flood(), will drop the packet already
>    (no matter if multicast-to-unicast is enabled or not)
> 
> Case B): Multicast router present on port:
> -> The new patch does not apply multicast-to-unicast but just floods
>    packet unaltered
>    ("else { port = rport; addr = NULL; }" branch)

Ah, interesting. This is different then - the mac80211 code is not L3
aware at all.

johannes
