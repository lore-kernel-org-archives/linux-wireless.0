Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35644 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbbAWKdw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:33:52 -0500
Message-ID: <1422009226.2728.31.camel@sipsolutions.net> (sfid-20150123_113356_969685_0F555C2D)
Subject: Re: [PATCH] mac80211: synchronize_net() before flushing the queues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Jan 2015 11:33:46 +0100
In-Reply-To: <1422008312.13429.5.camel@egrumbacBox>
References: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1422006994.2728.22.camel@sipsolutions.net>
	 <1422008312.13429.5.camel@egrumbacBox>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 10:18 +0000, Grumbach, Emmanuel wrote:

> I don't think it will introduce that much of latency.
> Note that there is a call to flush() right after that, this means that
> any driver which implements this call needs to wait there. So you have
> the latency in either place. The only additional latency it adds is for
> other RCU sections / packets on other interfaces.

This is correct.

> Also - since we just stopped the netif, there can possibly be only one
> packet for each vif / ac processing. This is not too much data to
> process.

But this is the wrong conclusion.

synchronize_rcu() is expensive, no matter what, especially if you have
multiple cores. The RCU grace periods will practically never line up,
and it needs to wait for every CPU to go through one.

It's not actually just "one packet for each vif/ac" - it's a whole tail
of whatever other RCU usages there are. Back when this was discussed,
the wizery people measured this to hundreds of ms in many not too
uncommon cases.

> Your call, but to honest, I have been optimizing the roaming as well (as
> you know). And it was really bad for drivers that implements the flush()
> callback. Especially in cases where you are already far from the AP you
> want to roam from. This is why I added the drop parameter and other
> optimizations (don't flush() after probing etc...)

Well, yes, but that's an upper bound - here with the synchronize_net()
we're more talking about a lower bound.

johannes

