Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1AQJfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 04:35:31 -0500
Subject: Re: Fwd: [PATCH 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-7-git-send-email-arik@wizery.com>
	 <1295167829.3574.10.camel@jlt3.sipsolutions.net>
	 <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
	 <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:35:29 +0100
Message-ID: <1295256929.3726.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 23:53 +0200, Arik Nemtsov wrote:

> > Also, I'm worried about races between this and RX. All of the RX path
> > assumes that it is running at the same time. The ap_sta_ps_{start,end}
> > functions won't be called from the RX path when the flag is set, and
> > this is dependent on setting the flag, but is there really nothing in
> > them that could race?
> 
> They might race if the user is not careful. On a SMP machine a user
> can call ieee80211_rx() and ap_sta_ps_start() from two different
> workqueues for example.
> I can add an explicit mutex, but a documentation warning will suffice here no?

Well, a mutex won't be possible, and we don't do "code path locking"
anyway. I'd appreciate if you could actually see which things would
potentially race -- I took a brief look into these functions and it
didn't look like there are actually races except of these two against
each other maybe?

> > Finally, I'm worried about this calling back into the driver's
> > sta_notify callback. If that is to remain that way, it needs to be
> > *very* clearly documented, I'd *much* prefer it not doing that but
> > handing off to a work struct or so internally.
> >
> 
> sta_notify is pretty useless when the low level driver calls toggles
> the PS-mode by itself. How about I simply remove the call to
> sta_notify in case IEEE80211_HW_AP_LINK_PS is set?
> If a low level driver needs to do some deferred processing after a
> PS-mode transition, it can queue a work on its own..

Yes, that's probably a good idea -- but definitely needs to be
documented in the sta_notify docs. OTOH, mac80211 de-bounces sta_notify
in a way. Maybe that needs to be done for the function call as well,
maybe via a return value?

johannes

