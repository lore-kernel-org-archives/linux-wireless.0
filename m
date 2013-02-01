Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3BAJxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 04:53:55 -0500
Message-ID: <1359712448.8528.2.camel@jlt4.sipsolutions.net> (sfid-20130201_105400_972116_71810A1F)
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 01 Feb 2013 10:54:08 +0100
In-Reply-To: <20130131174443.GB2018@pandem0nium>
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1359642321.8415.56.camel@jlt4.sipsolutions.net>
	 <20130131161346.GA1387@pandem0nium>
	 <1359650760.8415.91.camel@jlt4.sipsolutions.net>
	 <20130131174443.GB2018@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 18:44 +0100, Simon Wunderlich wrote:

> "If the master device has detected a radar signal on an Operating Channel during In-Service Monitoring, the
> master device shall instruct all its associated slave devices to stop transmitting on this channel which becomes
> an Unavailable Channel. For devices operating on multiple (adjacent or non-adjacent) Operating Channels
> simultaneously, only the Operating Channel containing the frequency on which radar was detected shall
> become an Unavailable Channel."
> 
> At least in ath9k it appears that the radar header contains some information whether
> the radar was received on the primary or extension channel.
> 
> I don't know how upcoming 80 MHz devices handle that though.
> 
> We can remove it now and re-add it later if you prefer?

No no, it's fine, I was just wondering.

> > > Hmm, actually I've tried setting the frequency with iw and got a EINVAL back.
> > > I'll look into it again if I missed something, but thought it would be good to
> > > not have this stuff redundant.
> > 
> > Ok. Hmm. EINVAL? Maybe you tried setting to a radar frequency or
> > something? Can you try setting to say channel 1? I don't think you
> > changed __nl80211_set_channel() to check cac_started, so ...
> > 
> 
> I can try again ... but maybe this is obsolete when using wdev->channel.

Yes, then you'd not have the problem.

> > > > > +	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> > > > > +	if (err < 1)
> > > > > +		return err;
> > > > 
> > > > That doesn't make sense, if userspace starts CAC and that is successful
> > > > it would expect to eventually receive an event that it completed? Thus
> > > > if you return 0 here it would get confused, no?
> > > > 
> > > 
> > > Ah yes, I should probably return EINVAL in this case, or the appropriate
> > > error code otherwise ... 
> > 
> > Maybe return some more useful error code? Can't really find any one that
> > is appropriate though.
> 
> We should add EUSELESS. :D
> Can't think of anything better, so will keep it at EINVAL until someone has
> a better idea.

:)

> > [...]
> > > > > @@ -884,6 +884,9 @@ static void handle_channel(struct wiphy *wiphy,
> > > > >  		return;
> > > > >  	}
> > > > >  
> > > > > +	chan->dfs_state = IEEE80211_DFS_USABLE;
> > > > > +	chan->dfs_state_entered = jiffies;
> > > > 
> > > > Here also you don't really need the time assignment.
> > > > 
> > > > (I skipped this before, so pasting here)
> > > > 
> > > 
> > > Hm, aren't channels initialized in this function? I wanted to set some
> > > sane values here - although time is not relevant for the USABLE state,
> > > I thought it might be useful if this info is exported to userspace or
> > > for debugging.
> > 
> > Maybe so, I just don't think you need the time there since it won't be
> > of relevance in the USABLE state. The "state entered" time is only used
> > for UNAVAILABLE.
> > 
> > Maybe therefore state_entered should be renamed to "unavailable_until"
> > with the corresponding change in the logic of adding the time when it's
> > set to that state?
> 
> Can do that, if no one is interested in when we, say, change from unavailable
> to usable (after NOP). This is what Zefir asked for. 
> 
> Personally I don't care at all, and we discuss that in the cover letter thread
> anyway. Let's see what Zefir says or if anyone else objects, I put that onto
> the "TODO if nobody objects list". :)

Heh. Ok I see Zefir's argument, so I guess that's reasonable. I just
didn't see a use for it in the kernel so was wondering.

johannes

