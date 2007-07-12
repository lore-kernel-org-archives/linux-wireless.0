Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38128
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757778AbXGLWLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 18:11:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Date: Fri, 13 Jul 2007 00:10:58 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
References: <20070712085432.528319000@bu3sch.de> <200707122342.27164.mb@bu3sch.de> <20070712145347.ab861215.akpm@linux-foundation.org>
In-Reply-To: <20070712145347.ab861215.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707130010.58338.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 July 2007 23:53, Andrew Morton wrote:
> On Thu, 12 Jul 2007 23:42:26 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > > +#define assert(cond)	do {						\
> > > > +	if (unlikely(!(cond))) {					\
> > > > +		ssb_dprintk(KERN_ERR PFX "BUG: Assertion failed (%s) "	\
> > > > +			    "at: %s:%d:%s()\n",				\
> > > > +			    #cond, __FILE__, __LINE__, __func__);	\
> > > > +	}								\
> > > > +		       } while (0)
> > > 
> > > Odd.  One would normally expect an assert() to terminate execution in some
> > > fashion if it fails.  In-kernel that means BUG.  But this assert() just
> > > whines and continues.
> > 
> > An assertion failure is not a fatal bug, so we continue execution.
> > We do the same in bcm43xx and I really think we mustn't BUG on an
> > assertion failure, as people would already have killed me.
> > Additionally to that, I insert really lots of assert()s into the code.
> > I don't want all these to be WARN_ONs or BUGs, as it would bloat the
> > kernel a lot. In the places where I want runtime checks in nondebug
> > builds, I already use WARN_ON.
> 
> Do `man 3 assert'.  The reader of your code will expect that an assert()
> will "terminate the program" (or the kernel equivalent) if the assertion
> fails.
> 
> So the principle of least surprise tells us "this shouldn't be called
> assert()".

Well, I do know that userspace assert() terminates the program.
But, in the kernel we use BUG() for this.
So let's better rename BUG() to assert() ;)
No just kidding.
IMO the word "assert" is short and to the point what this code
is actually doing. It asserts that a condition is true and
complains otherwise.

Let's make a deal, Andrew.
As I almost always do assert(0), I will remove the assert() macro
and introduce a macro SSB_CAN_NOT_REACH() or something like that
to mark codepaths that can not be reached.
I'll replace the rest of the assert()s that check an actual condition
with WARN_ON.
OK?
