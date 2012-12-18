Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51640 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2LREpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 23:45:44 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so2589852wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 20:45:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355798517-27063-1-git-send-email-thomas@cozybit.com>
References: <1355798517-27063-1-git-send-email-thomas@cozybit.com>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 17 Dec 2012 20:38:12 -0800
Message-ID: <CAPjQAd8VdGeVjWnKaMh8x-vJhtjCASU-u2qcMivwrokuyt1M-A@mail.gmail.com> (sfid-20121218_054548_416935_BD7408E3)
Subject: Re: [PATCH] mac80211: RMC buckets are just list heads
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2012 at 6:41 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> The array of rmc_entrys is redundant since only the
> list_head is used. Make this an array of list_heads
> instead and save ~6k per vif at runtime :D

Nice!

> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh.c |    8 ++++----
>  net/mac80211/mesh.h |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 1bf03f9..649ad51 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -163,7 +163,7 @@ int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
>                 return -ENOMEM;
>         sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
>         for (i = 0; i < RMC_BUCKETS; i++)
> -               INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i].list);
> +               INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
>         return 0;
>  }
>
> @@ -177,7 +177,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
>                 return;
>
>         for (i = 0; i < RMC_BUCKETS; i++)
> -               list_for_each_entry_safe(p, n, &rmc->bucket[i].list, list) {
> +               list_for_each_entry_safe(p, n, &rmc->bucket[i], list) {
>                         list_del(&p->list);
>                         kmem_cache_free(rm_cache, p);
>                 }
> @@ -210,7 +210,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
>         /* Don't care about endianness since only match matters */
>         memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
>         idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
> -       list_for_each_entry_safe(p, n, &rmc->bucket[idx].list, list) {
> +       list_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
>                 ++entries;
>                 if (time_after(jiffies, p->exp_time) ||
>                                 (entries == RMC_QUEUE_MAX_LEN)) {
> @@ -229,7 +229,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
>         p->seqnum = seqnum;
>         p->exp_time = jiffies + RMC_TIMEOUT;
>         memcpy(p->sa, sa, ETH_ALEN);
> -       list_add(&p->list, &rmc->bucket[idx].list);
> +       list_add(&p->list, &rmc->bucket[idx]);
>         return 0;
>  }
>
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index 7c9215f..84c28c6 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -184,7 +184,7 @@ struct rmc_entry {
>  };
>
>  struct mesh_rmc {
> -       struct rmc_entry bucket[RMC_BUCKETS];
> +       struct list_head bucket[RMC_BUCKETS];
>         u32 idx_mask;
>  };
>
> --
> 1.7.10.4
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
