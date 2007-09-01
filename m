Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10713 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbXIAKyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 06:54:54 -0400
Subject: Re: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc  replies
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1188638228.7585.124.camel@johannes.berg>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
	 <20070901043557.2498.6553.stgit@dv.roinet.com>
	 <1188638228.7585.124.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 06:54:51 -0400
Message-Id: <1188644091.4146.12.camel@gx>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-09-01 at 11:17 +0200, Johannes Berg wrote: 
> On Sat, 2007-09-01 at 00:35 -0400, Pavel Roskin wrote:
> > Don't cancel all delayed works indiscriminately.  In case of
> > at76_rx_mgmt_auth(), cancel the timeout regardless of the status of the
> > reply, as long as the reply is for us.
> 
> Out of curiosity, why are you cleaning up code that needs to be deleted
> anyhow? The way I see it, the driver ought to be be ported to mac80211,
> no? It seems to ship with an in-driver softmac.

I understand that.  But at the time I did it, I wasn't even sure that
the mac80211 conversion is possible.  I wanted to have a solid base
before starting the risky conversion.

The driver used to have a big event handler that was split into several
works and a big timer handler that was split into several timers.  In
some cases, the code would cancel the "big timer" for some errors.  The
first step was replace it with the code to cancel all timers.  The
second step was to remove some unlikely or wrong cases, when the
specific timer cannot be running or shouldn't be canceled.  I'm not
going to do any more cleanup of this kind.

What happened is that the driver in wireless-dev/at76 is a version 57
commits below the top of my repository, and the mac80211 port was
started at the point 35 commits above the version in wireless-dev/at76.

It would have been easier if everybody just had started with my current
code, but since it didn't happen, I'm trying to fix it.  The first step
is to go the the point where Kalle started mac80211 conversion.  The
rest doesn't contain any major fixes, although some changes are pretty
intrusive.  I'll see what to do with them once I have a chance to play
with the mac80211 conversion patch.

The patches I have sent were not meant to be reviewed in this list,
since I expected the latest version to be imported as is.  But I think
it's still better to send the patches separately rather than a single
patch.  If nothing else, the separate patches could receive some useful
comments.

-- 
Regards,
Pavel Roskin
