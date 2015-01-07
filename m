Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44795 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbAGKfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:35:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21677.3195.451116.244389@gargle.gargle.HOWL> (sfid-20150107_113522_675979_F5C4793F)
Date: Wed, 7 Jan 2015 16:07:47 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> I don't think this should be adjustable.

Why ?

> I assume you tested this in conjunction with rx batching patch - what
> fill level values did you use to see throughput improvement? How
> (un)responsive was serial/ssh connection to the machine?

Any value north of 128 made the console unresponsive, with
the CPU maxed out. But 16 appears to be rather low ? Performance
numbers are low and we end up with lots of replenish tasklets.

But - the internal driver somehow manages to keep CPU usage
down at a fill level of *1000*.

I think for ath10k, the default could stay the same on low end MIPS boards
like AP135, but on slightly more powerful boards like AP148 with dual-core
ARM processors, performance can be boosted by increasing the fill level
while still keeping responsiveness at a reasonable level.

> I have a patch internally which removes the replenishment tasklet and
> I wonder how will it behave with rx batching then, hmm..

I tried that earlier and could see only marginal improvement. The biggest
increase came when I replaced netif_receive_skb() with netif_rx()
in mac80211/rx.c.

Sujith
