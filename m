Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:28449 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbYFJOmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 10:42:40 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1648062ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2008 07:42:39 -0700 (PDT)
Message-ID: <a44ae5cd0806100742t1bd275dib43c5d72b3dd9659@mail.gmail.com> (sfid-20080610_164254_665012_33C73DB2)
Date: Tue, 10 Jun 2008 10:42:38 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806101637.11473.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <19f34abd0806100729h7a060012h91e81248c9c7cdca@mail.gmail.com>
	 <200806101634.21576.mb@bu3sch.de> <200806101637.11473.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I forgot to label the kernel tree.  It is 2.6.26-rc5-mm2.

On Tue, Jun 10, 2008 at 10:37 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 10 June 2008 16:34:21 Michael Buesch wrote:
>> On Tuesday 10 June 2008 16:29:17 Vegard Nossum wrote:
>> > On Tue, Jun 10, 2008 at 4:23 PM, Michael Buesch <mb@bu3sch.de> wrote:
>> > > On Tuesday 10 June 2008 16:09:37 Miles Lane wrote:
>> > >> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> > >> IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
>> > >
>> > >
>> > > It seems to crash at
>> > >  60 extern const struct dma_mapping_ops *dma_ops;
>> > >  61
>> > >  62 static inline int dma_mapping_error(dma_addr_t dma_addr)
>> > >  63 {
>> > >  64         if (dma_ops->mapping_error)
>> > >  65                 return dma_ops->mapping_error(dma_addr);
>> > >  66
>> > >  67         return (dma_addr == bad_dma_address);
>> > >  68 }
>> >
>> > No, this is wrong.
>> >
>> > /* Check if a DMA mapping address is invalid. */
>> > static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>> >                                   dma_addr_t addr,
>> >                                   size_t buffersize, bool dma_to_device)
>> > {
>> >         if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
>> >
>> > It crashes on this line ---^
>>
>> Which calls dma_mapping_error(), correct?
>>
>> But you are right. I see the bug now.
>> ring->dev is assigned after the call.
>> I wonder why it works reliably on all of my machines.
>>
>
> Ehm no wait a second...
> What strange tree are you looking at?
> This is a copy of the code from my local tree.
>
>  516 /* Check if a DMA mapping address is invalid. */
>  517 static bool b43_dma_mapping_error(struct b43_dmaring *ring,
>  518                                   dma_addr_t addr,
>  519                                   size_t buffersize, bool dma_to_device)
>  520 {
>  521         if (unlikely(dma_mapping_error(addr)))
>  522                 return 1;
>
> This code is perfectly fine.
> This must be some merge error in some upstream tree.
>
> --
> Greetings Michael.
>
