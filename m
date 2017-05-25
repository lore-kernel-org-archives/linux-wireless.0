Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:59322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942821AbdEYRBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:01:19 -0400
Date: Thu, 25 May 2017 13:01:17 -0400 (EDT)
Message-Id: <20170525.130117.551364108206528221.davem@davemloft.net> (sfid-20170525_190133_361061_0EBFD6D5)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [RFC] skbuff: introduce skb_put_zero()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170524070747.18573-1-johannes@sipsolutions.net>
References: <20170524070747.18573-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 24 May 2017 09:07:47 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> This pattern was introduced a number of times in mac80211 just now,
> and since it's present in a number of other places it makes sense
> to add a little helper for it.
> 
> The transformations of all code were done with the following spatch:
> 
> @@
> identifier p;
> expression len;
> expression skb;
> @@
> -p = skb_put(skb, len);
> -memset(p, 0, len);
> +p = skb_put_zero(skb, len);
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> NB: the patch won't apply to net-next because a few of the mac80211
>     users don't exist there yet

Acked-by: David S. Miller <davem@davemloft.net>

No objections, feel free to push this in via your mac80211 tree.
