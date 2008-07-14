Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36399
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYGNMAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:00:11 -0400
Date: Mon, 14 Jul 2008 05:00:11 -0700 (PDT)
Message-Id: <20080714.050011.186100773.davem@davemloft.net> (sfid-20080714_140016_388254_F2E3CD73)
To: jarkao2@gmail.com
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/39]: netdev: Move next_sched into struct
 netdev_queue.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080714114913.GA4504@ff.dom.local>
References: <20080703.000333.199735542.davem@davemloft.net>
	<20080714114913.GA4504@ff.dom.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 14 Jul 2008 11:49:13 +0000

> On 03-07-2008 09:03, David Miller wrote:
> > We schedule queues, not the device, for output queue
> > processing in BH.
> > 
> ...
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8e38948..c5e3532 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1323,13 +1323,14 @@ static void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev)
> >  void __netif_schedule(struct net_device *dev)
> >  {
> >  	if (!test_and_set_bit(__LINK_STATE_SCHED, &dev->state)) {
> 
> Isn't this bit supposed to be set/tested per queue as well, or do I
> miss something?

That shoule not happen until my later patches which switch that all
over.

See patch 5/13 which I posted on Thursday, Jul 10.  That's when the
transition from "global queue state + per-queue state" into "only
per-queue state" happens.

Until that point, we have to keep the existing quasi-multi-queue
semantics in order to not break drivers etc.
