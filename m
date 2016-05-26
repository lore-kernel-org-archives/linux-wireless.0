Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34960 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbcEZIHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 04:07:10 -0400
Received: by mail-wm0-f51.google.com with SMTP id a136so14082869wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2016 01:07:10 -0700 (PDT)
Subject: Re: [PATCH V3] brcmfmac: print error if p2p_ifadd firmware command
 fails
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1464123910-8281-1-git-send-email-zajec5@gmail.com>
 <1464216299-25232-1-git-send-email-zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <434b808f-0433-2b01-29b9-24331a773e7c@broadcom.com> (sfid-20160526_100747_315360_E1F1BEEA)
Date: Thu, 26 May 2016 10:07:06 +0200
MIME-Version: 1.0
In-Reply-To: <1464216299-25232-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-5-2016 0:44, Rafał Miłecki wrote:
> This is helpful for debugging, without this all I was getting from "iw"
> command on device with BCM43602 was:
>> command failed: Too many open files in system (-23)
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: s/in/if/ in commit message
> V3: Add one more error message as suggested by Arend
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index 1652a48..bc26aec 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2031,7 +2031,7 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
>  	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
>  				       sizeof(if_request));
>  	if (err)
> -		return err;
> +		brcmf_err("p2p_ifadd failed %d\n", err);
>  
>  	return err;
>  }
> @@ -2185,6 +2185,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
>  	err = brcmf_p2p_request_p2p_if(&cfg->p2p, ifp, cfg->p2p.int_addr,
>  				       iftype);
>  	if (err) {
> +		brcmf_err("Failed to request P2P virtual interface %s\n", name);
>  		brcmf_cfg80211_arm_vif_event(cfg, NULL);
>  		goto fail;
>  	}

Not exactly what I meant. I meant instead of and the function I would
like the error message in is brcmf_cfg80211_add_iface() so you also get
an error message when AP interface creation fails.

Regards,
Arend
