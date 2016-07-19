Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36400 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbcGSKTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:19:46 -0400
Received: by mail-pa0-f44.google.com with SMTP id pp5so5820735pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:19:46 -0700 (PDT)
Subject: Re: [PATCH 1/4] brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
To: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <1468884277-18606-2-git-send-email-f.fainelli@gmail.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <da72c3a5-48c4-4936-a9d4-aa686e636ec3@broadcom.com> (sfid-20160719_121957_606971_BAD9DA6F)
Date: Tue, 19 Jul 2016 12:19:40 +0200
MIME-Version: 1.0
In-Reply-To: <1468884277-18606-2-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-7-2016 1:24, Florian Fainelli wrote:
> In case brcmf_sdiod_recv_chain() cannot complete a succeful call to
> brcmf_sdiod_buffrw, we would be leaking glom_skb and not free it as we
> should, fix this.
> 
> Reported-by: coverity (CID 1164856)
> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index c4b89d27e2e8..f549c25608d6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -726,8 +726,10 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
>  			return -ENOMEM;
>  		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
>  					 glom_skb);
> -		if (err)
> +		if (err) {
> +			brcmu_pkt_buf_free_skb(glom_skb);
>  			goto done;
> +		}
>  
>  		skb_queue_walk(pktq, skb) {
>  			memcpy(skb->data, glom_skb->data, skb->len);
> 
