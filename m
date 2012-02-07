Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42513 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2BGVz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 16:55:26 -0500
Received: by ghrr11 with SMTP id r11so3460650ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 13:55:25 -0800 (PST)
Message-ID: <4F319DCA.7080507@lwfinger.net> (sfid-20120207_225529_787263_356DDFFF)
Date: Tue, 07 Feb 2012 15:55:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simon Graham <simon.graham@virtualcomputer.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH] rtlwifi: Handle previous allocation failures when freeing
 device memory
References: <BC8BC73D12649F439B502B4CB6FD58B1053E2C92@BE23.exg4.exghost.com>
In-Reply-To: <BC8BC73D12649F439B502B4CB6FD58B1053E2C92@BE23.exg4.exghost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 03:31 PM, Simon Graham wrote:
> Handle previous allocation failures when freeing device memory
>
> Signed-off-by: Simon Graham<simon.graham@virtualcomputer.com>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |   24 ++++++++++++++----------
>   1 files changed, 14 insertions(+), 10 deletions(-)
>

NACK. For both TX and RX rings, the memory allocation was checked following the 
pci_alloc_consistent() calls in routines _rtl_pci_init_tx_ring() and 
_rtl_pci_init_rx_ring(). Rechecking here is not necessary.

Larry

> diff --git a/drivers/net/wireless/rtlwifi/pci.c
> b/drivers/net/wireless/rtlwifi/pci.c
> index c5f6a32..fb84707 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -1148,10 +1148,12 @@ static void _rtl_pci_free_tx_ring(struct
> ieee80211_hw *hw,
>   		ring->idx = (ring->idx + 1) % ring->entries;
>   	}
>
> -	pci_free_consistent(rtlpci->pdev,
> -			    sizeof(*ring->desc) * ring->entries,
> -			    ring->desc, ring->dma);
> -	ring->desc = NULL;
> +	if (ring->desc) {
> +		pci_free_consistent(rtlpci->pdev,
> +				    sizeof(*ring->desc) * ring->entries,
> +				    ring->desc, ring->dma);
> +		ring->desc = NULL;
> +	}
>   }
>
>   static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci)
> @@ -1175,12 +1177,14 @@ static void _rtl_pci_free_rx_ring(struct rtl_pci
> *rtlpci)
>   			kfree_skb(skb);
>   		}
>
> -		pci_free_consistent(rtlpci->pdev,
> -				sizeof(*rtlpci->rx_ring[rx_queue_idx].
> -				       desc) * rtlpci->rxringcount,
> -				rtlpci->rx_ring[rx_queue_idx].desc,
> -				rtlpci->rx_ring[rx_queue_idx].dma);
> -		rtlpci->rx_ring[rx_queue_idx].desc = NULL;
> +		if (rtlpci->rx_ring[rx_queue_idx].desc) {
> +			pci_free_consistent(rtlpci->pdev,
> +
> sizeof(*rtlpci->rx_ring[rx_queue_idx].
> +						 desc) *
> rtlpci->rxringcount,
> +
> rtlpci->rx_ring[rx_queue_idx].desc,
> +
> rtlpci->rx_ring[rx_queue_idx].dma);
> +			rtlpci->rx_ring[rx_queue_idx].desc = NULL;
> +		}
>   	}
>   }
>

