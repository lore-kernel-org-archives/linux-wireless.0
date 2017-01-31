Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f174.google.com ([209.85.210.174]:32781 "EHLO
        mail-wj0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdAaL5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 06:57:49 -0500
Received: by mail-wj0-f174.google.com with SMTP id la6so3485193wjc.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 03:56:55 -0800 (PST)
Subject: Re: [PATCH 1/2] brcmfmac: check brcmf_bus_get_memdump result for
 error
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170130150952.7133-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ebe3e543-51c3-140a-5140-c2c32afec74e@broadcom.com> (sfid-20170131_125755_778122_81F2599F)
Date: Tue, 31 Jan 2017 12:56:53 +0100
MIME-Version: 1.0
In-Reply-To: <20170130150952.7133-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 30-1-2017 16:09, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This method may be unsupported (see: USB bus) or may just fail (see:
> SDIO bus).
> While at it rework logic in brcmf_sdio_bus_get_memdump function to avoid
> too many conditional code nesting levels.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 23 +++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> index e64557c35553..6f8a4b074c31 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> @@ -32,16 +32,25 @@ static int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
>  {
>  	void *dump;
>  	size_t ramsize;
> +	int err;
>  
>  	ramsize = brcmf_bus_get_ramsize(bus);
> -	if (ramsize) {
> -		dump = vzalloc(len + ramsize);
> -		if (!dump)
> -			return -ENOMEM;
> -		memcpy(dump, data, len);
> -		brcmf_bus_get_memdump(bus, dump + len, ramsize);
> -		dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
> +	if (!ramsize)
> +		return -ENOTSUPP;
> +
> +	dump = vzalloc(len + ramsize);
> +	if (!dump)
> +		return -ENOMEM;
> +
> +	memcpy(dump, data, len);
> +	err = brcmf_bus_get_memdump(bus, dump + len, ramsize);
> +	if (err) {
> +		vfree(dump);
> +		return err;
>  	}
> +
> +	dev_coredumpv(bus->dev, dump, len + ramsize, GFP_KERNEL);
> +
>  	return 0;
>  }
>  
> 
