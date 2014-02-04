Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:46999 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754505AbaBDTnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 14:43:50 -0500
Message-ID: <1391543026.2538.28.camel@joe-AO722> (sfid-20140204_204354_071168_1B3CABEF)
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Fix build error on ARM
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Holger Schurig <holgerschurig@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Date: Tue, 04 Feb 2014 11:43:46 -0800
In-Reply-To: <3469296.SINb5BZOG8@wuerfel>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	 <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com>
	 <1391531796.2538.21.camel@joe-AO722> <3469296.SINb5BZOG8@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 19:40 +0100, Arnd Bergmann wrote:
> On Tuesday 04 February 2014 08:36:36 Joe Perches wrote:
> > On Tue, 2014-02-04 at 08:03 +0100, Holger Schurig wrote:
> > > Joe, look in linux/arch/arm/include/asm/delay.h. The macro udelay
> > > cannot handle large values because of lost-of-precision.
> > > 
> > > IMHO udelay on ARM is broken, because it also cannot work with fast
> > > ARM processors (where bogomips >= 3355, which is in sight now). It's
> > > just not broken enought that someone did something against it ...   so
> > > the current kludge is good enought.
> > 
> > Maybe something like this would be better?
> > 
> 
> I actually like the fact that we get link errors for insane 'udelay'
> times.

For static values yes, for computed values no.

This emits a warning/dump_stack on the non-static
values.  It could also emit some similar #warning
on static values > insane too.



