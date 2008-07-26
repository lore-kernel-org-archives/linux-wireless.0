Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:10624 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYGZNRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 09:17:43 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3157518ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jul 2008 06:17:41 -0700 (PDT)
Date: Sat, 26 Jul 2008 15:18:38 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080726131838.GA2873@ami.dom.local> (sfid-20080726_151749_854708_2AD8ECCE)
References: <20080725193416.GB3107@ami.dom.local> <1217014575.4758.7.camel@johannes.berg> <20080725200137.GC3107@ami.dom.local> <20080726.021846.236624483.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080726.021846.236624483.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 26, 2008 at 02:18:46AM -0700, David Miller wrote:
...
> I think there might be an easier way, but we may have
> to modify the state bits a little.
> 
> Every call into ->hard_start_xmit() is made like this:
> 
> 1. lock TX queue
> 2. check TX queue stopped
> 3. call ->hard_start_xmit() if not stopped
> 
> This means that we can in fact do something like:
> 
> 	unsigned int i;
> 
> 	for (i = 0; i < dev->num_tx_queues; i++) {
> 		struct netdev_queue *txq;
> 
> 		txq = netdev_get_tx_queue(dev, i);
> 		spin_lock_bh(&txq->_xmit_lock);
> 		netif_tx_freeze_queue(txq);
> 		spin_unlock_bh(&txq->_xmit_lock);
> 	}
> 
> netif_tx_freeze_queue() just sets a new bit we add.
> 
> Then we go to the ->hard_start_xmit() call sites and check this new
> "frozen" bit as well as the existing "stopped" bit.
> 
> When we unfreeze each queue later, we see if it is stopped, and if not
> we schedule it's qdisc for packet processing.

I guess some additional synchronization will be added yet to prevent
parallel freeze and especially unfreeze.

Jarek P.
