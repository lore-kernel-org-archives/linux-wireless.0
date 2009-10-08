Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbZJHPJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 11:09:38 -0400
Date: Thu, 8 Oct 2009 08:09:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Mike Galbraith <efault@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
Message-ID: <20091008080936.5f3b0e1b@infradead.org>
In-Reply-To: <200910081655.37485.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	<1254974743.7797.21.camel@marge.simson.net>
	<20091008064041.67219b13@infradead.org>
	<200910081655.37485.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Oct 2009 16:55:36 +0200
Frans Pop <elendil@planet.nl> wrote:
> > It turns out that on x86, these two 'opportunistic' timers only
> > get checked when another "real" timer happens.
> > These opportunistic timers have the objective to save power by
> > hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
> > as much as possible.
> 
> This patch makes quite a difference for me. iwlagn and phy0 now 
> consistently show at ~10 ms or lower.\

most excellent

 
> I do still get occasional high latencies, but those are for things
> like "[rpc_wait_bit_killable]" or "Writing a page to disk", where I
> guess you'd expect them. Those high latencies are mostly only listed
> for "Global" and don't translate to individual processes.

and they're very different types of latencies, caused by disk and such.


> The ~10 ms I still get for iwlagn and phy0 (and sometimes higher (~30
> ms) for others like Xorg and artsd) is still "Scheduler: waiting for
> cpu'. If it is actually due to (un)interuptable sleep, isn't that a
> misleading label? I directly associated that with scheduler latency.

it's actually the time between wakeup and running, as measured by
scheduler statistics

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
