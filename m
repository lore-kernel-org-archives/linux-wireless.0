Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:34326 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbdAIMmf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 07:42:35 -0500
Date: Mon, 9 Jan 2017 13:42:31 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Subject: Re: [PATCH net-next] bridge: multicast to unicast
Message-ID: <20170109124231.GA9086@otheros> (sfid-20170109_134339_792481_447AB8CA)
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
 <20170107151530.GG3134@otheros>
 <1483949149.17582.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1483949149.17582.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 09, 2017 at 09:05:49AM +0100, Johannes Berg wrote:
> On Sat, 2017-01-07 at 16:15 +0100, Linus Lüssing wrote:
> 
> > Actually, I do not quite understand that remark in the mac80211
> > multicast-to-unicast patch. IP should not care about the ethernet
> > header?
> 
> But it does, for example RFC 1122 states:
> 
>          When a host sends a datagram to a link-layer broadcast address,
>          the IP destination address MUST be a legal IP broadcast or IP
>          multicast address.
> 
>          A host SHOULD silently discard a datagram that is received via
>          a link-layer broadcast (see Section 2.4) but does not specify
>          an IP multicast or broadcast destination address.

This example is the other way round. It specifies how the IP
destination should look like in case of link-layer broadcast. Not
how the link-layer destination should look like in case of a
multicast/broadcast IP destination.

Any other examples?
