Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62826 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051Ab0CaJtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 05:49:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100331090836.GA30801@buzzloop.caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
	 <x2ve2d7436a1003310207t16a7d1d6r7853de2dfa647c6c@mail.gmail.com>
	 <20100331090836.GA30801@buzzloop.caiaq.de>
Date: Wed, 31 Mar 2010 11:49:49 +0200
Message-ID: <k2he2d7436a1003310249v63878e0ahe1b398401937a225@mail.gmail.com>
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit transfers
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org,
	Alagu Sankar <alagusankar@embwise.com>,
	Volker Ernst <volker.ernst@txtr.com>,
	Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Bing Zhao <bzhao@marvell.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 31 marca 2010 11:08 u¿ytkownik Daniel Mack <daniel@caiaq.de> napisa³:
> On Wed, Mar 31, 2010 at 11:07:06AM +0200, Micha³ Miros³aw wrote:
>> 2010/3/30 Daniel Mack <daniel@caiaq.de>:
>> [...]
>> > @@ -1022,6 +1025,27 @@ static int if_sdio_probe(struct sdio_func *func,
>> >        if (ret)
>> >                goto disable;
>> >
>> > +       /* For 1-bit transfers, we need to enable the interrupt flags in
>> > +        * the CCCR register. Temporarily set the function number to 0
>> > +        * for that. */
>> > +       if ((host->caps & MMC_CAP_SDIO_IRQ) &&
>> > +           (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
>> > +               unsigned int num = func->num;
>> > +               u8 reg;
>> > +
>> > +               func->num = 0;
>> > +               reg = sdio_readb(func, SDIO_CCCR_IF, &ret);
>> > +               if (ret)
>> > +                       goto release_int;
>> > +
>> > +               reg |= SDIO_BUS_ECSI | SDIO_BUS_SCSI;
>> > +               sdio_writeb(func, reg, SDIO_CCCR_IF, &ret);
>> > +               if (ret)
>> > +                       goto release_int;
>> > +
>> > +               func->num = num;
>> > +       }
>> > +
>> >        card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
>> >        if (ret)
>> >                goto release_int;
>>
>> You should probably just use mmc_io_rw_direct() in this case instead
>> of abusing func->num.
>
> Hmm, that function isn't exported, and I didn't want to change this. You
> say you'd prefer that? I can cook up something that does it, no problem.

BTW, I can't see any exported functions to access fn#0 directly from
drivers. Maybe it's time to introduce them now - at least CCCR has
some vendor-defined parts that drivers may want to access and there is
a lot of place in CIS area that can be (ab)used by devices.

Best Regards,
Micha³ Miros³aw
