Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47348 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZIHTHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 15:07:47 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Ml62f-0003hB-7s
	for linux-wireless@vger.kernel.org; Tue, 08 Sep 2009 21:07:49 +0200
Received: from cac94-1-81-57-151-96.fbx.proxad.net ([81.57.151.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 21:07:49 +0200
Received: from castet.matthieu by cac94-1-81-57-151-96.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 21:07:49 +0200
To: linux-wireless@vger.kernel.org
From: matthieu castet <castet.matthieu@free.fr>
Subject: Re: Stop using tasklets for bottom halves
Date: Tue, 8 Sep 2009 19:07:32 +0000 (UTC)
Message-ID: <loom.20090908T210153-638@post.gmane.org>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com> <20090907171406.6a4b6116@nehalam> <1252376254.21261.2052.camel@gandalf.stny.rr.com> <200909080650.43181.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@...> writes:
> 
> I recently converted the b43 driver to threaded interrupt handlers and
> a workqueue based TX mechanism. (My motivation was porting b43 to the SDIO bus
that
> needs to sleep, so requires process context).
Well you can do busy wait : for sending small sd command, the overhead of
sleep ( context switch) can be bigger than the sleep.

> 
> I think there's no real reason for process context being slow in general. It's
just that
> we have additional context switches. But these are fast on Linux.
> 
It depends of architecture. For example on older arm (armv5) context switch can
be slow (need tlb and cache flush). It is not really true for kernel thread that
keeps the same mmu mapping and don't need all those flush, but there still a
visible performance hit.


Matthieu



