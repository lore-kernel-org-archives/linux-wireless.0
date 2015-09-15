Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:55549 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbbIOJ5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 05:57:12 -0400
Message-ID: <55F7EB74.30701@neratec.com> (sfid-20150915_115719_336651_4CB00AD8)
Date: Tue, 15 Sep 2015 11:57:08 +0200
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] [resend] ath9k: allow up to 8 access point vifs on DFS
 channels
References: <773DB8A82AB6A046AE0195C68612A31901A720F6@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901A720F6@sbs2003.acksys.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/15 18:26, Jean-Pierre TOSONI wrote:
> Allow the combination of 8 (AP + mesh) interfaces on radar channels
>
> Tested with hostapd, 2 and 8 BSSIDs, 1 or 2 DFS channels, BW 20 MHz
> TODO: test AP+mesh combination
> TODO: test 40 MHz BW
> ---
> This patch was done with quilt on Openwrt against compat-wireless
> 2014-11-04
>
> Any feedback?
>
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -723,6 +723,14 @@ static const struct ieee80211_iface_limi
>   				 BIT(NL80211_IFTYPE_ADHOC) },
>   };
>   
> +static const struct ieee80211_iface_limit if_dfs_limits_mvap[] = {
> +	{ .max = 8,	.types =
> +#ifdef CONFIG_MAC80211_MESH
> +				 BIT(NL80211_IFTYPE_MESH_POINT) |
> +#endif
> +				 BIT(NL80211_IFTYPE_AP) },
> +};
> +
>   static const struct ieee80211_iface_combination if_comb[] = {
>   	{
>   		.limits = if_limits,
> @@ -746,6 +754,16 @@ static const struct ieee80211_iface_comb
>   		.num_different_channels = 1,
>   		.beacon_int_infra_match = true,
>   		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
> |
> +					BIT(NL80211_CHAN_WIDTH_20) |
> +					BIT(NL80211_CHAN_WIDTH_40),
> +	},
> +	{
> +		.limits = if_dfs_limits_mvap,
> +		.n_limits = ARRAY_SIZE(if_dfs_limits_mvap),
> +		.max_interfaces = 8,
> +		.num_different_channels = 1,
> +		.beacon_int_infra_match = true,
> +		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT)
> |
>   					BIT(NL80211_CHAN_WIDTH_20) |
>   					BIT(NL80211_CHAN_WIDTH_40),
>   	}
Hi
This mail is in my list of "potentially interesting changes".
Do you plan to send this as patch at some point?
Or are you still testing something?

Best regards
Matthias
