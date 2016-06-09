Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38111 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbcFIS44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:56:56 -0400
Received: by mail-wm0-f52.google.com with SMTP id m124so72733957wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2016 11:56:55 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: slightly simplify building interface
 combinations
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1465326626-365-1-git-send-email-zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5759BBF4.1080807@broadcom.com> (sfid-20160609_205740_928572_F7DB8A82)
Date: Thu, 9 Jun 2016 20:56:52 +0200
MIME-Version: 1.0
In-Reply-To: <1465326626-365-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07-06-16 21:10, Rafał Miłecki wrote:
> This change reorders some operations in brcmf_setup_ifmodes in hope to
> make it simpler:
> 1) It allocates arrays right before filling them. This way it's easier
>    to follow requested array length as it's immediately followed by
>    code filling it. It's easier to check e.g. why we need 4 entries for
>    P2P. Other than that it deduplicates some checks (e.g. for P2P).
> 2) It reorders code to first prepare limits and then define a new combo.
>    Previously this was mixed (e.g. we were setting num of channels
>    before preparing limits).
> 3) It modifies mbss code to use i variable just like other combos do.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 37 ++++++++++------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 4894eb7..33e682e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6300,29 +6300,15 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
>  	if (!combo)
>  		goto err;
>  
> -	c0_limits = kcalloc(p2p ? 3 : 2, sizeof(*c0_limits), GFP_KERNEL);
> -	if (!c0_limits)
> -		goto err;
> -
> -	if (p2p) {
> -		p2p_limits = kcalloc(4, sizeof(*p2p_limits), GFP_KERNEL);
> -		if (!p2p_limits)
> -			goto err;
> -	}
> -
> -	if (mbss) {
> -		mbss_limits = kcalloc(1, sizeof(*mbss_limits), GFP_KERNEL);
> -		if (!mbss_limits)
> -			goto err;
> -	}
> -
>  	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>  				 BIT(NL80211_IFTYPE_ADHOC) |
>  				 BIT(NL80211_IFTYPE_AP);
>  
>  	c = 0;
>  	i = 0;
> -	combo[c].num_different_channels = 1;
> +	c0_limits = kcalloc(p2p ? 3 : 2, sizeof(*c0_limits), GFP_KERNEL);
> +	if (!c0_limits)
> +		goto err;
>  	c0_limits[i].max = 1;
>  	c0_limits[i++].types = BIT(NL80211_IFTYPE_STATION);
>  	if (p2p) {
> @@ -6340,6 +6326,7 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
>  		c0_limits[i].max = 1;
>  		c0_limits[i++].types = BIT(NL80211_IFTYPE_AP);
>  	}
> +	combo[c].num_different_channels = 1;
>  	combo[c].max_interfaces = i;
>  	combo[c].n_limits = i;
>  	combo[c].limits = c0_limits;
> @@ -6347,7 +6334,9 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
>  	if (p2p) {
>  		c++;
>  		i = 0;
> -		combo[c].num_different_channels = 1;
> +		p2p_limits = kcalloc(4, sizeof(*p2p_limits), GFP_KERNEL);
> +		if (!p2p_limits)
> +			goto err;
>  		p2p_limits[i].max = 1;
>  		p2p_limits[i++].types = BIT(NL80211_IFTYPE_STATION);
>  		p2p_limits[i].max = 1;
> @@ -6356,6 +6345,7 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
>  		p2p_limits[i++].types = BIT(NL80211_IFTYPE_P2P_CLIENT);
>  		p2p_limits[i].max = 1;
>  		p2p_limits[i++].types = BIT(NL80211_IFTYPE_P2P_DEVICE);
> +		combo[c].num_different_channels = 1;
>  		combo[c].max_interfaces = i;
>  		combo[c].n_limits = i;
>  		combo[c].limits = p2p_limits;
> @@ -6363,14 +6353,19 @@ static int brcmf_setup_ifmodes(struct wiphy *wiphy, struct brcmf_if *ifp)
>  
>  	if (mbss) {
>  		c++;
> +		i = 0;
> +		mbss_limits = kcalloc(1, sizeof(*mbss_limits), GFP_KERNEL);
> +		if (!mbss_limits)
> +			goto err;
> +		mbss_limits[i].max = 4;
> +		mbss_limits[i++].types = BIT(NL80211_IFTYPE_AP);
>  		combo[c].beacon_int_infra_match = true;
>  		combo[c].num_different_channels = 1;
> -		mbss_limits[0].max = 4;
> -		mbss_limits[0].types = BIT(NL80211_IFTYPE_AP);
>  		combo[c].max_interfaces = 4;
> -		combo[c].n_limits = 1;
> +		combo[c].n_limits = i;
>  		combo[c].limits = mbss_limits;
>  	}
> +
>  	wiphy->n_iface_combinations = n_combos;
>  	wiphy->iface_combinations = combo;
>  	return 0;
> 
