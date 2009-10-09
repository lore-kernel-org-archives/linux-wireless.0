Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42655 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757477AbZJIUHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:07:09 -0400
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200910091827.01774.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910082259.35204.elendil@planet.nl>
	 <1255070103.7639.30.camel@marge.simson.net>
	 <200910091827.01774.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 22:06:20 +0200
Message-Id: <1255118780.7305.13.camel@marge.simson.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-09 at 18:27 +0200, Frans Pop wrote:
> On Friday 09 October 2009, Mike Galbraith wrote:
> > sched: update the clock of runqueue select_task_rq() selected.
> >
> > In try_to_wake_up(), we update the runqueue clock, but select_task_rq()
> > may select a different runqueue than the one we updated, leaving the new
> > runqueue's clock stale for a bit.
> >
> > This patch cures occasional huge latencies reported by latencytop when
> > coming out of idle on a mostly idle NO_HZ box.
> 
> This patch (without Arjan's previous one applied) also fixes my latency 
> issues. Nice work!

Thanks for the confirmation (and kind words).

	-Mike

