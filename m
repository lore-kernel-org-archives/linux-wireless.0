Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38138 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab1H3P1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 11:27:24 -0400
Received: by mail-bw0-f50.google.com with SMTP id zu5so4806411bkb.9
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 08:27:22 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314713812.4011.33.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 18:27:18 +0300
Message-ID: <1314718038.2296.460.camel@cumari> (sfid-20110830_172727_801166_0219844A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 16:16 +0200, Johannes Berg wrote: 
> On Tue, 2011-08-30 at 15:39 +0300, Luciano Coelho wrote:
> 
> > + * @NL80211_ATTR_MAX_FILTER_SSIDS: number of SSIDs you can use as
> > + *	filters in a scheduled scan request, a wiphy attribute.
> 
> When we add more filters, hopefully the number of filters will stay be
> this? IOW, shouldn't this be "MAX_FILTERS"? Basically, each filter can
> be thought of as a profile, and a profile can contain various attributes
> that must match, I think?

Hmmm... I think we shouldn't limit the number of total filters, but the
limits of each kind of filtering.  The firmwares will most likely have
limitation on how many SSIDs can be added to the filter list.  In our
case, we can have max 8 (soon 16) SSIDs in the let-through list.  So I
think this should remain.  Maybe it could be moved to a
FILTER_CAPABILITIES nested attribute instead?


> > + * @NL80211_ATTR_SCHED_SCAN_FILTER: Nested attribute with various
> > + *	types of filtering to be used with scheduled scans.
> > + *	If @NL80211_ATTR_SCAN_SSIDS is passed with values that are not
> > + *	included in the filter, the driver may return -EINVAL, since
> > + *	it doesn't make sense to send probe requests with SSIDs that
> > + *	will be filtered out.  This doesn't apply to the wildcard SSID.
> > + *	If ommited, no filtering is done.
> 
> Maybe cfg80211 should just apply that rule anyway? But is that really
> true anyway? Say "DIRECT-" as the P2P wildcard ...

It would still be true for wildcard filtering, wouldn't it? In wildcard
filtering, you can't pass "DIRECT-" in the SSID list, because that would
be added to the probe requests.  I guess in the P2P wildcard case, we
would want to issue wildcard probe requests (ie. with zero-length SSID)?

I think we can still keep it like this and improve the filter list by
adding a "wildcard" attribute if you want to filter on P2P wildcards?

Now back to "Maybe cfg80211 should apply that rule", I thought about it,
but decided to keep it hw-specific, since I don't know what other HW
will want to do. ;) But I can add it to cfg80211 if you like.


> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > index a37f264..a3e58ff 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -882,6 +882,9 @@ struct cfg80211_scan_request {
> >   * @interval: interval between each scheduled scan cycle
> >   * @ie: optional information element(s) to add into Probe Request or %NULL
> >   * @ie_len: length of ie in octets
> > + * @filter_ssids: SSIDs to pass to the host (others are filtered out).
> > + * 	If ommited, no filtering is done.
> > + * @n_filter_ssids: number of filter SSIDs
> 
> Maybe we should create a filter struct right away and use that with
> filters/n_filters?

I can do that too.  This is not really affected by the NL80211 API and,
since we only have SSID filtering so far, I decided not to put it in a
struct yet (this could be changed later).  But I can also add it now, no
problem.


> > +++ b/net/wireless/nl80211.c
> > @@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
> >  					 .len = IEEE80211_MAX_DATA_LEN },
> >  	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
> >  					 .len = IEEE80211_MAX_DATA_LEN },
> > +	[NL80211_ATTR_SCHED_SCAN_FILTER] = { .type = NLA_NESTED },
> >  };
> 
> Don't we need a policy for the filter attributes?

Hmmm, right.  I missed that.  I have made the filter attributes as
sub-attributes that must be inside the filter nest, so they don't really
fit here.  But I'll figure out how to add policies for them.


> > +	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
> > +		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
> > +				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
> > +		if (attr)
> > +			nla_for_each_nested(attr2, attr, tmp)
> > +				n_filter_ssids++;
> > +	}
> > +
> > +	if (n_filter_ssids > wiphy->max_filter_ssids)
> > +		return -EINVAL;
> 
> That looks a little odd. What does that even do? I don't understand the
> find_nested at all.

The idea is that the filter attributes are inside the nested
NL80211_ATTR_SCHED_SCAN_FILTER.  So, what I do here is get the filter
SSID attribute from inside the filter nest.  The SSID filter attribute
itself is also a nest (an array) and that's what I go through in the
nla_for_each_nested().

My idea is that we have this kind of struct:

SCHED_SCAN_START(ssids[], filter{ssid_filters[], bssid_filters[], ...}, ...)

Anyway, I'll recheck if there is a simpler (and maybe correct? ;) way of
doing this.

Thanks for your review, v2 is coming soon. 


-- 
Cheers,
Luca.

