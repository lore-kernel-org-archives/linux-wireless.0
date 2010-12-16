Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab0LPMxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:53:41 -0500
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
In-Reply-To: <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	 <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	 <1292499024.3612.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
	 <1292501047.3612.9.camel@jlt3.sipsolutions.net>
	 <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
	 <1292502934.3612.15.camel@jlt3.sipsolutions.net>
	 <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 13:53:40 +0100
Message-ID: <1292504020.3612.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 04:46 -0800, Paul Stewart wrote:

> >> I haven't dug deep into it, but I can guess at a reason -- ath9k stores idle
> >> state in two different places -- one is meant to mirror mac80211's state,
> >> and the other one is internal, periodically computed from the state of all
> >> wiphys. The ath9k version of the fix modified the
> >> internal state without the mac80211 mirror.
> >
> > But at this point mac80211 doesn't care what the state is any more.
> 
> Huh?  I'm not sure I understand this statement.  If mac80211 suspends
> and resumes with open_count > 1 (e.g, with an associated STA), I argue
> mac80211 _does_ care what the state is.  In fact, although we called
> stop() on the driver, there's every expectation that on resume any state
> stored on suspend is recovered.  Are you not assuming this?

Not really -- the driver may throw away all internal state, mac80211
will (attempt to) restore it all through drv_config() with changed = ~0.
Evidently ath9k has some magic that makes this fail?

johannes

