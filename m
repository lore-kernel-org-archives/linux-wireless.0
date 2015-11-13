Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59621 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbbKMQfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:35:43 -0500
Message-ID: <1447432539.3271.23.camel@sipsolutions.net> (sfid-20151113_173554_933071_58FCFE93)
Subject: Re: [RFC v4 8/8] mac80211: use Kconfig counters to determine
 feature optimisation
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 17:35:39 +0100
In-Reply-To: <20151113112922.3442aa1a@gandalf.local.home>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	 <1447318073-22669-9-git-send-email-johannes@sipsolutions.net>
	 <20151113112922.3442aa1a@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 11:29 -0500, Steven Rostedt wrote:

> > -	select MAC80211_HW_HAS_RATE_CONTROL_OFF
> > -	select MAC80211_HW_RX_INCLUDES_FCS_OFF
> 
> What happened to these two?

I removed the _OFF ones entirely, and instead with this patch am now
relying on modified logic:

 _on  = flags_counter > 0
 _off = flags_counter < driver_counter

So the ones that are requested _OFF no longer need to be listed in
Kconfig - that was the entire point of doing the count (increment)
thing since we can then add new flags without touching all the drivers
to select them to _OFF.

> > +config MAC80211_NUM_DRIVERS
> > +	int
> > +	depends on MAC80211
> 
> Why the depends? Does it make it 1 to start with?
> 

No, it just removes it from the Kconfig entirely when you don't even
have MAC80211 instead of leaving it set there to 0. Probably not really
necessary, or could be better to put them all inside an "if mac80211"
block.

johannes
