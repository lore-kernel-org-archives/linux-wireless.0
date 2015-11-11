Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44834 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbbKKHh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 02:37:57 -0500
Message-ID: <1447227472.2276.7.camel@sipsolutions.net> (sfid-20151111_083800_895935_55C5543E)
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 11 Nov 2015 08:37:52 +0100
In-Reply-To: <1447201345.2475.15.camel@coelho.fi>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	 <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	 <1447201345.2475.15.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-11-11 at 02:22 +0200, Luca Coelho wrote:
> 
> Now that you have all these options in Kconfig, wouldn't it be
> possible
> to remove the calls to the "static" ieee80211_hw_set() in the drivers
> and somehow set all the flags that are defined in Kconfig
> automatically?
> 

Since Kconfig flags are global (across multiple drivers) I don't really
see a way to do that.

I'd *love*, however, to have an "increment" in Kconfig, then I could
get rid of the _OFF ones:

config MAC80211_NUM_DRIVERS
	int

config MAC80211_HW_HAS_RATE_CONTROL
	int

config MY_DRIVER
	depends on MAC80211
	increment MAC80211_NUM_DRIVERS
	increment MAC80211_HW_MYFLAG


and then later

if (CONFIG_MAC80211_HW_MYFLAG == 0)
	/* optimise for flag OFF */
else if (CONFIG_MAC80211_HW_MYFLAG > 0 &&
         CONFIG_MAC80211_NUM_DRIVERS == CONFIG_MAC80211_HW_MYFLAG)
	/* optimise for flag ON */
else if (CONFIG_MAC80211_HW_MYFLAG > 0)
	/* don't optimise */

That's far more maintainable in the long term, since each driver only
needs to list in its Kconfig the flags it *wants*, not *all*.

Maybe I'll try to see if I can hack Kconfig to do that.

johannes
