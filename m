Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58951 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1HJRKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 13:10:05 -0400
Received: by gya6 with SMTP id 6so793472gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 10:10:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110810185534.5f4b9db9@milhouse>
References: <1312992688-6976-1-git-send-email-zajec5@gmail.com>
	<1312992688-6976-2-git-send-email-zajec5@gmail.com>
	<20110810183339.7259d936@milhouse>
	<CACna6rxNV-d_YNrCOqFCz8cbmbiXh-OqOYkvYmXacJCHsJ74-g@mail.gmail.com>
	<20110810185534.5f4b9db9@milhouse>
Date: Wed, 10 Aug 2011 19:10:03 +0200
Message-ID: <CACna6rz0m7SDT=gn26yGQYa6w4KghabCcK8QfM_NmJmpgN2gcg@mail.gmail.com> (sfid-20110810_191009_687976_6901DD74)
Subject: Re: [PATCH 2/2] b43: fix DMA on some bugged hardware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 sierpnia 2011 18:55 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Wed, 10 Aug 2011 18:45:57 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> W dniu 10 sierpnia 2011 18:33 użytkownik Michael Büsch <m@bues.ch> napisał:
>> > On Wed, 10 Aug 2011 18:11:28 +0200
>> >> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
>> >> index 0953ce1..9a2b678 100644
>> >> --- a/drivers/net/wireless/b43/dma.c
>> >> +++ b/drivers/net/wireless/b43/dma.c
>> >> @@ -174,7 +174,10 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
>> >>       addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
>> >>       addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
>> >>           >> SSB_DMA_TRANSLATION_SHIFT;
>> >> -     addrhi |= ring->dev->dma.translation;
>> >> +     if (ring->dev->dma.translation_in_low)
>> >> +             addrlo |= ring->dev->dma.translation;
>> >> +     else
>> >> +             addrhi |= ring->dev->dma.translation;
>> >>       if (slot == ring->nr_slots - 1)
>> >>               ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
>> >>       if (start)
>> >> @@ -656,10 +659,12 @@ static int alloc_initial_descbuffers(struct b43_dmaring *ring)
>> >>  static int dmacontroller_setup(struct b43_dmaring *ring)
>> >>  {
>> >>       int err = 0;
>> >> +     int tmp;
>> >>       u32 value;
>> >>       u32 addrext;
>> >>       u32 trans = ring->dev->dma.translation;
>> >>       bool parity = ring->dev->dma.parity;
>> >> +     u32 addrs[2];
>> >>
>> >>       if (ring->tx) {
>> >>               if (ring->type == B43_DMA_64BIT) {
>> >> @@ -673,12 +678,14 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
>> >>                       if (!parity)
>> >>                               value |= B43_DMA64_TXPARITYDISABLE;
>> >>                       b43_dma_write(ring, B43_DMA64_TXCTL, value);
>> >> -                     b43_dma_write(ring, B43_DMA64_TXRINGLO,
>> >> -                                   (ringbase & 0xFFFFFFFF));
>> >> -                     b43_dma_write(ring, B43_DMA64_TXRINGHI,
>> >> -                                   ((ringbase >> 32) &
>> >> -                                    ~SSB_DMA_TRANSLATION_MASK)
>> >> -                                   | trans);
>> >> +
>> >> +                     addrs[0] = ringbase & 0xFFFFFFFF;
>> >> +                     addrs[1] = ringbase >> 32;
>> >> +                     tmp = ring->dev->dma.translation_in_low ? 0 : 1;
>> >> +                     addrs[tmp] &= ~SSB_DMA_TRANSLATION_MASK;
>> >> +                     addrs[tmp] |= trans;
>> >> +                     b43_dma_write(ring, B43_DMA64_TXRINGLO, addrs[0]);
>> >> +                     b43_dma_write(ring, B43_DMA64_TXRINGHI, addrs[1]);
>> >>               } else {
>> >>                       u32 ringbase = (u32) (ring->dmabase);
>> >>
>> >> @@ -710,12 +717,15 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
>> >>                       if (!parity)
>> >>                               value |= B43_DMA64_RXPARITYDISABLE;
>> >>                       b43_dma_write(ring, B43_DMA64_RXCTL, value);
>> >> -                     b43_dma_write(ring, B43_DMA64_RXRINGLO,
>> >> -                                   (ringbase & 0xFFFFFFFF));
>> >> -                     b43_dma_write(ring, B43_DMA64_RXRINGHI,
>> >> -                                   ((ringbase >> 32) &
>> >> -                                    ~SSB_DMA_TRANSLATION_MASK)
>> >> -                                   | trans);
>> >> +
>> >> +                     addrs[0] = ringbase & 0xFFFFFFFF;
>> >> +                     addrs[1] = ringbase >> 32;
>> >> +                     tmp = ring->dev->dma.translation_in_low ? 0 : 1;
>> >> +                     addrs[tmp] &= ~SSB_DMA_TRANSLATION_MASK;
>> >> +                     addrs[tmp] |= trans;
>> >> +                     b43_dma_write(ring, B43_DMA64_RXRINGLO, addrs[0]);
>> >> +                     b43_dma_write(ring, B43_DMA64_RXRINGHI, addrs[1]);
>> >> +
>> >>                       b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
>> >>                                     sizeof(struct b43_dmadesc64));
>> >>               } else {
>> >> @@ -1052,6 +1062,21 @@ static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
>> >>       return 0;
>> >>  }
>> >
>> >
>> > This doesn't look correct to me for several reasons:
>> >
>> > In the fill-op the address is not masked correctly with the translation mask.
>> > In both the fill-op and both ring setups, the actual address extension bits
>> > are always taken from the address's high word. I guess the extension should
>> > be the low word bits for devices where we use the low word. That's the only
>> > thing that would make sense. But hey, it's not that we have sane hardware here.
>> > So this has to be checked.
>>
>> Ouch, yeah, you should be right (according to common sense of design).
>>
>> Unfortunately, on my machine, kernel provides low addresses for DMA purposes:
>> 0x1f310000
>> 0x1f318000
>> 0x1f31c000
>>
>> Can I ask/hack kernel to offer b43 addresses starting with 0x4... or
>> 0x8... (or 0xc...)?
>
> I'm not sure I understand..
> Are you actually saying that those shiny new devices are total crap
> in that their 64bit DMA engine can only do real-life-30bit, because they
> completely fucked up the extension bits?
> Did you try to fix the extension according to my suggestion? Does that
> break stuff?

Sorry, I was thinking about some additional tests without really
sharing my thoughts.

kernel offers me addresses like:
0x000000001f310000
0x000000001f318000
0x000000001f31c000

However I wanted to hack kernel to receive something conflicting with:
#define SSB_DMA_TRANSLATION_MASK	0xC0000000

For example I wanted to receive from kernel address like:
0x000000005f318000
or
0x000000009f318000


However that are just some additional tests. It sounds pretty obvious
that we should take addrext from the "correct" part of ringbase (AKA
ring->dmabase).

-- 
Rafał
