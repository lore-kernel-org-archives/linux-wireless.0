Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2F1IPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 04:15:53 -0400
Message-ID: <1340871351.4491.19.camel@jlt3.sipsolutions.net> (sfid-20120628_101558_681417_E9602F90)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 10:15:51 +0200
In-Reply-To: <4FEC015B.4020603@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	    <1340718188.14634.47.camel@jlt3.sipsolutions.net>
	    <4FEAB698.5070309@tieto.com>
	   <1340784614.8305.8.camel@jlt3.sipsolutions.net>
	   <4FEADCAE.5080508@tieto.com>
	  <1340795424.11012.11.camel@jlt3.sipsolutions.net>
	  <4FEAFFF1.7080706@tieto.com>
	 <1340805730.11012.33.camel@jlt3.sipsolutions.net>
	 <4FEC015B.4020603@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 09:01 +0200, Michal Kazior wrote:

> >> Hmm.. Yeah we need to now, sort of. FullMAC drivers could suffer, but we
> >> could drop connections upon CSA in mac80211 for the time being.
> >>
> >> cfg80211 could provide:
> >>    * cfg80211_sta_can_switch_chan
> >>    * cfg80211_sta_ch_switch_notify
> >>
> >> mac80211 could then be able to know whether num_different_channels has
> >> been reached (cfg80211_sta_can_switch_chan) and eventually notify upon
> >> channel switch (cfg80211_sta_ch_switch_notify).
> >>
> >> Channel switch would happen if either:
> >>    * cfg80211_sta_can_switch_chan is true
> >>    * channel context for target CSA channel already exists
> >>
> >> I'm just unsure about the current_bss thing - whether we should e.g.
> >> initiate a scan to update it, or can we shamelessly update the channel
> >> in the structure directly?
> >
> > Today mac80211 just updates it, yeah.
> 
> Should I send the ,,respect channels in iface combinations'' as a 
> [PATCH] now, or should the CSA issue (in cfg80211) be addressed first?

Good question. Even if we don't do CSA first, I guess we don't really
break anything right now, do we? And if the driver/mac80211 just changes
the channel, that means it could seem to go over the limit of 1 channel
but things just break down like they do today?

I guess I'd like to have the CSA stuff addressed, but it seems we
haven't really closed on the best way yet, and I don't want to hold off
your work for it for too long?

johannes

