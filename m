Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:46123 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYCaQUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 12:20:21 -0400
Received: by rn-out-0910.google.com with SMTP id e24so600895rng.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 09:20:18 -0700 (PDT)
Message-ID: <1ba2fa240803310920w7dfee53bn81e4a938c219bb23@mail.gmail.com> (sfid-20080331_172025_704097_1951D4B8)
Date: Mon, 31 Mar 2008 19:20:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vladimir Koutny" <vlado@work.ksp.sk>
Subject: Re: [PATCH 1/2] mac80211: correct use_short_preamble handling
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <47F0FD9F.6020709@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47F0FD9F.6020709@work.ksp.sk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 31, 2008 at 6:05 PM, Vladimir Koutny <vlado@work.ksp.sk> wrote:
> ERP IE bit for preamble mode is 0 for short and 1 for long, not the other
> way around. This fixes the value reported to the driver via
> bss_conf->use_short_preamble field.
>
> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
>
> ---
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index f9cf2f1..6fb179a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -360,7 +360,7 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>        struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
>        struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>        bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
> -       bool preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
> +       bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
>        DECLARE_MAC_BUF(mac);
>        u32 changed = 0;
>
> @@ -376,16 +376,15 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
>                changed |= BSS_CHANGED_ERP_CTS_PROT;
>        }
>
> -       if (preamble_mode != bss_conf->use_short_preamble) {
> +       if (use_short_preamble != bss_conf->use_short_preamble) {
>                if (net_ratelimit()) {
>                        printk(KERN_DEBUG "%s: switched to %s barker preamble"
>                               " (BSSID=%s)\n",
>                               sdata->dev->name,
> -                              (preamble_mode == WLAN_ERP_PREAMBLE_SHORT) ?
> -                                       "short" : "long",
> +                              use_short_preamble ? "short" : "long",
>                               print_mac(mac, ifsta->bssid));
>                }
> -               bss_conf->use_short_preamble = preamble_mode;
> +               bss_conf->use_short_preamble = use_short_preamble;
>                changed |= BSS_CHANGED_ERP_PREAMBLE;
>        }


ACK
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
