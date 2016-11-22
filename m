Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751018AbcKVF7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 00:59:06 -0500
Message-ID: <1479794340.2517.34.camel@coelho.fi> (sfid-20161122_070107_634127_62C354D5)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 Nov 2016 07:59:00 +0200
In-Reply-To: <a222d5d1-408d-fd96-4cb9-896f6a9dab59@broadcom.com>
References: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
         <dffc5408-3337-32e7-0998-3ae8a5199fa9@broadcom.com>
         <e176de78-6ab3-ad83-5e9d-082ceb85d786@broadcom.com>
         <1479740918.2517.28.camel@coelho.fi>
         <a222d5d1-408d-fd96-4cb9-896f6a9dab59@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: scheduled scan interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,
On Mon, 2016-11-21 at 20:34 +0100, Arend Van Spriel wrote:
> On 21-11-2016 16:08, Luca Coelho wrote:
> > Hi Arend,
> > 
> > On Mon, 2016-11-21 at 13:03 +0100, Arend Van Spriel wrote:
> > > On 21-11-2016 12:30, Arend Van Spriel wrote:
> > > > On 21-11-2016 12:19, Arend Van Spriel wrote:
> > > > > Hi Johannes, Luca,
> > > > > 
> > > > > The gscan work made me look at scheduled scan and the implementation of
> > > > > it in brcmfmac. The driver ignored the interval parameter from
> > > > > user-space. Now I am fixing that. One thing is that our firmware has a
> > > > > minimum interval which can not be indicated in struct wiphy. The other
> > > > > issue is how the maximum interval is used in the nl80211.c.
> > > > > 
> > > > > In nl80211_parse_sched_scan_plans() it is used against value passed in
> > > > > NL80211_ATTR_SCHED_SCAN_INTERVAL and NL80211_SCHED_SCAN_PLAN_INTERVAL.
> > > > > For the first one it caps the value to the maximum, but for the second
> > > > > one it returns -EINVAL. I suspect this is done because maximum interval
> > > > > was introduced with schedule scan plans, but it feels inconsistent.
> > > > 
> > > > It also maybe simply wrong to cap. At least brcmfmac does not set the
> > > > maximum so it will always get interval being zero. Maybe better to do:
> > > > 
> > > > 		if (wiphy->max_sched_scan_plan_interval &&
> > > > 		    request->scan_plans[0].interval >
> > > > 		    wiphy->max_sched_scan_plan_interval)
> > > > 			return -EINVAL;
> > > > 
> > > > > Thoughts?
> > > 
> > > Digging deeper. Looking at v4.3 before introduction of sched_scan_plans.
> > > struct sched_scan_request::interval was specified in milliseconds! Below
> > > the drivers that I see having scheduled scan support:
> > > 
> > > iwlmvm: cap interval, convert to seconds.
> > > ath6kl: cap to 1sec minimum, no max check, convert to seconds.
> > > wl12xx: no checking in driver, fw need milliseconds.
> > > wl18xx: no checking in driver, fw need milliseconds.
> > > 
> > > The milliseconds conversion seems to be taken care of by multiplying
> > > with MSEC_PER_SEC in wl{12,18}xx drivers.
> > > 
> > > It seems in 4.8 only iwlmvm set wiphy->max_sched_scan_plan_interval so
> > > other drivers will get interval of zero which only ath6kl handles.
> > 
> > With the introduction of scheduled scan plans, we sort of deprecated
> > the "generic" scheduled scan interval.  It doesn't make sense to have
> > both passed at the same time, so nl80211 forbids
> > NL80211_ATTR_SCHED_SCAN_INTERVAL if we pass
> > NL80211_ATTR_SCHED_SCAN_PLANS.
> 
> Indeed, but if no plans are passed it is still allowed.

That's right.  But the driver will get it as a single plan.


> > The original NL80211_ATTR_SCHED_SCAN_INTERVAL was specified in msecs,
> > which is silly because we can never get millisecond accuracy in this. 
> > Thus, in the plans API, we decided to use seconds instead (because it
> > makes much more sense).  Additionally, the interval is considered
> > "advisory", because the FW may not be able guarantee the exact
> > intervals (for instance, the iwlwifi driver actually starts the
> > interval timer after scan completion, so if you specify 10 seconds
> > intervals, in practice they'll be 13-14 seconds).
> 
> Agree. Our firmware wants to have it in seconds as well.

It was actually my mistake when I implemented it in my TI days (can't
hide from git blame ;)). TI's firmware used msecs and I just blindly
followed it.


> > I'm not sure I'm answering your question, because I'm also not sure I
> > understood the question. :)
> 
> The question is this: Why is the interval capped at
> max_sched_scan_plan_interval if it exceeds it and no plans are provided
> (so continue to setup the scheduled scan request) whereas when plans are
> provided and an interval exceeds max_sched_scan_plan_interval it aborts
> with -EINVAL.

Oh, I see.  The problem is that the "max_sched_scan_plan_interval" was
introduced later.  If the userspace passes
NL80211__ATTR_SCHED_SCAN_INTERVAL, it probably means that it doesn't
know about NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL (i.e. it's only using an
old API).  If it is also, for some reason, passing a very large number,
we shouldn't suddenly make it fail with -EINVALID, because that would
be a break of UABI.  And since we know the driver cannot support such a
large number, we cap it because it's the best we can do.

Now, if the userspace uses NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL, it
means that it knows the new API (and was written after the new API was
introduced), so we can be stricter and assume it must have checked
NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL.

Makes sense?


> And a follow-up question for this snippet of code in
> nl80211_parse_sched_scan_plans():
> 
> 	if (!attrs[NL80211_ATTR_SCHED_SCAN_PLANS]) {
> 		u32 interval;
> 
> 		/*
> 		 * If scan plans are not specified,
> 		 * %NL80211_ATTR_SCHED_SCAN_INTERVAL must be specified. In this
> 		 * case one scan plan will be set with the specified scan
> 		 * interval and infinite number of iterations.
> 		 */
> 		if (!attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
> 			return -EINVAL;
> 
> 		interval = nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL]);
> 		if (!interval)
> 			return -EINVAL;
> 
> 		request->scan_plans[0].interval =
> 			DIV_ROUND_UP(interval, MSEC_PER_SEC);
> 		if (!request->scan_plans[0].interval)
> 			return -EINVAL;
> 
> 		if (request->scan_plans[0].interval >
> 		    wiphy->max_sched_scan_plan_interval)
> 			request->scan_plans[0].interval =
> 				wiphy->max_sched_scan_plan_interval;
> 
> 		return 0;
> 	}
> 
> So in v4.3 the interval was only validated to be non-zero. Now the
> interval is validated and capped to wiphy->max_sched_scan_plan_interval
> but apart from iwlmvm there are no driver specifying that so
> max_sched_scan_plan_interval = 0 for those and interval is unsigned int
> not equal to zero. So the last if statement above is true setting the
> interval to zero. I think the if statement should be extended to assure
> max_sched_scan_interval is non-zero, ie. set explicitly by the driver:
> 
> 		if (wiphy->max_sched_scan_plan_interval &&
> 		    request->scan_plans[0].interval >
> 		    wiphy->max_sched_scan_plan_interval)
> 			request->scan_plans[0].interval =
> 				wiphy->max_sched_scan_plan_interval;

If the driver doesn't set the max_sched_scan_plan_interval, mac80211's
default of MAX_U32 will be used:

struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
			   const char *requested_name)
{
[...]
	rdev->wiphy.max_sched_scan_plans = 1;
	rdev->wiphy.max_sched_scan_plan_interval = U32_MAX;

	return &rdev->wiphy;
}
EXPORT_SYMBOL(wiphy_new_nm);

...so max_sched_scan_plan_interval will never be zero, unless the
driver explicitly sets it to zero.


--
Cheers,
Luca.
