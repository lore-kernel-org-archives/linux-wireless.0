Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50316 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932305AbXBPM6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 07:58:33 -0500
Date: Fri, 16 Feb 2007 13:58:27 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070216135827.7d262ae3@griffin.suse.cz>
In-Reply-To: <200702161325.47396.IvDoorn@gmail.com>
References: <200702141423.27823.IvDoorn@gmail.com>
	<20070215215722.3db7f3ca@griffin.suse.cz>
	<20070216130329.5f1dffee@griffin.suse.cz>
	<200702161325.47396.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2007 13:25:47 +0100, Ivo van Doorn wrote:
> On Friday 16 February 2007 13:03, Jiri Benc wrote:
> > On Thu, 15 Feb 2007 21:57:22 +0100, Jiri Benc wrote:
> > > Thinking about it more, sdata should be the correct place. It's more
> > > per-interface thing than per-BSS (although the difference is small in
> > > this particular case).
> > 
> > ...and thinking about it even more, that won't work with WDS.
> 
> You mean storing the sequence counter per-interface won't work,
> or per-bss?

Both.

When you have a WDS link and some other wireless interface at the same
time, their source addresses are (in most cases) the same. You want to
have the sequence control counter shared by them. Actually, it will
probably work most of time even when they have different counters. The
situation where it won't work is if you have two virtual interfaces,
one in STA and second in WDS mode, both connected to the same AP. I
can't figure out how this particular setup could be useful but it's
generally not disallowed.

Anyway, using different counter for a WDS interface probably violates
802.11 (although it's not much specific in this case). I believe it
will work in most cases, though.

Any ideas how to solve that?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
