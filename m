Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49137
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYGCUqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 16:46:10 -0400
Date: Thu, 03 Jul 2008 13:46:10 -0700 (PDT)
Message-Id: <20080703.134610.250208084.davem@davemloft.net> (sfid-20080703_224616_197200_5EE57A19)
To: kaber@trash.net
Cc: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/39]: pkt_sched: Add qdisc_all_tx_empty()
From: David Miller <davem@davemloft.net>
In-Reply-To: <486CCFFE.7060009@trash.net>
References: <20080703.000343.16709755.davem@davemloft.net>
	<486CCFFE.7060009@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 03 Jul 2008 15:11:26 +0200

> David Miller wrote:
> > As per comments, this isn't a foolproof implementation.  This is being
> > added so that we can contain and isolate all the explicit ->tx_queue
> > references in the tree.
> > 
> > +/* Are all TX queues of the device empty?  */
> > +static inline bool qdisc_all_tx_empty(const struct net_device *dev)
> > +{
> > +	struct netdev_queue *txq = &dev->tx_queue;
> > +
> > +	/* XXX This is not correct but it is good enough for the
> > +	 * XXX one place that wants this, IRDA.  If we wanted to
> > +	 * XXX do this right, we'd need to add a qdisc op to
> > +	 * XXX probe for the queue state.
> > +	 */
> > +	return skb_queue_empty(&txq->qdisc->q);
> > +}
> 
> 
> It this comment referring to the fact that its looking at
> qdisc->q itself, while the qdisc might be using internal
> queues? If so, just using txq->qdisc->q.qlen should be
> fine since qdiscs are required to always update this value,
> even if they're not using the queue itself.

Indeed, and this is exactly what the sch_generic.c packet output path
uses as a test too.

Thanks Patrick, I'll fix this up.
