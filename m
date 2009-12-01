Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:53739 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbZLAUll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 15:41:41 -0500
Message-ID: <4B157F8A.4070707@gmail.com>
Date: Tue, 01 Dec 2009 21:41:46 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Benoit Papillault <benoit.papillault@free.fr>
CC: IvDoorn@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: Disable RX aggregation for rt2800usb
References: <1259619690-2749-1-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1259619690-2749-1-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/09 23:21, Benoit Papillault wrote:
> From: Benoit PAPILLAULT <benoit.papillault@free.fr>
> 
> RX aggregation is a way to receive multiple 802.11 frames in one RX buffer.
> However, we don't know yet how to handle this case in rt2800usb_fill_rxdone
> and this has probably no impact on RX performance as well, so we disable it
> 
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index af85d18..ed31763 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -295,9 +295,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
>  
>  	rt2800_register_read(rt2x00dev, USB_DMA_CFG, &reg);
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
> -	/* Don't use bulk in aggregation when working with USB 1.1 */
> -	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
> -			   (rt2x00dev->rx->usb_maxpacket == 512));
> +	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
>  	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
>  	/*
>  	 * Total room for RX frames in kilobytes, PBF might still exceed

