Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34115 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbaFLIjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 04:39:14 -0400
Message-ID: <1402562338.8095.4.camel@jlt4.sipsolutions.net> (sfid-20140612_103936_937220_E485078E)
Subject: Re: [patch V2] wireless: mwifiex: Use the proper interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Bing Zhao <bzhao@marvell.com>, LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 12 Jun 2014 10:38:58 +0200
In-Reply-To: <alpine.DEB.2.10.1406121029530.5170@nanos> (sfid-20140612_103227_131521_9EAF500A)
References: <20140611234024.103571777@linutronix.de>
	 <20140611234607.607201623@linutronix.de>
	 <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com>
	 <alpine.DEB.2.10.1406121029530.5170@nanos>
	 (sfid-20140612_103227_131521_9EAF500A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-12 at 10:31 +0200, Thomas Gleixner wrote:

> +	u32 queue_delay = ktime_to_ms(net_timedelta(skb->tstamp));

FWIW, I think the same as patch 12 applies here. net_timedelta() doesn't
really seem to be a good way to calculate time deltas.

And yes - I've seen situations where this matters, e.g. when running
ntpdate after system startup.

johannes


