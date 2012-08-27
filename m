Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32965 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2H0NuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 09:50:03 -0400
Received: by pbbrr13 with SMTP id rr13so7462791pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 06:50:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp>
References: <5811BCFB-A140-4A91-BF85-8074242B6000@jaist.ac.jp>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 27 Aug 2012 06:49:43 -0700
Message-ID: <CAG6hwVPtKYVcZPOm_p6kCrEPOpsRS_Lc=rWEkEkYW+ZC-8wAcg@mail.gmail.com> (sfid-20120827_155009_138146_D02CAF6F)
Subject: Re: [PATCH] mac80211: Various small fixes for cfg.c: mpath_set_pinfo()
To: LEO Airwarosu Yoichi Shinoda <shinoda@jaist.ac.jp>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shinoda,

On Mon, Aug 27, 2012 at 6:28 AM, LEO Airwarosu Yoichi Shinoda
<shinoda@jaist.ac.jp> wrote:
>
> Various small fixes for net/mac80211/cfg.c:mpath_set_pinfo():
> Initialize *pinfo before filling members in, handle MESH_PATH_RESOLVED
> correctly, and remove bogus assignment; result in correct display
> of FLAGS values and meaningful EXPTIME for expired paths in iw utility.
>
> Signed-off-by: Yoichi Shinoda <shinoda@jaist.ac.jp>
Acked-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/cfg.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index d41974a..d69e38b 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1378,6 +1378,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
>         else
>                 memset(next_hop, 0, ETH_ALEN);
>
> +       memset(pinfo, 0, sizeof(struct mpath_info));
> +

This is probably up to personal preference, but IMO 'sizeof(*p)' is a
little nicer since the compiler already knows the pointer type.

>         pinfo->generation = mesh_paths_generation;
>
>         pinfo->filled = MPATH_INFO_FRAME_QLEN |
> @@ -1396,7 +1398,6 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
>         pinfo->discovery_timeout =
>                         jiffies_to_msecs(mpath->discovery_timeout);
>         pinfo->discovery_retries = mpath->discovery_retries;
> -       pinfo->flags = 0;
>         if (mpath->flags & MESH_PATH_ACTIVE)
>                 pinfo->flags |= NL80211_MPATH_FLAG_ACTIVE;
>         if (mpath->flags & MESH_PATH_RESOLVING)
> @@ -1405,10 +1406,8 @@ static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
>                 pinfo->flags |= NL80211_MPATH_FLAG_SN_VALID;
>         if (mpath->flags & MESH_PATH_FIXED)
>                 pinfo->flags |= NL80211_MPATH_FLAG_FIXED;
> -       if (mpath->flags & MESH_PATH_RESOLVING)
> -               pinfo->flags |= NL80211_MPATH_FLAG_RESOLVING;
> -
> -       pinfo->flags = mpath->flags;
> +       if (mpath->flags & MESH_PATH_RESOLVED)
> +               pinfo->flags |= NL80211_MPATH_FLAG_RESOLVED;
>  }
>
>  static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
> --
> 1.7.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
