Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36720 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762403AbYGCNLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 09:11:31 -0400
Message-ID: <486CCFFE.7060009@trash.net> (sfid-20080703_151206_948373_CC45BD2C)
Date: Thu, 03 Jul 2008 15:11:26 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, vinay@linux.vnet.ibm.com,
	krkumar2@in.ibm.com, mchan@broadcom.com, Matheos.Worku@Sun.COM,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/39]: pkt_sched: Add qdisc_all_tx_empty()
References: <20080703.000343.16709755.davem@davemloft.net>
In-Reply-To: <20080703.000343.16709755.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> As per comments, this isn't a foolproof implementation.  This is being
> added so that we can contain and isolate all the explicit ->tx_queue
> references in the tree.
> 
> +/* Are all TX queues of the device empty?  */
> +static inline bool qdisc_all_tx_empty(const struct net_device *dev)
> +{
> +	struct netdev_queue *txq = &dev->tx_queue;
> +
> +	/* XXX This is not correct but it is good enough for the
> +	 * XXX one place that wants this, IRDA.  If we wanted to
> +	 * XXX do this right, we'd need to add a qdisc op to
> +	 * XXX probe for the queue state.
> +	 */
> +	return skb_queue_empty(&txq->qdisc->q);
> +}


It this comment referring to the fact that its looking at
qdisc->q itself, while the qdisc might be using internal
queues? If so, just using txq->qdisc->q.qlen should be
fine since qdiscs are required to always update this value,
even if they're not using the queue itself.
