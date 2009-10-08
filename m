Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932435AbZJHOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 10:55:43 -0400
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frans Pop <elendil@planet.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1255011186.7294.1.camel@marge.simson.net>
References: <200910051500.55875.elendil@planet.nl>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1254974743.7797.21.camel@marge.simson.net>
	 <20091008064041.67219b13@infradead.org>
	 <1255011186.7294.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 16:54:54 +0200
Message-Id: <1255013694.7309.7.camel@marge.simson.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-08 at 16:13 +0200, Mike Galbraith wrote:
> On Thu, 2009-10-08 at 06:40 -0700, Arjan van de Ven wrote:
> > On Thu, 08 Oct 2009 06:05:43 +0200
> > Mike Galbraith <efault@gmx.de> wrote:
> 
> > > OK, I see latencytop spikes here on an idle box too, to the tune of up
> > > to a _second_.  Booting with nohz=off seems to have cured it.
> > 
> > interesting..
> > 
> > 
> > by chance, does this patch fix it ?
> 
> I haven't seen incredible yet, but with idle box, have seen > 200ms, so
> would say no.

But this dinky hunk of my patchlet does indeed still fix it right up.

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -495,8 +495,10 @@ static void update_curr(struct cfs_rq *c
 	u64 now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
 
-	if (unlikely(!curr))
+	if (unlikely(!curr)) {
+		update_rq_clock(rq_of(cfs_rq));
 		return;
+	}
 
 	/*
 	 * Get the amount of time the current task was running

We have a clock problem with NO_HZ coming out of idle, so we may well
have real latency issues at the same time, not bogons.

	-Mike

