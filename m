Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1HaHxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:53:24 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314776962.2296.540.camel@cumari>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
	 <1314776396.4161.19.camel@jlt3.sipsolutions.net>
	 <1314776962.2296.540.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:53:18 +0200
Message-ID: <1314777198.4161.20.camel@jlt3.sipsolutions.net> (sfid-20110831_095327_725277_2680941D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 10:49 +0300, Luciano Coelho wrote:

> Whitelisting and blacklisting the same SSID would be one of the
> "illegal" cases that we may want to reject with -EINVAL.
> 
> But my idea was that you could do this:
> 
> MATCH={SSID=foo} and
> NOT_MATCH={BSSID=00:01:02:03:04:05}
> 
> or
> 
> MATCH={BSSID=00:01:02:03:04:05} and
> NOT_MATCH={SSID=foo}
> 
> or, making more sense:
> 
> MATCH={BSSID=00:01:02:03:04:05} and
> NOT_MATCH={MIN_RSSI=-70}
> 
> My point is that many of these combinations might not make sense, but
> generalizing the API allows for cases that *do* make sense but we have
> not thought of yet.

Good point :)

> > > I also prefer using match/not_match (couldn't find a better antonym),
> > > because "filter" is ambiguous (let-through or leave-out?).
> > 
> > agree.
> 
> We could also use a single list like this:
> 
> FILTER={1={MATCH=true, SSID=foo}, 2={MATCH=false, BSSID=...}
> 
> But then we're becoming a bit too "netfiltery". :P What do you think?

Heh. Don't really care :)

I guess the thing to keep in mind is that it's all an optimisation and
if a device can't support certain combinations it doesn't really
matter :)

johannes


