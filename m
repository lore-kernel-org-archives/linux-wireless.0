Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36525 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdAaL6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 06:58:22 -0500
Received: by mail-wm0-f46.google.com with SMTP id c85so257583887wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 03:58:21 -0800 (PST)
Subject: Re: [PATCH 2/2] brcmfmac: be more verbose when PSM's watchdog fires
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170130150952.7133-1-zajec5@gmail.com>
 <20170130150952.7133-2-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cd45588f-3d14-8227-1992-1611a9af38e2@broadcom.com> (sfid-20170131_125830_701290_49A4E31F)
Date: Tue, 31 Jan 2017 12:58:19 +0100
MIME-Version: 1.0
In-Reply-To: <20170130150952.7133-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-1-2017 16:09, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It's important to inform user so he knows things went wrong. He may also
> want to get memory dump for further debugging purposes.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> index 6f8a4b074c31..f4644cf371c7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> @@ -58,10 +58,18 @@ static int brcmf_debug_psm_watchdog_notify(struct brcmf_if *ifp,
>  					   const struct brcmf_event_msg *evtmsg,
>  					   void *data)
>  {
> +	int err;
> +
>  	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
>  
> -	return brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
> -					  evtmsg->datalen);
> +	brcmf_err("PSM's watchdog has fired!\n");
> +
> +	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
> +					 evtmsg->datalen);
> +	if (err)
> +		brcmf_err("Failed to get memory dump, %d\n", err);
> +
> +	return err;
>  }
>  
>  void brcmf_debugfs_init(void)
> 
