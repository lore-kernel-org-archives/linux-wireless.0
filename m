Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33160 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758120AbZJHNTX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 09:19:23 -0400
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200910081509.05394.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1255001062.7500.1.camel@marge.simson.net>
	 <200910081509.05394.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 15:18:33 +0200
Message-Id: <1255007913.8381.23.camel@marge.simson.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-08 at 15:09 +0200, Frans Pop wrote:
> On Thursday 08 October 2009, Mike Galbraith wrote:
> > Care to try a patch?
> >
> > latencytop: only account on-runqueue wait time as being scheduler
> > latency.
> >
> > Latencytop was accounting uninterruptible and interruptible sleep time
> > up to 5ms, which is not the latency the user is looking for.  Account
> > time waiting on-runqueue instead.  Also add a clock update to
> > update_curr() for the case where there's nobody home.  When coming out
> > of idle with NO_HZ, not updating the clock leads to bogus max latency
> > report.
> 
> With this patch the high values for iwlagn and phy0 are gone. The values 
> now match roughly with the output of your script.
> 
> If (un)interruptible sleep is worth displaying in latencytop then maybe it 
> should be identified as a separate cause instead of lumped under "waiting 
> for CPU"?

That's what I was just thing about trying, add a cause sleep.

> > TODO: Figure out where the heck empty braces come from.
> 
> I also see these lines with "[]" sometimes; looks to come from 'sleep'.
> 
> And I still see lines with only a "." as the cause; this seems specific to 
> targets marked with the penguin (work queues?).
> 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Arjan van de Ven <arjan@infradead.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> 
> If Arjan is happy with the patch, please add my:

Probably just a diagnostic, but...

> Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Saved.

	-Mike

