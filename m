Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:35678 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750723AbaBEMcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 07:32:50 -0500
Message-ID: <1391603566.2538.63.camel@joe-AO722> (sfid-20140205_133317_223890_6A8E43B3)
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Fix build error on ARM
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Date: Wed, 05 Feb 2014 04:32:46 -0800
In-Reply-To: <20140205115035.GO26684@n2100.arm.linux.org.uk>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	 <1391483274-20331-2-git-send-email-sujith@msujith.org>
	 <1391484878.2538.11.camel@joe-AO722>
	 <21232.24855.201543.400943@gargle.gargle.HOWL>
	 <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com>
	 <1391531796.2538.21.camel@joe-AO722>
	 <20140205115035.GO26684@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 11:50 +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 04, 2014 at 08:36:36AM -0800, Joe Perches wrote:
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
> 
> No, the point of __bad_udelay() is that people doing stupidly large
> udelay()s result in build errors,

Apparently, people just convert stupidly large udelay()s
to mdelay and not be bothered.

>  rather than having to run the kernel
> and trip over a non-existent debugging message beacuse they haven't
> built the kernel with DEBUG defined.
> 
> NAK.

<shrug>

Perhaps there should be some runtime udelay > maximum
supported check.

