Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1CSQLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 12:11:47 -0400
Received: by bwz15 with SMTP id 15so4094523bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 09:11:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: Dividing by a non-static value in carl9170-fw?
Date: Sat, 19 Mar 2011 16:43:46 +0100
Cc: linux-wireless@vger.kernel.org
References: <20110116031600.GA21973@zenon.in.qult.net> <201103190303.07310.chunkeey@googlemail.com> <20110319092237.GA19163@zenon.in.qult.net>
In-Reply-To: <20110319092237.GA19163@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103191643.46628.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 March 2011 10:22:37 Ignacy Gawedzki wrote:
> On Sat, Mar 19, 2011 at 03:03:06AM +0100, thus spake Christian Lamparter:
> > On Saturday 19 March 2011 02:22:44 Ignacy Gawedzki wrote:
> > > If you define the global variables as volatile, then the optimization is
> > > forbidden and you should get the bogus results.
> > 
> > ???
> > No, "global" is enough. As long as you don't select "const".
> > (In fact there's more of a story behind "const volatile"
> > than you might think, or have you ever wondered why carl9170
> > still ships with gcc 4.4 instead of 4.5? Anyway that's OT)
> 
> As a rule of thumb, I remembered that "volatile" tells the compiler "you're
> not the only one to manage that variable, don't make any assumptions about its
> current value", as could be the case if the variable is allocated in some
> shared memory segment/register/whatever and might change "on its own".
> Anyway, in the case at hand, it seems to make a difference.

why not give it a try ;). define a and b as global variables, initialize them
and try if a/b needs __udiv or not. you'll be surprised that no c-compiler
(unless a buggy one) will even think about this sort of "constant"
optimization.

OT: the use of volatile is ill-reputed and many people have complained
about it throughout the history.
http://lwn.net/Articles/233482/ [which ended up in:]
http://kernel.org/doc/Documentation/volatile-considered-harmful.txt

the only reason why we get away with it is because most of
it is locked up behind accessor functions in include/io.h & dma.h
and it should remain that way.

> BTW, it seems you have some detailed technical documentation about the AR9170
> at your disposal.  I was wondering whether this is something available
> publicly or not.  Could be an interesting read at times. =)
There are a lot of easy accessible docs about the CPU on the net. In fact you
can even get Verilog/VHDL code of various SH2-clones without any problem.
But that's about it, for information about the MAC/USB I have to rely on
Chen.

Best regards,
	Christian
