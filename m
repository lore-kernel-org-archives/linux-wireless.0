Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42697 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1HMW0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 18:26:46 -0400
Received: by gxk21 with SMTP id 21so2659264gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 15:26:45 -0700 (PDT)
Message-ID: <4E46FA21.9060207@lwfinger.net> (sfid-20110814_002654_376103_970212EE)
Date: Sat, 13 Aug 2011 17:26:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][RFT][PATCH V2 2/2] b43: fix DMA on some bugged hardware
References: <1313001339-11211-1-git-send-email-zajec5@gmail.com> <1313001339-11211-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1313001339-11211-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2011 01:35 PM, Rafał Miłecki wrote:
> Some hardware with 64-bit DMA uses lower address word for setting
> routing (translation) bit. Add workaround for such boards.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> This requires testing on at least 1 normal 64-bit DMA card and 1 32-bit
> DMA card. So far it was tested only on my 14e4:4329 where it fixed DMA.
> ---
>   drivers/net/wireless/b43/b43.h |    1 +
>   drivers/net/wireless/b43/dma.c |  113 +++++++++++++++++++++++++++-------------
>   drivers/net/wireless/b43/dma.h |    6 ++
>   3 files changed, 84 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index c818b0b..3aee322 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -594,6 +594,7 @@ struct b43_dma {
>   	struct b43_dmaring *rx_ring;
>
>   	u32 translation; /* Routing bits */
> +	bool translation_in_low; /* Should translation bit go into low addr? */
>   	bool parity; /* Check for parity */
>   };
>
> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
> index 0953ce1..547851c 100644
> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -47,6 +47,38 @@
>    * into separate slots. */
>   #define TX_SLOTS_PER_FRAME	2
>
> +static u32 b43_dma_address(struct b43_dma *dma, dma_addr_t dmaaddr,
> +			   enum b43_addrtype addrtype)
> +{
> +	u32 uninitialized_var(addr);
> +
> +	switch (addrtype) {
> +	case B43_DMA_ADDR_LOW:
> +		addr = dmaaddr&  0xFFFFFFFF;
> +		if (dma->translation_in_low) {
> +			addr&= ~SSB_DMA_TRANSLATION_MASK;
> +			addr |= dma->translation;
> +		}
> +		break;
> +	case B43_DMA_ADDR_HIGH:
> +		addr = dmaaddr>>  32;
> +		if (!dma->translation_in_low) {
> +			addr&= ~SSB_DMA_TRANSLATION_MASK;
> +			addr |= dma->translation;
> +		}
> +		break;
> +	case B43_DMA_ADDR_EXT:
> +		if (dma->translation_in_low)
> +			addr = dmaaddr&  0xFFFFFFFF;
> +		else
> +			addr = dmaaddr>>  32;
> +		addr&= SSB_DMA_TRANSLATION_MASK;
> +		addr>>= SSB_DMA_TRANSLATION_SHIFT;
> +		break;

Sorry I missed this earlier, but when this code is compiled on a 32-bit system, 
the compiler spits out

   CC [M]  drivers/net/wireless/b43/dma.o
drivers/net/wireless/b43/dma.c: In function ‘b43_dma_address’:
drivers/net/wireless/b43/dma.c:64: warning: right shift count >= width of type
drivers/net/wireless/b43/dma.c:74: warning: right shift count >= width of type

This is reasonable as dma_addr_t is 32 bits.

Larry
