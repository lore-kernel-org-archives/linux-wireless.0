Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45743 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751915AbYGCLze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:34 -0400
In-Reply-To: <20080703.000436.77009639.davem@davemloft.net>
Subject: Re: [PATCH 24/39]: netdev: Allocate multiple queues for TX.
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, Matheos.Worku@Sun.COM,
	mchan@broadcom.com, netdev@vger.kernel.org,
	vinay@linux.vnet.ibm.com
Message-ID: <OF4D241345.95F11555-ON6525747B.002760BE-6525747B.00360059@in.ibm.com> (sfid-20080703_135615_903974_5652AB88)
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Thu, 3 Jul 2008 15:19:50 +0530
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

I have to clone to get a full picture of the changes and that
unfortunately works only in the mornings due to network issues,
so from looking at code on kernel.org:

1. Some netdev_queue variables are called dev_queue and others are
   called txq. Is it to signify difference between functions that are
   single queue vs multiqueue? Can it be made consistent to use txq
   instead since everything is a transmit queue?

2. netif_queue_stopped and netif_subqueue_stopped can be both made to
   call netif_tx_queue_stopped to make them look consistent. Then you
   can delete __netif_subqueue_stopped(). However, I haven't looked if
   any other user of this function is there or not (due to download
   issue).

static inline int netif_tx_queue_stopped(const struct netdev_queue
*dev_queue)
{
      return test_bit(__QUEUE_STATE_XOFF, &dev_queue->state);
}

static inline int netif_queue_stopped(const struct net_device *dev)
{
      return netif_tx_queue_stopped(netdev_get_tx_queue(dev, 0));
}

static inline int netif_subqueue_stopped(const struct net_device *dev,
                                         struct sk_buff *skb)
{
      return netif_tx_queue_stopped(netdev_get_tx_queue(dev,
                                    skb_get_queue_mapping(skb)));
}

3. Since many functions iterate over the list of tx-queues, you could
   optimize all those functions (saving a few cycles per loop), eg:

struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
{
      unsigned int i;

      for (i = 0; i < dev->num_tx_queues; i++) {
            struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
            struct Qdisc *q = __qdisc_lookup(txq, handle);
            if (q)
                  return q;
      }
      return NULL;
}
To ->
struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
{
      struct netdev_queue *txq;
      unsigned int i;

      for (i = 0, txq = netdev_get_tx_queue(dev, 0); i <
dev->num_tx_queues; i++, txq++) {
            struct Qdisc *q = __qdisc_lookup(txq, handle);
            if (q)
                  return q;
      }
      return NULL;
}

And since there are many functions doing:
      for (i = 0; i < dev->num_tx_queues; i++) {
            struct netdev_queue *txq = netdev_get_tx_queue(dev, i);

this can be changed to:
      list_for_each_txq(...)?

If you feel either of these or both will help, I can submit a patch to do
similarly for all the other occurences.

Thanks,

- KK

