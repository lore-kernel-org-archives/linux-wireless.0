Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:32973 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933042AbdAGPPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 10:15:33 -0500
Date: Sat, 7 Jan 2017 16:15:30 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Michael Braun <michael-dev@fami-braun.de>
Subject: Re: [PATCH net-next] bridge: multicast to unicast
Message-ID: <20170107151530.GG3134@otheros> (sfid-20170107_161553_952141_BFE27538)
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
 <1483706872.4089.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1483706872.4089.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 06, 2017 at 01:47:52PM +0100, Johannes Berg wrote:
> How does this compare and/or relate to the multicast-to-unicast feature
> we were going to add to the wifi stack, particularly mac80211? Do we
> perhaps not need that feature at all, if bridging will have it?
> 
> I suppose that the feature there could apply also to locally generated
> traffic when the AP interface isn't in a bridge, but I think I could
> live with requiring the AP to be put into a bridge to achieve a similar
> configuration?
> 
> Additionally, on an unrelated note, this seems to apply generically to
> all kinds of frames, losing information by replacing the address.
> Shouldn't it have similar limitations as the wifi stack feature has
> then, like only applying to ARP, IPv4, IPv6 and not general protocols?

(should all three be answered with Michael's and my reply to
Michael's mail, I think)

> 
> Also, it should probably come with the same caveat as we documented for
> the wifi feature:
> 
>     Note that this may break certain expectations of the receiver,
>     such as the ability to drop unicast IP packets received within
>     multicast L2 frames, or the ability to not send ICMP destination
>     unreachable messages for packets received in L2 multicast (which
>     is required, but the receiver can't tell the difference if this
>     new option is enabled.)

Actually, I do not quite understand that remark in the mac80211
multicast-to-unicast patch. IP should not care about the ethernet
header?
