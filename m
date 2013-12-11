Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:58535 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LKUzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 15:55:47 -0500
Date: Thu, 12 Dec 2013 07:55:32 +1100
From: James Cameron <quozl@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: status of libertas_tf + sdio?
Message-ID: <20131211205532.GE452@us.netrek.org> (sfid-20131211_215550_234185_A4A76970)
References: <20131203202607.0b445195@kemnade.info>
 <1386167786.19448.4.camel@dcbw.foobar.com>
 <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com>
 <20131209041821.GC14878@us.netrek.org>
 <CA+E=qVd_F_=z5Vb2jan-nNVmizQznOiR=98CPHQevMxbnxGJiA@mail.gmail.com>
 <20131210022746.GE28975@us.netrek.org>
 <CA+E=qVdFq6XNAibsTUCbxQVbdRh+p6YT=nvgvmuO_u7jkBdKcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+E=qVdFq6XNAibsTUCbxQVbdRh+p6YT=nvgvmuO_u7jkBdKcw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 11, 2013 at 11:10:50AM +0300, Vasily Khoruzhick wrote:
> On Tue, Dec 10, 2013 at 5:27 AM, James Cameron <quozl@laptop.org> wrote:
> > On Mon, Dec 09, 2013 at 12:38:28PM +0300, Vasily Khoruzhick wrote:
> >> On Mon, Dec 9, 2013 at 7:18 AM, James Cameron <quozl@laptop.org> wrote:
> >> > On Fri, Dec 06, 2013 at 01:40:00PM +0300, Vasily Khoruzhick wrote:
> >> >> Out of curiosity,
> >> >>
> >> >> Does anyone know if it's possible to get thin firmware for 8686 with
> >> >> SPI interface?
> >> >
> >> > What happens when you try?
> >>
> >> How? There's no tf available for 8686 with SPI interface.
> >
> > How do you know that?  Are you saying that SPI support was removed
> > from firmware during the conversion from fat to thin?
> 
> Err, there's no lbtf_spi.bin file.

Basing decisions on the names of files rather than the code they
may contain seems rather limiting.

In the absence of evidence, there's a possibility that SPI support
remained.

> >> > How are you downloading firmware over SPI?
> >>
> >> See drivers/net/wireless/libertas/if_spi.c, but it's for fat
> >> firmware
> >
> > What happens if you send the thin firmware instead?
> 
> I have no thin firmware for 8686 with SPI interface

What happens if you send the thin firmware for SDIO interface to the
device using the fat firmware helper for SPI interface?

I don't have an SPI setup to test, but I gather you do.

> >> > I'm not aware of a second stage firmware download helper
> >> > specific to the SPI mode.
> >>
> >> What's a second stage firmware download helper?
> >
> > File sd8686_helper.bin, we use it in Open Firmware with SDIO 8686 on
> > OLPC XO.
> >
> > For SPI, which we don't use, I see if_spi.c uses gspi8686_v9_helper.bin
> >
> > I was wrong; I am now aware of a second stage firmware downloader
> > helper specific to the SPI mode.  I hadn't looked before.
> >
> >> > I think it is not possible without firmware engineering.
> >>
> >> Yeah, just hoped that Marvell already did it. It's a pity that
> >> firmware source code isn't available :(
> >
> > Cozybit did the thin firmware, if I recall correctly.
> 
> Do you think it makes sense to contact them?

I don't think it makes sense to ignore them, but I don't wish to
speculate further.

-- 
James Cameron
http://quozl.linux.org.au/
