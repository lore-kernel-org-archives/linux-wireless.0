Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60530 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbXKWFhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 00:37:07 -0500
Message-ID: <474666F7.6090405@lwfinger.net> (sfid-20071123_053725_619078_0FE7A01E)
Date: Thu, 22 Nov 2007 23:36:55 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] b43: Changes to enable BCM4311 rev 02 with wireless
 core revision 13
References: <4744a544.OLz3JRLe85L+V2nd%Larry.Finger@lwfinger.net> <200711221834.32026.mb@bu3sch.de>
In-Reply-To: <200711221834.32026.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> partially acked.
> Though, I'm not quite sure yet why you remove that
> address extension bits. The specs clearly say that they _are_ there.
> And it makes sense to use them, as two bytes of the address are used
> for the routing stuff. So the highest 2 bits of the address have to be put
> somewhere else. That's the "Transmit Channel Control Word" and
> "Receive Channel Control Word" where 0x00030000 are the extension bits.
> 

The appropriate section of dmacontroller_setup() in my patched source is as follows:

        if (ring->tx) {
                if (ring->dma64) {
                        u64 ringbase = (u64) (ring->dmabase);

                        b43_dma_write(ring, B43_DMA64_TXCTL,
                                      B43_DMA64_TXENABLE);
                        b43_dma_write(ring, B43_DMA64_TXRINGLO,
                                      (ringbase & 0xFFFFFFFF));
                        b43_dma_write(ring, B43_DMA64_TXRINGHI,
                                      (ringbase >> 32));
                } else {
			...... untouched 32-bit stuff ....
		}
        } else {
                err = alloc_initial_descbuffers(ring);
                if (err)
                        goto out;
                if (ring->dma64) {
                        u64 ringbase = (u64) (ring->dmabase);

                        value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
                                | B43_DMA64_RXENABLE;
                        b43_dma_write(ring, B43_DMA64_RXCTL, value);
                        b43_dma_write(ring, B43_DMA64_RXRINGLO,
                                      (ringbase & 0xFFFFFFFF));
                        b43_dma_write(ring, B43_DMA64_RXRINGHI,
                                      (ringbase >> 32));
                        b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
                                      sizeof(struct b43_dmadesc64));
                } else {
			........... 32-bit stuff ........
	}

No address extensions are used here because the specs clearly state that a flat 64-bit address is
used to specify the Descriptor Ring address. My code matches the specs.

In the 64-bit fill_descriptor routine, the my patches result in the following code:

        addrlo = (u32) (dmaaddr & 0xFFFFFFFF);
        addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
        addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
            >> SSB_DMA_TRANSLATION_SHIFT;
        addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
        if (slot == ring->nr_slots - 1)
                ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
        if (start)
                ctl0 |= B43_DMA64_DCTL0_FRAMESTART;
        if (end)
                ctl0 |= B43_DMA64_DCTL0_FRAMEEND;
        if (irq)
                ctl0 |= B43_DMA64_DCTL0_IRQ;
        ctl1 |= (bufsize - ring->frameoffset)
            & B43_DMA64_DCTL1_BYTECNT;
        ctl1 |= (addrext << B43_DMA64_DCTL1_ADDREXT_SHIFT)
            & B43_DMA64_DCTL1_ADDREXT_MASK;

In this case, the specs do call for the upper two bits to be masked off the high 32 bits of the
address to be used for the routing code. These are saved in 'addrext' above. The routing bits, which
must be '10' for the 64-bit case, are then shifted into that 2-bit field, and the masked address
bits are encoded into the second control word 'ctl1' in the above snippet. As far as I can tell, my
code is doing exactly what the specs require - address extensions and all. If not, please show me
the error.

> However I do think that this might be related to the bug you are explaining
> in the comment:
>> +	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
>> +	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
>> +	 * which accounts for the GFP_DMA flag below.
>

Not true for two reasons. The first one is that it is the address of the ring buffer that is getting
the error, and that part does not use any extension bits. Secondly, the address extension stuff
would only apply if my computer had more than 2^(62) bytes of RAM, which is something like 10
billion GB - an amount that probably exceeds the total RAM in the world. As best I can tell, this
bug triggers when the Ring Buffer is placed above the 64-Megabyte level.

Larry


