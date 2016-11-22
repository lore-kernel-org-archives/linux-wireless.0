Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41274 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753324AbcKVJTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 04:19:06 -0500
Message-ID: <1479806342.2517.44.camel@coelho.fi> (sfid-20161122_101912_513116_12F1096D)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 Nov 2016 11:19:02 +0200
In-Reply-To: <006ec2b0-9659-49ed-40f7-b8980b7e3ec7@broadcom.com>
References: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
         <dffc5408-3337-32e7-0998-3ae8a5199fa9@broadcom.com>
         <e176de78-6ab3-ad83-5e9d-082ceb85d786@broadcom.com>
         <1479740918.2517.28.camel@coelho.fi>
         <a222d5d1-408d-fd96-4cb9-896f6a9dab59@broadcom.com>
         <1479794340.2517.34.camel@coelho.fi>
         <006ec2b0-9659-49ed-40f7-b8980b7e3ec7@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: scheduled scan interval
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-22 at 10:10 +0100, Arend Van Spriel wrote:
> On 22-11-2016 6:59, Luca Coelho wrote:
> > Oh, I see.  The problem is that the "max_sched_scan_plan_interval" was
> > introduced later.  If the userspace passes
> > NL80211__ATTR_SCHED_SCAN_INTERVAL, it probably means that it doesn't
> > know about NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL (i.e. it's only using an
> > old API).  If it is also, for some reason, passing a very large number,
> > we shouldn't suddenly make it fail with -EINVALID, because that would
> > be a break of UABI.  And since we know the driver cannot support such a
> > large number, we cap it because it's the best we can do.
> > 
> > Now, if the userspace uses NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL, it
> > means that it knows the new API (and was written after the new API was
> > introduced), so we can be stricter and assume it must have checked
> > NL80211_ATTR_MAX_SCAN_PLAN_INTERVAL.
> > 
> > Makes sense?
> 
> Not really. As you say if user-space passes
> NL80211_ATTR_SCHED_SCAN_INTERVAL it is using old API. Otherwise it
> should pass NL80211_ATTR_SCHED_SCAN_PLANS.

Errr... I meant "if the userspace uses NL80211_ATTR_SCHED_SCAN_PLANS",
pasted the wrong thing. ;)


> If the driver doesn't set the max_sched_scan_plan_interval, mac80211's
> > default of MAX_U32 will be used:
> > 
> > struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
> > 			   const char *requested_name)
> > {
> > [...]
> > 	rdev->wiphy.max_sched_scan_plans = 1;
> > 	rdev->wiphy.max_sched_scan_plan_interval = U32_MAX;
> > 
> > 	return &rdev->wiphy;
> > }
> > EXPORT_SYMBOL(wiphy_new_nm);
> > 
> > ...so max_sched_scan_plan_interval will never be zero, unless the
> > driver explicitly sets it to zero.
> 
> I think you are overlooking the cfg80211-based drivers here. According
> to lxr at least brcmfmac, mwifiex, and ath6kl are not specifying it.
> "Funny" detail is that scheduled scan support in mwifiex seems to be
> introduced after the scan plan API change.

You're right, I did overlook non-mac80211 drivers.


> With the old API nl80211 only assured it to be non-zero. The only one
> capping the value was iwlmvm. The only one setting the
> max_sched_scan_plan_interval (overriding mac80211 value) now is iwlmvm.
> So I think checking if it is set before capping it retains the old API
> behaviour.

Fair enough.  The change you propose, to also check whether the value
is set (since 0 interval doesn't make sense), is valid.  :)

--
Luca.
