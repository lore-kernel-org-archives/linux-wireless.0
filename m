Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46982 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbbKKO3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 09:29:07 -0500
Message-ID: <1447252142.2276.19.camel@sipsolutions.net> (sfid-20151111_152911_490442_B38C978E)
Subject: Re: [RFC v2 3/4] mac80211: use static keys for hw flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>
Date: Wed, 11 Nov 2015 15:29:02 +0100
In-Reply-To: <20151111091859.55f6a4fd@gandalf.local.home>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
	 <1447145549-27376-4-git-send-email-johannes@sipsolutions.net>
	 <1447201345.2475.15.camel@coelho.fi>
	 <1447227472.2276.7.camel@sipsolutions.net>
	 <20151111083430.1e77c329@gandalf.local.home>
	 <1447249156.2276.17.camel@sipsolutions.net>
	 <20151111091859.55f6a4fd@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OnOn Wed, 11 Nov 2015 14:39:16 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
> > > On Wed, 2015-11-11 at 08:34 -0500, Steven Rostedt wrote:
> > 
> > > > config MY_DRIVER
> > > > 	depends on MAC80211
> > > > 	increment MAC80211_NUM_DRIVERS
> > > > 	increment MAC80211_HW_MYFLAG  
> > > 
> > > If you don't need to check more that >0 why not just use
> > > SELECT?  
> > 
> > > > if (CONFIG_MAC80211_HW_MYFLAG == 0)
> > > > 	/* optimise for flag OFF */
> > > > else if (CONFIG_MAC80211_HW_MYFLAG > 0 &&
> > > >          CONFIG_MAC80211_NUM_DRIVERS ==
> > > > CONFIG_MAC80211_HW_MYFLAG)
> > > > 	/* optimise for flag ON */
> > > > else if (CONFIG_MAC80211_HW_MYFLAG > 0)
> > > > 	/* don't optimise */  
> > 
> > I'm comparing those numbers to see if there's a driver that's
> > incrementing NUM_DRIVERS but not HW_MYFLAG.
> > 
 Wed, 2015-11-11 at 09:18 -0500, Steven Rostedt wrote:
> 
> OK, I'm still a bit confused. What happens if another driver
> increments
> NUM_DRIVERS? Then the above wont be equal right? That's what you
> want?
> 

Right. Basically it'd be one of three options:
 * all compiled drivers want the flag set:
   use a static key to make the fast case "flag set"
 * no compiled driver wants the flag set:
   use a static key to make the fast case "flag unset"
 * different drivers are compiled:
   don't use a static key since we don't know which one will get used

johannes

