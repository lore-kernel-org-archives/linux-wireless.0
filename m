Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756909AbYEHD0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 23:26:13 -0400
Date: Wed, 07 May 2008 20:26:06 -0700 (PDT)
Message-Id: <20080507.202606.242037993.davem@davemloft.net> (sfid-20080508_052517_251398_44E7CFED)
To: herbert@gondor.apana.org.au
Cc: mb@bu3sch.de, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ron.rindjunsky@intel.com, tomasw@gmail.com, ivdoorn@gmail.com,
	peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080508032208.GA401@gondor.apana.org.au>
References: <20080507130548.GA26977@gondor.apana.org.au>
	<200805071548.06693.mb@bu3sch.de>
	<20080508032208.GA401@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 8 May 2008 11:22:08 +0800

> On Wed, May 07, 2008 at 03:48:06PM +0200, Michael Buesch wrote:
> >
> > So there's no way to actually fail in a TX handler? Drivers
> > are doomed to drop the packet, if they cannot handle it due to
> > ring overflow?
> 
> You're supposed to stop the queue before the ring overflows.

Right, and this is why drivers choose a TX wakeup threshold such
that they can accept an arbitrarily sized TSO frame.

For example, from drivers/net/tg3.c's ->hard_start_xmit():

	if (unlikely(tg3_tx_avail(tp) <= (MAX_SKB_FRAGS + 1))) {
		netif_stop_queue(dev);
		if (tg3_tx_avail(tp) > TG3_TX_WAKEUP_THRESH(tp))
			netif_wake_queue(tp->dev);
	}

The driver is responsible for stopping the queue _before_ it
enters a state where there is not enough space in the queue
to accept a packet.

This is why most drivers make the following kind of BUG check
at the start of their ->hard_start_xmit()

	if (unlikely(tg3_tx_avail(tp) <= (skb_shinfo(skb)->nr_frags + 1))) {
		if (!netif_queue_stopped(dev)) {
			netif_stop_queue(dev);

			/* This is a hard error, log it. */
			printk(KERN_ERR PFX "%s: BUG! Tx Ring full when "
			       "queue awake!\n", dev->name);
		}
		return NETDEV_TX_BUSY;
	}
