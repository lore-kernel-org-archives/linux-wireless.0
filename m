Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33274 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdGZJcq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 05:32:46 -0400
Received: by mail-wm0-f53.google.com with SMTP id c184so24063269wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jul 2017 02:32:46 -0700 (PDT)
Message-ID: <597861BB.3080201@broadcom.com> (sfid-20170726_113250_269962_C100614B)
Date: Wed, 26 Jul 2017 11:32:43 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Daniel Stone <daniels@collabora.com>
CC: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [PATCH v2] brcmfmac: Don't grow SKB by negative size
References: <20170726084924.27546-1-daniels@collabora.com>
In-Reply-To: <20170726084924.27546-1-daniels@collabora.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:49 AM, Daniel Stone wrote:
> The commit to rework the headroom check in start_xmit() now calls
> pxskb_expand_head() unconditionally if the header is CoW. Unfortunately,
> it does so with the delta between the extant headroom and the header
> length, which may be negative if there is already sufficient headroom.
>
> pskb_expand_head() does allow for size being 0, in which case it just
> copies, so clamp the header delta to zero.
>
> Opening Chrome (and all my tabs) on a PCIE device was enough to reliably
> hit this.
>
> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
> Signed-off-by: Daniel Stone <daniels@collabora.com>
> Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: James Hughes <james.hughes@raspberrypi.org>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
>   1 file changed, 1 insertion(+)
>
> Really sorry, I forgot to re-run format-patch after fixing the initial
> patch. I've run out of coffee. :(

Sufficient coffee over here so I have no excuse. You are obviously 
right. Please tag this patch for 4.13, ie.:

[PATCH for-4.13 V3] brcmfmac: ....

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 2153e8062b4c..42dbd5a8c220 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -215,6 +215,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>   	/* Make sure there's enough writeable headroom */
>   	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
>   		head_delta = drvr->hdrlen - skb_headroom(skb);
> +		head_delta = max(head_delta, 0);

minor nit, but can you make it:
-  		head_delta = drvr->hdrlen - skb_headroom(skb);
+		head_delta = max(drvr->hdrlen - skb_headroom(skb), 0);

Regards,
Arend
