Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46738 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbbKKNjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 08:39:24 -0500
Message-ID: <1447249156.2276.17.camel@sipsolutions.net> (sfid-20151111_143942_737801_E0A4A971)
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Date: Wed, 11 Nov 2015 14:39:16 +0100
In-Reply-To: <20151111083430.1e77c329@gandalf.local.home>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	 <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	 <1447201345.2475.15.camel@coelho.fi>
	 <1447227472.2276.7.camel@sipsolutions.net>
	 <20151111083430.1e77c329@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-11 at 08:34 -0500, Steven Rostedt wrote:

> > config MY_DRIVER
> > 	depends on MAC80211
> > 	increment MAC80211_NUM_DRIVERS
> > 	increment MAC80211_HW_MYFLAG
> 
> If you don't need to check more that >0 why not just use SELECT?

> > if (CONFIG_MAC80211_HW_MYFLAG == 0)
> > 	/* optimise for flag OFF */
> > else if (CONFIG_MAC80211_HW_MYFLAG > 0 &&
> >          CONFIG_MAC80211_NUM_DRIVERS == CONFIG_MAC80211_HW_MYFLAG)
> > 	/* optimise for flag ON */
> > else if (CONFIG_MAC80211_HW_MYFLAG > 0)
> > 	/* don't optimise */

I'm comparing those numbers to see if there's a driver that's
incrementing NUM_DRIVERS but not HW_MYFLAG.

johannes
