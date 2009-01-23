Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52482 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbZAWTeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:34:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:33:28 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <200901231902.06336.mb@bu3sch.de> <82AB87FD-0247-4049-AA3D-309C3C1539FF@ing.unibs.it>
In-Reply-To: <82AB87FD-0247-4049-AA3D-309C3C1539FF@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901232033.28470.mb@bu3sch.de> (sfid-20090123_203429_052005_2C559783)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 20:18:52 Francesco Gringoli wrote:
> > Nothing. Why do we need to have different names?
> Well, I was only considering a question raised by John, we can surely  
> maintain these names.

I guess I missed that. What was the question?
Note that proprietary and open firmwares are in separate directories, so
I don't see why we should rename them.
Renaming firmware is a huge pain. We did it several times in the past and
I really want to avoid it. It creates a major confusion for users for some months.

> >> - detection of the opensource firmware capabilities: are you really
> >> sure we cannot use a shm location that the bcm proprietary firmware
> >> uses for some other purpose?
> >
> > Yes, well. You're not intermixing an earlier discussion into this,  
> > where
> > you didn't indicate opensource capabilities to the kernel.
> > If you indicate OS capabilities, you can use whatever offset you  
> > want, of course.
> Excellent. We will modify the firmware accordingly and encode the  
> options.

Thanks. Would be nice if you could also do the corresponding driver patch.

> >> - what to do with rts procedure: we can implement this feature easily
> >> but I'm not sure about the value it can add to people (the majority  
> >> of
> >> users?) that use the bcm board in station mode. This is different for
> >> those who run a bcm card in AP mode, but we can clearly discourage
> >> them to run this firmware in AP mode if  not sure about rts usage by
> >> stations. However, we put this task in the todo list.
> >
> > RTS/CTS is not specific to AP mode. It's used on any station in the  
> > BSS.
> > See IEEE 802.11 specs.
> Yes, in fact we put this task in the todo list.

Thanks.

> >> - tx header layout: the opensource firmware is now using the old
> >> memory layout in the tx header (<351). Do you think switching to 410
> >> format is mandatory now or we can concentrate on the other tasks?
> >
> > Yes, the old format is deprecated and will be removed soon.
> Ok, first task in the todo list!

Well, doesn't need to the the first one. Just note that support for this is
scheduled to be removed in summer 2008. So if any problems show up (broadcom
releases yet another API, for example), I will immediately remove it.

> Ok, thanks for the hint. I will check,

There are a few things we're not yet sure about.
For example the operand for the GPR number got an additional bit.
But we're not sure if the real number of GPRs also was doubled in the hardware.
There are a few FIXMEs in the code for this...
I think this simply has to be tested by trial and error.

-- 
Greetings, Michael.
