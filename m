Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:39195 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab1HaHaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:30:22 -0400
Received: by mail-ew0-f50.google.com with SMTP id 10so216821ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 00:30:20 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314771627.4161.9.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 10:30:16 +0300
Message-ID: <1314775816.2296.531.camel@cumari> (sfid-20110831_093053_645853_DF9BDF23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 08:20 +0200, Johannes Berg wrote: 
> > Other filters that come to my mind would be by security features,
> > regardless of the SSID (eg. "give me all open security SSIDs", or "I
> > only want WPA2 capable SSIDs").  The wl12xx firmware doesn't support
> > this at the moment, but I can see some potential use-cases for this.
> 
> That might be interesting. But maybe that's a filter a la my previous
> model with SSID unset and security set to open etc.? If you add that
> filter to wl12xx you'd get wakeup for every network though, so in this
> special case it might be interesting to know whether or not the device
> supports it. OTOH, if you want to connect to any open network, you'll
> need to swallow the wakeup cost anyway.
> 
> > Yet another possibility is to filter out based on signal strength
> > (wl12xx supports it).  For instance it may make sense for roaming, eg.
> > "give me only SSIDs with better signal than the one I'm connected to
> > right now").
> 
> Wouldn't that also just be an extension? Or would this not be a
> per-network filter?

Right, we can do it as an extension.


> > These are all theoretical and at least we don't have any real
> > requirement for them at the moment.  But this was more or less what I
> > was preparing for.
> 
> Ok. I think the BSSID blacklist would just be a separate attribute, I
> see no reason to have a nesting for that.

Actually, we could make the filter and blacklisting very generic.  We
can use the same attributes for both.  The only difference would be that
the former would include anything that matches and the latter would
exclude anything that matches.


> > In any case, I think for the filtering, we can implement some kind of
> > wildcard too.  We could have a bit in the filter saying that it's a
> > wildcard, so any results that start with the supplied bytes would pass
> > through.
> > 
> > In this case, I think the same rule of not having SSIDs that don't fit
> > the filters would still apply.  For instance, if you pass only "DIRECT-"
> > for the probe_reqs, without broadcast, it doesn't make sense to have a
> > filter that only matches "FOOBAR".
> 
> True. Do we really want to add this wildcard complexity to filters
> though? Is it really worth it? OTOH, I guess you'd need it for something
> like iPass.

Yeah, it was the hotspot case that I had in mind.  But since we don't
need this right now, let's leave it out.  It can be added easily later
on.


> > > > I think we can still keep it like this and improve the filter list by
> > > > adding a "wildcard" attribute if you want to filter on P2P wildcards?
> > > > 
> > > > Now back to "Maybe cfg80211 should apply that rule", I thought about it,
> > > > but decided to keep it hw-specific, since I don't know what other HW
> > > > will want to do. ;) But I can add it to cfg80211 if you like.
> > > 
> > > Is it something you _need_ to make your firmware happy? Otherwise I
> > > think I'd rather leave it out completely :)
> > 
> > Kind of, yes.  Actually our firmware is "smart" in the scheduled scan
> > feature.  You pass a single list of SSIDs to it with attributes such as
> > open/hidden and it will by itself decide whether to send a probe_req for
> > it or not.  And it will filter for those SSIDs regardless of whether a
> > probe_req was sent.  It's a bit more complicated than that, but not
> > really relevant here.
> > 
> > I could probably manage without this limitation in the API, but then it
> > would be difficult to handle the max_ssids and max_filter_ssids
> > limitations (the limitation in our case actually applies to a sum of the
> > two).  If we have the limitation in the API, then the filter list will
> > always be a superset of the SSID list, which makes it simpler. ;)
> 
> OK :)

I'll add the check in cfg80211 then.  There are probably other
combinations that don't make sense either (eg. sending an SSID in the
probes and blacklisting it).


> > > Yeah of course they don't fit but see how we have a separate policy for
> > > key attributes for example.
> > 
> > Sure, I tried to look at the key attributes and reg stuff, but they
> > actually use a different nl callback.  I didn't see how to use it for
> > the filter stuff, which is actually a subset of attributes for the
> > existing scan attributes.  Anyway, I'll check the nl API more carefully
> > and fix this.  I probably need to use nla_parse() and such.
> 
> > > Oh. Ok you're thinking of this completely differently than I am. With
> > > the filtering I'm looking at (see above) the way to make this make sense
> > > is to do
> > > 
> > > FILTERS={1={SSID=foo, ...}, 2={SSID=bar, ...}, ... }
> > 
> > This makes sense too, but if we want to support other kinds of filters
> > (such as the ones I mentioned above), we need to have at least the type
> > of filter for each:
> > 
> > FILTERS={1={type=SSID, SSID=foo},
> > 2={type=SSID, SSID=bar},
> > 3={type=RSSI, min_rssi=-70},
> > 4={type=BLACKLIST, BSSID=bssid1},
> > 5={type=BLACKLIST, BSSID=bssid2},
> > ...}
> > 
> > What I was originally thinking of implementing was this: 
> > 
> > FILTERS={SSID={SSID_LIST={foo, bar, ...}},
> > 	 RSSI={min_rssi},
> > 	 BLACKLIST={BSSID_LIST={bssid1, bssid2, ...}},
> > 	 ...}
> > 
> > ...and the SSID_LIST elements could be foo={SSID="FOO", security=WPA2},
> > bar={SSID="bar", security=OPEN}, for example.  Though I'm not sure this
> > is necessary (see my question earlier).
> 
> I wouldn't bother nesting those though, so I'd do
> 
> NETWORK_FILTER=(1=(SSID=...), ...)
> BSSID_BLACKLIST=(1=...,2=...,...)
> etc.
> That way only the network attributes that belong to a "profile" like
> SSID, security, ... are nested.

Yeah, this is okay.  To make it more generic though, should we make it
like this?

MATCH={1={SSID=foo, SECURITY=open, BSSID=00:01:02:03:04:05, ...}, 2={...}}
NOT_MATCH={1={SSID=bar, ...}, 2={BSSID=00:02:03:04:05:06, ...}, ...}

Meaning that we just have MATCH/NO_MATCH and use the same set of
attributes for both? Maybe someone will want to blacklist an SSID or
other attributes too.  Who wants to see APs called "Free open wifi"? :D

I also prefer using match/not_match (couldn't find a better antonym),
because "filter" is ambiguous (let-through or leave-out?).

-- 
Cheers,
Luca.

