Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56303 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3LSP5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 10:57:00 -0500
Received: by mail-ve0-f176.google.com with SMTP id oz11so755418veb.7
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 07:56:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387442279-1526-2-git-send-email-twpedersen@gmail.com>
References: <1387442279-1526-1-git-send-email-twpedersen@gmail.com> <1387442279-1526-2-git-send-email-twpedersen@gmail.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Thu, 19 Dec 2013 19:56:39 +0400
Message-ID: <CAHNKnsR1yfSZaZiDS3k27ZcpDxbLohP2DNOLz=eoJqpZWS5udQ@mail.gmail.com> (sfid-20131219_165713_735185_2C3D6837)
Subject: Re: [PATCH 2/2] mac80211: sync dtim_count to TSF
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/12/19 Thomas Pedersen <twpedersen@gmail.com>:
> On starting a mesh, ad-hoc, or AP BSS, the interface
> dtim_count countdown should match that of the driver TSF.
>
...
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index ac18528..8211d30 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -951,6 +951,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>                               struct cfg80211_ap_settings *params)
>  {
>         struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = sdata->local;
>         struct beacon_data *old;
>         struct ieee80211_sub_if_data *vlan;
>         u32 changed = BSS_CHANGED_BEACON_INT |
> @@ -1030,6 +1031,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>                 return err;
>         }
>
> +       ieee80211_recalc_dtim(local, sdata);
>         ieee80211_bss_info_change_notify(sdata, changed);
>
>         netif_carrier_on(dev);
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 04b5a14..89160f7 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -468,6 +468,7 @@ static ssize_t ieee80211_if_parse_tsf(
>                 }
>         }
>
> +       ieee80211_recalc_dtim(local, sdata);
>         return buflen;
>  }
>  __IEEE80211_IF_FILE_W(tsf);
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index d6ba8414..a92c8a9 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -369,6 +369,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>                 return;
>         }
>
> +       ieee80211_recalc_dtim(local, sdata);
>         ieee80211_bss_info_change_notify(sdata, bss_change);
>
>         ifibss->state = IEEE80211_IBSS_MLME_JOINED;
...
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 5a74b24..5b919ca 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -807,6 +807,7 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>                 return -ENOMEM;
>         }
>
> +       ieee80211_recalc_dtim(local, sdata);
>         ieee80211_bss_info_change_notify(sdata, changed);
>
>         netif_carrier_on(sdata->dev);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 656648b..599cf37 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -2588,3 +2588,31 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
>
>         return headroom;
>  }
> +
> +void ieee80211_recalc_dtim(struct ieee80211_local *local,
> +                          struct ieee80211_sub_if_data *sdata)
> +{
...
> +       sdata->u.mesh.ps.dtim_count = dtim_count;
> +}

Apologize for my intrusiveness, but could this write operation lead to
unpredictable results for non-mesh interfaces?

-- 
BR,
Sergey
