Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:33731 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbcL1VIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 16:08:02 -0500
Received: by mail-qk0-f169.google.com with SMTP id t184so256218647qkd.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2016 13:08:01 -0800 (PST)
Subject: Re: [PATCH 2/2] cfg80211: reg: support
 ieee80211-(min|max)-center-freq DT properties
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20161228155955.25518-1-zajec5@gmail.com>
 <20161228155955.25518-2-zajec5@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <491a5af2-449d-4b2a-c4ed-af0e89b2ca78@broadcom.com> (sfid-20161228_220810_420648_7950F7E5)
Date: Wed, 28 Dec 2016 22:07:55 +0100
MIME-Version: 1.0
In-Reply-To: <20161228155955.25518-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-12-16 16:59, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> They allow specifying hardware limitations of supported channels. This
> may be useful for specifying single band devices or devices that support
> only some part of the whole band.
> E.g. some tri-band routers have separated radios for lower and higher
> part of 5 GHz band.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  net/wireless/reg.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 5dbac37..35ba5c7 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1123,6 +1123,26 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
>  }
>  EXPORT_SYMBOL(reg_initiator_name);
>  
> +static bool reg_center_freq_of_valid(struct wiphy *wiphy,
> +				     struct ieee80211_channel *chan)
> +{
> +	struct device_node *np = wiphy_dev(wiphy)->of_node;
> +	u32 val;
> +
> +	if (!np)
> +		return true;
> +
> +	if (!of_property_read_u32(np, "ieee80211-min-center-freq", &val) &&
> +	    chan->center_freq < KHZ_TO_MHZ(val))
> +		return false;
> +
> +	if (!of_property_read_u32(np, "ieee80211-max-center-freq", &val) &&
> +	    chan->center_freq > KHZ_TO_MHZ(val))
> +		return false;

I suspect these functions rely on CONFIG_OF. So might not build for
!CONFIG_OF.

Regards,
Arend
