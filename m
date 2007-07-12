Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXGLW1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 18:27:38 -0400
Date: Thu, 12 Jul 2007 15:25:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070712152556.299e9913.akpm@linux-foundation.org>
In-Reply-To: <200707130010.58338.mb@bu3sch.de>
References: <20070712085432.528319000@bu3sch.de>
	<200707122342.27164.mb@bu3sch.de>
	<20070712145347.ab861215.akpm@linux-foundation.org>
	<200707130010.58338.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 13 Jul 2007 00:10:58 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> > So the principle of least surprise tells us "this shouldn't be called
> > assert()".
> 
> Well, I do know that userspace assert() terminates the program.
> But, in the kernel we use BUG() for this.
> So let's better rename BUG() to assert() ;)
> No just kidding.
> IMO the word "assert" is short and to the point what this code
> is actually doing. It asserts that a condition is true and
> complains otherwise.
> 
> Let's make a deal, Andrew.
> As I almost always do assert(0), I will remove the assert() macro
> and introduce a macro SSB_CAN_NOT_REACH() or something like that
> to mark codepaths that can not be reached.
> I'll replace the rest of the assert()s that check an actual condition
> with WARN_ON.
> OK?

I don't understand all the fuss.

When I looked at that code I assumed that your assert() implementation
would be a wrapper of some from around a BUG().  But it wasn't.

A suitable way of preventing others from being similarly surprised would be
to call it something other than assert().  That's all.
