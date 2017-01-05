Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35298 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970436AbdAEJuo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 04:50:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id a197so427832196wmd.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2017 01:50:37 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: check if we can support used firmware API
 version
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170103161140.16919-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1acc759f-0724-0ad4-fc2b-75bd41715cbb@broadcom.com> (sfid-20170105_110718_450681_B9577C52)
Date: Thu, 5 Jan 2017 10:50:34 +0100
MIME-Version: 1.0
In-Reply-To: <20170103161140.16919-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-1-2017 17:11, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Every new firmware API will most likely require changes in our code to
> support it. Right now we support 2 versions only. Refuse to init if we
> detect newer version.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> Hi Arend,
> 
> I think you were concerned about possible firmware API changes. Please
> review this patch, I hope it's a proper check for running unsupported
> firmware version which could result in broken communication between host
> driver and a device.
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 0babfc7..c69ae84 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -6816,6 +6816,11 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
>  		brcmf_err("Failed to get D11 version (%d)\n", err);
>  		goto priv_out;
>  	}
> +	if (io_type > BRCMU_D11AC_IOTYPE) {
> +		brcmf_err("Unsupported IO version %d\n", io_type);
> +		goto priv_out;
> +	}

I prefer to have this in brcmu_d11_attach() and have it return an error.
Now this actually does not cover the API version in its entirety. The
broadcom firmware API is a bit more complicated. Firmware commands may
use structured data where we may only add fields at the end to keep it
backward compatible and they are versioned if that can not be avoided.
As example see recent patch [1].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/9442873/
>  	cfg->d11inf.io_type = (u8)io_type;
>  	brcmu_d11_attach(&cfg->d11inf);
>  
> 
