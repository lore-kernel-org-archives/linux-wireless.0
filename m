Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ADRBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 12:01:40 -0500
Subject: Re: [PATCH 2/2] mac80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <20120104165144.GA3381@pandem0nium>
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1324304099-18327-3-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1325600690.3316.12.camel@jlt3.sipsolutions.net>
	 <20120104165144.GA3381@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 18:01:38 +0100
Message-ID: <1325696498.3339.33.camel@jlt3.sipsolutions.net> (sfid-20120104_180144_217383_8DEA2E9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Maybe we could update all stations in the slow-path (changes in the HT
> > mask) and then just use the already masked version in the sta entry in
> > the fastpath here?
> 
> You are right that this definitly adds some load on the fastpath (Although
> I don't know how much the compiler optimizes here anyway, its only 10 bytes
> which are set and masked).
> 
> Currently I see two approaches here:
> 
> 1.) move the masking into the station handling code (when a new station joins).
>     We would also need to iterate over the connected station when changing
>     the mcs_mask while the interface is up.
>     --> this will probably need to change at quite some palces and might be race-risky

Yeah this is what I was thinking of, but you could well be right that it
might be quite hard to do.

> 2.) keep the masking in the rate_control_get_rate() function, but mask only
>     once (first time) and keep the result in the station struct. Next time we
>     enter it, we use the already masked result. We could then use a flag to
>     remember that we already computed the mask and just use it, and another
>     flag to signalize if the mcs_mask was modified externally
>     --> this is not racy and rather simple, but adds some flags

I don't really like that, it's just as much complexity really and you
need to still iterate all stations to invalidate the flag if mcs_mask
was changed.

Better just keep it as is unless we find it's a problem.

johannes

