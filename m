Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58662 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FFQzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 12:55:49 -0400
Received: by iwn34 with SMTP id 34so3262776iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 09:55:49 -0700 (PDT)
Message-ID: <4DED0692.3050909@lwfinger.net> (sfid-20110606_185553_984074_BDE28E91)
Date: Mon, 06 Jun 2011 11:55:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rtlwifi: Allocate new skb before modifying old
References: <4DECE02C.1030205@ring3k.org>
In-Reply-To: <4DECE02C.1030205@ring3k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 09:11 AM, Mike McCormack wrote:
> Make sure not to modify the skb we resubmit.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>

I think this is a bug introduced by commit a9e1286975843042480. If it is, please 
resubmit as a single patch with subject "rtlwifi: Fix case where modified skb 
could be resubmitted", or something like this. Any bug fixes will go into 3.0, 
while the enhancements will go to 3.1.

Larry

> ---
>   drivers/net/wireless/rtlwifi/pci.c |   28 +++++++++++++---------------
>   1 files changed, 13 insertions(+), 15 deletions(-)
>
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

