Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:55964 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab1CSJWl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 05:22:41 -0400
Date: Sat, 19 Mar 2011 10:22:37 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Dividing by a non-static value in carl9170-fw?
Message-ID: <20110319092237.GA19163@zenon.in.qult.net>
References: <20110116031600.GA21973@zenon.in.qult.net>
 <201103190143.27042.chunkeey@googlemail.com>
 <20110319012244.GA4157@zenon.in.qult.net>
 <201103190303.07310.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201103190303.07310.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2011 at 03:03:06AM +0100, thus spake Christian Lamparter:
> On Saturday 19 March 2011 02:22:44 Ignacy Gawedzki wrote:
> > I suppose in your case the values are known at compile time and the compiler
> > does the calculation statically.
> sometimes its just down to "luck" ;)
> 
> > If you define the global variables as volatile, then the optimization is
> > forbidden and you should get the bogus results.
> 
> ???
> No, "global" is enough. As long as you don't select "const".
> (In fact there's more of a story behind "const volatile"
> than you might think, or have you ever wondered why carl9170
> still ships with gcc 4.4 instead of 4.5? Anyway that's OT)

As a rule of thumb, I remembered that "volatile" tells the compiler "you're
not the only one to manage that variable, don't make any assumptions about its
current value", as could be the case if the variable is allocated in some
shared memory segment/register/whatever and might change "on its own".

Anyway, in the case at hand, it seems to make a difference.

> > BTW, I used udivsi3_i4i.S from the Linux kernel, modified it as you indicated.
> > Please find my version attached.
> You are right, I can reproduce your problem with the attached udiv.
> The crux is seems to be "hidden" inside the kernel's Makefile:
> 
> >udivsi3-y                       := udivsi3_i4i-Os.o
> >
> >ifneq ($(CONFIG_CC_OPTIMIZE_FOR_SIZE),y)
> >udivsi3-$(CONFIG_CPU_SH3)       := udivsi3_i4i.o
> >udivsi3-$(CONFIG_CPU_SH4)       := udivsi3_i4i.o
> >endif
> 
> It looks like the version you are using is "made" for SH3+,
> however the AR9170 has a SH2. (Jup, I can't believe it either :-D)

Ahaaa.  Thanks for your help.  It works much better now.

BTW, it seems you have some detailed technical documentation about the AR9170
at your disposal.  I was wondering whether this is something available
publicly or not.  Could be an interesting read at times. =)

Regards,

Ignacy

-- 
Everything is more fun naked except cooking with grease.
