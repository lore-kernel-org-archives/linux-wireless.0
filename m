Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37536 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdACMKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 07:10:32 -0500
Received: by mail-wm0-f48.google.com with SMTP id t79so427548019wmt.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 04:10:31 -0800 (PST)
Subject: Re: [PATCH V4 2/2] cfg80211: support ieee80211-freq-limit DT property
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170103110340.23249-1-zajec5@gmail.com>
 <20170103110340.23249-2-zajec5@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a67789ba-3346-6e10-89c2-2df419a80910@broadcom.com> (sfid-20170103_131036_588483_89347855)
Date: Tue, 3 Jan 2017 13:10:27 +0100
MIME-Version: 1.0
In-Reply-To: <20170103110340.23249-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-1-2017 12:03, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This patch adds a helper for reading that new property and applying
> limitations or supported channels specified this way.
> It may be useful for specifying single band devices or devices that
> support only some part of the whole band. It's common that tri-band
> routers have separated radios for lower and higher part of 5 GHz band.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Put main code in core.c as it isn't strictly part of regulatory - pointed
>     by Arend.
>     Update to support ieee80211-freq-limit (new property).
> V3: Introduce separated wiphy_read_of_freq_limits function.
>     Add extra sanity checks for DT data.
>     Move code back to reg.c as suggested by Johannes.
> V4: Move code to of.c
>     Use one helper called at init time (no runtime hooks)
>     Modify orig_flags
> ---
>  include/net/cfg80211.h |  26 ++++++++++
>  net/wireless/Makefile  |   1 +
>  net/wireless/of.c      | 137 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/reg.c     |   4 +-
>  net/wireless/reg.h     |   2 +
>  5 files changed, 168 insertions(+), 2 deletions(-)
>  create mode 100644 net/wireless/of.c
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ca2ac1c..d7723a8 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -311,6 +311,32 @@ struct ieee80211_supported_band {
>  	struct ieee80211_sta_vht_cap vht_cap;
>  };
>  
> +/**
> + * wiphy_read_of_freq_limits - read frequency limits from device tree
> + *
> + * @wiphy: the wireless device to get extra limits for
> + *
> + * Some devices may have extra limitations specified in DT. This may be useful
> + * for chipsets that normally support more bands but are limited due to board
> + * design (e.g. by antennas or extermal power amplifier).
> + *
> + * This function reads info from DT and uses it to *modify* channels (disable
> + * unavailable ones). It's usually a *bad* idea to use it in drivers with
> + * shared channel data as DT limitations are device specific.
> + *
> + * As this function access device node it has to be called after set_wiphy_dev.

You are aware that you need to modify this description with earlier
patch "cfg80211: allow passing struct device in the wiphy_new call",
right? :-p

> + * It also modifies channels so they have to be set first.
> + */
> +#ifdef CONFIG_OF
> +int wiphy_read_of_freq_limits(struct wiphy *wiphy);
> +#else /* CONFIG_OF */
> +static inline int wiphy_read_of_freq_limits(struct wiphy *wiphy)
> +{
> +	return 0;
> +}
> +#endif /* !CONFIG_OF */
> +
> +

[...]

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 5dbac37..bda0e9e 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -748,8 +748,8 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
>  	return true;
>  }
>  
> -static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
> -			    u32 center_freq_khz, u32 bw_khz)
> +bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
> +		     u32 center_freq_khz, u32 bw_khz)
>  {
>  	u32 start_freq_khz, end_freq_khz;

would it be more appropriate to move this function to util.c?

Regards,
Arend
