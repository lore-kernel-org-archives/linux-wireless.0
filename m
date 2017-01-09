Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38152 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753306AbdAIIF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 03:05:59 -0500
Message-ID: <1483949149.17582.1.camel@sipsolutions.net> (sfid-20170109_090625_757834_008330AE)
Subject: Re: [PATCH net-next] bridge: multicast to unicast
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Date: Mon, 09 Jan 2017 09:05:49 +0100
In-Reply-To: <20170107151530.GG3134@otheros>
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
         <1483706872.4089.8.camel@sipsolutions.net> <20170107151530.GG3134@otheros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-01-07 at 16:15 +0100, Linus Lüssing wrote:

> Actually, I do not quite understand that remark in the mac80211
> multicast-to-unicast patch. IP should not care about the ethernet
> header?

But it does, for example RFC 1122 states:

         When a host sends a datagram to a link-layer broadcast address,
         the IP destination address MUST be a legal IP broadcast or IP
         multicast address.

         A host SHOULD silently discard a datagram that is received via
         a link-layer broadcast (see Section 2.4) but does not specify
         an IP multicast or broadcast destination address.

You can probably find other examples too.

johannes
