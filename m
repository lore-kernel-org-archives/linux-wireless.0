Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:54414 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2DKOMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 10:12:16 -0400
Date: Wed, 11 Apr 2012 10:12:01 -0400 (EDT)
Message-Id: <20120411.101201.40584059095994801.davem@davemloft.net> (sfid-20120411_161223_540190_5D2FCAFE)
To: eric.dumazet@gmail.com
Cc: marc@merlins.org, Larry.Finger@lwfinger.net,
	bhutchings@solarflare.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: avoid order-1 allocations on wifi and tx path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334129882.5300.2539.camel@edumazet-glaptop>
References: <1334122980.5300.2154.camel@edumazet-glaptop>
	<1334125848.5300.2330.camel@edumazet-glaptop>
	<1334129882.5300.2539.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 11 Apr 2012 09:38:02 +0200

> David, I forgot to say this should be backported to 3.2 & 3.3

Yep.

> commit 87fb4b7b533073 (net: more accurate skb truesize) did the
> placement of skb_shared_info at the end of skb head, so
> sk_stream_alloc_skb() had to reserve more room so that tailroom stayed
> at MSS

Will keep that in mind, thanks.
