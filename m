Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34769 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753668AbcI0LZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 07:25:55 -0400
Received: by mail-pf0-f182.google.com with SMTP id l25so5026142pfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 04:25:54 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: replace WARNING on timeout with a simple error
 message
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20160927101224.3534-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a084ce54-9b96-fbdc-34b1-7c6429bed24e@broadcom.com> (sfid-20160927_132623_022029_512878B6)
Date: Tue, 27 Sep 2016 13:25:33 +0200
MIME-Version: 1.0
In-Reply-To: <20160927101224.3534-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-9-2016 12:12, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Even with timeout increased to 950 ms we get WARNINGs from time to time.
> It mostly happens on A-MPDU stalls (e.g. when station goes out of
> range). It may take up to 5-10 secods for the firmware to recover and
> for that time it doesn't process packets.
> 
> It's still useful to have a message on time out as it may indicate some
> firmware problem and incorrect key update. Raising a WARNING however
> wasn't really that necessary, it doesn't point to any driver bug anymore
> and backtrace wasn't much useful.

Indeed the interesting part would be in another context. So:

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 6d046ba..9e6f60a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -1161,7 +1161,8 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
>  				 !brcmf_get_pend_8021x_cnt(ifp),
>  				 MAX_WAIT_FOR_8021X_TX);
>  
> -	WARN_ON(!err);
> +	if (!err)
> +		brcmf_err("Timed out waiting for no pending 802.1x packets\n");
>  
>  	return !err;
>  }
> 
