Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1GZRsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 13:48:00 -0400
Received: by iyb12 with SMTP id 12so751172iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 10:47:59 -0700 (PDT)
Message-ID: <4E2EFDCC.3060604@lwfinger.net> (sfid-20110726_194804_044937_6678BCFC)
Date: Tue, 26 Jul 2011 12:47:56 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43legacy: remove 64-bit DMA support
References: <20110725213832.32510.3753.stgit@mj.roinet.com>
In-Reply-To: <20110725213832.32510.3753.stgit@mj.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 04:40 PM, Pavel Roskin wrote:
> Devices supported by b43legacy don't support 64-bit DMA.
>
> Signed-off-by: Pavel Roskin<proski@gnu.org>
> ---
> The patch was tested on Broadcom 4306.
>
>   drivers/net/wireless/b43legacy/dma.c |  374 ++++++----------------------------
>   drivers/net/wireless/b43legacy/dma.h |  107 ----------
>   2 files changed, 71 insertions(+), 410 deletions(-)

Tested on BCM4303.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

See some minor comments below.

Larry


> diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
> index 704ee62..a23b998 100644
> --- a/drivers/net/wireless/b43legacy/dma.c
> +++ b/drivers/net/wireless/b43legacy/dma.c
> @@ -42,10 +42,9 @@
>
>   /* 32bit DMA ops. */
>   static
> -struct b43legacy_dmadesc_generic *op32_idx2desc(
> -					struct b43legacy_dmaring *ring,
> -					int slot,
> -					struct b43legacy_dmadesc_meta **meta)
> +struct b43legacy_dmadesc32 *op32_idx2desc(struct b43legacy_dmaring *ring,
> +					  int slot,
> +					  struct b43legacy_dmadesc_meta **meta)
>   {
>   	struct b43legacy_dmadesc32 *desc;
>
> @@ -53,11 +52,11 @@ struct b43legacy_dmadesc_generic *op32_idx2desc(
>   	desc = ring->descbase;
>   	desc =&(desc[slot]);
>
> -	return (struct b43legacy_dmadesc_generic *)desc;
> +	return (struct b43legacy_dmadesc32 *)desc;
>   }
>
>   static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
> -				 struct b43legacy_dmadesc_generic *desc,
> +				 struct b43legacy_dmadesc32 *desc,
>   				 dma_addr_t dmaaddr, u16 bufsize,
>   				 int start, int end, int irq)
>   {
> @@ -67,7 +66,7 @@ static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
>   	u32 addr;
>   	u32 addrext;
>
> -	slot = (int)(&(desc->dma32) - descbase);
> +	slot = (int)(desc - descbase);
>   	B43legacy_WARN_ON(!(slot>= 0&&  slot<  ring->nr_slots));
>
>   	addr = (u32)(dmaaddr&  ~SSB_DMA_TRANSLATION_MASK);
> @@ -87,8 +86,8 @@ static void op32_fill_descriptor(struct b43legacy_dmaring *ring,
>   	ctl |= (addrext<<  B43legacy_DMA32_DCTL_ADDREXT_SHIFT)
>   	&  B43legacy_DMA32_DCTL_ADDREXT_MASK;
>
> -	desc->dma32.control = cpu_to_le32(ctl);
> -	desc->dma32.address = cpu_to_le32(addr);
> +	desc->control = cpu_to_le32(ctl);
> +	desc->address = cpu_to_le32(addr);
>   }
>
>   static void op32_poke_tx(struct b43legacy_dmaring *ring, int slot)
> @@ -128,121 +127,6 @@ static void op32_set_current_rxslot(struct b43legacy_dmaring *ring,
>   			    (u32)(slot * sizeof(struct b43legacy_dmadesc32)));
>   }
>
> -static const struct b43legacy_dma_ops dma32_ops = {
> -	.idx2desc		= op32_idx2desc,
> -	.fill_descriptor	= op32_fill_descriptor,
> -	.poke_tx		= op32_poke_tx,
> -	.tx_suspend		= op32_tx_suspend,
> -	.tx_resume		= op32_tx_resume,
> -	.get_current_rxslot	= op32_get_current_rxslot,
> -	.set_current_rxslot	= op32_set_current_rxslot,
> -};
> -
> -/* 64bit DMA ops. */
> -static
> -struct b43legacy_dmadesc_generic *op64_idx2desc(
> -					struct b43legacy_dmaring *ring,
> -					int slot,
> -					struct b43legacy_dmadesc_meta
> -					**meta)
> -{
> -	struct b43legacy_dmadesc64 *desc;
> -
> -	*meta =&(ring->meta[slot]);
> -	desc = ring->descbase;
> -	desc =&(desc[slot]);
> -
> -	return (struct b43legacy_dmadesc_generic *)desc;
> -}
> -
> -static void op64_fill_descriptor(struct b43legacy_dmaring *ring,
> -				 struct b43legacy_dmadesc_generic *desc,
> -				 dma_addr_t dmaaddr, u16 bufsize,
> -				 int start, int end, int irq)
> -{
> -	struct b43legacy_dmadesc64 *descbase = ring->descbase;
> -	int slot;
> -	u32 ctl0 = 0;
> -	u32 ctl1 = 0;
> -	u32 addrlo;
> -	u32 addrhi;
> -	u32 addrext;
> -
> -	slot = (int)(&(desc->dma64) - descbase);
> -	B43legacy_WARN_ON(!(slot>= 0&&  slot<  ring->nr_slots));
> -
> -	addrlo = (u32)(dmaaddr&  0xFFFFFFFF);
> -	addrhi = (((u64)dmaaddr>>  32)&  ~SSB_DMA_TRANSLATION_MASK);
> -	addrext = (((u64)dmaaddr>>  32)&  SSB_DMA_TRANSLATION_MASK)
> -		>>  SSB_DMA_TRANSLATION_SHIFT;
> -	addrhi |= ring->dev->dma.translation;
> -	if (slot == ring->nr_slots - 1)
> -		ctl0 |= B43legacy_DMA64_DCTL0_DTABLEEND;
> -	if (start)
> -		ctl0 |= B43legacy_DMA64_DCTL0_FRAMESTART;
> -	if (end)
> -		ctl0 |= B43legacy_DMA64_DCTL0_FRAMEEND;
> -	if (irq)
> -		ctl0 |= B43legacy_DMA64_DCTL0_IRQ;
> -	ctl1 |= (bufsize - ring->frameoffset)
> -		&  B43legacy_DMA64_DCTL1_BYTECNT;
> -	ctl1 |= (addrext<<  B43legacy_DMA64_DCTL1_ADDREXT_SHIFT)
> -		&  B43legacy_DMA64_DCTL1_ADDREXT_MASK;
> -
> -	desc->dma64.control0 = cpu_to_le32(ctl0);
> -	desc->dma64.control1 = cpu_to_le32(ctl1);
> -	desc->dma64.address_low = cpu_to_le32(addrlo);
> -	desc->dma64.address_high = cpu_to_le32(addrhi);
> -}
> -
> -static void op64_poke_tx(struct b43legacy_dmaring *ring, int slot)
> -{
> -	b43legacy_dma_write(ring, B43legacy_DMA64_TXINDEX,
> -			    (u32)(slot * sizeof(struct b43legacy_dmadesc64)));
> -}
> -
> -static void op64_tx_suspend(struct b43legacy_dmaring *ring)
> -{
> -	b43legacy_dma_write(ring, B43legacy_DMA64_TXCTL,
> -			    b43legacy_dma_read(ring, B43legacy_DMA64_TXCTL)
> -			    | B43legacy_DMA64_TXSUSPEND);
> -}
> -
> -static void op64_tx_resume(struct b43legacy_dmaring *ring)
> -{
> -	b43legacy_dma_write(ring, B43legacy_DMA64_TXCTL,
> -			    b43legacy_dma_read(ring, B43legacy_DMA64_TXCTL)
> -			&  ~B43legacy_DMA64_TXSUSPEND);
> -}
> -
> -static int op64_get_current_rxslot(struct b43legacy_dmaring *ring)
> -{
> -	u32 val;
> -
> -	val = b43legacy_dma_read(ring, B43legacy_DMA64_RXSTATUS);
> -	val&= B43legacy_DMA64_RXSTATDPTR;
> -
> -	return (val / sizeof(struct b43legacy_dmadesc64));
> -}
> -
> -static void op64_set_current_rxslot(struct b43legacy_dmaring *ring,
> -				    int slot)
> -{
> -	b43legacy_dma_write(ring, B43legacy_DMA64_RXINDEX,
> -			    (u32)(slot * sizeof(struct b43legacy_dmadesc64)));
> -}
> -
> -static const struct b43legacy_dma_ops dma64_ops = {
> -	.idx2desc		= op64_idx2desc,
> -	.fill_descriptor	= op64_fill_descriptor,
> -	.poke_tx		= op64_poke_tx,
> -	.tx_suspend		= op64_tx_suspend,
> -	.tx_resume		= op64_tx_resume,
> -	.get_current_rxslot	= op64_get_current_rxslot,
> -	.set_current_rxslot	= op64_set_current_rxslot,
> -};
> -
> -
>   static inline int free_slots(struct b43legacy_dmaring *ring)
>   {
>   	return (ring->nr_slots - ring->used_slots);
> @@ -358,14 +242,6 @@ return 0;
>   static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
>   					int controller_idx)
>   {
> -	static const u16 map64[] = {
> -		B43legacy_MMIO_DMA64_BASE0,
> -		B43legacy_MMIO_DMA64_BASE1,
> -		B43legacy_MMIO_DMA64_BASE2,
> -		B43legacy_MMIO_DMA64_BASE3,
> -		B43legacy_MMIO_DMA64_BASE4,
> -		B43legacy_MMIO_DMA64_BASE5,
> -	};
>   	static const u16 map32[] = {
>   		B43legacy_MMIO_DMA32_BASE0,
>   		B43legacy_MMIO_DMA32_BASE1,
> @@ -375,11 +251,6 @@ static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
>   		B43legacy_MMIO_DMA32_BASE5,
>   	};
>
> -	if (type == B43legacy_DMA_64BIT) {
> -		B43legacy_WARN_ON(!(controller_idx>= 0&&
> -				  controller_idx<  ARRAY_SIZE(map64)));
> -		return map64[controller_idx];
> -	}
>   	B43legacy_WARN_ON(!(controller_idx>= 0&&
>   			controller_idx<  ARRAY_SIZE(map32)));
>   	return map32[controller_idx];
> @@ -491,25 +362,15 @@ static int b43legacy_dmacontroller_rx_reset(struct b43legacy_wldev *dev,
>
>   	might_sleep();
>
> -	offset = (type == B43legacy_DMA_64BIT) ?
> -		 B43legacy_DMA64_RXCTL : B43legacy_DMA32_RXCTL;
> +	offset = B43legacy_DMA32_RXCTL;
>   	b43legacy_write32(dev, mmio_base + offset, 0);
>   	for (i = 0; i<  10; i++) {
> -		offset = (type == B43legacy_DMA_64BIT) ?
> -			 B43legacy_DMA64_RXSTATUS : B43legacy_DMA32_RXSTATUS;
> +		offset = B43legacy_DMA32_RXSTATUS;
>   		value = b43legacy_read32(dev, mmio_base + offset);
> -		if (type == B43legacy_DMA_64BIT) {
> -			value&= B43legacy_DMA64_RXSTAT;
> -			if (value == B43legacy_DMA64_RXSTAT_DISABLED) {
> -				i = -1;
> -				break;
> -			}
> -		} else {
> -			value&= B43legacy_DMA32_RXSTATE;
> -			if (value == B43legacy_DMA32_RXSTAT_DISABLED) {
> -				i = -1;
> -				break;
> -			}
> +		value&= B43legacy_DMA32_RXSTATE;

I am surprised that checkpatch doesn't see the spacing around the &= as an error.

> +		if (value == B43legacy_DMA32_RXSTAT_DISABLED) {
> +			i = -1;
> +			break;
>   		}
>   		msleep(1);
>   	}
> @@ -533,43 +394,24 @@ static int b43legacy_dmacontroller_tx_reset(struct b43legacy_wldev *dev,
>   	might_sleep();
>
>   	for (i = 0; i<  10; i++) {
> -		offset = (type == B43legacy_DMA_64BIT) ?
> -			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
> +		offset = B43legacy_DMA32_TXSTATUS;
>   		value = b43legacy_read32(dev, mmio_base + offset);
> -		if (type == B43legacy_DMA_64BIT) {
> -			value&= B43legacy_DMA64_TXSTAT;
> -			if (value == B43legacy_DMA64_TXSTAT_DISABLED ||
> -			    value == B43legacy_DMA64_TXSTAT_IDLEWAIT ||
> -			    value == B43legacy_DMA64_TXSTAT_STOPPED)
> -				break;
> -		} else {
> -			value&= B43legacy_DMA32_TXSTATE;
> -			if (value == B43legacy_DMA32_TXSTAT_DISABLED ||
> -			    value == B43legacy_DMA32_TXSTAT_IDLEWAIT ||
> -			    value == B43legacy_DMA32_TXSTAT_STOPPED)
> -				break;
> -		}
> +		value&= B43legacy_DMA32_TXSTATE;

Ditto.

> +		if (value == B43legacy_DMA32_TXSTAT_DISABLED ||
> +		    value == B43legacy_DMA32_TXSTAT_IDLEWAIT ||
> +		    value == B43legacy_DMA32_TXSTAT_STOPPED)
> +			break;
>   		msleep(1);
>   	}
> -	offset = (type == B43legacy_DMA_64BIT) ? B43legacy_DMA64_TXCTL :
> -						 B43legacy_DMA32_TXCTL;
> +	offset = B43legacy_DMA32_TXCTL;
>   	b43legacy_write32(dev, mmio_base + offset, 0);
>   	for (i = 0; i<  10; i++) {
> -		offset = (type == B43legacy_DMA_64BIT) ?
> -			 B43legacy_DMA64_TXSTATUS : B43legacy_DMA32_TXSTATUS;
> +		offset = B43legacy_DMA32_TXSTATUS;
>   		value = b43legacy_read32(dev, mmio_base + offset);
> -		if (type == B43legacy_DMA_64BIT) {
> -			value&= B43legacy_DMA64_TXSTAT;
> -			if (value == B43legacy_DMA64_TXSTAT_DISABLED) {
> -				i = -1;
> -				break;
> -			}
> -		} else {
> -			value&= B43legacy_DMA32_TXSTATE;
> -			if (value == B43legacy_DMA32_TXSTAT_DISABLED) {
> -				i = -1;
> -				break;
> -			}
> +		value&= B43legacy_DMA32_TXSTATE;

Ditto.
