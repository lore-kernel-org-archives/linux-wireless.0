Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbXGLVzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 17:55:20 -0400
Date: Thu, 12 Jul 2007 14:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070712145347.ab861215.akpm@linux-foundation.org>
In-Reply-To: <200707122342.27164.mb@bu3sch.de>
References: <20070712085432.528319000@bu3sch.de>
	<20070712085744.604965000@bu3sch.de>
	<20070712112732.f7373a33.akpm@linux-foundation.org>
	<200707122342.27164.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2007 23:42:26 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > > +#define assert(cond)	do {						\
> > > +	if (unlikely(!(cond))) {					\
> > > +		ssb_dprintk(KERN_ERR PFX "BUG: Assertion failed (%s) "	\
> > > +			    "at: %s:%d:%s()\n",				\
> > > +			    #cond, __FILE__, __LINE__, __func__);	\
> > > +	}								\
> > > +		       } while (0)
> > 
> > Odd.  One would normally expect an assert() to terminate execution in some
> > fashion if it fails.  In-kernel that means BUG.  But this assert() just
> > whines and continues.
> 
> An assertion failure is not a fatal bug, so we continue execution.
> We do the same in bcm43xx and I really think we mustn't BUG on an
> assertion failure, as people would already have killed me.
> Additionally to that, I insert really lots of assert()s into the code.
> I don't want all these to be WARN_ONs or BUGs, as it would bloat the
> kernel a lot. In the places where I want runtime checks in nondebug
> builds, I already use WARN_ON.

Do `man 3 assert'.  The reader of your code will expect that an assert()
will "terminate the program" (or the kernel equivalent) if the assertion
fails.

So the principle of least surprise tells us "this shouldn't be called
assert()".
