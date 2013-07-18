Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cooperlighting-sw.cooperlighting.com ([216.130.131.68]:55622
	"EHLO cooperlighting-sw.cooperlighting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab3GRBL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 21:11:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: So, which IEEE<->Frequency mappings should we be all using?
Date: Thu, 18 Jul 2013 08:58:42 +0800
Message-ID: <475A4E02EFF4724A9E58F55A56AC1316089BB77C@APEVS1.ap.ci.root> (sfid-20130718_031202_552406_2881BB23)
In-Reply-To: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com>
References: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com>
From: "Wright, Brett" <Brett.Wright@cooperindustries.com>
To: "Adrian Chadd" <adrian@freebsd.org>,
	<freebsd-wireless@freebsd.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: owner-freebsd-wireless@freebsd.org [mailto:owner-freebsd-
> wireless@freebsd.org] On Behalf Of Adrian Chadd
> Sent: Thursday, 18 July 2013 3:42 AM
> To: freebsd-wireless@freebsd.org; linux-wireless@vger.kernel.org
> Subject: So, which IEEE<->Frequency mappings should we be all using?
> 
> Hi all,
> 
> I've been increasingly asked to bring up FreeBSD on "other" bands.
> 
> * 420MHz
> * 700MHz
> * 900MHz (which we already have, due to history);
> * 3.6GHz
> * 4.9GHz
> 
> I'd also like to support half and quarter width channels on these
frequencies.
> If I use the 2GHz channel mapping method, I end up with a very
restricted
> channel set and it definitely has no "gaps" for 5/10MHz increments.
> 
> Now, what I'd like to do is figure out some sane, shared method of
> translating channel frequencies to IEEE numbers and back. That way the
BSDs
> and Linux (and maybe commercial stacks; I dunno what they do) can have
> some sane chance of interoperating.
> 
> So: Is there some standardised or semi-standardised channel mapping
> method? Or should we invent one?
> 
> 
> -adrian

Hi Adrian,

I wanted to make similar changes to madwifi some years ago, and as there
was no standard I invented one.
This likely won't align with your requirements, but share some details
below in case it may help.

The approach I took was that the ieee channel numbers should overlap for
the different frequency bands, as there are a huge number of different
channels once you include all bands + 5, 10, 20, (and maybe 40) channel
widths (not such a big deal since no manufacturers seem to offer a radio
that supports more than one of the lower frequency bands on one board).
This way the 20MHz channel numbers were unchanged for all bands (as they
report as 2.4GHz band anyway), and the 5 and 10 MHz widths I mapped
above channel 14 using mapgsm() and ath_hal_mhz2ieee(), plus other
additions like unmapgsm, etc.
To cut a long story short I ended up with channels 1-14 for 20MHz, 21-34
for 5MHz, and 41-54 for 10MHz.



