Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35014 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751631AbcLGJkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:40:06 -0500
Message-ID: <1481103603.4092.38.camel@sipsolutions.net> (sfid-20161207_104008_553050_B01ED505)
Subject: Re: [PATCH] mac80211: Ensure enough headroom when forwarding mesh
 pkt
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Laurent Trarieux <Laurent.Trarieux@ceva-dsp.com>
Date: Wed, 07 Dec 2016 10:40:03 +0100
In-Reply-To: <356db1fcf788467f9145abc10e218d66@ceva-dsp.com> (sfid-20161206_134746_387190_5D33F815)
References: <356db1fcf788467f9145abc10e218d66@ceva-dsp.com>
         (sfid-20161206_134746_387190_5D33F815)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -	fwd_skb = skb_copy(skb, GFP_ATOMIC);
> +	if (skb_headroom(skb) >= local->tx_headroom)
> +		fwd_skb = skb_copy(skb, GFP_ATOMIC);
> +	else
> +		fwd_skb = skb_copy_expand(skb, local->tx_headroom,
> +					  0, GFP_ATOMIC);

Why bother making this conditional? It seems that always using
skb_copy_expand() should be sufficient? The code between the two
(skb_copy, skb_copy_expand) is almost identical anyway, apart from the
latter setting the headroom (and tailroom).

johannes
