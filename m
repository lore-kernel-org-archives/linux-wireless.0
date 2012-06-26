Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab2FZPc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 11:32:57 -0400
Message-ID: <1340724774.4484.0.camel@jlt3.sipsolutions.net> (sfid-20120626_173300_925478_0C2ED381)
Subject: Re: [RFC v3 12/13] cfg80211: add channel checking for iface
 combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jun 2012 17:32:54 +0200
In-Reply-To: <4FE9BCC3.7070704@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
	  <1340713818-28549-13-git-send-email-michal.kazior@tieto.com>
	 <1340717368.14634.36.camel@jlt3.sipsolutions.net>
	 <4FE9BCC3.7070704@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 15:44 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Tue, 2012-06-26 at 14:30 +0200, Michal Kazior wrote:
> >
> >> +#define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
> >
> > Might make sense to put this into cfg80211.h, since e.g. hwsim could
> > support this many channels?
> >
> >> +		cfg80211_get_chan_state(rdev, wdev_iter, &ch, &chmode);
> >> +
> >> +		switch (chmode) {
> >> +		case CHAN_MODE_UNDEFINED:
> >> +			break;
> >> +		case CHAN_MODE_SHARED:
> >> +			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
> >> +				if (!used_channels[i] || used_channels[i] == ch)
> >> +					break;
> >> +
> >> +			BUG_ON(i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS);
> >
> > I'd prefer not to use BUG_ON(), maybe WARN_ON() and return some error?
> > It seems it could actually happen with buggy drivers that suddenly go
> > above their num_different_channels by switching around themselves or
> > something?
> 
> Hmm.. Now that I think of it we could probably hit the BUG_ON normally. 
> Suppose a driver supports num_different_channels == 
> CFG80211_MAX_NUM_DIFFERENT_CHANNELS. If cfg80211_can_use_iftype_chan is 
> called with another different channel we will hit the BUG_ON, no?
> 
> I think we should either do a WARN_ON_ONCE here, or nothing actually. 
> And return -EBUSY of course.

Good point, this seems like it could happen.

johannes

