Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51020 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZKVSTM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 13:19:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Sun, 22 Nov 2009 19:19:00 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>
References: <200911192224.29491.mb@bu3sch.de> <200911221852.19143.mb@bu3sch.de> <4B097EE8.10902@lwfinger.net>
In-Reply-To: <4B097EE8.10902@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911221919.02550.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 November 2009 19:11:52 Larry Finger wrote:
> On 11/22/2009 11:52 AM, Michael Buesch wrote:
> > On Thursday 19 November 2009 22:24:29 Michael Buesch wrote:
> >> This rewrites the error handling policies in the TX status handler.
> >> It tries to be error-tolerant as in "try hard to not crash the machine".
> >> It won't recover from errors (that are bugs in the firmware or driver),
> >> because that's impossible. However, it will return a more or less useful
> >> error message and bail out. It also tries hard to use rate-limited messages
> >> to not flood the syslog in case of a failure.
> >>
> >> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > So did somebody try this with opensource firmware, yet?
> 
> I'm testing now. So far, it has survived about 18 hours running tcpperf in one
> console, and a flood ping in another.

Cool. Thanks for testing. I'd have expected it to blow up, though. It's a little bit
strange, because there still are reports of blowing up opensource firmware. This patch
should produce better error messages in that case (it will not fix the blown firmware).

> It looks really good, but I want at least 
> 24 hours before committing.

Well, no. Just commit it, please. If this breaks, the _firmware_ has to be fixed.
Not the patch.

-- 
Greetings, Michael.
