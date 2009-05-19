Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37446 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZESQim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 12:38:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 09:38:44 -0700
Date: Tue, 19 May 2009 09:38:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: prevent infinite loop
Message-ID: <20090519163847.GA7428@tesla>
References: <alpine.DEB.2.00.0905182011270.7956@gandalf.stny.rr.com> <40f31dec0905181734t6a3db7f4peb2d57c3aebe075b@mail.gmail.com> <alpine.DEB.2.00.0905182041470.7956@gandalf.stny.rr.com> <40f31dec0905182332v49aff368oe485efaa56fbc11a@mail.gmail.com> <43e72e890905182339u68c4d4f5v3a2f25e9e3547e60@mail.gmail.com> <alpine.DEB.2.00.0905190743070.1767@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.0905190743070.1767@gandalf.stny.rr.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 04:45:14AM -0700, Steven Rostedt wrote:
> 
> On Mon, 18 May 2009, Luis R. Rodriguez wrote:
> 
> > On Mon, May 18, 2009 at 11:32 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > > 2009/5/19 Steven Rostedt <rostedt@goodmis.org>:
> > >>
> > >> On Tue, 19 May 2009, Nick Kossifidis wrote:
> > >>>
> > >>> This is already fixed on wireless-testing ;-)
> > >>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/phy.c;h=d0d1c350025aebba1fe4e17a44550536a59951ba;hb=HEAD
> > >>
> > >> Thanks, but this does only half. Although I did not hit this in my laptop,
> > >> it can be an issue. If step[0] == step[1] you have the same problem.
> > >>
> > >
> > > Having the same power value for 2 different steps is something we can
> > > expect (although docs say that we expect the line to be monotonically
> > > increasing but anyway), having the same step twice is way out of spec,
> > > there is no way we can have the same step twice on EEPROM, only if we
> > > have a corrupted EEPROM (we need to add some sanity checks indeed here
> > > -> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/ath/ath5k/eeprom.c;h=c56b494d417acd40d445d922f2861b53cc2315df;hb=HEAD#l910
> > > to handle such a case but first we need to have a "default" eeprom
> > > dataset to fallback when we get such errors).
> >
> > Don't bother with busted EEPROMs, if its busted its busted. Chances
> > are the complexity we'd need to add to deal with such devices is
> > simply not worth it.
> 
> My concern is that a busted EEPROM should not lock up the kernel, when we
> can avoid it.

Sure, which is why there is a checksum which can be checked first.
IIRC we don't bail out if that fails in ath5k.

> Put in a nasty WARN_ON if the steps are equal, and exit the
> routine. But don't let it go into an infinite loop and have the user
> wondering why their system just locked up.

Sure, my point was more for not implemention a default EEPROM
as that would bring more complexity to the driver.

  Luis

