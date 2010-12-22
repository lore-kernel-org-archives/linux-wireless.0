Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38303 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0LVSWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:22:30 -0500
Received: by qwa26 with SMTP id 26so5420550qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:22:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293009307.3531.13.camel@jlt3.sipsolutions.net>
References: <1293009307.3531.13.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 22 Dec 2010 10:22:08 -0800
Message-ID: <AANLkTik9PS-wKYg=XC0bUaZ=a99d-FdUmzZfvALVQ9Tv@mail.gmail.com>
Subject: Re: [PATCH 2.6.37] mac80211: fix mesh forwarding
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Had I encountered this I would have changed the "failed to clone mesh
frame" message to "I'm about to crash".  Your fix is better.

Thanks!

On Wed, Dec 22, 2010 at 1:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Under memory pressure, the mac80211 mesh code
> may helpfully print a message that it failed
> to clone a mesh frame and then will proceed
> to crash trying to use it anyway. Fix that.
>
> Cc: stable@kernel.org [2.6.27+]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Javier Cardona <javier@cozybit.com>

> ---
>  net/mac80211/rx.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/rx.c     2010-12-22 10:05:58.000000000 +0100
> +++ wireless-testing/net/mac80211/rx.c  2010-12-22 10:06:08.000000000 +0100
> @@ -1831,9 +1831,11 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
>
>                        fwd_skb = skb_copy(skb, GFP_ATOMIC);
>
> -                       if (!fwd_skb && net_ratelimit())
> +                       if (!fwd_skb && net_ratelimit()) {
>                                printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
>                                                   sdata->name);
> +                               goto out;
> +                       }
>
>                        fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
>                        memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
> @@ -1871,6 +1873,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
>                }
>        }
>
> + out:
>        if (is_multicast_ether_addr(hdr->addr1) ||
>            sdata->dev->flags & IFF_PROMISC)
>                return RX_CONTINUE;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
