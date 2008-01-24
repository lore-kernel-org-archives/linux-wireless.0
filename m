Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41197 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYAXWTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 17:19:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Thu, 24 Jan 2008 23:17:50 +0100
Cc: linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801081630.31110.mb@bu3sch.de> <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801242317.50948.mb@bu3sch.de> (sfid-20080124_221917_702676_EEDAB18D)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 21:27:03 Linus Torvalds wrote:
> 
> On Tue, 8 Jan 2008, Michael Buesch wrote:
> > > >
> > > > Can you check if that is the
> > > > WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> > > > in rx.c line 1486?
> > 
> > Yes fine.
> > Patches are on their way. Ignore the warning for now. It is harmless.
> 
> I don't think this ever got fixed. 

This was fixed in the drivers. A fix for zd1211rw got in and for
the RTL wireless drivers. Did any other driver trigger this warning?

> I don't see any alternative but just uncomment that bogus warning, because 
> it's otherwise going to just cause way more noise than it's worth. It's 
> apparently known to developers, and as such it's worthless in the source 
> code except as a way to make poor users worry.
> 
> It's been in the top oops/warnings report for the last three weeks, and I 
> haven't gotten any patches for it, so I'm a bit grumpy. What's the point 
> of having a WARN_ON() if nobody involved *does* anything about it?

It was already fixed before this bugreport, in this mail thread
you are replying to, was sent.
We do have a long maintainers chain for wireless
driver developers -> john linville -> netdev -> you
So it can cause some delay sometimes, but I'm pretty sure the fixes
should have hit mainline by now. I can recheck that if you desire.

-- 
Greetings Michael.
