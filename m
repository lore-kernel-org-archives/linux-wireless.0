Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab2B1PYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:24:21 -0500
Subject: Re: Occasional truncated scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald Wahl <ronald.wahl@raritan.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4F4CEFA6.2090005@raritan.com>
References: <4F4CE4D6.6020108@raritan.com>
	 (sfid-20120228_152950_864254_C21F9143) <1330440166.3368.7.camel@jlt3.sipsolutions.net>
	 <4F4CEFA6.2090005@raritan.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 16:24:19 +0100
Message-ID: <1330442659.3368.13.camel@jlt3.sipsolutions.net> (sfid-20120228_162430_694022_1801A6E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-28 at 16:15 +0100, Ronald Wahl wrote:

> >> Currently I implemented a heuristic that checks if some minimum space
> >> (currently 256 bytes) is still free _after_ adding a BSS and otherwise
> >> return -E2BIG so the user space can provide a larger buffer but this is
> >> a crappy hack.
> >>
> >> Can the code be changed in some way to more reliably detect if some data
> >> did not fit into the buffer and report this to user space?
> >
> > Unfortunately not. The maximum buffer size userspace can provide is
> > limited to 64k. In busy environments, this size can be exceeded. As a
> > result, if we do this, you can't get *any* scan results in such
> > environments. I believe the current code is almost the best we can do
> > for wireless extensions, but it may be possible to implement never
> > truncating a single BSS entry.
> 
> My problem is not that the scan results are larger than 64k. The user 
> space is coded so that it provides a small buffer that is doubled in 
> size until the data fits into the buffer. But the kernel code does not 
> always detect the case that the buffer is almost full and just starts 
> skipping some data without notifying user space with E2BIG.

Ok. Yes, this could be fixed by making sure that a single BSS is
atomically written or not written -- probably simply by rolling back at
the end of the function if it didn't fit and returning an error etc. If
you wanted to work on this, I'd review & accept the patch, but I have no
intention whatsoever to do this myself :-)

johannes

