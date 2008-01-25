Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55459 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbYAYSX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 13:23:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 19:21:48 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251723.58891.mb@bu3sch.de> <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801251921.48862.mb@bu3sch.de> (sfid-20080125_182332_613640_CC361FC0)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 17:43:09 Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > 
> > If we are talking about what's sane or not...
> > It's trivial to fix this in the firmware, like sane vendors like
> > Broadcom do.
> 
> You just showed your total disregard for any sanity by calling broadcom 
> "sane".

The Broadcom firmware _is_ mostly sane. That's what I am saying.
I wasn't talking about Broadcom's support or anything else.

> > Architectures that can't do unaligned access are heavily used in
> > wireless embedded routers. So we are not going to pay a huge
> > price there so just one vendor doesn't have to fix his firmware.
> 
> .. and you also showed that you didn't even read my email and the options 
> I outlined. The fact is, the Intel wireless chipset only works with x86 
> CPU's. There is absolutely zero "price" on crap CPU's, because they are 
> simply not relevant to this driver.

I'm not sure what's so hard about adding this trivial fix to the firmware.
The _fact_ that this warning triggered for lots of drivers means that
developers are not aware of the problem. So why should we go on hiding bugs
that are _trivial_ to fix?

I absolutely hate the attitude "The problem does not happen on most
of the stuff intel uses, so they don't need to fix this". So, I also don't
need to fix bugs in code I wrote, just because I don't have such use
scenario? That would be great. I'd know thousands of lines of b43 code
that I'd like to immediately remove then.
That's just not how it works in the real world.

We should write the kernel and drivers as portable as possible. We left the
old days when linux only ran on an i386. ;)

And to say it again, this is really really trivial to fix. So why remove
a sanity check that tells you about bugs in other drivers where it does
matter (because they are used on such weird architectures), just because one
vendor says "hey, doesn't matter for me"?

Adding the check to the driver is not an option, because most driver developers
are not aware of the issue. So they would not add this. They would just run
into weird issues and waste time debugging it.

If this was a hard to fix problem which would require changing lots of things,
ok. That would be OK to remove the sanity check then. But that's not the case.

-- 
Greetings Michael.
