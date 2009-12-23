Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30004 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZLWCDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 21:03:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 18:03:07 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19249.32300.243423.92179@gargle.gargle.HOWL>
Date: Wed, 23 Dec 2009 07:49:24 +0530
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <20091222165528.GE4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL>
	<20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux>
	<20091222165528.GE4385@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Trimming CC List)

Luis Rodriguez wrote:
> > Here's the new log with 0x601, with a few pm-suspend successes above.

The only issue here is a call to wakeup the chip comes
after the ->stop() callback. And that happens here:

> > [  271.448580] Freezing user space processes ... (elapsed 0.00 seconds) done.
> > [  271.450215] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > [  271.450296] PM: Entering mem sleep
> > [  271.450321] Suspending console(s) (use no_console_suspend to debug)
> > [  271.456054] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  271.456073] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
> > [  271.456112] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
> > [  271.456141] ath9k: Detach Interface
> > [  271.456161] ath9k: NETWORK SLEEP -> AWAKE
> > [  271.458525] ath9k: AWAKE -> NETWORK SLEEP
> > [  271.458533] ath9k: NETWORK SLEEP -> FULL-SLEEP
> > [  271.458544] ath9k:
> > [  271.458547] ath9k: Driver halt
> > [  271.458552] FULL-SLEEP -> AWAKE

The actual issue then lies in the callsite, probably mac80211 - having stopped
the driver (during suspend), any notifications/calls to the driver are invalid.

But strange that I am not able to reproduce this.
What distribution are you using ? Also, the version of NM ?

Sujith
