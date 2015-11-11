Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:39541 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbbKKOTD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 09:19:03 -0500
Date: Wed, 11 Nov 2015 09:18:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
Message-ID: <20151111091859.55f6a4fd@gandalf.local.home> (sfid-20151111_151907_161149_A0BBC9CE)
In-Reply-To: <1447249156.2276.17.camel@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	<1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	<1447201345.2475.15.camel@coelho.fi>
	<1447227472.2276.7.camel@sipsolutions.net>
	<20151111083430.1e77c329@gandalf.local.home>
	<1447249156.2276.17.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Nov 2015 14:39:16 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2015-11-11 at 08:34 -0500, Steven Rostedt wrote:
> 
> > > config MY_DRIVER
> > > 	depends on MAC80211
> > > 	increment MAC80211_NUM_DRIVERS
> > > 	increment MAC80211_HW_MYFLAG  
> > 
> > If you don't need to check more that >0 why not just use SELECT?  
> 
> > > if (CONFIG_MAC80211_HW_MYFLAG == 0)
> > > 	/* optimise for flag OFF */
> > > else if (CONFIG_MAC80211_HW_MYFLAG > 0 &&
> > >          CONFIG_MAC80211_NUM_DRIVERS == CONFIG_MAC80211_HW_MYFLAG)
> > > 	/* optimise for flag ON */
> > > else if (CONFIG_MAC80211_HW_MYFLAG > 0)
> > > 	/* don't optimise */  
> 
> I'm comparing those numbers to see if there's a driver that's
> incrementing NUM_DRIVERS but not HW_MYFLAG.
> 

OK, I'm still a bit confused. What happens if another driver increments
NUM_DRIVERS? Then the above wont be equal right? That's what you want?

-- Steve
