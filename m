Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:54393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2DKOLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 10:11:50 -0400
Date: Wed, 11 Apr 2012 10:11:34 -0400 (EDT)
Message-Id: <20120411.101134.410148429938272473.davem@davemloft.net> (sfid-20120411_161155_689192_9D3DCF62)
To: eric.dumazet@gmail.com
Cc: marc@merlins.org, Larry.Finger@lwfinger.net,
	bhutchings@solarflare.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] net: allow pskb_expand_head() to get maximum tailroom
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334124519.5300.2246.camel@edumazet-glaptop>
References: <1334038263.2907.1.camel@edumazet-glaptop>
	<20120411052733.GA17352@merlins.org>
	<1334124519.5300.2246.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 11 Apr 2012 08:08:39 +0200

> Marc Merlin reported many order-1 allocations failures in TX path on its
> wireless setup, that dont make any sense with MTU=1500 network, and non
> SG capable hardware.
> 
> Turns out part of the problem comes from pskb_expand_head() not using
> ksize() to get exact head size given by kmalloc(). Doing the same thing
> than __alloc_skb() allows more tailroom in skb and can prevent future
> reallocations.
> 
> As a bonus, struct skb_shared_info becomes cache line aligned.
> 
> Reported-by: Marc MERLIN <marc@merlins.org>
> Tested-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied and queued up for -stable.
