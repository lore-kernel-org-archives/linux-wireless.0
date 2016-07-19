Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34265 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbcGSJZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 05:25:27 -0400
Received: by mail-lf0-f51.google.com with SMTP id l69so8483601lfg.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 02:25:26 -0700 (PDT)
Subject: Re: [PATCH 2/4] brcmsmac: Free packet if dma_mapping_error() fails in
 dma_rxfill
To: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <1468884277-18606-3-git-send-email-f.fainelli@gmail.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <04e7b050-4e9c-b306-98ac-7a3ac0566b72@broadcom.com> (sfid-20160719_112531_143434_374E8CBE)
Date: Tue, 19 Jul 2016 11:25:23 +0200
MIME-Version: 1.0
In-Reply-To: <1468884277-18606-3-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-7-2016 1:24, Florian Fainelli wrote:
> In case dma_mapping_error() returns an error in dma_rxfill, we would be
> leaking a packet that we allocated with brcmu_pkt_buf_get_skb().
> 
> Reported-by: coverity (CID 1081819)
> Fixes: 67d0cf50bd32 ("brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()")

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
> index 796f5f9d5d5a..b7df576bb84d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/dma.c
> @@ -1079,8 +1079,10 @@ bool dma_rxfill(struct dma_pub *pub)
>  
>  		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
>  				    DMA_FROM_DEVICE);
> -		if (dma_mapping_error(di->dmadev, pa))
> +		if (dma_mapping_error(di->dmadev, pa)) {
> +			brcmu_pkt_buf_free_skb(p);
>  			return false;
> +		}
>  
>  		/* save the free packet pointer */
>  		di->rxp[rxout] = p;
> 
