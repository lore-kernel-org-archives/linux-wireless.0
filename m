Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:10866 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGYSfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 14:35:53 -0400
Received: by ik-out-1112.google.com with SMTP id c28so2798930ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 11:35:51 -0700 (PDT)
Date: Fri, 25 Jul 2008 20:36:22 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ingo Oeser <netdev@axxeo.de>
Cc: David Miller <davem@davemloft.net>, peterz@infradead.org,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080725183622.GA3107@ami.dom.local> (sfid-20080725_203602_626786_F66C7AF2)
References: <1216806614.7257.152.camel@twins> <1216810696.7257.175.camel@twins> <20080723.131441.200166513.davem@davemloft.net> <200807251904.37302.netdev@axxeo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807251904.37302.netdev@axxeo.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 25, 2008 at 07:04:36PM +0200, Ingo Oeser wrote:
...
> I'm sure as hell, I miss sth. but can't it be done by this pseudo-code:

...And I really doubt it can't be done like this.

Jarek P.

> 
> netif_tx_lock(device)
> {
> 	mutex_lock(device->queue_entry_mutex);
> 	foreach_queue_entries(queue, device->queues)
> 	{
> 		spin_lock(queue->tx_lock);
> 		set_noop_tx_handler(queue);
> 		spin_unlock(queue->tx_lock);
> 	}
> 	mutex_unlock(device->queue_entry_mutex);
> }
> 
> netif_tx_unlock(device)
> {
> 	mutex_lock(device->queue_entry_mutex);
> 	foreach_queue_entries(queue, device->queues)
> 	{
> 		spin_lock(queue->tx_lock);
> 		set_useful_tx_handler(queue);
> 		spin_unlock(queue->tx_lock);
> 	}
> 	mutex_unlock(device->queue_entry_mutex);
> }
> 
> Then protect use of the queues by queue->tx_lock in transmit path.
> The first setup of the queue doesn't need to be protected, since no-one
> knows the device. The final cleanup of the device doesn't need to be
> protected either, because netif_tx_lock() and netif_tx_unlock() should
> not be called after entering the final cleanup.
> 
> Some VM locking works this way...
> 
> 
> Best Regards
> 
> Ingo Oeser
