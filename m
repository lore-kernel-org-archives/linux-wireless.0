Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbcBALo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 06:44:28 -0500
Date: Mon, 1 Feb 2016 12:44:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Baozeng <sploving1@gmail.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org, syzkaller@googlegroups.com,
	linux-wireless@vger.kernel.org
Subject: Re: sched/core: WARNING in __might_sleep
Message-ID: <20160201114423.GS6357@twins.programming.kicks-ass.net> (sfid-20160201_124443_032791_F7828F0C)
References: <CAP=GMUGr=qHO4uh9v=ZmEhGu1GTBGzmuZNQ+_Ds38yRXq1ZXPA@mail.gmail.com>
 <20160201111313.GQ6357@twins.programming.kicks-ass.net>
 <1454325966.3211.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1454325966.3211.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2016 at 12:26:06PM +0100, Johannes Berg wrote:
> On Mon, 2016-02-01 at 12:13 +0100, Peter Zijlstra wrote:
> > 
> > Yeah, from the rfkill code, which you failed to CC.
> 
> Thanks Peter :)
> 
> > In any case, this is a fail in the rfkill code, which should be
> > sorted
> > with the below patch (but the rfkill people should double check), and
> > ideally they'd use list_empty_careful() instead of the mutex, but I
> > don't know their code well enough to say if that's safe or not.
> 
> Even list_empty() is fine in this case since we go and recheck it
> anyway in the calling loop, while the mutex is held.
> 
> I have commit 6736fde9672f on its way to mainline.

OK, that looks good. Thanks!
