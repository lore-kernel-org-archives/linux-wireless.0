Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34891 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdARJ1t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 04:27:49 -0500
Received: by mail-pg0-f49.google.com with SMTP id 194so3274081pgd.2
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2017 01:27:48 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: drop brcmf_bus_detach and inline its code
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170117192325.14528-1-zajec5@gmail.com>
 <20170117192325.14528-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9a5f6081-7ba9-7422-a664-47ea075c729f@broadcom.com> (sfid-20170118_102801_260056_228FE5F3)
Date: Wed, 18 Jan 2017 10:27:38 +0100
MIME-Version: 1.0
In-Reply-To: <20170117192325.14528-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-1-2017 20:23, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Driver used to call brcmf_bus_detach only from one place and it already
> contained a check for drvr not being NULL. We can get rid of this extra
> function, call brcmf_bus_stop directly and simplify the code.
> There also isn't brcmf_bus_attach function which one could expect so it
> looks more consistent this way.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index adf8eb1..122c79d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -1075,16 +1075,6 @@ void brcmf_bus_add_txhdrlen(struct device *dev, uint len)
>  	}
>  }
>  
> -static void brcmf_bus_detach(struct brcmf_pub *drvr)
> -{
> -	brcmf_dbg(TRACE, "Enter\n");
> -
> -	if (drvr) {
> -		/* Stop the bus module */
> -		brcmf_bus_stop(drvr->bus_if);
> -	}
> -}
> -
>  void brcmf_dev_reset(struct device *dev)
>  {
>  	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
> @@ -1131,7 +1121,7 @@ void brcmf_detach(struct device *dev)
>  
>  	brcmf_fws_deinit(drvr);
>  
> -	brcmf_bus_detach(drvr);
> +	brcmf_bus_stop(drvr->bus_if);
>  
>  	brcmf_proto_detach(drvr);
>  
> 
