Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33690 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755709AbdC2LX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:23:28 -0400
Received: by mail-lf0-f68.google.com with SMTP id r36so1311323lfi.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 04:23:26 -0700 (PDT)
Subject: Re: [PATCH 2/5] brcmfmac: move brcmf_fws_deinit to bcdc layer
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
 <1490697808-5538-3-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <840eff3f-afac-4267-c5ef-a505a82f2db4@gmail.com> (sfid-20170329_132650_774117_453D0797)
Date: Wed, 29 Mar 2017 13:23:23 +0200
MIME-Version: 1.0
In-Reply-To: <1490697808-5538-3-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2017 12:43 PM, Arend van Spriel wrote:
> From: Franky Lin <franky.lin@broadcom.com>
>
> Move brcmf_fws_deinit into brcmf_proto_bcdc_detach since it is a bcdc
> exclusive feature.
>
> Signed-off-by: Franky Lin <franky.lin@broadcom.com>
> Change-Id: Iefa5db632b92185a49d538b1cd25b7d8be618ce0
> Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/8157
> Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
> Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 -------
>  2 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> index bc24b00..67a132c1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> @@ -464,6 +464,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
>
>  void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
>  {
> +	brcmf_fws_deinit(drvr);
>  	kfree(drvr->proto->pd);
>  	drvr->proto->pd = NULL;
>  }

I'd appreciate you commenting on someones work. I wouldn't mind "Move deinit to
brcmf_proto_bcdc_detach" comment so I could update my
[PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
if that is so important.


> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 9886280..ba4da48 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -32,7 +32,6 @@
>  #include "p2p.h"
>  #include "cfg80211.h"
>  #include "fwil.h"
> -#include "fwsignal.h"
>  #include "feature.h"
>  #include "proto.h"
>  #include "pcie.h"
> @@ -1034,10 +1033,6 @@ int brcmf_bus_started(struct device *dev)
>  		brcmf_cfg80211_detach(drvr->config);
>  		drvr->config = NULL;
>  	}
> -	if (drvr->fws) {
> -		brcmf_proto_del_if(ifp->drvr, ifp);
> -		brcmf_fws_deinit(drvr);
> -	}
>  	brcmf_net_detach(ifp->ndev, false);
>  	if (p2p_ifp)
>  		brcmf_net_detach(p2p_ifp->ndev, false);

I don't like this. By removing del_if from error path you assume add_if doesn't
allocate any memory and it never will.

It's quite hacky for me. If you init something, then you should also deinit it.
Otherwise it's too easy to introduce an invalid state or add a memory leak.
Please keep code simple to follow.
