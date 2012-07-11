Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34668 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242Ab2GKBJ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 21:09:28 -0400
Message-ID: <1341968967.13724.23.camel@joe2Laptop> (sfid-20120711_030935_726325_30E5CB83)
Subject: Re: [PATCH] etherdevice: introduce eth_broadcast_addr
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, johannes@sipsolutions.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 10 Jul 2012 18:09:27 -0700
In-Reply-To: <20120710.174142.995966539991957646.davem@davemloft.net>
References: <20120708.235808.1602900783296556684.davem@davemloft.net>
	 <1341937124.4475.27.camel@jlt3.sipsolutions.net>
	 <CAP=VYLqNyAF1gSsKTd3YojeJXK_-pEzXAKyVQbQfwhtwOyMmwg@mail.gmail.com>
	 <20120710.174142.995966539991957646.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 17:41 -0700, David Miller wrote:
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Tue, 10 Jul 2012 20:09:44 -0400
> 
> > On Tue, Jul 10, 2012 at 12:18 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> From: Johannes Berg <johannes.berg@intel.com>
> >>
> >> A lot of code has either the memset or an inefficient copy
> >> from a static array that contains the all-ones broadcast
> > 
> > Shouldn't we see all that "lot of code" here in this same
> > commit, now using this new shortcut?

If I grepped properly, there are 42 instances of static arrays for
for broadcast ethernet addresses in drivers/net and drivers/staging
so it'd save some smallish amount of code by using a combination of
is_broadcast_ether_addr and this new func.

I think there are 53 instances of the memset(foo, 0xff, 6|ETH_ALEN).

> I disagree and I intend to apply Johannes's patch as-is to net-next.

Sounds fine to me.

For some additional style symmetry, how about a conversion of
random_ether_address to eth_random_addr too via

o Rename random_ether_addr to eth_random_addr and add a
  #define random_ether_addr eth_random_addr
o sed 's/\brandom_ether_addr\b/eth_random_addr/g' files_that_use_REA
o remove the #define after awhile


