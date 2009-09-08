Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60140 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZIHTMO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 15:12:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: Stop using tasklets for bottom halves
Date: Tue, 8 Sep 2009 21:12:05 +0200
Cc: linux-wireless@vger.kernel.org
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com> <200909080650.43181.mb@bu3sch.de> <loom.20090908T210153-638@post.gmane.org>
In-Reply-To: <loom.20090908T210153-638@post.gmane.org>
MIME-Version: 1.0
Message-Id: <200909082112.06572.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 September 2009 21:07:32 matthieu castet wrote:
> Michael Buesch <mb@...> writes:
> > 
> > I recently converted the b43 driver to threaded interrupt handlers and
> > a workqueue based TX mechanism. (My motivation was porting b43 to the SDIO bus
> that
> > needs to sleep, so requires process context).
> Well you can do busy wait : for sending small sd command, the overhead of
> sleep ( context switch) can be bigger than the sleep.

The bus is _really_ slow and we push the whole network load through it.
So we really don't want to busywait. It would effectively lockup the machine
on network traffic.

And besides that, the SDIO subsystem requires process context. I was not going
to rewrite that.

> It depends of architecture. For example on older arm (armv5) context switch can
> be slow (need tlb and cache flush). It is not really true for kernel thread that
> keeps the same mmu mapping and don't need all those flush,

Yeah, but that's what it is. A kernel thread.

> but there still a 
> visible performance hit.

That's the initial question. How big is it?

-- 
Greetings, Michael.
