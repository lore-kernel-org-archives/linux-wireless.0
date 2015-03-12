Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33009 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbbCLQDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 12:03:04 -0400
Message-ID: <5501B8B5.2010801@lwfinger.net> (sfid-20150312_170330_418145_014D67A6)
Date: Thu, 12 Mar 2015 11:03:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>, chaoming_li@realsil.com.cn,
	kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: get buffer_desc before trying to alloc new skb
References: <1426160036-1542-1-git-send-email-hamo.by@gmail.com>
In-Reply-To: <1426160036-1542-1-git-send-email-hamo.by@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2015 06:33 AM, Yang Bai wrote:
> if rtlpriv->use_new_trx_flow == true and we run out of memory
> to alloc a new skb, we will directly jump to no_new tag with
> buffer_desc == NULL. Then we will dereference this NULL pointer
> in function _rtl_pci_init_one_rxdesc.
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>

Good catch. The only problem that I have is this fix adds even more branching to 
this interrupt routine. At first glance, I should be able to set buffer_desc in 
the earlier code where the code has already branched. For testing, an RTL8192EE 
card will be needed. Do you have such a card?

Larry

> ---
>   drivers/net/wireless/rtlwifi/pci.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index a62170e..7fe04d1 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -820,17 +820,19 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
>   		pci_unmap_single(rtlpci->pdev, *((dma_addr_t *)skb->cb),
>   				 rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
>
> +		if (rtlpriv->use_new_trx_flow)
> +			buffer_desc =
> +			  &rtlpci->rx_ring[rxring_idx].buffer_desc
> +				[rtlpci->rx_ring[rxring_idx].idx];
> +
>   		/* get a new skb - if fail, old one will be reused */
>   		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
>   		if (unlikely(!new_skb))
>   			goto no_new;
> -		if (rtlpriv->use_new_trx_flow) {
> -			buffer_desc =
> -			  &rtlpci->rx_ring[rxring_idx].buffer_desc
> -				[rtlpci->rx_ring[rxring_idx].idx];
> +		if (rtlpriv->use_new_trx_flow)
>   			/*means rx wifi info*/
>   			pdesc = (struct rtl_rx_desc *)skb->data;
> -		}
> +
>   		memset(&rx_status , 0 , sizeof(rx_status));
>   		rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
>   						 &rx_status, (u8 *)pdesc, skb);
>

