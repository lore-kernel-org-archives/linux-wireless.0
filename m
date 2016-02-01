Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53405 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbcBAL0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 06:26:19 -0500
Message-ID: <1454325966.3211.1.camel@sipsolutions.net> (sfid-20160201_122635_680264_51B0873A)
Subject: Re: sched/core: WARNING in __might_sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>,
	Baozeng <sploving1@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
	syzkaller@googlegroups.com, linux-wireless@vger.kernel.org
Date: Mon, 01 Feb 2016 12:26:06 +0100
In-Reply-To: <20160201111313.GQ6357@twins.programming.kicks-ass.net>
References: <CAP=GMUGr=qHO4uh9v=ZmEhGu1GTBGzmuZNQ+_Ds38yRXq1ZXPA@mail.gmail.com>
	 <20160201111313.GQ6357@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-01 at 12:13 +0100, Peter Zijlstra wrote:
> 
> Yeah, from the rfkill code, which you failed to CC.

Thanks Peter :)

> In any case, this is a fail in the rfkill code, which should be
> sorted
> with the below patch (but the rfkill people should double check), and
> ideally they'd use list_empty_careful() instead of the mutex, but I
> don't know their code well enough to say if that's safe or not.

Even list_empty() is fine in this case since we go and recheck it
anyway in the calling loop, while the mutex is held.

I have commit 6736fde9672f on its way to mainline.

johannes

