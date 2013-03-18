Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3CRVZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 17:25:31 -0400
Message-ID: <1363641919.8260.37.camel@jlt4.sipsolutions.net> (sfid-20130318_222539_075810_D6386E11)
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 18 Mar 2013 22:25:19 +0100
In-Reply-To: <20130318211419.GC17878@gobelin> (sfid-20130318_221427_461504_67334B5A)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
	 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
	 <1363634710.8260.15.camel@jlt4.sipsolutions.net>
	 <20130318211419.GC17878@gobelin> (sfid-20130318_221427_461504_67334B5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 22:14 +0100, Karl Beldan wrote:
> On Mon, Mar 18, 2013 at 08:25:10PM +0100, Johannes Berg wrote:
> > On Sun, 2013-03-17 at 21:30 +0100, Karl Beldan wrote:
> > 
> > > +	if (conf->chandef.chan)
> > 
> > > +	else
> > > +		wiphy_debug(hw->wiphy,
> > > +			    "%s (freq=0/%s idle=%d ps=%d smps=%s)\n",
> > 
> > I don't think the else should be allowed to happen.
> > 
> 
> Although I saw the hw config got an initial channel right from the start
> in ieee80211_register_hw, the original checks in the code confused since
> it tested for it in the tracing of drv_config.
> I'll get rid of it (in trace.h too).

It has to check in tracing because tracing can be invoked when the
driver uses chanctx, in which case it will be NULL. And indeed, that's
also the reason for hwsim -- it can operate in both chanctx and
non-chanctx modes. Sorry about the confusion!

> > > +static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
> > > +				 const struct cfg80211_chan_def *def2)
> > 
> > indentation
> > 
> This one is good, it's just the side effect of the addition of the
> leading '+'.

Ahrg, yeah, I can't trust my email client any more. It used to get this
right :-(

> > >  		/* update the device channel directly */
> > > -		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
> > > +		sdata->local->hw.conf.chandef.chan = sdata->local->oper_chandef.chan;
> > >  	}
> > 
> > All of this is now even more obviously wrong. If it's an HT40 channel,
> > it previously would try to switch to the same HT40 channel, but now it'd
> > result in an invalid chandef, the center_freq1 would now be wrong.
> > 
> Yes, thanks ! I was careless here.
> We should replace the csa_channel with a csa_chandef and get the freqs
> with the vif processed in ieee80211_sta_process_chanswitch, or is it
> utterly wrong ?

It's all kinda bad. We really have to implement extended CSA that tells
us what channel width to switch to, I have some patches but it's tricky
and I can't really test it :-(

johannes

