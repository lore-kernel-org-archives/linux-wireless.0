Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:45079 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYGYTdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 15:33:20 -0400
Received: by ug-out-1314.google.com with SMTP id h2so27245ugf.16
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 12:33:19 -0700 (PDT)
Date: Fri, 25 Jul 2008 21:34:16 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Oeser <netdev@axxeo.de>, David Miller <davem@davemloft.net>,
	peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080725193416.GB3107@ami.dom.local> (sfid-20080725_213325_377743_66B76470)
References: <1216806614.7257.152.camel@twins> <1216810696.7257.175.camel@twins> <20080723.131441.200166513.davem@davemloft.net> <200807251904.37302.netdev@axxeo.de> <20080725183622.GA3107@ami.dom.local> <1217013384.4758.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217013384.4758.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 25, 2008 at 09:16:24PM +0200, Johannes Berg wrote:
> On Fri, 2008-07-25 at 20:36 +0200, Jarek Poplawski wrote:
> > On Fri, Jul 25, 2008 at 07:04:36PM +0200, Ingo Oeser wrote:
> > ...
> > > I'm sure as hell, I miss sth. but can't it be done by this pseudo-code:
> > 
> > ...And I really doubt it can't be done like this.
> 
> Umm, of course it cannot, because then we'd have to take the mutex in
> the TX path, which we cannot. We cannot have another lock in the TX
> path, what's so hard to understand about? We need to be able to lock all
> queues to lock out multiple tx paths at once in some (really) slow paths
> but not have any extra lock overhead for the tx path, especially not a
> single lock.

But this mutex doesn't have to be mutex. And it's not for the tx path,
only for "service" just like netif_tx_lock(). The fast path needs only
queue->tx_lock.

Jarek P.
