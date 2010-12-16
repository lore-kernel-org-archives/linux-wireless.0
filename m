Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0LPMfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:35:36 -0500
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
In-Reply-To: <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	 <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	 <1292499024.3612.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	 <1292501047.3612.9.camel@jlt3.sipsolutions.net>
	 <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 13:35:34 +0100
Message-ID: <1292502934.3612.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 04:27 -0800, Paul Stewart wrote:

> > How so? After resume, mac80211 will invoke start(), add interfaces and
> > stations back, and then invoke drv_config with all flags in "changed"
> > set. Therefore, at this point, the device should be reset. Where's this
> > not working?
> 
> I haven't dug deep into it, but I can guess at a reason -- ath9k stores idle
> state in two different places -- one is meant to mirror mac80211's state,
> and the other one is internal, periodically computed from the state of all
> wiphys. The ath9k version of the fix modified the
> internal state without the mac80211 mirror. 

But at this point mac80211 doesn't care what the state is any more.

> The ath9k config() routine
> probably does nothing when called with "all changed" on resume because
> in fact, if we suspend and resume when non-idle, nothing _has_ changed
> from that perspective.

Hmm, I still don't get it. The "idle just changed" flag is set -- and
idle will actually be what it was at suspend time. If ath9k was simply
setting its own idle state on stop(), and returning to what mac80211
says when it first configures the device after start(), what would the
problem be?

>   I fear that unless ath9k gets changed more
> substantially, it really does need to be informed of IDLE changes.

I'd rather have ath9k change more than try to enforce this perfectly in
mac80211. I still think that's brittle, and every little bug in a corner
case will cause severe problems since it causes suspend/resume to fail.

johannes

