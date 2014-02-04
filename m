Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaBDSkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 13:40:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Joe Perches <joe@perches.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Fix build error on ARM
Date: Tue, 04 Feb 2014 19:40:18 +0100
Message-ID: <3469296.SINb5BZOG8@wuerfel> (sfid-20140204_194035_071616_E8973866)
In-Reply-To: <1391531796.2538.21.camel@joe-AO722>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org> <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com> <1391531796.2538.21.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 February 2014 08:36:36 Joe Perches wrote:
> On Tue, 2014-02-04 at 08:03 +0100, Holger Schurig wrote:
> > Joe, look in linux/arch/arm/include/asm/delay.h. The macro udelay
> > cannot handle large values because of lost-of-precision.
> > 
> > IMHO udelay on ARM is broken, because it also cannot work with fast
> > ARM processors (where bogomips >= 3355, which is in sight now). It's
> > just not broken enought that someone did something against it ...   so
> > the current kludge is good enought.
> 
> Maybe something like this would be better?
> 

I actually like the fact that we get link errors for insane 'udelay'
times. In most cases it's a driver bug because we shouldn't keep
the CPU busy for an eternity in the kernel (and call msleep() instead).
For the rare cases where mdelay makes sense, we also want to add
a comment to the code explaining why msleep cannot be used.

	Arnd
