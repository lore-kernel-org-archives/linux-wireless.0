Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdGZV7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 17:59:42 -0400
Subject: Re: [for-v4.13,V4] brcmfmac: Don't grow SKB by negative size
To: Daniel Stone <daniels@collabora.com>,
        linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <20170726112410.22353-1-daniels@collabora.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <8ae43770-e29f-e46c-034d-7bdee73009ea@redhat.com> (sfid-20170726_235945_844684_20CDFC67)
Date: Wed, 26 Jul 2017 23:59:39 +0200
MIME-Version: 1.0
In-Reply-To: <20170726112410.22353-1-daniels@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 26-07-17 13:24, Daniel Stone wrote:
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
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> v2: Correct thinko.
> v3: Bring assignment on to one line.
> v4: Use max_t rather than max.

I can confirm that this fixes a brcmfmac kernel panic for me:

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 2153e8062b4c..5cc3a07dda9e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -214,7 +214,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>   
>   	/* Make sure there's enough writeable headroom */
>   	if (skb_headroom(skb) < drvr->hdrlen || skb_header_cloned(skb)) {
> -		head_delta = drvr->hdrlen - skb_headroom(skb);
> +		head_delta = max_t(int, drvr->hdrlen - skb_headroom(skb), 0);
>   
>   		brcmf_dbg(INFO, "%s: insufficient headroom (%d)\n",
>   			  brcmf_ifname(ifp), head_delta);
> 
