Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2FZH22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 03:28:28 -0400
Message-ID: <1340695700.4662.6.camel@jlt3.sipsolutions.net> (sfid-20120626_092832_472824_DFEA51A8)
Subject: Re: iwlwifi: "GF was set with SGI:SISO"
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 09:28:20 +0200
In-Reply-To: <878vfbhilx.fsf@nemi.mork.no>
References: <87lijfjkjk.fsf@nemi.mork.no>
	 <1340613038.4589.10.camel@jlt3.sipsolutions.net>
	 <878vfbhilx.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 10:59 +0200, Bjørn Mork wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > There's nothing you can do about it, I'll just downgrade it -- see patch
> > below, also for an explanation.
> 
> Thanks.  That looks like the only sensible solution.  I did some commit
> digging, and it seems this log message was introduced out of the blue
> with no explanation during code refactoring.

There's also a bug report that I hadn't linked to before:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2361

There, somebody says the RS algorithm also gets "stuck" in this case, so
I may instead of removing the message ratelimit it or so.

He has a trace though, so hopefully we can just find the error soon :)


> > Maybe some 11g client disconnected from the AP and then the messages
> > started showing up?
> 
> Could very well be.  The 11g client would probably be my phone then.  It
> tends to do connects/disconnects on its own, so it sounds likely that it
> could just have disconnected when the log messages started appearing.

Ok, that gives us a plausible scenario. When I get the trace, I'll
investigate in this direction.

johannes

