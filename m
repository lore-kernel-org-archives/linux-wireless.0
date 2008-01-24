Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38561 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbYAXWFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 17:05:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43: Fix MAC control and microcode init
Date: Thu, 24 Jan 2008 23:03:36 +0100
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200801222023.35131.mb@bu3sch.de> <1201165981.3454.49.camel@johannes.berg>
In-Reply-To: <1201165981.3454.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801242303.36694.mb@bu3sch.de> (sfid-20080124_220520_062594_AEDAAD98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 10:13:01 Johannes Berg wrote:
> 
> > This also adds a longer delay for waiting for the microcode
> > to initialize itself. It seems that the current timeout is sufficient
> > on all available devices, but there's no real reason why we shouldn't
> > wait for up to one second. Slow embedded devices might exist.
> 
> Your decision, but I very much doubt you can make the MAC any slower
> than on the old devices, in fact, on new chips it runs considerably
> faster I think.

Ok, well. But the host machine does get faster. In theory we only
gave the microcode 500 microseconds of time to initialize. I think
that is is a pretty tiny timeframe. In practice the time was higher,
because we had a loop that checked MMIO and delayed for 10usec.
Of course this all has overhead. But as machines get faster and faster
I think we can't assume to have more than 500 microseconds of time.

So, increasing the delay to one second doesn't hurt anyone. In
all common cases it will continue after a few milliseconds. That's fine.
Even if there is something going wrong (wrong firmware) you can
interrupt the one second delay by hitting ^C.

I think the specs originally sayed to use a much longer delay than
we were using. But we did use a shorter delay, because in some old
bcm43xx code this ran unter spinlock as far as I remember. So we didn't
want to spin several milliseconds and lockup the system, if something
goes wrong in firmware. These times are gone and now we can sleep
in this part of the code.

-- 
Greetings Michael.
