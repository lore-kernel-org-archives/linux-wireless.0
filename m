Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55046 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYAYWRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 17:17:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 23:15:09 +0100
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801252221.07558.mb@bu3sch.de> <20080125214626.GG14687@tuxdriver.com>
In-Reply-To: <20080125214626.GG14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801252315.10112.mb@bu3sch.de> (sfid-20080125_221743_584512_DEF8AADC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 22:46:26 John W. Linville wrote:
> On Fri, Jan 25, 2008 at 10:21:07PM +0100, Michael Buesch wrote:
> > On Friday 25 January 2008 22:11:44 Inaky Perez-Gonzalez wrote:
> > > On Friday 25 January 2008, Michael Buesch wrote:
> > > > On Friday 25 January 2008 19:34:46 Linus Torvalds wrote:
> > > > > My attitude is: CPU's that do unaligned accesses right are the *good* 
> > > > > CPU's. We should encourage them, and put the onus of being crap on the 
> > > > > ones that are crap, rather than penalizing the ones that aren't.
> > > > 
> > > > I absolutely agree. But as this can get fixed with _no_ performance loss
> > > > at all inside of the firmware (and who if not intel can change stuff
> > > > in their firmware?), I think this warning is in fact valid.
> > > 
> > > Well, you forgot the point that maybe it is not that simple to get such
> > > a seemingly simple change into the firmware for a long list of reasons.
> > 
> > The reasons being?
> 
> Firmware certification is expensive.
> 
> Plus it is a bit unfair to ask for firmware changes just because the
> vendor is actually engaged with us.  If this were Broadcom or Zydas
> firmware we would have little recourse other than to accept it or
> fix it in the driver or stack.

Well, we could patch broadcom's firmware ;)

But anyway.
So what about removing the WARN_ON() and replacing it by
a conditional memmove then?
I mean, the wireless hardware I care about already is sane or fixed.
So if intel doesn't want to support this kind of machines, I'd say in
the end it is OK and we should not care about it at all. I mean, nobody
is forced to buy an intel card to use on such a machine.

I must say I don't care much about intel's customers that want to run
intel wireless in a machine that can't do unaligned access, if intel itself
doesn't care at all about them. In the end it is _intel's_ performance
problem and not ours.

The problem with that is that the warning goes away and _future_ drivers
will probably run into this performance problem and don't know about.

-- 
Greetings Michael.
