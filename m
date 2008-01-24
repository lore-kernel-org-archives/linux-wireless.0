Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3586 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbYAXVcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 16:32:05 -0500
Date: Thu, 24 Jan 2008 16:07:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080124210728.GD3200@tuxdriver.com> (sfid-20080124_213210_900983_50AF2014)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda> <200801081630.31110.mb@bu3sch.de> <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2008 at 12:27:03PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 8 Jan 2008, Michael Buesch wrote:
> > > >
> > > > Can you check if that is the
> > > > WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> > > > in rx.c line 1486?
> > 
> > Yes fine.
> > Patches are on their way. Ignore the warning for now. It is harmless.
> 
> I don't think this ever got fixed. 
> 
> I don't see any alternative but just uncomment that bogus warning, because 
> it's otherwise going to just cause way more noise than it's worth. It's 
> apparently known to developers, and as such it's worthless in the source 
> code except as a way to make poor users worry.
> 
> It's been in the top oops/warnings report for the last three weeks, and I 
> haven't gotten any patches for it, so I'm a bit grumpy. What's the point 
> of having a WARN_ON() if nobody involved *does* anything about it?

We've been trying to shame the iwlwifi team into fixing it.  They have
been blaming their firmware, but I think they could fix the alignment
in their driver.

There is no great harm in reverting
81100eb80add328c4d2a377326f15aa0e7236398 if you would like to go ahead
and push the 2.6.24 release.  I suspect, however, that the mac80211
guys would like to keep it (or put it back for 2.6.25) to continue
to shame driver developers in the future.

John
-- 
John W. Linville
linville@tuxdriver.com
