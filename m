Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35480 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1GTLKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:10:55 -0400
Received: by pzk37 with SMTP id 37so172484pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 04:10:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110720105540.1c9d072c@maggie>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
	<1311113542-2540-2-git-send-email-zajec5@gmail.com>
	<20110720011509.504022f8@maggie>
	<CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
	<20110720105540.1c9d072c@maggie>
Date: Wed, 20 Jul 2011 13:10:55 +0200
Message-ID: <CACna6rxNyZquGMVz5RUWs58ty+KTeFkv5wcccBQyw2n2A7XLMA@mail.gmail.com> (sfid-20110720_131059_599000_A984A969)
Subject: [PATCH 1/3] b43: replace DMA translation workarounds with just a one, commented
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jul 20, 2011 10:55 AM, "Michael Büsch" <m@bues.ch> wrote:
>
> On Wed, 20 Jul 2011 08:16:08 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
> > W dniu 20 lipca 2011 01:15 użytkownik Michael Büsch <m@bues.ch> napisał:
> > > On Wed, 20 Jul 2011 00:12:20 +0200
> > > Rafał Miłecki <zajec5@gmail.com> wrote:
> > >> +              * be fixed on ssb side, but requires testing with b43,
> > >> +              * b43legacy and b44. */
> > >
> > > No it doesn't. b44 and b43legacy don't use 64bit DMA.
> > > Just fix it in ssb, please.
> >
> > They (drivers) don't, but what if we start giving them routing for
> > 64-bit DMA? AFAIU they treat 64-bit DMA as 32-bit one (according to
> > specs: "If 64 Bit isn't an option, Silicon Backplane and PCI-E buses
> > can use 32 bit DMA.").
> >
> > Won't they start using 64-bit DMA in the 32-bit way but with 64-bit
> > routing bits?
> >
>
> I have no idea what you're talking about.
> The fact is: These "temporary workarounds" tend to stay in the driver forever
> if we don't fix it _now_. So please fix it now.
> We know whether we are on 64bit DMA or not. So if we are on 64bit DMA, use the 64bit mask.
> Simply pass the "32 or 64 bit" boolean flag to ssb_dma_translation() as parameter.
> There's nothing that can go wrong here with older drivers.

Sorry, for not explaining this well eno
ugh. I'm afraid of situation where b44 driver supports 64-bit DMA
device *without* handling this as such a device. It treats it as
32-bit one and it works thanks to kind of ssb's fallback described in
the specs. Now if I clean ssb_dma_translation we will detect that DMA
is 64-bit and we will pass different routing bit.

So as the result b44 will still treat DMA as 32-bit one, but it will
start using routing for 64-bit one.
Alternative is to do not detect kind of DMA in the ssb_dma_translation
but take it as a parameter (as you suggested). A *little* more to care
about on the driver side but would make a trick.

Or... is there any b44 supported device with 64-bit DMA at all?


-- 
Rafał
