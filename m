Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35684 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcEYVFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 17:05:21 -0400
Received: by mail-wm0-f42.google.com with SMTP id a136so10600wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2016 14:05:20 -0700 (PDT)
Subject: Re: [PATCH V2] brcmfmac: print error if p2p_ifadd firmware command
 fails
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1464123728-7555-1-git-send-email-zajec5@gmail.com>
 <1464123910-8281-1-git-send-email-zajec5@gmail.com>
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
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5746138D.2090700@broadcom.com> (sfid-20160525_230544_493706_76132BD2)
Date: Wed, 25 May 2016 23:05:17 +0200
MIME-Version: 1.0
In-Reply-To: <1464123910-8281-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-05-16 23:05, Rafał Miłecki wrote:
> This is helpful for debugging, without this all I was getting from "iw"
> command on device with BCM43602 was:
>> command failed: Too many open files in system (-23)
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: s/in/if/ in commit message
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index 1652a48..f7b7e29 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2031,7 +2031,7 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
>  	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
>  				       sizeof(if_request));
>  	if (err)
> -		return err;
> +		brcmf_err("p2p_ifadd failed %d\n", err);

I would prefer adding a more generic failure message including ifname
and type in brcmf_cfg80211_add_iface() in cfg80211.c.

Regards,
Arend

>  
>  	return err;
>  }
> 
