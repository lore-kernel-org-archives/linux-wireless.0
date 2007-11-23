Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52034
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXKWNtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 08:49:18 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
Date: Fri, 23 Nov 2007 14:47:18 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4744a544.OLz3JRLe85L+V2nd%Larry.Finger@lwfinger.net> <200711221834.32026.mb@bu3sch.de> <474666F7.6090405@lwfinger.net>
In-Reply-To: <474666F7.6090405@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711231447.19262.mb@bu3sch.de> (sfid-20071123_134920_545237_A6356941)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 November 2007 06:36:55 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > partially acked.
> > Though, I'm not quite sure yet why you remove that
> > address extension bits. The specs clearly say that they _are_ there.
> > And it makes sense to use them, as two bytes of the address are used
> > for the routing stuff. So the highest 2 bits of the address have to be put
> > somewhere else. That's the "Transmit Channel Control Word" and
> > "Receive Channel Control Word" where 0x00030000 are the extension bits.
> > 
> 
> The appropriate section of dmacontroller_setup() in my patched source is as follows:
> 
>         if (ring->tx) {
>                 if (ring->dma64) {
>                         u64 ringbase = (u64) (ring->dmabase);
> 
>                         b43_dma_write(ring, B43_DMA64_TXCTL,
>                                       B43_DMA64_TXENABLE);
>                         b43_dma_write(ring, B43_DMA64_TXRINGLO,
>                                       (ringbase & 0xFFFFFFFF));
>                         b43_dma_write(ring, B43_DMA64_TXRINGHI,
>                                       (ringbase >> 32));
>                 } else {
> 			...... untouched 32-bit stuff ....
> 		}
>         } else {
>                 err = alloc_initial_descbuffers(ring);
>                 if (err)
>                         goto out;
>                 if (ring->dma64) {
>                         u64 ringbase = (u64) (ring->dmabase);
> 
>                         value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
>                                 | B43_DMA64_RXENABLE;
>                         b43_dma_write(ring, B43_DMA64_RXCTL, value);
>                         b43_dma_write(ring, B43_DMA64_RXRINGLO,
>                                       (ringbase & 0xFFFFFFFF));
>                         b43_dma_write(ring, B43_DMA64_RXRINGHI,
>                                       (ringbase >> 32));
>                         b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
>                                       sizeof(struct b43_dmadesc64));
>                 } else {
> 			........... 32-bit stuff ........
> 	}
> 
> No address extensions are used here because the specs clearly state that a flat 64-bit address is
> used to specify the Descriptor Ring address. My code matches the specs.

I'm not sure which specifications you use, but here it clearly describes the
extension bits:
http://bcm-v4.sipsolutions.net/802.11/DMA#TransmitChannelControlWord-1

> > However I do think that this might be related to the bug you are explaining
> > in the comment:
> >> +	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
> >> +	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
> >> +	 * which accounts for the GFP_DMA flag below.

> the error, and that part does not use any extension bits. Secondly, the address extension stuff
> would only apply if my computer had more than 2^(62) bytes of RAM, which is something like 10
> billion GB - an amount that probably exceeds the total RAM in the world.

This is not true. We live in a world with IO-MMUs.

-- 
Greetings Michael.
