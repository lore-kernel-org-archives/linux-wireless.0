Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52371 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3EAUIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 16:08:12 -0400
Received: by mail-ie0-f182.google.com with SMTP id bn7so2361847ieb.27
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 13:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367421455-18463-7-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-7-git-send-email-juhosg@openwrt.org>
Date: Wed, 1 May 2013 22:08:11 +0200
Message-ID: <CAL1gcdP0ygaGVNqb9XMgzAXqnKEvmj3qPidSeOf+tJJS9_d5ww@mail.gmail.com> (sfid-20130501_220815_084796_50283642)
Subject: Re: [PATCH 6/7] rt2x00: rt2x00dev: defer operational mode detection
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 5:17 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Only do it after the queues are allocated. This
> will allow to use the 'rt2x00dev->bcn->limit'
> instead of 'rt2x00dev->ops->bcn->entry_num'.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   34 +++++++++++++++----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index b287467..6a20172 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1301,23 +1301,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>                 (rt2x00dev->ops->max_ap_intf - 1);
>
>         /*
> -        * Determine which operating modes are supported, all modes
> -        * which require beaconing, depend on the availability of
> -        * beacon entries.
> -        */
> -       rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> -       if (rt2x00dev->ops->bcn->entry_num > 0)
> -               rt2x00dev->hw->wiphy->interface_modes |=
> -                   BIT(NL80211_IFTYPE_ADHOC) |
> -                   BIT(NL80211_IFTYPE_AP) |
> -#ifdef CONFIG_MAC80211_MESH
> -                   BIT(NL80211_IFTYPE_MESH_POINT) |
> -#endif
> -                   BIT(NL80211_IFTYPE_WDS);
> -
> -       rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> -
> -       /*
>          * Initialize work.
>          */
>         rt2x00dev->workqueue =
> @@ -1348,6 +1331,23 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>                 goto exit;
>
>         /*
> +        * Determine which operating modes are supported, all modes
> +        * which require beaconing, depend on the availability of
> +        * beacon entries.
> +        */
> +       rt2x00dev->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> +       if (rt2x00dev->ops->bcn->entry_num > 0)
> +               rt2x00dev->hw->wiphy->interface_modes |=
> +                   BIT(NL80211_IFTYPE_ADHOC) |
> +                   BIT(NL80211_IFTYPE_AP) |
> +#ifdef CONFIG_MAC80211_MESH
> +                   BIT(NL80211_IFTYPE_MESH_POINT) |
> +#endif
> +                   BIT(NL80211_IFTYPE_WDS);
> +
> +       rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> +
> +       /*
>          * Initialize ieee80211 structure.
>          */
>         retval = rt2x00lib_probe_hw(rt2x00dev);
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
---
Gertjan
