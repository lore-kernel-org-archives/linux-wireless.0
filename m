Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:17485 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941369AbdAGKjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 05:39:41 -0500
Subject: Re: [PATCH net-next] bridge: multicast to unicast
To: Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
 <8836daaa-9638-4502-d079-fd428595f822@nbd.name>
 <1483710841.12677.1.camel@sipsolutions.net>
Cc: "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <22fad045-57c6-7789-d19f-f47bd0faf441@fami-braun.de> (sfid-20170107_114036_166502_53D6FAD6)
Date: Sat, 7 Jan 2017 11:32:57 +0100
MIME-Version: 1.0
In-Reply-To: <1483710841.12677.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.01.2017 um 14:54 schrieb Johannes Berg:
> 
>> The bridge layer can use IGMP snooping to ensure that the multicast
>> stream is only transmitted to clients that are actually a member of
>> the group. Can the mac80211 feature do the same?
> 
> No, it'll convert the packet for all clients that are behind that
> netdev. But that's an argument for dropping the mac80211 feature, which
> hasn't been merged upstream yet, no?

But there is multicast/broadcast traffic like e.g. ARP and some IP
multicast groups that are not covered by IGMP snooping. The mac80211
patch converts this to unicast as well, which the bridge cannot do.

That way, these features both complement and overlap each other.

Regards,
Michael
