Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60468 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757177AbdAFNyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:54:08 -0500
Message-ID: <1483710841.12677.1.camel@sipsolutions.net> (sfid-20170106_145438_248442_484DE4C5)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Michael Braun <michael-dev@fami-braun.de>
Date: Fri, 06 Jan 2017 14:54:01 +0100
In-Reply-To: <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
         <1483706872.4089.8.camel@sipsolutions.net>
         <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The bridge layer can use IGMP snooping to ensure that the multicast
> stream is only transmitted to clients that are actually a member of
> the group. Can the mac80211 feature do the same?

No, it'll convert the packet for all clients that are behind that
netdev. But that's an argument for dropping the mac80211 feature, which
hasn't been merged upstream yet, no?

johannes
