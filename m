Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47538 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1FGBf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 21:35:56 -0400
Received: by iwn34 with SMTP id 34so3608136iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 18:35:55 -0700 (PDT)
Message-ID: <4DED8078.8030208@lwfinger.net> (sfid-20110607_033600_058618_6AC62960)
Date: Mon, 06 Jun 2011 20:35:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Avoid modifying skbs that are resubmitted
References: <4DED69A7.4000108@ring3k.org>
In-Reply-To: <4DED69A7.4000108@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 06:58 PM, Mike McCormack wrote:
>
> In the case we fail to allocate a new skb, the old skb should
> be resubmitted unmodified.
>
> Fixes bug introduced in a9e12869758430424804.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |   28 +++++++++++++---------------
>   1 files changed, 13 insertions(+), 15 deletions(-)
>

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

John,

This patch is needed for kernel 3.0.

Larry

> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index fc44005..e502db0 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -670,6 +670,19 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>   							&rx_status,
>   							 (u8 *) pdesc, skb);
>
> +			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
> +			if (unlikely(!new_skb)) {
> +				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
> +					 DBG_DMESG,
> +					 ("can't alloc skb for rx\n"));
> +				goto done;
> +			}
> +
> +			pci_unmap_single(rtlpci->pdev,
> +					 *((dma_addr_t *) skb->cb),
> +					 rtlpci->rxbuffersize,
> +					 PCI_DMA_FROMDEVICE);
> +
>   			skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
>   							 false,
>   							 HW_DESC_RXPKT_LEN));
> @@ -686,21 +699,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>   			hdr = rtl_get_hdr(skb);
>   			fc = rtl_get_fc(skb);
>
> -			/* try for new buffer - if allocation fails, drop
> -			 * frame and reuse old buffer
> -			 */
> -			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
> -			if (unlikely(!new_skb)) {
> -				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
> -					 DBG_DMESG,
> -					 ("can't alloc skb for rx\n"));
> -				goto done;
> -			}
> -			pci_unmap_single(rtlpci->pdev,
> -					 *((dma_addr_t *) skb->cb),
> -					 rtlpci->rxbuffersize,
> -					 PCI_DMA_FROMDEVICE);
> -
>   			if (!stats.crc&&  !stats.hwerror) {
>   				memcpy(IEEE80211_SKB_RXCB(skb),&rx_status,
>   				       sizeof(rx_status));

