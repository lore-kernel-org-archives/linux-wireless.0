Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37252 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcFRT0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2016 15:26:42 -0400
Received: by mail-wm0-f50.google.com with SMTP id a66so28346604wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2016 12:26:41 -0700 (PDT)
Subject: Re: [PATCH RFC 1/2] brcmfmac: remove interface before notifying
 listener
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list.pdl@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5765A06C.3040005@broadcom.com> (sfid-20160618_212718_841553_D0693336)
Date: Sat, 18 Jun 2016 21:26:36 +0200
MIME-Version: 1.0
In-Reply-To: <1466273932-11554-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-06-16 20:18, Rafał Miłecki wrote:
> So far when receiving event about in-firmware-interface removal we were
> notifying our listener and afterwards we were removing Linux interface.
> 

[snip]

> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> index 9da7a4c..5fd1886 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> @@ -18,6 +18,7 @@
>  #include "brcmu_wifi.h"
>  #include "brcmu_utils.h"
>  
> +#include "cfg80211.h"
>  #include "core.h"
>  #include "debug.h"
>  #include "tracepoint.h"
> @@ -180,10 +181,16 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
>  	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
>  		brcmf_fws_reset_interface(ifp);
>  
> -	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);

The reason for doing this first is because we are passing the ifp, which
is netdev_priv(ifp->ndev). In brcmf_remove_interface() we only
unregister the netdev, which will end up (after scheduling) in
brcmf_free_netdev() thus freeing the ifp. By moving the event handler
function ifp may be stale already.

> +	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
> +		bool rtnl_locked = brcmf_cfg80211_vif_event_armed(drvr->config);
> +
> +		brcmf_remove_interface(ifp, rtnl_locked);

I guess rtnl_locked here means "rtnl_is_locked() by brcmfmac". It
actually does not matter who is holding the rtnl_lock. At least when it
is brcmfmac it is still a different task, ie. hostapd, iw, etc. Also
when brcmf_cfg80211_vif_event_armed() return false there may still be
some task holding the rtnl_lock.

Regards,
Arend
