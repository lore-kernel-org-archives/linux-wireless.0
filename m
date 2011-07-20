Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55909 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1GTIzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 04:55:47 -0400
Date: Wed, 20 Jul 2011 10:55:40 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just
 a one, commented
Message-ID: <20110720105540.1c9d072c@maggie> (sfid-20110720_105551_375680_AB7636FF)
In-Reply-To: <CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
	<1311113542-2540-2-git-send-email-zajec5@gmail.com>
	<20110720011509.504022f8@maggie>
	<CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jul 2011 08:16:08 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> W dniu 20 lipca 2011 01:15 użytkownik Michael Büsch <m@bues.ch> napisał:
> > On Wed, 20 Jul 2011 00:12:20 +0200
> > Rafał Miłecki <zajec5@gmail.com> wrote:
> >> +              * be fixed on ssb side, but requires testing with b43,
> >> +              * b43legacy and b44. */
> >
> > No it doesn't. b44 and b43legacy don't use 64bit DMA.
> > Just fix it in ssb, please.
> 
> They (drivers) don't, but what if we start giving them routing for
> 64-bit DMA? AFAIU they treat 64-bit DMA as 32-bit one (according to
> specs: "If 64 Bit isn't an option, Silicon Backplane and PCI-E buses
> can use 32 bit DMA.").
> 
> Won't they start using 64-bit DMA in the 32-bit way but with 64-bit
> routing bits?
> 

I have no idea what you're talking about.
The fact is: These "temporary workarounds" tend to stay in the driver forever
if we don't fix it _now_. So please fix it now.
We know whether we are on 64bit DMA or not. So if we are on 64bit DMA, use the 64bit mask.
Simply pass the "32 or 64 bit" boolean flag to ssb_dma_translation() as parameter.
There's nothing that can go wrong here with older drivers.
