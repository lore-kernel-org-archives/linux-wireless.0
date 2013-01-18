Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARVyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 16:54:25 -0500
Message-ID: <1358546080.7922.36.camel@jlt4.sipsolutions.net> (sfid-20130118_225429_846877_EC8618BB)
Subject: Re: [PATCHv6 3/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 18 Jan 2013 22:54:40 +0100
In-Reply-To: <20130117134034.GC19552@pandem0nium>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-4-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1358376672.15012.37.camel@jlt4.sipsolutions.net>
	 <20130117134034.GC19552@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-17 at 14:40 +0100, Simon Wunderlich wrote:

> Actually there is no limit how long a channel is considered "available", at
> least in ETSI. ETSI EN 301-893 v1.4.1 had a limit of 24 hours for that,
> but that was removed in v1.5.1 and didn't re-appear since then (current is
> v1.7.1).

Huh indeed, I would have expected that to be there. It does have a
non-occupancy time though (30 minutes), maybe we should implement that?

I'm also thinking with the next regdb format update we should allow
specifying these timeouts etc. there.

Does anyone have the relevant FCC rules? I can't find anything with
google ...

> But we can move the CAC/timeout in the wdev and have keep a flag field in
> the channel struct instead, marking the channel as available, unavailable, etc.
> 
> What do you think?

I think that would make sense. Probably available/unavailable and
"non-occupancy until"?

> > I have a feeling this change should take into account the channel width,
> > and whether CAC completed successfully?
> > 
> 
> All channels used for operation are checked already in cfg80211_chandef_usable()
> for the flags.
> 
> If the channel width is supported at all is checked with cfg80211_can_use_iftype_chan()
> before/after.
> 
> So I don't see the neccesity for further checking width, or am I missing something?

Hmm, cfg80211_reg_can_beacon() is exported and usable by other modules,
so it should probably do more checking?

> > > +	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
> > > +	if (!err) {
> > > +		wdev->preset_chandef = chandef;
> > > +		chandef.chan->cac_started = true;
> > > +		chandef.chan->radar_detect_timeout = jiffies +
> > > +			msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
> > > +	}
> > > +
> > > +	return err;
> > > +}
> > 
> > This still seems somewhat wrong. For the duration of the CAC, the
> > channel should be "locked" in some way, no? As it stands now, nothing
> > prevents userspace from adding another vif and using it for something
> > entirely different, while cfg80211 thinks the CAC is actually running.
> > 
> 
> Hmm, we can put the "CAC state" in the wdev then, and use it for locking?

I think it may need to be the CAC chandef? Not sure, but we definitely
need something to use in cfg80211_get_chan_state().

johannes

