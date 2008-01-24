Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44176 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759788AbYAXWfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 17:35:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Thu, 24 Jan 2008 23:33:02 +0100
Cc: linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801242317.50948.mb@bu3sch.de> <alpine.LFD.1.00.0801241423190.7482@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801241423190.7482@hp.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801242333.03129.mb@bu3sch.de> (sfid-20080124_223522_655595_7A57B2FA)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 23:26:41 Linus Torvalds wrote:
> 
> On Thu, 24 Jan 2008, Michael Buesch wrote:
> > 
> > This was fixed in the drivers. A fix for zd1211rw got in and for
> > the RTL wireless drivers. Did any other driver trigger this warning?
> 
> The Intel driver does, and was tagged as the main culprit in at least the 
> pseudo-automated oops reports that Arjan sends to lkml.

Oh, well. Intel... hm.
They basically refused to fix it by now.
Please don't blame us mainline developers for this.
We _did_ immediately care to fix our drivers. So the only driver
that is actually not fixed is the intel stuff, which is kind of
developed out of tree and only pushed from time to time.

I don't know why they didn't fix it, yet, but I guess it's low
priority for them, as it does not cause any problems on
intel CPUs.

> > So it can cause some delay sometimes, but I'm pretty sure the fixes
> > should have hit mainline by now. I can recheck that if you desire.
> 
> I'm 100% sure they haven't, since I could trigger this warning as of the 
> tree an hour ago (and I have since reverted it, so now I can't). That's 
> what reminded me - doing a final round of "test on the machines I have 
> available" before releasing 2.6.24.

I guess you tested with Intel wireless, right?

I'm sorry for the inconvenience anyway.
It's OK to revert this WARN_ON for the release kernel, as it does
only cause any problems on CPUs that can't do unaligned access.

-- 
Greetings Michael.
