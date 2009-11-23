Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37919 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756706AbZKWKtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:49:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Mon, 23 Nov 2009 11:49:36 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200911192224.29491.mb@bu3sch.de> <4B0A137B.7050604@lwfinger.net>
In-Reply-To: <4B0A137B.7050604@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200911231149.38494.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009 05:45:47 Larry Finger wrote:
> On 11/19/2009 03:24 PM, Michael Buesch wrote:
> > This rewrites the error handling policies in the TX status handler.
> > It tries to be error-tolerant as in "try hard to not crash the machine".
> > It won't recover from errors (that are bugs in the firmware or driver),
> > because that's impossible. However, it will return a more or less useful
> > error message and bail out. It also tries hard to use rate-limited messages
> > to not flood the syslog in case of a failure.
> 
> This patch definitely helped open-source firmware, but it is not a complete fix.

It is no fix _at_ _all_.
The patch does not change a single line of code that wasn't either an assertion
or a machine crash before.
So it just transforms assertions into more verbose assertions and crashes into
assertions without a crash.

> debug: Out of order TX status report on DMA ring 1. Expected 114, but got 146

Ok, this is what I expected.

Let's see what's going on. Here's the ring. o is unused, * is used.

ooooooooooooooo***************************************************ooooooooooooooooooooooooooo
               ^               ^                                 ^
               114             146                               newest
               oldest

So as you can see, the firmware reported a TX status for a frame right in the middle of
the ringbuffer. The new code detects this now before getting a double free and/or silent
memory corruption (freeing of used memory).

It really is illegal to report a TX status for a frame that's not the oldest one in the ring.
The firmware is required to process all frames in-order on one ring.

So how can this failure happen? I think there basically are three ways this can happen.

- First is that the ordering within one ring really gets messed up and it loses track
  of its ring pointers. I'm not sure if this is likely. Probably not.
- It messes up the ring membership. So it reports a TX status on the wrong ring.
  Note that the "ring" kernel pointer in the TX status report handler is derived
  from the cookie (and so also the number in the message "Out of order TX status
  report on DMA ring 1" is derived from the cookie). So it's untrustworthy in case of
  broken firmware. The firmware has QoS-alike mechanisms, even if QoS is disabled. Maybe
  these mechanisms are broken.
- Third is the possibility of a driver bug. I rule that out as long as nobody is
  able to reproduce it with proprietary firmware.

-- 
Greetings, Michael.
