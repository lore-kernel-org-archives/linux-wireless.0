Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:60284 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754615Ab1HaHt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:49:28 -0400
Received: by mail-ew0-f42.google.com with SMTP id 2so301957ewy.15
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 00:49:25 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314776396.4161.19.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
	 <1314776396.4161.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 10:49:22 +0300
Message-ID: <1314776962.2296.540.camel@cumari> (sfid-20110831_094931_318084_461A0F86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:39 +0200, Johannes Berg wrote: 
> On Wed, 2011-08-31 at 10:30 +0300, Luciano Coelho wrote:
> 
> > > Ok. I think the BSSID blacklist would just be a separate attribute, I
> > > see no reason to have a nesting for that.
> > 
> > Actually, we could make the filter and blacklisting very generic.  We
> > can use the same attributes for both.  The only difference would be that
> > the former would include anything that matches and the latter would
> > exclude anything that matches.
> 
> Hm, true, but does it really make sense to blacklist SSIDs when we have
> a whitelist for them? Or would you want to whitelist a wildcard and then
> blacklist a specific one?

Whitelisting and blacklisting the same SSID would be one of the
"illegal" cases that we may want to reject with -EINVAL.

But my idea was that you could do this:

MATCH={SSID=foo} and
NOT_MATCH={BSSID=00:01:02:03:04:05}

or

MATCH={BSSID=00:01:02:03:04:05} and
NOT_MATCH={SSID=foo}

or, making more sense:

MATCH={BSSID=00:01:02:03:04:05} and
NOT_MATCH={MIN_RSSI=-70}

My point is that many of these combinations might not make sense, but
generalizing the API allows for cases that *do* make sense but we have
not thought of yet.


> > I also prefer using match/not_match (couldn't find a better antonym),
> > because "filter" is ambiguous (let-through or leave-out?).
> 
> agree.

We could also use a single list like this:

FILTER={1={MATCH=true, SSID=foo}, 2={MATCH=false, BSSID=...}

But then we're becoming a bit too "netfiltery". :P What do you think?

-- 
Cheers,
Luca.

