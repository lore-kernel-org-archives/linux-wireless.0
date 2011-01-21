Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1AUIno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 03:43:44 -0500
Subject: Re: [RFC/WIP 23/33] ath9k_htc: Enable AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <19768.63310.121728.324735@gargle.gargle.HOWL>
References: <19768.63310.121728.324735@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 09:43:42 +0100
Message-ID: <1295599422.3831.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 08:32 +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index dc96c06..b4ae719 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -753,7 +753,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>  
>  	hw->wiphy->interface_modes =
>  		BIT(NL80211_IFTYPE_STATION) |
> -		BIT(NL80211_IFTYPE_ADHOC);
> +		BIT(NL80211_IFTYPE_ADHOC) |
> +		BIT(NL80211_IFTYPE_AP);

It'd be kinda nice if that could be made dependent on firmware
capability bits or version since otherwise everybody will think they
have it ... and it will not work?

johannes

