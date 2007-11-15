Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:32972 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbXKOPDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 10:03:00 -0500
Message-ID: <473C5F98.1050007@lwfinger.net> (sfid-20071115_150306_122967_E9B5113B)
Date: Thu, 15 Nov 2007 09:02:48 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: seandarcy2@gmail.com, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/T] b43: Implement the BCM94311MCG rev 02 card with a rev
 13 802.11 core
References: <473bdf5e.LS8yn+6u1JmDiT9C%Larry.Finger@lwfinger.net> <200711151138.17468.mb@bu3sch.de>
In-Reply-To: <200711151138.17468.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 15 November 2007 06:55:42 Larry Finger wrote:
>> --- wireless-2.6.orig/drivers/net/wireless/b43/dma.c
>> +++ wireless-2.6/drivers/net/wireless/b43/dma.c
>> @@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
>>  	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
>>  	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
>>  	    >> SSB_DMA_TRANSLATION_SHIFT;
>> -	addrhi |= ssb_dma_translation(ring->dev->dev);
>> +	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
>>  	if (slot == ring->nr_slots - 1)
>>  		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
>>  	if (start)
> 
> Wait, this looks broken to me. It looks like the bug is more
> inside of the ssb_dma_translation function, rather than here.

Yes and no. In the DMA specs (http://bcm-v4.sipsolutions.net/802.11/DMA), a 2-bit "routing code" is
used for the address portion of a descriptor. For 32-bit, a value of 1 indicates "Client Mode
Translation". With a 64-bit device, a value of 2 is the valid routing code and 1 leads to DMA
Errors. It seemed easier to take a 0/1 output from ssb_dma_translation and shift it for the 64-bit
case than to teach ssb to distinguish between 32- and 64-bit DMA. BTW, we do have one other option -
we could ignore the routing and address extension bits and _limit_ the user to a maximum of 0.5
Zettabytes! What is the probability that any machine will exceed that amount of memory within our
lifetimes? But then, I never expected to see Terrabyte disk drives in a 3.5 inch package!! Have you
noted that Broadcom uses a 2-bit routing code _AND_ a 2-bit address extension? Why they didn't use a
flat 64-bit address is a mystery.

I can, however, go either way - your drivers and your call.

>> @@ -426,14 +426,15 @@ static inline
>>  static int alloc_ringmemory(struct b43_dmaring *ring)
>>  {
>>  	struct device *dev = ring->dev->dev->dev;
>> +	int size = (ring->dma64) ? 8192 : B43_DMA_RINGMEMSIZE;
> 
> Uhm, a page is also 4k in x86_64?
> Why doesn't using a page here work? What does happen?

You get random 4K/8K alignment and the driver fails with a Fatal DMA error for those with 4K alignment.

>> @@ -636,18 +637,13 @@ static int dmacontroller_setup(struct b4
>>  		if (ring->dma64) {
>>  			u64 ringbase = (u64) (ring->dmabase);
>>  
>> -			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
>> -			    >> SSB_DMA_TRANSLATION_SHIFT;
>> -			value = B43_DMA64_TXENABLE;
>> -			value |= (addrext << B43_DMA64_TXADDREXT_SHIFT)
>> -			    & B43_DMA64_TXADDREXT_MASK;
>> -			b43_dma_write(ring, B43_DMA64_TXCTL, value);
>> +			b43_dma_write(ring, B43_DMA64_TXCTL,
>> +				      B43_DMA64_TXENABLE);
> 
> Ehm, why are you removing this?

Unlike 32-bit DMA and the 64-bit descriptors, the 64-bit case uses two full 32-bit words to store
the Descriptor Ring Address. No fancy packing of the upper bits into the control word are needed.

>>  			b43_dma_write(ring, B43_DMA64_TXRINGLO,
>>  				      (ringbase & 0xFFFFFFFF));
>>  			b43_dma_write(ring, B43_DMA64_TXRINGHI,
>>  				      ((ringbase >> 32) &
>> -				       ~SSB_DMA_TRANSLATION_MASK)
>> -				      | trans);
>> +				       0xFFFFFFFF));
> 
> Huh?

This mask is not needed. It is a carryover from when I was having a problem. This will become
b43_dma_write(ring, B43_DMA64_TXRINGHI,(ringbase >> 32)); in the next version.

>>  		} else {
>>  			u32 ringbase = (u32) (ring->dmabase);
>>  
>> @@ -668,20 +664,16 @@ static int dmacontroller_setup(struct b4
>>  		if (ring->dma64) {
>>  			u64 ringbase = (u64) (ring->dmabase);
>>  
>> -			addrext = ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
>> -			    >> SSB_DMA_TRANSLATION_SHIFT;
>> -			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
>> -			value |= B43_DMA64_RXENABLE;
>> -			value |= (addrext << B43_DMA64_RXADDREXT_SHIFT)
>> -			    & B43_DMA64_RXADDREXT_MASK;
>> +			value = (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
>> +				| B43_DMA64_RXENABLE;
>>  			b43_dma_write(ring, B43_DMA64_RXCTL, value);
>>  			b43_dma_write(ring, B43_DMA64_RXRINGLO,
>>  				      (ringbase & 0xFFFFFFFF));
>>  			b43_dma_write(ring, B43_DMA64_RXRINGHI,
>>  				      ((ringbase >> 32) &
>> -				       ~SSB_DMA_TRANSLATION_MASK)
>> -				      | trans);
>> -			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
>> +				       0xFFFFFFFF));
>> +			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
>> +				      sizeof(struct b43_dmadesc64));
> 
> Same here.

Same change for the RX Descriptor Ring Address.

>> @@ -695,11 +687,12 @@ static int dmacontroller_setup(struct b4
>>  			b43_dma_write(ring, B43_DMA32_RXRING,
>>  				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
>>  				      | trans);
>> -			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
>> +			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
>> +				      sizeof(struct b43_dmadesc32));
> 
> I'm not sure why you do this change.

It took me a while to figure out where the magic number of 200 came from, and what I needed for the
64-bit case. In fact I think the 200 is a bug and should be 0x200. To me, this change makes it clearer.

>> Index: wireless-2.6/drivers/net/wireless/b43/dma.h
>> ===================================================================
>> --- wireless-2.6.orig/drivers/net/wireless/b43/dma.h
>> +++ wireless-2.6/drivers/net/wireless/b43/dma.h
>> @@ -260,6 +260,13 @@ static inline u32 b43_dma_read(struct b4
>>  static inline
>>      void b43_dma_write(struct b43_dmaring *ring, u16 offset, u32 value)
>>  {
>> +	/* temporary debugging code */
>> +	if (((offset == 8) || (offset == 0x28)) && ring->dma64 &&
>> +	     ((value & 0x1FFF) != 0)) {
>> +		printk(KERN_ERR "b43: bad desc ring address for 64-bit DMA"
>> +		       " - offset, value: 0x%.2X 0x%.4X\n", offset, value);
>> +		dump_stack();
>> +	}
> 
> Ok, temporary. You know what that means :)

In this case, it disappears before the patch goes to John!

Larry


