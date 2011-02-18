Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:35192 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1BRLym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 06:54:42 -0500
Subject: Re: [RFC] AI support
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
In-Reply-To: <1298014793.28946.39.camel@dev.znau.edu.ua> (sfid-20110218_084826_360002_FFFFFFFF9D44E835)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 <4D5DDCBC.2050501@broadcom.com> <1298014793.28946.39.camel@dev.znau.edu.ua>
	 (sfid-20110218_084826_360002_FFFFFFFF9D44E835)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 12:53:51 +0100
Message-ID: <1298030032.22193.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 09:39 +0200, George Kashperko wrote: 
> > This just reinforces what Michael said about name confusion.
> > 
> > Michael's proposal of separating SSB and AXI, and decoupling the device 
> > drivers from the bus routines, is going to be much more maintainable in 
> > the long run.  AXI is going to be far more widespread than SSB ever was, 
> > and it would be really unfortunate if we carry the SSB baggage forward.
> > 
> > I've been poking around at disentangling the sb and ai routines in 
> > drivers/staging/brcm80211/utils/{aiutils,sbutils,siutils}.c.  I don't 
> > have anything to put out for comments yet, but it's enough to convince 
> > me that it's the right direction.

> Yes, AI, lets say, over SBB, makes some confusion and this confusion
> could be avoided with separate SSB/AI bus drivers but in current SSB
> design state its 99% of copy-pasting SSB code with changing nothing
> other than &ops pointers and ssb_ prefixes with something like bcmai_ or
> similar which honestly makes no sense to me considering than the goal is
> to <avoid confusion>. Pretty much sure there will be even more confusion
> than before.

There are plenty of examples in the kernel where code was simply forked
for the development of a new technology. Look at b43/b43legacy or
ext2/3/4 just for a few examples. The forks were made on purpose
to avoid maintainability nightmares. Yes, at first sight, some code had
to be duplicated. But I don't see that as an issue. The two codebases
will diverge quickly from each other as development is done.

So I'm supporting Henry in that SSB is legacy and EOL. Let's simply
start over and don't carry old cruft over.

Note that this does not mean that we need to duplicate the MIPS,
common and probably pci core drivers. A hybrid module can be done,
if that's desired to avoid code duplication.

And I also think that you're worrying _way_ too much about a few
if/else statements in the drivers. (Look at the TMSLOW discussion).
The SSB/AI->driver interface is trivial and tiny. There will be maybe
10 if/else statements. It's really _not_ worth introducing major
abstraction code in the SSB and AI code to avoid a few if/else
statements in the drivers.
The bulk of the SSB->driver interface _is_ already abstracted inside
of the drivers (b43_read/write...). The rest is negligible.

And if it turns out _afterwards_ that we could avoid a few if/else
statements by introducing some additional abstraction layer, this
thing can be introduced _afterwards_.

PS: Could you please stop stripping the CC list.

-- 
Greetings Michael.


