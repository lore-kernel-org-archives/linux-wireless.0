Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54379 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3B0MhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:37:21 -0500
Received: by mail-ie0-f182.google.com with SMTP id k14so515904iea.41
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 04:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361891395-59990-1-git-send-email-nbd@openwrt.org>
References: <1361891395-59990-1-git-send-email-nbd@openwrt.org>
Date: Wed, 27 Feb 2013 13:37:20 +0100
Message-ID: <CAL1gcdO-SYTeXQhaGQgwE8=ZpK=S9YOnSuizR9WGCHA-X+7kyw@mail.gmail.com> (sfid-20130227_133725_662731_7731F824)
Subject: Re: [PATCH 3.9] rt2x00: error in configurations with mesh support disabled
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Tue, Feb 26, 2013 at 4:09 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
> interface combinations with NL80211_IFTYPE_MESH_POINT present.
> Add appropriate ifdefs to avoid running into errors.

I'm not sure if rt2x00 is the proper place to fix this. To me it
doesn't look good to have to sprinkle these kind of ifdefs throughout
the drivers to check if mac80211 has mesh enabled.
I would prefer a solution where drivers are still able to indicate
that they support mesh interfaces, but where mac80211/cfg80211 prevent
these kind of interfaces from being created.

@Johannes: What is your view on this?

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 1031db6..189744d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1236,8 +1236,10 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>          */
>         if_limit = &rt2x00dev->if_limits_ap;
>         if_limit->max = rt2x00dev->ops->max_ap_intf;
> -       if_limit->types = BIT(NL80211_IFTYPE_AP) |
> -                       BIT(NL80211_IFTYPE_MESH_POINT);
> +       if_limit->types = BIT(NL80211_IFTYPE_AP);
> +#ifdef CONFIG_MAC80211_MESH
> +       if_limit->types |= BIT(NL80211_IFTYPE_MESH_POINT);
> +#endif
>
>         /*
>          * Build up AP interface combinations structure.
> @@ -1309,7 +1311,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>                 rt2x00dev->hw->wiphy->interface_modes |=
>                     BIT(NL80211_IFTYPE_ADHOC) |
>                     BIT(NL80211_IFTYPE_AP) |
> +#ifdef CONFIG_MAC80211_MESH
>                     BIT(NL80211_IFTYPE_MESH_POINT) |
> +#endif
>                     BIT(NL80211_IFTYPE_WDS);
>
>         rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> --
> 1.8.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
