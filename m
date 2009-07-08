Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40714 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754794AbZGHIqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 04:46:30 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1247022413.4755.56.camel@johannes.local>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
	 <1247022413.4755.56.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 09:46:24 +0100
Message-Id: <1247042784.6595.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-08 at 05:06 +0200, Johannes Berg wrote:
> On Tue, 2009-07-07 at 18:04 +0100, Catalin Marinas wrote:
> > Hi,
> > 
> > I'm investigating several kmemleak reports like the one below (it could
> > as well be a false positive but it needs more digging):
> 
> By the way, what kind of machine do you need for kmemleak to be
> feasible? I tried booting a kernel with it in kvm on my 2 ghz laptop,
> and that was completely unfeasible.

What do you mean by unfeasible?

There are some patches in my kmemleak branch which I'll push upstream
again (important ones are the renicing of the kmemleak thread and a few
more cond_resched calls):

http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak

There are 3 more patches under discussion to track the bootmem
allocations (which dropped the number of false positives to 0 on my
laptop).

Anyway, I run it from some ARM embedded systems at ~200MHz and 256MB of
RAM to dual core x86 at 2GHz with 3GB of RAM. I also ran it on quemu in
the past (but, well, in the embedded world I'm pretty used with
emulators taking 10 min to boot the kernel).

But it can slow things down since it tracks every memory allocation and
it needs to look up the pointer in an rb tree.

-- 
Catalin

