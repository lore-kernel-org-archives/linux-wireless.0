Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35689 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZKWKaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:30:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Mon, 23 Nov 2009 11:30:22 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200911192224.29491.mb@bu3sch.de> <4B09E691.8020205@lwfinger.net>
In-Reply-To: <4B09E691.8020205@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911231130.23873.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009 02:34:09 Larry Finger wrote:
> On 11/19/2009 03:24 PM, Michael Buesch wrote:
> > This rewrites the error handling policies in the TX status handler.
> > It tries to be error-tolerant as in "try hard to not crash the machine".
> > It won't recover from errors (that are bugs in the firmware or driver),
> > because that's impossible. However, it will return a more or less useful
> > error message and bail out. It also tries hard to use rate-limited messages
> > to not flood the syslog in case of a failure.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> 
> Tested and ACKed by Larry Finger. Not only does this improve the error handling
> for b43, but it also appears to fix the skb == NULL error that I experienced
> with the open-source firmware.

I don't think there's any way it can fix this. The patch doesn't change the
code behavior. It just changes the sanity checks, that under normal circumstances
should never trigger.

> John - please push this into wireless-testing. It should also go to 2.6.32, but
> it is likely too large for the current stage. At least Cc it to stable.

Don't put it into stable. This is not a fix.
I don't think it's suitable for 2.6.32 at this stage, too.

-- 
Greetings, Michael.
