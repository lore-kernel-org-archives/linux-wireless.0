Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab0LGVPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:15:12 -0500
Date: Tue, 7 Dec 2010 16:01:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, pstew@google.com, stable@kernel.org
Subject: Re: [PATCH 2/3] ath9k: Fix power save count imbalance on
 ath_radio_enable()
Message-ID: <20101207210130.GM2700@tuxdriver.com>
References: <1291425653-2884-1-git-send-email-lrodriguez@atheros.com>
 <1291425653-2884-3-git-send-email-lrodriguez@atheros.com>
 <AANLkTimd5ZKCWjDaVQcqx9t=_zoJC+UC5_4nkRQ-Uq8R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimd5ZKCWjDaVQcqx9t=_zoJC+UC5_4nkRQ-Uq8R@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 05:34:08PM -0800, Luis R. Rodriguez wrote:
> On Fri, Dec 3, 2010 at 5:20 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > Upon a failure we never call ath9k_ps_restore() on ath_radio_enable(),
> > this will throw off the sc->ps_usecount. When the sc->ps_usecount
> > is > 0 we never put the chip to full sleep. This drains battery,
> > and will also make the chip fail upon resume with:
> >
> > ath: Starting driver with initial channel: 5745 MHz
> > ath: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
> >
> > This would make the chip useless upon resume.
> >
> > I cannot prove this can happen but in theory it is so best to
> > avoid this race completely and not have users complain about
> > a broken device after resume.
> >
> > Cc: stable@kernel.org
> > Cc: Paul Stewart <pstew@google.com>
> > Cc: Amod Bodas <amod.bodas@atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> John, this one is for you, sorry I failed to send it to you. And
> Johannes, sorry, I forgot to remove you from my send script :)

So, this is for 2.6.37?  FWIW, it was the only PATCH in a series
of RFCs...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
