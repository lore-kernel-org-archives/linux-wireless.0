Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1H3QJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 12:09:22 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314718038.2296.460.camel@cumari>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 18:09:17 +0200
Message-ID: <1314720557.4011.41.camel@jlt3.sipsolutions.net> (sfid-20110830_180925_469541_54BC6195)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 18:27 +0300, Luciano Coelho wrote:
> On Tue, 2011-08-30 at 16:16 +0200, Johannes Berg wrote: 
> > On Tue, 2011-08-30 at 15:39 +0300, Luciano Coelho wrote:
> > 
> > > + * @NL80211_ATTR_MAX_FILTER_SSIDS: number of SSIDs you can use as
> > > + *	filters in a scheduled scan request, a wiphy attribute.
> > 
> > When we add more filters, hopefully the number of filters will stay be
> > this? IOW, shouldn't this be "MAX_FILTERS"? Basically, each filter can
> > be thought of as a profile, and a profile can contain various attributes
> > that must match, I think?
> 
> Hmmm... I think we shouldn't limit the number of total filters, but the
> limits of each kind of filtering.  The firmwares will most likely have
> limitation on how many SSIDs can be added to the filter list.  In our
> case, we can have max 8 (soon 16) SSIDs in the let-through list.  So I
> think this should remain.  Maybe it could be moved to a
> FILTER_CAPABILITIES nested attribute instead?

Well, so the filters I see happening will be along the lines of:
	SSID 'foo' with WPA2-PSK and CCMP

(because that's what the user configured).

Are you envisioning other filters that make sense w/o an SSID?

> > Maybe cfg80211 should just apply that rule anyway? But is that really
> > true anyway? Say "DIRECT-" as the P2P wildcard ...
> 
> It would still be true for wildcard filtering, wouldn't it? In wildcard
> filtering, you can't pass "DIRECT-" in the SSID list, because that would
> be added to the probe requests.  I guess in the P2P wildcard case, we
> would want to issue wildcard probe requests (ie. with zero-length SSID)?

No, "DIRECT-" *is*  the P2P wildcard, any DIRECT-XY GO will reply to
"DIRECT-". You might want "DIRECT-" in the SSID list even if the GO
you're interested in is "DIRECT-6z".

> I think we can still keep it like this and improve the filter list by
> adding a "wildcard" attribute if you want to filter on P2P wildcards?
> 
> Now back to "Maybe cfg80211 should apply that rule", I thought about it,
> but decided to keep it hw-specific, since I don't know what other HW
> will want to do. ;) But I can add it to cfg80211 if you like.

Is it something you _need_ to make your firmware happy? Otherwise I
think I'd rather leave it out completely :)

> > > + * @filter_ssids: SSIDs to pass to the host (others are filtered out).
> > > + * 	If ommited, no filtering is done.
> > > + * @n_filter_ssids: number of filter SSIDs
> > 
> > Maybe we should create a filter struct right away and use that with
> > filters/n_filters?
> 
> I can do that too.  This is not really affected by the NL80211 API and,
> since we only have SSID filtering so far, I decided not to put it in a
> struct yet (this could be changed later).  But I can also add it now, no
> problem.

Ok, I think I'd prefer that, I know it'll only be a short while until we
add more to it and it would be easier to not have to modify wl12xx at
that time.

> > > +	[NL80211_ATTR_SCHED_SCAN_FILTER] = { .type = NLA_NESTED },
> > >  };
> > 
> > Don't we need a policy for the filter attributes?
> 
> Hmmm, right.  I missed that.  I have made the filter attributes as
> sub-attributes that must be inside the filter nest, so they don't really
> fit here.  But I'll figure out how to add policies for them.

Yeah of course they don't fit but see how we have a separate policy for
key attributes for example.

> > > +	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
> > > +		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
> > > +				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
> > > +		if (attr)
> > > +			nla_for_each_nested(attr2, attr, tmp)
> > > +				n_filter_ssids++;
> > > +	}
> > > +
> > > +	if (n_filter_ssids > wiphy->max_filter_ssids)
> > > +		return -EINVAL;
> > 
> > That looks a little odd. What does that even do? I don't understand the
> > find_nested at all.
> 
> The idea is that the filter attributes are inside the nested
> NL80211_ATTR_SCHED_SCAN_FILTER.  So, what I do here is get the filter
> SSID attribute from inside the filter nest.  The SSID filter attribute
> itself is also a nest (an array) and that's what I go through in the
> nla_for_each_nested().
> 
> My idea is that we have this kind of struct:
> 
> SCHED_SCAN_START(ssids[], filter{ssid_filters[], bssid_filters[], ...}, ...)
> 
> Anyway, I'll recheck if there is a simpler (and maybe correct? ;) way of
> doing this.

Oh. Ok you're thinking of this completely differently than I am. With
the filtering I'm looking at (see above) the way to make this make sense
is to do

FILTERS={1={SSID=foo, ...}, 2={SSID=bar, ...}, ... }

IOW have filters be a nested attribute that contains an array that you
walk with for_each_nested() (the attribute ID there 1,2,.. doesn't
matter) and then each of those is nested again containing the filter
attributes. IOW, FILTERS becomes a list of profiles.

johannes

