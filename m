Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:35910 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdAHNBC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jan 2017 08:01:02 -0500
Received: by mail-wj0-f178.google.com with SMTP id ew7so41518892wjc.3
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2017 05:01:02 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: setup wiphy bands after registering it
 first
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170107203605.24866-1-zajec5@gmail.com>
 <20170107203605.24866-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <117c6355-a612-1797-a1ae-225f68543568@broadcom.com> (sfid-20170108_140107_873794_20D5E9D7)
Date: Sun, 8 Jan 2017 14:00:58 +0100
MIME-Version: 1.0
In-Reply-To: <20170107203605.24866-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7-1-2017 21:36, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> During bands setup we disable all channels that firmware doesn't support
> in the current regulatory setup. If we do this before wiphy_register
> it will result in copying set flags (including IEEE80211_CHAN_DISABLED)
> to the orig_flags which is supposed to be persistent. We don't want this
> as regulatory change may result in enabling some channels. We shouldn't
> mess with orig_flags then (by changing them or ignoring them) so it's
> better to just take care of their proper values.
> 
> This patch cleanups code a bit (by taking orig_flags more seriously) and
> allows further improvements like disabling really unavailable channels.
> We will need that e.g. if some frequencies should be disabled for good
> due to hardware setup (design).

I think this and previous patch are too dependent and prefer to have
them in a single patch. Despite that for both:

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 45ee5b6..729bf33 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6477,8 +6477,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
>  			wiphy->bands[NL80211_BAND_5GHZ] = band;
>  		}
>  	}
> -	err = brcmf_setup_wiphybands(wiphy);
> -	return err;
> +	return 0;
>  }
>  
>  static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
> @@ -6843,6 +6842,12 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>  		goto priv_out;
>  	}
>  
> +	err = brcmf_setup_wiphybands(wiphy);
> +	if (err) {
> +		brcmf_err("Setting wiphy bands failed (%d)\n", err);
> +		goto wiphy_unreg_out;
> +	}
> +
>  	/* If cfg80211 didn't disable 40MHz HT CAP in wiphy_register(),
>  	 * setup 40MHz in 2GHz band and enable OBSS scanning.
>  	 */
> 
