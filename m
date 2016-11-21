Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35810 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbcKULaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 06:30:19 -0500
Received: by mail-pf0-f182.google.com with SMTP id i88so64112333pfk.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 03:30:18 -0800 (PST)
Subject: Re: scheduled scan interval
To: Johannes Berg <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dffc5408-3337-32e7-0998-3ae8a5199fa9@broadcom.com> (sfid-20161121_123032_428396_2FF63892)
Date: Mon, 21 Nov 2016 12:30:13 +0100
MIME-Version: 1.0
In-Reply-To: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-11-2016 12:19, Arend Van Spriel wrote:
> Hi Johannes, Luca,
> 
> The gscan work made me look at scheduled scan and the implementation of
> it in brcmfmac. The driver ignored the interval parameter from
> user-space. Now I am fixing that. One thing is that our firmware has a
> minimum interval which can not be indicated in struct wiphy. The other
> issue is how the maximum interval is used in the nl80211.c.
> 
> In nl80211_parse_sched_scan_plans() it is used against value passed in
> NL80211_ATTR_SCHED_SCAN_INTERVAL and NL80211_SCHED_SCAN_PLAN_INTERVAL.
> For the first one it caps the value to the maximum, but for the second
> one it returns -EINVAL. I suspect this is done because maximum interval
> was introduced with schedule scan plans, but it feels inconsistent.

It also maybe simply wrong to cap. At least brcmfmac does not set the
maximum so it will always get interval being zero. Maybe better to do:

		if (wiphy->max_sched_scan_plan_interval &&
		    request->scan_plans[0].interval >
		    wiphy->max_sched_scan_plan_interval)
			return -EINVAL;

> Thoughts?
> 
> Regards,
> Arend
> 
