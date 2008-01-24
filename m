Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYAXU1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 15:27:51 -0500
Date: Thu, 24 Jan 2008 12:27:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801081630.31110.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org> (sfid-20080124_202755_066317_7467C072)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda> <200801081630.31110.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 8 Jan 2008, Michael Buesch wrote:
> > >
> > > Can you check if that is the
> > > WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> > > in rx.c line 1486?
> 
> Yes fine.
> Patches are on their way. Ignore the warning for now. It is harmless.

I don't think this ever got fixed. 

I don't see any alternative but just uncomment that bogus warning, because 
it's otherwise going to just cause way more noise than it's worth. It's 
apparently known to developers, and as such it's worthless in the source 
code except as a way to make poor users worry.

It's been in the top oops/warnings report for the last three weeks, and I 
haven't gotten any patches for it, so I'm a bit grumpy. What's the point 
of having a WARN_ON() if nobody involved *does* anything about it?

		Linus
