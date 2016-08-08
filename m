Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.194]:63319 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbcHHPv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 11:51:27 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Arnd Bergmann' <arnd@arndb.de>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: 'Arvind Yadav' <arvind.yadav.cs@gmail.com>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"leoli@freescale.com" <leoli@freescale.com>,
	"qiang.zhao@freescale.com" <qiang.zhao@freescale.com>,
	"viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"scottwood@freescale.com" <scottwood@freescale.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>
Subject: RE: [5.3] ucc_geth: Fix to avoid IS_ERR_VALUE abuses and dead code
 on 64bit systems.
Date: Mon, 8 Aug 2016 15:49:22 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D5F50C532@AcuExch.aculab.com> (sfid-20160808_175134_305382_D26BC215)
References: <1470386442-7208-1-git-send-email-arvind.yadav.cs@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D5F50C493@AcuExch.aculab.com>
 <2862487.guU7g5Qkfj@wuerfel>
In-Reply-To: <2862487.guU7g5Qkfj@wuerfel>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arnd Bergmann
> Sent: 08 August 2016 16:13
> 
> On Monday, August 8, 2016 2:49:11 PM CEST David Laight wrote:
> >
> > > If qe_muram_alloc will return any error, Then IS_ERR_VALUE will always
> > > return 0. it'll not call ucc_fast_free for any failure. Inside 'if code'
> > > will be a dead code on 64bit. Even qe_muram_addr will return wrong
> > > virtual address. Which can cause an error.
> > >
> > >  kfree((void *)ugeth->tx_bd_ring_offset[i]);
> >
> > Erm, kfree() isn't the right function for things allocated by qe_muram_alloc().
> >
> > I still thing you need to stop this code using IS_ERR_VALUE() at all.
> 
> Those are two separate issues:
> 
> a) The ucc_geth driver mixing kmalloc() memory with muram, and assigning
>    the result to "u32" and "void __iomem *" variables, both of which
>    are wrong at least half of the time.
> 
> b) calling conventions of qe_muram_alloc() being defined in a way that
>    requires the use of IS_ERR_VALUE(), because '0' is a valid address
>    here.

Yep, it is all a big bag of worms...
'0' being valid is going to make tidying up after failure 'problematic'.

> The first one can be solved by updating the network driver, ideally
> by getting rid of the casts and using proper types and accessors,
> while the second would require updating all users of that interface.

It might be worth (at least as a compilation option) of embedding the
'muram offset' in a structure (passed and returned by value).

The compiler can then check that the driver code is never be looking
directly at the value.

For 'b' zero can be made invalid by changing the places where the
offset is added/subtracted.
It could even be used to offset the saved physical and virtual
addresses of the area - so not needing any extra code when the values
are converted to physical/virtual addresses.

	David

