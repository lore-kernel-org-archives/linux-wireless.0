Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41120 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932311AbcKUPIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 10:08:44 -0500
Message-ID: <1479740918.2517.28.camel@coelho.fi> (sfid-20161121_160848_289918_6D425CCB)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Nov 2016 17:08:38 +0200
In-Reply-To: <e176de78-6ab3-ad83-5e9d-082ceb85d786@broadcom.com>
References: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
         <dffc5408-3337-32e7-0998-3ae8a5199fa9@broadcom.com>
         <e176de78-6ab3-ad83-5e9d-082ceb85d786@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: scheduled scan interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, 2016-11-21 at 13:03 +0100, Arend Van Spriel wrote:
> On 21-11-2016 12:30, Arend Van Spriel wrote:
> > On 21-11-2016 12:19, Arend Van Spriel wrote:
> > > Hi Johannes, Luca,
> > > 
> > > The gscan work made me look at scheduled scan and the implementation of
> > > it in brcmfmac. The driver ignored the interval parameter from
> > > user-space. Now I am fixing that. One thing is that our firmware has a
> > > minimum interval which can not be indicated in struct wiphy. The other
> > > issue is how the maximum interval is used in the nl80211.c.
> > > 
> > > In nl80211_parse_sched_scan_plans() it is used against value passed in
> > > NL80211_ATTR_SCHED_SCAN_INTERVAL and NL80211_SCHED_SCAN_PLAN_INTERVAL.
> > > For the first one it caps the value to the maximum, but for the second
> > > one it returns -EINVAL. I suspect this is done because maximum interval
> > > was introduced with schedule scan plans, but it feels inconsistent.
> > 
> > It also maybe simply wrong to cap. At least brcmfmac does not set the
> > maximum so it will always get interval being zero. Maybe better to do:
> > 
> > 		if (wiphy->max_sched_scan_plan_interval &&
> > 		    request->scan_plans[0].interval >
> > 		    wiphy->max_sched_scan_plan_interval)
> > 			return -EINVAL;
> > 
> > > Thoughts?
> 
> Digging deeper. Looking at v4.3 before introduction of sched_scan_plans.
> struct sched_scan_request::interval was specified in milliseconds! Below
> the drivers that I see having scheduled scan support:
> 
> iwlmvm: cap interval, convert to seconds.
> ath6kl: cap to 1sec minimum, no max check, convert to seconds.
> wl12xx: no checking in driver, fw need milliseconds.
> wl18xx: no checking in driver, fw need milliseconds.
> 
> The milliseconds conversion seems to be taken care of by multiplying
> with MSEC_PER_SEC in wl{12,18}xx drivers.
> 
> It seems in 4.8 only iwlmvm set wiphy->max_sched_scan_plan_interval so
> other drivers will get interval of zero which only ath6kl handles.

With the introduction of scheduled scan plans, we sort of deprecated
the "generic" scheduled scan interval.  It doesn't make sense to have
both passed at the same time, so nl80211 forbids
NL80211_ATTR_SCHED_SCAN_INTERVAL if we pass
NL80211_ATTR_SCHED_SCAN_PLANS.

The original NL80211_ATTR_SCHED_SCAN_INTERVAL was specified in msecs,
which is silly because we can never get millisecond accuracy in this. 
Thus, in the plans API, we decided to use seconds instead (because it
makes much more sense).  Additionally, the interval is considered
"advisory", because the FW may not be able guarantee the exact
intervals (for instance, the iwlwifi driver actually starts the
interval timer after scan completion, so if you specify 10 seconds
intervals, in practice they'll be 13-14 seconds).

I'm not sure I'm answering your question, because I'm also not sure I
understood the question. :)

--
Cheers,
Luca.
