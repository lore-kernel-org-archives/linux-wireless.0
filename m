Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34114 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdBXNbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:31:49 -0500
Received: by mail-qt0-f169.google.com with SMTP id n21so16526672qta.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 05:31:48 -0800 (PST)
Subject: Re: [PATCH 4.12] brcmfmac: put chip into passive mode (when
 attaching) just once
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170224131027.29880-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cbcb8722-15bb-bf6e-f329-972797b02028@broadcom.com> (sfid-20170224_143626_399150_446FA8EC)
Date: Fri, 24 Feb 2017 14:31:43 +0100
MIME-Version: 1.0
In-Reply-To: <20170224131027.29880-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-2-2017 14:10, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It avoids some unnecessary work. Most likely there wasn't much sense in
> doing this before bus reset anyway, as reset is supposed to put chip
> into default state. In PCIe code (only bus implementing reset) we e.g.
> use watchdog to perform a chip "reboot".

Sorry, but removing the fisrt passive call will cause chip lockups for
sure on certain systems. We learned the hard way :-p

Regards,
Arend

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index 05f22ff81d60..670f2f50f9e5 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -967,16 +967,14 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
>  	if (ret)
>  		return ret;
>  
> -	/* assure chip is passive for core access */
> -	brcmf_chip_set_passive(&ci->pub);
> -
>  	/* Call bus specific reset function now. Cores have been determined
>  	 * but further access may require a chip specific reset at this point.
>  	 */
> -	if (ci->ops->reset) {
> +	if (ci->ops->reset)
>  		ci->ops->reset(ci->ctx, &ci->pub);
> -		brcmf_chip_set_passive(&ci->pub);
> -	}
> +
> +	/* assure chip is passive for core access */
> +	brcmf_chip_set_passive(&ci->pub);
>  
>  	return brcmf_chip_get_raminfo(ci);
>  }
> 
