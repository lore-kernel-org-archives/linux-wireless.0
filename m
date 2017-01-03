Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39051 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756878AbdACNPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 08:15:35 -0500
Subject: Re: [PATCH net-next] bridge: multicast to unicast
To: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
References: <20170102193214.31723-1-linus.luessing@c0d3.blue>
Cc: "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <8db3f67d-a767-d61e-b101-9b78c1f59569@nbd.name> (sfid-20170103_141855_620349_A019F9A6)
Date: Tue, 3 Jan 2017 14:15:29 +0100
MIME-Version: 1.0
In-Reply-To: <20170102193214.31723-1-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-02 20:32, Linus Lüssing wrote:
> Implements an optional, per bridge port flag and feature to deliver
> multicast packets to any host on the according port via unicast
> individually. This is done by copying the packet per host and
> changing the multicast destination MAC to a unicast one accordingly.
> 
> multicast-to-unicast works on top of the multicast snooping feature of
> the bridge. Which means unicast copies are only delivered to hosts which
> are interested in it and signalized this via IGMP/MLD reports
> previously.
> 
> This feature is intended for interface types which have a more reliable
> and/or efficient way to deliver unicast packets than broadcast ones
> (e.g. wifi).
> 
> However, it should only be enabled on interfaces where no IGMPv2/MLDv1
> report suppression takes place. This feature is disabled by default.
> 
> The initial patch and idea is from Felix Fietkau.
> 
> Cc: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Please add Signed-off-by: Felix Fietkau <nbd@nbd.name>
in the next version, and maybe also From:

Thanks,

- Felix
