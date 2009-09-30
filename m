Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50373
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771AbZI3XdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 19:33:14 -0400
Date: Wed, 30 Sep 2009 16:33:33 -0700 (PDT)
Message-Id: <20090930.163333.234658158.davem@davemloft.net>
To: oliver@hartkopp.net
Cc: johannes@sipsolutions.net, mb@bu3sch.de, kalle.valo@iki.fi,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix NOHZ: local_softirq_pending 08
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AC3A0F1.3060306@hartkopp.net>
References: <1254324077.3959.7.camel@johannes.local>
	<4AC39A90.6060602@hartkopp.net>
	<4AC3A0F1.3060306@hartkopp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oliver Hartkopp <oliver@hartkopp.net>
Date: Wed, 30 Sep 2009 20:18:25 +0200

> Socket buffers that are generated and received inside softirqs or from process
> context must not use netif_rx() that's intended to be used from irq context only.
> 
> This patch introduces a new helper function netif_rx_ti(skb) that tests for
> in_interrupt() before invoking netif_rx() or netif_rx_ni().
> 
> It fixes the ratelimited kernel warning
> 
>         NOHZ: local_softirq_pending 08
> 
> in the mac80211 and can subsystems.
> 
> Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>

I bet all of these code paths can use netif_receive_skb() or
don't need this conditional blob at all.

Looking at some specific cases in this patch:

1) VCAN:  This RX routine is only invoked from the drivers
   ->ndo_start_xmit() handler, and therefore like the loopback
   driver we know that BH's are already disabled and therefore
   it can always use netif_rx() safely.

   Why did you convert this case?

   And if this needs to be converted, why doesn't loopback need
   to be?

2) af_can.c:  In what situation will netif_rx_ni() not be appropriate
   here?  It should always execute in softirq or user context, now
   hardirq context.

And the list goes on and on, I don't really like this new conditional
testing of interrupt state.  As always, that's usually a red flag and
as far as I can see these spots where you're changing things are only
trying to receive packets in one of the two possible cases not both.

I'm not applying this until all of these details are sorted out and
you add some verbosity to the commit message explaining each and every
case you are changing, what contexts those cases can be called
from, and from where.

Thanks.
