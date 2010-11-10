Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59794 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab0KJLS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 06:18:26 -0500
Message-ID: <4CDA7F7A.4000705@ti.com>
Date: Wed, 10 Nov 2010 13:18:18 +0200
From: Gery Kahn <geryk@ti.com>
Reply-To: geryk@ti.com
MIME-Version: 1.0
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] Revert "wl1271: Change supported channel order for
 a more optimal scan"
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com> <1289384840-28305-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1289384840-28305-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2010 12:27 PM, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen<juuso.oikarinen@nokia.com>
>
> This reverts commit fa21c7a9e4be439e217fe72edbd39b643b643791.
>
> The reverted patch caused more harm than benefit.
>
> Signed-off-by: Juuso Oikarinen<juuso.oikarinen@nokia.com>
> ---
>   drivers/net/wireless/wl12xx/wl1271_main.c |   86 +++++++++++++---------------
>   1 files changed, 40 insertions(+), 46 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index eb9f821..1f912cd 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -2215,24 +2215,21 @@ static struct ieee80211_rate wl1271_rates[] = {
>   	  .hw_value_short = CONF_HW_BIT_RATE_54MBPS, },
>   };
>
> -/*
> - * Can't be const, mac80211 writes to this. The order of the channels here
> - * is designed to improve scanning.
> - */
> +/* can't be const, mac80211 writes to this */
>   static struct ieee80211_channel wl1271_channels[] = {
>   	{ .hw_value = 1, .center_freq = 2412, .max_power = 25 },
> -	{ .hw_value = 5, .center_freq = 2432, .max_power = 25 },
> -	{ .hw_value = 9, .center_freq = 2452, .max_power = 25 },
> -	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
> -	{ .hw_value = 4, .center_freq = 2427, .max_power = 25 },
> -	{ .hw_value = 8, .center_freq = 2447, .max_power = 25 },
> -	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
> -	{ .hw_value = 3, .center_freq = 2422, .max_power = 25 },
> -	{ .hw_value = 7, .center_freq = 2442, .max_power = 25 },
> -	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
>   	{ .hw_value = 2, .center_freq = 2417, .max_power = 25 },
> +	{ .hw_value = 3, .center_freq = 2422, .max_power = 25 },
> +	{ .hw_value = 4, .center_freq = 2427, .max_power = 25 },
> +	{ .hw_value = 5, .center_freq = 2432, .max_power = 25 },
>   	{ .hw_value = 6, .center_freq = 2437, .max_power = 25 },
> +	{ .hw_value = 7, .center_freq = 2442, .max_power = 25 },
> +	{ .hw_value = 8, .center_freq = 2447, .max_power = 25 },
> +	{ .hw_value = 9, .center_freq = 2452, .max_power = 25 },
>   	{ .hw_value = 10, .center_freq = 2457, .max_power = 25 },
> +	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
> +	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
> +	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
>   };
>
>   /* mapping to indexes for wl1271_rates */
> @@ -2323,52 +2320,49 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
>   	  .hw_value_short = CONF_HW_BIT_RATE_54MBPS, },
>   };
>
> -/*
> - * 5 GHz band channels for WL1273 - can't be const, mac80211 writes to this.
> - * The order of the channels here is designed to improve scanning.
> - */
> +/* 5 GHz band channels for WL1273 */
>   static struct ieee80211_channel wl1271_channels_5ghz[] = {
>   	{ .hw_value = 183, .center_freq = 4915},
> -	{ .hw_value = 188, .center_freq = 4940},
> -	{ .hw_value = 8, .center_freq = 5040},
> -	{ .hw_value = 34, .center_freq = 5170},
> -	{ .hw_value = 44, .center_freq = 5220},
> -	{ .hw_value = 60, .center_freq = 5300},
> -	{ .hw_value = 112, .center_freq = 5560},
> -	{ .hw_value = 132, .center_freq = 5660},
> -	{ .hw_value = 157, .center_freq = 5785},
>   	{ .hw_value = 184, .center_freq = 4920},
> +	{ .hw_value = 185, .center_freq = 4925},
> +	{ .hw_value = 187, .center_freq = 4935},
> +	{ .hw_value = 188, .center_freq = 4940},
>   	{ .hw_value = 189, .center_freq = 4945},
> -	{ .hw_value = 9, .center_freq = 5045},
> -	{ .hw_value = 36, .center_freq = 5180},
> -	{ .hw_value = 46, .center_freq = 5230},
> -	{ .hw_value = 64, .center_freq = 5320},
> -	{ .hw_value = 116, .center_freq = 5580},
> -	{ .hw_value = 136, .center_freq = 5680},
>   	{ .hw_value = 192, .center_freq = 4960},
> -	{ .hw_value = 11, .center_freq = 5055},
> -	{ .hw_value = 38, .center_freq = 5190},
> -	{ .hw_value = 48, .center_freq = 5240},
> -	{ .hw_value = 100, .center_freq = 5500},
> -	{ .hw_value = 120, .center_freq = 5600},
> -	{ .hw_value = 140, .center_freq = 5700},
> -	{ .hw_value = 185, .center_freq = 4925},
>   	{ .hw_value = 196, .center_freq = 4980},
> -	{ .hw_value = 12, .center_freq = 5060},
> -	{ .hw_value = 40, .center_freq = 5200},
> -	{ .hw_value = 52, .center_freq = 5260},
> -	{ .hw_value = 104, .center_freq = 5520},
> -	{ .hw_value = 124, .center_freq = 5620},
> -	{ .hw_value = 149, .center_freq = 5745},
> -	{ .hw_value = 161, .center_freq = 5805},
> -	{ .hw_value = 187, .center_freq = 4935},
>   	{ .hw_value = 7, .center_freq = 5035},
> +	{ .hw_value = 8, .center_freq = 5040},
> +	{ .hw_value = 9, .center_freq = 5045},
> +	{ .hw_value = 11, .center_freq = 5055},
> +	{ .hw_value = 12, .center_freq = 5060},
>   	{ .hw_value = 16, .center_freq = 5080},
> +	{ .hw_value = 34, .center_freq = 5170},
> +	{ .hw_value = 36, .center_freq = 5180},
> +	{ .hw_value = 38, .center_freq = 5190},
> +	{ .hw_value = 40, .center_freq = 5200},
>   	{ .hw_value = 42, .center_freq = 5210},
> +	{ .hw_value = 44, .center_freq = 5220},
> +	{ .hw_value = 46, .center_freq = 5230},
> +	{ .hw_value = 48, .center_freq = 5240},
> +	{ .hw_value = 52, .center_freq = 5260},
>   	{ .hw_value = 56, .center_freq = 5280},
> +	{ .hw_value = 60, .center_freq = 5300},
> +	{ .hw_value = 64, .center_freq = 5320},
> +	{ .hw_value = 100, .center_freq = 5500},
> +	{ .hw_value = 104, .center_freq = 5520},
>   	{ .hw_value = 108, .center_freq = 5540},
> +	{ .hw_value = 112, .center_freq = 5560},
> +	{ .hw_value = 116, .center_freq = 5580},
> +	{ .hw_value = 120, .center_freq = 5600},
> +	{ .hw_value = 124, .center_freq = 5620},
>   	{ .hw_value = 128, .center_freq = 5640},
> +	{ .hw_value = 132, .center_freq = 5660},
> +	{ .hw_value = 136, .center_freq = 5680},
> +	{ .hw_value = 140, .center_freq = 5700},
> +	{ .hw_value = 149, .center_freq = 5745},
>   	{ .hw_value = 153, .center_freq = 5765},
> +	{ .hw_value = 157, .center_freq = 5785},
> +	{ .hw_value = 161, .center_freq = 5805},
>   	{ .hw_value = 165, .center_freq = 5825},
>   };
>
Just couple words what harm it was?
