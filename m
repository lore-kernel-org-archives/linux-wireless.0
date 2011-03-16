Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1CPIr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 04:47:27 -0400
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
	 <1300263716.3761.1.camel@jlt3.sipsolutions.net>
	 <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 09:49:08 +0100
Message-ID: <1300265348.3761.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-16 at 01:44 -0700, Daniel Halperin wrote:
> On Wed, Mar 16, 2011 at 1:21 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2011-03-15 at 16:49 -0700, Daniel Halperin wrote:
> >
> >> x-T-R1-y-R2,
> >
> >>                       if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
> >> -                                     HT_RX_REORDER_BUF_TIMEOUT))
> >> +                                     HT_RX_REORDER_BUF_TIMEOUT) && skipped)
> >
> > Wait, your previous example of xT---R worked fine, but if you say x-T-
> > this patch won't work I think? Basically you're saying if we received
> > frames 2 and 4 after 3, and 3 times out, we can release 2 through 4. I
> > agree, but your code won't do that since skipped starts out at 1 due to
> > the first x. Or am I misreading this?
> >
> 
> The syntax I used in our private mail was confusing and I tried to
> simplify. Here, hyphens are just separators between frames (since R1,
> R2 have two-letter identifiers). Does that clear it up?

Oh. Right. Still though, what if it is x-R1-T-R2-y-...? This fixes
x-T-R1-...-y-..., but shouldn't some release be possible in the other
case as well?

johannes

