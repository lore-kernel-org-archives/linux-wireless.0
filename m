Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:8722 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYGNMWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:22:41 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2079222fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 05:22:40 -0700 (PDT)
Date: Mon, 14 Jul 2008 12:27:33 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/39]: netdev: Move next_sched into struct
	netdev_queue.
Message-ID: <20080714122733.GA4573@ff.dom.local> (sfid-20080714_142246_243442_51BDF33A)
References: <20080703.000333.199735542.davem@davemloft.net> <20080714114913.GA4504@ff.dom.local> <20080714.050011.186100773.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080714.050011.186100773.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 05:00:11AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Mon, 14 Jul 2008 11:49:13 +0000
> 
> > On 03-07-2008 09:03, David Miller wrote:
> > > We schedule queues, not the device, for output queue
> > > processing in BH.
> > > 
> > ...
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 8e38948..c5e3532 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -1323,13 +1323,14 @@ static void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev)
> > >  void __netif_schedule(struct net_device *dev)
> > >  {
> > >  	if (!test_and_set_bit(__LINK_STATE_SCHED, &dev->state)) {
> > 
> > Isn't this bit supposed to be set/tested per queue as well, or do I
> > miss something?
> 
> That shoule not happen until my later patches which switch that all
> over.
> 
> See patch 5/13 which I posted on Thursday, Jul 10.  That's when the
> transition from "global queue state + per-queue state" into "only
> per-queue state" happens.
> 
> Until that point, we have to keep the existing quasi-multi-queue
> semantics in order to not break drivers etc.

I've just wondered how this 1-13/13 step can work without this...

Jarek P.
