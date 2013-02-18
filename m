Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40448 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3BRSwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 13:52:14 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so2670863bkc.39
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 10:52:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com>
References: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 18 Feb 2013 10:51:50 -0800
Message-ID: <CAG6hwVP=R4b4TEqG1mC8F1F06_jBtRD8VZr-iAT11iY=bayr2g@mail.gmail.com> (sfid-20130218_195218_268054_017A30E6)
Subject: Re: [PATCH] mac80211: fix the problem of unicast forwarding from DS
 to DS in Mesh
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 18, 2013 at 3:16 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Unicast frame with unknown forwarding information always trigger
> the path discovery assuming destination is always located inside the
> MBSS. This patch allows the forwarding to look for mesh gate if path
> discovery inside the MBSS has failed.
>
> Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/tx.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5b9602b..dce3af3 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1844,9 +1844,18 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>                 }
>
>                 if (!is_multicast_ether_addr(skb->data)) {
> -                       mpath = mesh_path_lookup(sdata, skb->data);
> -                       if (!mpath)
> -                               mppath = mpp_path_lookup(sdata, skb->data);
> +                       struct sta_info *next_hop;
> +
> +                       mpath = mesh_path_lookup(skb->data, sdata);

The API is now mesh_path_lookup(sdata, skb->data) :)

> +                       if (mpath)
> +                               next_hop = rcu_dereference(mpath->next_hop);
> +
> +                       if (!mpath || (mpath && (!next_hop ||
> +                                       !(mpath->flags & MESH_PATH_ACTIVE))))

The mpath could still be resolving?

> +                               mppath = mpp_path_lookup(skb->data, sdata);
> +
> +                       if (mppath && mpath)
> +                               mesh_path_del(mpath->dst, mpath->sdata);

In general the mpath / mppath path selection code is very similar to
the point of duplication. I think these are ripe for a refactoring,
where a single mpath could represent an intra-MBSS or mesh gate
proxied destination. This is obviously out of scope for your patch,
but hopefully some day we can make all this mpath code readable :)

-- 
Thomas
