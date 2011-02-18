Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54065 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1BRWVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:21:46 -0500
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
In-Reply-To: <1298032787.25739.2.camel@dev.znau.edu.ua> (sfid-20110218_134828_009719_FFFFFFFFC55A831E)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 <4D5DDCBC.2050501@broadcom.com> <1298014793.28946.39.camel@dev.znau.edu.ua>
	 (sfid-20110218_084826_360002_FFFFFFFF9D44E835)  <1298030032.22193.1.camel@maggie>
	 <1298032787.25739.2.camel@dev.znau.edu.ua>
	 (sfid-20110218_134828_009719_FFFFFFFFC55A831E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 23:21:39 +0100
Message-ID: <1298067699.23801.9.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 14:39 +0200, George Kashperko wrote: 
> Does this mean RFC subject in its current state is rejected ?

I am not in charge to reject anything.

But I just noticed that you sent the patches to the list. So I'll
have a look at it. You should improve your CC lists in general
for all your mails. Most of us don't have the time to read all
mail on the list, so it's always a good idea to maintain a CC list
of people who already commented on the RFC for patch submissions.

> > So I'm supporting Henry in that SSB is legacy and EOL. Let's simply
> > start over and don't carry old cruft over.
> > 
> > Note that this does not mean that we need to duplicate the MIPS,
> > common and probably pci core drivers. A hybrid module can be done,
> > if that's desired to avoid code duplication.
> Well, any plans or even maybe ETA on this ?

No.

> > And I also think that you're worrying _way_ too much about a few
> > if/else statements in the drivers. (Look at the TMSLOW discussion).
> > The SSB/AI->driver interface is trivial and tiny. There will be maybe
> > 10 if/else statements. It's really _not_ worth introducing major
> > abstraction code in the SSB and AI code to avoid a few if/else
> > statements in the drivers.
> > The bulk of the SSB->driver interface _is_ already abstracted inside
> > of the drivers (b43_read/write...). The rest is negligible.
> Well, not like I really worry alot about those if/elses :)
> Just in this particular case of SSB in its current design I don't really
> see much differences in where bus implementation-specific management
> must be abstracted if only AI support over SSB is implemented. If there
> will be just b43 relying on such an abstraction then no doubt lets do it
> in b43 driver. But its not.

You should also look into the future.
I don't know what broadcom's plans are, but a rough guess would be
that AI will diverge more and more from SSB, so that more and more
hacks will be needed.
So I'm in favor of making a clean cut.

-- 
Greetings Michael.

