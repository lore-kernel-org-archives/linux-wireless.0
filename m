Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYCZPSi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 11:18:38 -0400
Subject: Re: [PATCH] libertas: fix spinlock recursion bug
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261541.48877.hs4233@mail.mn-solutions.de>
References: <200803191524.21866.hs4233@mail.mn-solutions.de>
	 <200803261541.48877.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 11:17:30 -0400
Message-Id: <1206544650.31383.15.camel@localhost.localdomain> (sfid-20080326_151842_649945_D7646AD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 15:41 +0100, Holger Schurig wrote:
> Hmm, that isn't the end of my spinlock problems. When I'm 
> associated and ping, I get another recursion:

Hmm, so netif_rx() can eventually result in call to hard_start_xmit()
later down the stack?  Ugh.  It's probably a consequence of the driver
not poking the network stack in the right way to say "hey, I'm busy" or
not punting something to a workqueue or whatever.

I agree the indirection in the current SDIO and USB drivers sucks, but
I'm getting more and more convinced that the way that the CF driver is
handling this sucks too.

Dan

> libertas assoc: associated to 00:13:19:80:da:30
> BUG: spinlock recursion on CPU#0, lbs_main/5566
>  lock: f58b58d8, .magic: dead4ead, .owner: 
> lbs_main/5566, .owner_cpu: 0
> Pid: 5566, comm: lbs_main Not tainted 2.6.25-rc5-wl #19
>  [<c01ccdb7>] spin_bug+0x76/0xb1
>  [<c01ccecb>] _raw_spin_lock+0x34/0xc9
>  [<c0306984>] _spin_lock_irqsave+0x17/0x1c
>  [<f8c33cdf>] lbs_hard_start_xmit+0x61/0x4e2 [libertas]
>  [<c0306bef>] ? _spin_unlock+0x8/0x1f
>  [<c014f497>] ? cache_alloc_refill+0x18c/0x439
>  [<c02b449b>] dev_hard_start_xmit+0x16f/0x1dc
>  [<c02c0f8b>] __qdisc_run+0x7a/0x14e
>  [<c02b67ba>] dev_queue_xmit+0x119/0x23b
>  [<c02bb187>] neigh_resolve_output+0x20a/0x236
>  [<c02b978e>] neigh_update+0x2c0/0x36a
>  [<c02c04e3>] ? eth_header_cache_update+0x0/0x12
>  [<c02e4331>] arp_process+0x4d6/0x50e
>  [<c02afc6d>] ? skb_release_data+0x84/0x89
>  [<c02afb6d>] ? __kfree_skb+0x61/0x64
>  [<c02e440c>] arp_rcv+0xa3/0xb3
>  [<c02b4021>] netif_receive_skb+0x1f7/0x26a
>  [<c02b643c>] process_backlog+0x5b/0xa5
>  [<c02b5fa3>] net_rx_action+0x7f/0x142
>  [<c011befe>] __do_softirq+0x38/0x70
>  [<c011bf5b>] do_softirq+0x25/0x2a
>  [<c02b5ea4>] netif_rx_ni+0x24/0x3e
>  [<f8c33b59>] lbs_process_rxed_packet+0x755/0x7c0 [libertas]
>  [<c02b024c>] ? __alloc_skb+0x4c/0xf8
>  [<f88f9096>] if_cs_get_int_status+0x22a/0x3d8 [libertas_cs]
>  [<f8c2ef5e>] lbs_thread+0x2fe/0x745 [libertas]
>  [<c0114edd>] ? default_wake_function+0x0/0xd
>  [<f8c2ec60>] ? lbs_thread+0x0/0x745 [libertas]
>  [<c0126f91>] kthread+0x39/0x60
>  [<c0126f58>] ? kthread+0x0/0x60
>  [<c01043c3>] kernel_thread_helper+0x7/0x10
>  =======================
> 

