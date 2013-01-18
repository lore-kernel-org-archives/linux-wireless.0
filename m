Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3ARWIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 17:08:32 -0500
Message-ID: <1358546933.7922.49.camel@jlt4.sipsolutions.net> (sfid-20130118_230835_421848_F8A19C95)
Subject: Re: [PATCHv6 0/6] Add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 18 Jan 2013 23:08:53 +0100
In-Reply-To: <20130117142125.GF19552@pandem0nium>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1358378574.15012.62.camel@jlt4.sipsolutions.net>
	 <20130117142125.GF19552@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> As stated before: "available until ..." time is not neccessary as far
> as I know. Also the channel must stay available when AP stops operation,
> I'll change that.

Yeah, I checked the documents myself now ... strange, but hey. Radars
are fixed installations and mostly active continually, so I guess they
figured it was no big deal.

> > Actually with your current patch 2) cannot be implemented at all because
> > the initial CAC never really finishes?
> 
> Yeah, for this case it is flawed - one could start radar detection on
> different channels one after another in short time, and we would just
> set "cac_started" and the timeout - which eventually might mark all channels
> available without checking for the required time on it. That seems wrong.

Indeed. But once you add the "locking", it will be that you can start
radar detection only on a single channel, and then it stays locked to
doing that until you start and stop an AP on that channel. That's also
undesirable.

> >  * radar detection finished:
> >    - driver: call mac80211 with result (radar detected or not)
> >    - mac80211: free up channel context (probably needs workqueue!)
> >                pass result to cfg80211
> >    - cfg80211: clear wdev radar detect chandef
> >                if OK to use: store availability in channel struct
> >                send result to userspace
> 
> Right now we only have the event for radar detect (i.e. detection
> failed).
> 
> We could add a timer to mark the channel available after the CAC time,
> if no radar has been detected in this time. Don't know if mac80211 or
> cfg80211 would be the best place for this, but I think the driver is not
> - this timer must be shared over various drivers after all.

Fair point. It seems likely though that full-MAC chips, if they
implement this at all, would have the timer in firmware. Therefore,
providing API for "radar detected" and "channel is usable" would make
more sense? The timer would then go into mac80211.

Later, if we modify the regdb format/API, we could also pass the minimum
time from there. That way, if it ever gets changed and we want to rely
on regdb info, we could.

> >  * start AP:
> >    - cfg80211: check channel availability
> >    - cfg80211/mac80211/driver? - enable radar detection while operating
> 
> mac80211 can instruct the driver to use radar detection while operating.
> E.g. pass it in sdata->vis.bss_conf ?

I would say in the chanctx, i.e. struct ieee80211_chanctx_conf. Since
not all drivers implement that yet, also struct ieee80211_conf. See how
local->_oper_channel gets set in mac80211/chan.c. This information would
be similar, the "master" information would be in the chandef, copied to
local/local->hw.conf.


> >  * AP channel switch:
> >    - if due to radar, mark channel as not clear
> OK - in AP case, we would have got the radar event anyway so the channel
> would already be marked "not clear". In IBSS however, that is possible
> (another station may have asked us to switch channel because of radar).

Oh, I wasn't even considering that -- don't care what you do there,
although it makes sense. OTOH, we would detect the radar ourselves, so
it doesn't really matter?

> > Note how I'm also letting the drivers determine the duration of the
> > radar check. Maybe the duration should be passed to the driver, or maybe
> > not, but I think for full-MAC chips it would be more likely that they
> > get an event for both cases from the device, not just the timeout you
> > have in software ...
> 
> Hm, I don't know. CAC times are subject to regulation changes. In ETSI
> it's one minute, for weather channels (5600-5650 MHz) 10 minutes (but we
> better don't support them anyway as they require incredible radar 
> detection rates).

See above. I have a feeling that if full-MAC chips implement this they'd
enforce a minimum time in firmware.

johannes

