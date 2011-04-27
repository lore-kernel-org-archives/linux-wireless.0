Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49611 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab1D0Vh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 17:37:57 -0400
Subject: Re: [PATCH] ssb: cc: prepare clockmode support for cores rev 10+
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <BANLkTikJj4vA6obyCkqwsiG+Ha7aOnz=SQ@mail.gmail.com>
References: <1303918811-4949-1-git-send-email-zajec5@gmail.com>
	 <1303936862.7373.5.camel@Nokia-N900>
	 <BANLkTikJj4vA6obyCkqwsiG+Ha7aOnz=SQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 23:37:49 +0200
Message-ID: <1303940269.31395.6.camel@maggie> (sfid-20110427_233801_363123_A15CECDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-27 at 22:52 +0200, Rafał Miłecki wrote: 
> 2011/4/27 Michael Büsch <m@bues.ch>:
> >> +            /* udelay(150); TODO: not available in early init */
> >
> > udelay() should be available at this point. Are you confusing it with
> > msleep(), which is not available that early?
> 
> I had no idea about this difference, thanks.
> 
> However I still think about initializing ChipCommon later, to let it
> *sleep* and no to delay boot process. Should this be fine? Or are
> there some important reasons to init ChipCommon early?

I don't think it matters it all, if the boot process takes
150 microseconds longer or not. So I'd rather not change it for
no good reason.
This new 0.00015 seconds (150 us) delay in chipcommon seems perfectly
fine.

Even a few MMIO bus accesses will take longer than this tiny delay.
And there are thousands of MMIO accesses on bootup.
So it will hardly be measureable.

-- 
Greetings Michael.

