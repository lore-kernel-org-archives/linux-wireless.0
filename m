Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58332 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241Ab1HaGJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:09:07 -0400
Received: by mail-ew0-f50.google.com with SMTP id 10so193461ewy.9
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 23:09:05 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314720557.4011.41.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:09:01 +0300
Message-ID: <1314770941.2296.507.camel@cumari> (sfid-20110831_080919_167184_724EBEA8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 18:09 +0200, Johannes Berg wrote: 
> On Tue, 2011-08-30 at 18:27 +0300, Luciano Coelho wrote:
> > On Tue, 2011-08-30 at 16:16 +0200, Johannes Berg wrote: 
> > > On Tue, 2011-08-30 at 15:39 +0300, Luciano Coelho wrote:
> > > 
> > > > + * @NL80211_ATTR_MAX_FILTER_SSIDS: number of SSIDs you can use as
> > > > + *	filters in a scheduled scan request, a wiphy attribute.
> > > 
> > > When we add more filters, hopefully the number of filters will stay be
> > > this? IOW, shouldn't this be "MAX_FILTERS"? Basically, each filter can
> > > be thought of as a profile, and a profile can contain various attributes
> > > that must match, I think?
> > 
> > Hmmm... I think we shouldn't limit the number of total filters, but the
> > limits of each kind of filtering.  The firmwares will most likely have
> > limitation on how many SSIDs can be added to the filter list.  In our
> > case, we can have max 8 (soon 16) SSIDs in the let-through list.  So I
> > think this should remain.  Maybe it could be moved to a
> > FILTER_CAPABILITIES nested attribute instead?
> 
> Well, so the filters I see happening will be along the lines of:
> 	SSID 'foo' with WPA2-PSK and CCMP
> 
> (because that's what the user configured).

Do you see any real advantage in passing the security parameters in the
search? Of course this would filter out a bit more, but in real life how
much would we gain? I guess reporting all matches for that SSID
(regardless of the security parameters) would already be good enough.

If we add these extra parameters, then we have to tell userspace whether
the device supports it or not (wl12xx at the moment doesn't).


> Are you envisioning other filters that make sense w/o an SSID?

I was thinking about other filters such as BSSID blacklisting that you
mentioned.  If we blacklist a BSSID, we probably don't need to care
which SSID it's advertising.

Other filters that come to my mind would be by security features,
regardless of the SSID (eg. "give me all open security SSIDs", or "I
only want WPA2 capable SSIDs").  The wl12xx firmware doesn't support
this at the moment, but I can see some potential use-cases for this.

Yet another possibility is to filter out based on signal strength
(wl12xx supports it).  For instance it may make sense for roaming, eg.
"give me only SSIDs with better signal than the one I'm connected to
right now").

These are all theoretical and at least we don't have any real
requirement for them at the moment.  But this was more or less what I
was preparing for.


> > > Maybe cfg80211 should just apply that rule anyway? But is that really
> > > true anyway? Say "DIRECT-" as the P2P wildcard ...
> > 
> > It would still be true for wildcard filtering, wouldn't it? In wildcard
> > filtering, you can't pass "DIRECT-" in the SSID list, because that would
> > be added to the probe requests.  I guess in the P2P wildcard case, we
> > would want to issue wildcard probe requests (ie. with zero-length SSID)?
> 
> No, "DIRECT-" *is*  the P2P wildcard, any DIRECT-XY GO will reply to
> "DIRECT-". You might want "DIRECT-" in the SSID list even if the GO
> you're interested in is "DIRECT-6z".

Ah, right, I had forgotten how this works.  I *really* need to find the
time to study P2P a bit more. :)

In any case, I think for the filtering, we can implement some kind of
wildcard too.  We could have a bit in the filter saying that it's a
wildcard, so any results that start with the supplied bytes would pass
through.

In this case, I think the same rule of not having SSIDs that don't fit
the filters would still apply.  For instance, if you pass only "DIRECT-"
for the probe_reqs, without broadcast, it doesn't make sense to have a
filter that only matches "FOOBAR".


> > I think we can still keep it like this and improve the filter list by
> > adding a "wildcard" attribute if you want to filter on P2P wildcards?
> > 
> > Now back to "Maybe cfg80211 should apply that rule", I thought about it,
> > but decided to keep it hw-specific, since I don't know what other HW
> > will want to do. ;) But I can add it to cfg80211 if you like.
> 
> Is it something you _need_ to make your firmware happy? Otherwise I
> think I'd rather leave it out completely :)

Kind of, yes.  Actually our firmware is "smart" in the scheduled scan
feature.  You pass a single list of SSIDs to it with attributes such as
open/hidden and it will by itself decide whether to send a probe_req for
it or not.  And it will filter for those SSIDs regardless of whether a
probe_req was sent.  It's a bit more complicated than that, but not
really relevant here.

I could probably manage without this limitation in the API, but then it
would be difficult to handle the max_ssids and max_filter_ssids
limitations (the limitation in our case actually applies to a sum of the
two).  If we have the limitation in the API, then the filter list will
always be a superset of the SSID list, which makes it simpler. ;)


> > > > + * @filter_ssids: SSIDs to pass to the host (others are filtered out).
> > > > + * 	If ommited, no filtering is done.
> > > > + * @n_filter_ssids: number of filter SSIDs
> > > 
> > > Maybe we should create a filter struct right away and use that with
> > > filters/n_filters?
> > 
> > I can do that too.  This is not really affected by the NL80211 API and,
> > since we only have SSID filtering so far, I decided not to put it in a
> > struct yet (this could be changed later).  But I can also add it now, no
> > problem.
> 
> Ok, I think I'd prefer that, I know it'll only be a short while until we
> add more to it and it would be easier to not have to modify wl12xx at
> that time.

Indeed sounds better.  I'll do it.


> > > > +	[NL80211_ATTR_SCHED_SCAN_FILTER] = { .type = NLA_NESTED },
> > > >  };
> > > 
> > > Don't we need a policy for the filter attributes?
> > 
> > Hmmm, right.  I missed that.  I have made the filter attributes as
> > sub-attributes that must be inside the filter nest, so they don't really
> > fit here.  But I'll figure out how to add policies for them.
> 
> Yeah of course they don't fit but see how we have a separate policy for
> key attributes for example.

Sure, I tried to look at the key attributes and reg stuff, but they
actually use a different nl callback.  I didn't see how to use it for
the filter stuff, which is actually a subset of attributes for the
existing scan attributes.  Anyway, I'll check the nl API more carefully
and fix this.  I probably need to use nla_parse() and such.


> > > > +	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
> > > > +		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
> > > > +				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
> > > > +		if (attr)
> > > > +			nla_for_each_nested(attr2, attr, tmp)
> > > > +				n_filter_ssids++;
> > > > +	}
> > > > +
> > > > +	if (n_filter_ssids > wiphy->max_filter_ssids)
> > > > +		return -EINVAL;
> > > 
> > > That looks a little odd. What does that even do? I don't understand the
> > > find_nested at all.
> > 
> > The idea is that the filter attributes are inside the nested
> > NL80211_ATTR_SCHED_SCAN_FILTER.  So, what I do here is get the filter
> > SSID attribute from inside the filter nest.  The SSID filter attribute
> > itself is also a nest (an array) and that's what I go through in the
> > nla_for_each_nested().
> > 
> > My idea is that we have this kind of struct:
> > 
> > SCHED_SCAN_START(ssids[], filter{ssid_filters[], bssid_filters[], ...}, ...)
> > 
> > Anyway, I'll recheck if there is a simpler (and maybe correct? ;) way of
> > doing this.
> 
> Oh. Ok you're thinking of this completely differently than I am. With
> the filtering I'm looking at (see above) the way to make this make sense
> is to do
> 
> FILTERS={1={SSID=foo, ...}, 2={SSID=bar, ...}, ... }

This makes sense too, but if we want to support other kinds of filters
(such as the ones I mentioned above), we need to have at least the type
of filter for each:

FILTERS={1={type=SSID, SSID=foo},
2={type=SSID, SSID=bar},
3={type=RSSI, min_rssi=-70},
4={type=BLACKLIST, BSSID=bssid1},
5={type=BLACKLIST, BSSID=bssid2},
...}

What I was originally thinking of implementing was this: 

FILTERS={SSID={SSID_LIST={foo, bar, ...}},
	 RSSI={min_rssi},
	 BLACKLIST={BSSID_LIST={bssid1, bssid2, ...}},
	 ...}

...and the SSID_LIST elements could be foo={SSID="FOO", security=WPA2},
bar={SSID="bar", security=OPEN}, for example.  Though I'm not sure this
is necessary (see my question earlier).


> IOW have filters be a nested attribute that contains an array that you
> walk with for_each_nested() (the attribute ID there 1,2,.. doesn't
> matter) and then each of those is nested again containing the filter
> attributes. IOW, FILTERS becomes a list of profiles.

I see.  I'll do something like this and get rid of the
nla_find_nested().  But first we need to agree on the data structs. :)

Too much discussion for my round in this discussion, I'll release and
let you express your thoughts too. ;)

-- 
Cheers,
Luca.

