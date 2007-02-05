Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:46609 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460AbXBEVh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 16:37:26 -0500
Date: Mon, 5 Feb 2007 22:37:24 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John Linville" <linville@tuxdriver.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] d80211: respect extra_tx_headroom
Message-ID: <20070205223724.51398750@griffin.suse.cz>
In-Reply-To: <200702051632.24949.IvDoorn@gmail.com>
References: <200702051632.24949.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Feb 2007 16:32:24 +0100, Ivo van Doorn wrote:
> When a driver requested additional header room
> through the extra_tx_headroom field, the stack
> should respect that and make sure that all frames
> that are being send to the stack actually have
> that extra header room.
> 
> [...]
> --- dscape/net/d80211/ieee80211_sta.c	2007-02-05 16:18:41.000000000 +0100
> [...]
> @@ -2007,6 +2017,8 @@
>  		if (!skb)
>  			break;
>  
> +		skb_reserve(skb, local->hw.extra_tx_headroom);
> +
>  		mgmt = (struct ieee80211_mgmt *)
>  			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
>  		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));

Please enlarge that dev_alloc_skb(400) few lines above by
extra_tx_headroom as well.

Btw, it would be nice if you could use -p option for diff as it makes
reviewing easier for me.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
