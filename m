Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2135 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2JCJIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 05:08:16 -0400
Message-ID: <506C0071.1000707@broadcom.com> (sfid-20121003_110820_820150_40A83C9D)
Date: Wed, 3 Oct 2012 11:08:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>
Subject: Re: [RFC] brcmsmac: check return from dma_map_single
References: <y>
 <1349203585-16095-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1349203585-16095-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2012 08:46 PM, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
>
> dma_map_single can fail, so it's return value needs to be checked and
> handled accordingly.  Failure to do so is akin to failing to check the
> return from a kmalloc.
>
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> ---
> I'm not too sure about the bail-out in dma_rxfill.  Perhaps the experts
> can suggest something better?
>
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> index 5e53305..fa24c58 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> @@ -1079,6 +1079,10 @@ bool dma_rxfill(struct dma_pub *pub)
>
>   		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
>   				    DMA_FROM_DEVICE);
> +		if (dma_mapping_error(di->dmadev, pa)) {
> +			brcmu_pkt_buf_free_skb(p);
> +			break;
> +		}

I noticed the calling function is ignoring any error returned by 
dma_rxfill(). I am not sure what to do here when this mapping error 
happens after being halfway the for loop filling the dma with receive 
buffers. The function is being called on mac80211 .start() callback so 
we have to pass the failure back to that.

>   		/* save the free packet pointer */
>   		di->rxp[rxout] = p;
> @@ -1293,13 +1297,15 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
>   	if (len == 0)
>   		return 0;
>
> +	/* get physical address of buffer start */
> +	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(di->dmadev, pa))
> +		return -1;
> +

Same for dma_txfast() and from DMA-API.txt I understand the buffer needs 
to be freed:

- checking the returned dma_addr_t of dma_map_single and dma_map_page
   by using dma_mapping_error():

         dma_addr_t dma_handle;

         dma_handle = dma_map_single(dev, addr, size, direction);
         if (dma_mapping_error(dev, dma_handle)) {
                 /*
                  * reduce current DMA mapping usage,
                  * delay and try again later or
                  * reset driver.
                  */
         }

Networking drivers must call dev_kfree_skb to free the socket buffer
and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
(ndo_start_xmit). This means that the socket buffer is just dropped in
the failure case.

>   	/* return nonzero if out of tx descriptors */
>   	if (nexttxd(di, txout) == di->txin)
>   		goto outoftxd;
>
> -	/* get physical address of buffer start */
> -	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
> -
>   	/* With a DMA segment list, Descriptor table is filled
>   	 * using the segment list instead of looping over
>   	 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
>

I will discuss how we should handle the error flows given the options 
mentioned in the DMA-API pseudo-code above.

Gr. AvS

