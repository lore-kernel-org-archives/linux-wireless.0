Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1HaGUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:20:35 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314770941.2296.507.camel@cumari>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:20:26 +0200
Message-ID: <1314771627.4161.9.camel@jlt3.sipsolutions.net> (sfid-20110831_082039_210792_5CD07AC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:09 +0300, Luciano Coelho wrote:

> > Well, so the filters I see happening will be along the lines of:
> > 	SSID 'foo' with WPA2-PSK and CCMP
> > 
> > (because that's what the user configured).
> 
> Do you see any real advantage in passing the security parameters in the
> search? Of course this would filter out a bit more, but in real life how
> much would we gain? I guess reporting all matches for that SSID
> (regardless of the security parameters) would already be good enough.

I don't really, but it seems that some people still want it.

> If we add these extra parameters, then we have to tell userspace whether
> the device supports it or not (wl12xx at the moment doesn't).

I thought about this, but I'm not convinced we really need to. A device
that doesn't support a given filter can always ignore it and wake up
even when the AP doesn't match all filters, ie. if I ask for
notification on (SSID="foo", WPA2-PSK, CCMP) and get notifications for
SSID="foo", I can still handle that. It's just not as efficient in the
corner case that there are lots of "foo" APs with different settings.

> > Are you envisioning other filters that make sense w/o an SSID?
> 
> I was thinking about other filters such as BSSID blacklisting that you
> mentioned.  If we blacklist a BSSID, we probably don't need to care
> which SSID it's advertising.

Indeed.

> Other filters that come to my mind would be by security features,
> regardless of the SSID (eg. "give me all open security SSIDs", or "I
> only want WPA2 capable SSIDs").  The wl12xx firmware doesn't support
> this at the moment, but I can see some potential use-cases for this.

That might be interesting. But maybe that's a filter a la my previous
model with SSID unset and security set to open etc.? If you add that
filter to wl12xx you'd get wakeup for every network though, so in this
special case it might be interesting to know whether or not the device
supports it. OTOH, if you want to connect to any open network, you'll
need to swallow the wakeup cost anyway.

> Yet another possibility is to filter out based on signal strength
> (wl12xx supports it).  For instance it may make sense for roaming, eg.
> "give me only SSIDs with better signal than the one I'm connected to
> right now").

Wouldn't that also just be an extension? Or would this not be a
per-network filter?

> These are all theoretical and at least we don't have any real
> requirement for them at the moment.  But this was more or less what I
> was preparing for.

Ok. I think the BSSID blacklist would just be a separate attribute, I
see no reason to have a nesting for that.

> In any case, I think for the filtering, we can implement some kind of
> wildcard too.  We could have a bit in the filter saying that it's a
> wildcard, so any results that start with the supplied bytes would pass
> through.
> 
> In this case, I think the same rule of not having SSIDs that don't fit
> the filters would still apply.  For instance, if you pass only "DIRECT-"
> for the probe_reqs, without broadcast, it doesn't make sense to have a
> filter that only matches "FOOBAR".

True. Do we really want to add this wildcard complexity to filters
though? Is it really worth it? OTOH, I guess you'd need it for something
like iPass.

> > > I think we can still keep it like this and improve the filter list by
> > > adding a "wildcard" attribute if you want to filter on P2P wildcards?
> > > 
> > > Now back to "Maybe cfg80211 should apply that rule", I thought about it,
> > > but decided to keep it hw-specific, since I don't know what other HW
> > > will want to do. ;) But I can add it to cfg80211 if you like.
> > 
> > Is it something you _need_ to make your firmware happy? Otherwise I
> > think I'd rather leave it out completely :)
> 
> Kind of, yes.  Actually our firmware is "smart" in the scheduled scan
> feature.  You pass a single list of SSIDs to it with attributes such as
> open/hidden and it will by itself decide whether to send a probe_req for
> it or not.  And it will filter for those SSIDs regardless of whether a
> probe_req was sent.  It's a bit more complicated than that, but not
> really relevant here.
> 
> I could probably manage without this limitation in the API, but then it
> would be difficult to handle the max_ssids and max_filter_ssids
> limitations (the limitation in our case actually applies to a sum of the
> two).  If we have the limitation in the API, then the filter list will
> always be a superset of the SSID list, which makes it simpler. ;)

OK :)

> > Yeah of course they don't fit but see how we have a separate policy for
> > key attributes for example.
> 
> Sure, I tried to look at the key attributes and reg stuff, but they
> actually use a different nl callback.  I didn't see how to use it for
> the filter stuff, which is actually a subset of attributes for the
> existing scan attributes.  Anyway, I'll check the nl API more carefully
> and fix this.  I probably need to use nla_parse() and such.

> > Oh. Ok you're thinking of this completely differently than I am. With
> > the filtering I'm looking at (see above) the way to make this make sense
> > is to do
> > 
> > FILTERS={1={SSID=foo, ...}, 2={SSID=bar, ...}, ... }
> 
> This makes sense too, but if we want to support other kinds of filters
> (such as the ones I mentioned above), we need to have at least the type
> of filter for each:
> 
> FILTERS={1={type=SSID, SSID=foo},
> 2={type=SSID, SSID=bar},
> 3={type=RSSI, min_rssi=-70},
> 4={type=BLACKLIST, BSSID=bssid1},
> 5={type=BLACKLIST, BSSID=bssid2},
> ...}
> 
> What I was originally thinking of implementing was this: 
> 
> FILTERS={SSID={SSID_LIST={foo, bar, ...}},
> 	 RSSI={min_rssi},
> 	 BLACKLIST={BSSID_LIST={bssid1, bssid2, ...}},
> 	 ...}
> 
> ...and the SSID_LIST elements could be foo={SSID="FOO", security=WPA2},
> bar={SSID="bar", security=OPEN}, for example.  Though I'm not sure this
> is necessary (see my question earlier).

I wouldn't bother nesting those though, so I'd do

NETWORK_FILTER=(1=(SSID=...), ...)
BSSID_BLACKLIST=(1=...,2=...,...)
etc.
That way only the network attributes that belong to a "profile" like
SSID, security, ... are nested.

johannes

