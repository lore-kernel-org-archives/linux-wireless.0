Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42176 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932390AbdAIPrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 10:47:10 -0500
Message-ID: <1483976821.20579.0.camel@sipsolutions.net> (sfid-20170109_164932_356127_678A19EE)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Jan 2017 16:47:01 +0100
In-Reply-To: <ebc5050e12c04273fa518e35d7f0b8bc@fami-braun.de>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
         <1483706872.4089.8.camel@sipsolutions.net>
         <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
         <1483710841.12677.1.camel@sipsolutions.net>
         <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de>
         <20170107145516.GE3134@otheros> <1483949336.17582.3.camel@sipsolutions.net>
         <6f5ec9f1-800a-2bc4-2f41-9d803343bb22@fami-braun.de>
         <1483964159.17582.34.camel@sipsolutions.net>
         <ebc5050e12c04273fa518e35d7f0b8bc@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-09 at 16:25 +0100, michael-dev wrote:
> Am 09.01.2017 13:15, schrieb Johannes Berg:
> > > That is bridge fdb entries (need to) expire so the bridge might
> > > "forget" a still-connected station not sending but only consuming
> > > broadcast traffic.
> > 
> > Ok, that I don't know. Somehow if you address a unicast packet
> > there
> > the bridge has to make a decision - so it really should know?
> 
> If the bridge has not learned the unicast destination mac address on
> any port, it will flood the packet on all ports except the port it
> received the packet on.

Ok, so this really needs to be done in mac80211.

I'll send out the pull request soon then.

johannes
