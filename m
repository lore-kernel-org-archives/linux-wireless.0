Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964882AbXBPQ6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 11:58:19 -0500
Subject: Re: [PATCH] d80211: Simplify channel & mode configuration
From: Dan Williams <dcbw@redhat.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <200702151552.02331.flamingice@sourmilk.net>
References: <200702092325.39994.flamingice@sourmilk.net>
	 <200702092343.54479.flamingice@sourmilk.net>
	 <20070215211528.623e1c14@griffin.suse.cz>
	 <200702151552.02331.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 12:01:10 -0500
Message-Id: <1171645270.4153.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-02-15 at 15:52 -0500, Michael Wu wrote:
> On Thursday 15 February 2007 15:15, Jiri Benc wrote:
> > > +	local->hw.conf.channel = chan->chan;
> > > +	local->hw.conf.channel_val = chan->val;
> > > +	local->hw.conf.power_level = chan->power_level;
> > > +	local->hw.conf.freq = chan->freq;
> > > +	local->hw.conf.phymode = mode->mode;
> > > +	local->hw.conf.antenna_max = chan->antenna_max;
> >
> > What about passing ieee80211_channel and ieee80211_hw_mode structures
> > instead of a ton of variables? (Just an idea, not a problem with the
> > patch.)
> >
> I was thinking that too, but I was trying to avoid driver api changes. I might 
> make a patch for it later if it still makes sense then.
> 
> > > +	if (local->curr_rates != mode->rates)
> > > +		rate_control_clear(local);
> > > +	local->curr_rates = mode->rates;
> > > +	local->num_curr_rates = mode->num_rates;
> > > +	ieee80211_prepare_rates(local);
> >
> > This will trigger rate control reinitialization when scanning on abg
> > cards. It's needed but not obvious at first sight. Perhaps some comment
> > would be useful here? (Again, not a problem with the patch, just
> > something I realized looking at the patch and thinking why the hell do
> > we do the reinitialization here?)
> >
> Yeah, this is why rate control never seems to work right on my system - 
> NetworkManager keeps scanning and resetting the rate control. I'm not sure 
> exactly how to fix it, so I just left it..

Hmm; NM shouldn't be resetting the rate explicitly.  If the driver
resets the rate on a scan, isn't that a problem in the driver?

Dan


