Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbYEUOUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 10:20:08 -0400
Subject: Re: mrv8k: now gets scan results
From: Dan Williams <dcbw@redhat.com>
To: Markus Becker <mab@comnets.uni-bremen.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805210900160.3750@bugs.comnets.uni-bremen.de>
References: <1211312013.10737.10.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0805210900160.3750@bugs.comnets.uni-bremen.de>
Content-Type: text/plain
Date: Wed, 21 May 2008 10:20:14 -0400
Message-Id: <1211379614.25344.7.camel@localhost.localdomain> (sfid-20080521_162013_007752_762CED2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-05-21 at 09:08 +0200, Markus Becker wrote:
> Hi Dan,
> 
> I just tested it and my Option Fusion+ HSDPA card does not scan:
> 
> May 21 08:52:17 shelbyville kernel: Command timeout
> May 21 08:52:17 shelbyville kernel: Could not set channel
> May 21 08:52:17 shelbyville kernel: ~Failed to set channel
> May 21 08:52:17 shelbyville kernel: wlan1: failed to set freq to 2417 MHz for scan

Interesting; it does take the firmware upload though, right?  What
firmware version gets reported by the driver when it loads?  I'll have
to try again with my Netgear PCI card which was a lot more unhappy with
the driver than my 3Com CardBus one.

I spent some time checking through marvell.git from Linville's repo on
kernel.org too, and it looks like we may be able to pull a lot of
constants and commands from that.  The RX and TX descriptors are
somewhat different, but I've generally found that Marvell's drivers and
firmware share a lot of API/ABI (would be stupid to break stuff all the
time anyway, even in closed source).  We may be able to use mrv8k for
the TopDog 802.11n PCI and USB parts as well since they are so similar
from a programming perspective.

Dan

> May 21 08:52:19 shelbyville kernel: Command timeout
> May 21 08:52:19 shelbyville kernel: Could not set channel
> May 21 08:52:19 shelbyville kernel: ~Failed to set channel
> May 21 08:52:19 shelbyville kernel: wlan1: failed to set freq to 2422 MHz for scan
> [...]
> 
> I also got some lockups, however I have no infrastructure setup to debug 
> those.
> 
> Thanks for all your efforts,
> Markus
> 
> On Tue, 20 May 2008, Dan Williams wrote:
> 
> > Hi,
> >
> > I've gotten mrv8k to the point where I can get scan results with it on
> > my 3COM 3CRGPC10075 CardBus card.  Data RX still doesn't work for some
> > reason and WEP associations still fail with a mac80211 timeout.  Enough
> > for today though.  All changes pushed to mrv8k.git on infradead.
> >
> > Dan
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

