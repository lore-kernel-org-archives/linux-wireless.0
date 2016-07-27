Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.sdf.org ([192.94.73.20]:50118 "EHLO sdf.lonestar.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753836AbcG0Kcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 06:32:41 -0400
From: Alan Curry <rlwinm@sdf.org>
Message-Id: <201607271032.u6RAWPcS008174@sdf.org> (sfid-20160727_123306_589102_77DBFA3B)
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
In-Reply-To: <20160724190237.GP2356@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 27 Jul 2016 10:32:25 +0000 (UTC)
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Alan Curry <rlwinm@sdf.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexmcwhirter@triadic.us
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Al Viro wrote:
> 
> Another thing (and if that works, it's *NOT* a proper fix - it would be
> papering over the problem, but at least it would show where to look for
> it) - try (on top of mainline) the following delta:

I tried it on top of v4.6.4 and on top of the very recent v4.7-2509-g59ebc44
from Linus, and still got corruption.

> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index b7de71f..0ee5995 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -734,7 +734,7 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
>  	if (!chunk)
>  		return 0;
>  
> -	if (msg_data_left(msg) < chunk) {
> +	if (iov_iter_single_seg_count(&msg->msg_iter) < chunk) {
>  		if (__skb_checksum_complete(skb))
>  			goto csum_error;
>  		if (skb_copy_datagram_msg(skb, hlen, msg, chunk))
> 

-- 
Alan Curry
