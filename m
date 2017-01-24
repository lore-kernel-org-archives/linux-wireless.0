Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:51758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdAXRl0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 12:41:26 -0500
Date: Tue, 24 Jan 2017 12:41:19 -0500 (EST)
Message-Id: <20170124.124119.2246238373876916746.davem@davemloft.net> (sfid-20170124_184140_848143_AD798B89)
To: linus.luessing@c0d3.blue
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, nbd@nbd.name,
        nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next v5] bridge: multicast to unicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170121200133.1864-1-linus.luessing@c0d3.blue>
References: <20170121200133.1864-1-linus.luessing@c0d3.blue>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Lüssing <linus.luessing@c0d3.blue>
Date: Sat, 21 Jan 2017 21:01:32 +0100

> From: Felix Fietkau <nbd@nbd.name>
> 
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
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> [linus.luessing@c0d3.blue: various bug + style fixes, commit message]
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>

I'm not completely happy that things have progressed this way, however
I don't have a better solution to suggest.
