Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 10:21:57 -0400
Message-ID: <1363962111.8238.52.camel@jlt4.sipsolutions.net> (sfid-20130322_152202_004826_D4A0E261)
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 22 Mar 2013 15:21:51 +0100
In-Reply-To: <20130322135038.GC29340@magnum.frso.rivierawaves.com> (sfid-20130322_145409_415927_302ECE38)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
	 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
	 <1363949737.8238.22.camel@jlt4.sipsolutions.net>
	 <20130322135038.GC29340@magnum.frso.rivierawaves.com>
	 (sfid-20130322_145409_415927_302ECE38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-22 at 14:50 +0100, Karl Beldan wrote:

> > > @@ -994,21 +996,25 @@ static void ieee80211_chswitch_work(struct work_struct *work)
> > >  	if (!ifmgd->associated)
> > >  		goto out;
> > >  
> > > -	sdata->local->_oper_channel = sdata->local->csa_channel;
> > > -	if (!sdata->local->ops->channel_switch) {
> > > +	cfreq_off = local->csa_channel->center_freq -
> > > +		local->_oper_chandef.chan->center_freq;
> > > +
> > > +	local->_oper_chandef.center_freq1 += cfreq_off;
> > > +	local->_oper_chandef.center_freq2 += cfreq_off;
> > 
> > Adjusting the center_freq1 is quite clearly wrong. :-)
> > 
> > Besides, it might not even be supported by the driver.
> > 
> Yes, the next serie will downgrade to NL80211_CHAN_WIDTH_20_NOHT.
> I know this is not acceptable, I will get back to this very soon.

That actually seems like a decent compromise, I'd accept that. It'll
likely not cause much more breakage than the current code would ... :)
Until we address this properly, of course, which I'll eventually need to
do as well.

> > There should be ready macros for chandef tracing -- can you use them?
> > 
> > > +		LOCAL_PR_FMT " ch:%#x" CHANDEF_PR_FMT,
> > > +		LOCAL_PR_ARG, __entry->changed, CHANDEF_PR_ARG
> > 
> > Hm so you used some? Why not all?
> > 
> I would have liked to use CHANDEF_ENTRY and CHANDEF_ASSIGN but they
> don't check for "chandef.chan != NULL" which would Oops when using
> chanctxes (and I hesitated to make it too invasive although I would
> gladly add the check if that doesn't bother you.

Doesn't bother me at all, go ahead and make that change.

johannes

