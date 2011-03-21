Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:34649 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1CULF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 07:05:28 -0400
Date: Mon, 21 Mar 2011 12:05:22 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Dividing by a non-static value in carl9170-fw?
Message-ID: <20110321110522.GA26382@zenon.in.qult.net>
References: <20110116031600.GA21973@zenon.in.qult.net>
 <201103190303.07310.chunkeey@googlemail.com>
 <20110319092237.GA19163@zenon.in.qult.net>
 <201103191643.46628.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201103191643.46628.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2011 at 04:43:46PM +0100, thus spake Christian Lamparter:
> On Saturday 19 March 2011 10:22:37 Ignacy Gawedzki wrote:
> > As a rule of thumb, I remembered that "volatile" tells the compiler "you're
> > not the only one to manage that variable, don't make any assumptions about its
> > current value", as could be the case if the variable is allocated in some
> > shared memory segment/register/whatever and might change "on its own".
> > Anyway, in the case at hand, it seems to make a difference.
> 
> why not give it a try ;). define a and b as global variables, initialize them
> and try if a/b needs __udiv or not. you'll be surprised that no c-compiler
> (unless a buggy one) will even think about this sort of "constant"
> optimization.

I almost forgot to reply to this one.  Of course you were right and optimizing
globals in this way doesn't make sense anyway.  After noticing the unexpected
behavior, I disassembled the object file and saw that the result of the
division was used as an immediate value.  Eventually, after this round of
email exchange, I realized that it was all due to my globals being declared as
"static", just for the sake of uniformity with other globals already there. =)
When globals' scope is limited to the compilation unit, the compiler may
optimize things out.

> OT: the use of volatile is ill-reputed and many people have complained
> about it throughout the history.
> http://lwn.net/Articles/233482/ [which ended up in:]
> http://kernel.org/doc/Documentation/volatile-considered-harmful.txt
> 
> the only reason why we get away with it is because most of
> it is locked up behind accessor functions in include/io.h & dma.h
> and it should remain that way.
> 
> > BTW, it seems you have some detailed technical documentation about the AR9170
> > at your disposal.  I was wondering whether this is something available
> > publicly or not.  Could be an interesting read at times. =)
> There are a lot of easy accessible docs about the CPU on the net. In fact you
> can even get Verilog/VHDL code of various SH2-clones without any problem.
> But that's about it, for information about the MAC/USB I have to rely on
> Chen.

I see.

Thanks again.

Ignacy

-- 
NO CARRIER
