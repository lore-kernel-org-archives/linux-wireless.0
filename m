Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f181.google.com ([209.85.210.181]:36157 "EHLO
        mail-wj0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758490AbdACMZk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 07:25:40 -0500
Received: by mail-wj0-f181.google.com with SMTP id c11so238749171wjx.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 04:25:39 -0800 (PST)
Subject: Re: [RFC] nl80211: allow multiple active scheduled scan requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481645071.20412.30.camel@sipsolutions.net>
 <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
 <1483353841.4596.2.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ba1cb1a1-3d27-7421-47ea-a5625a886518@broadcom.com> (sfid-20170103_132549_857894_D335CFCE)
Date: Tue, 3 Jan 2017 13:25:34 +0100
MIME-Version: 1.0
In-Reply-To: <1483353841.4596.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-1-2017 11:44, Johannes Berg wrote:
> 
>> +	/*
>> +	 * allow only one legacy scheduled scan if user-space
>> +	 * does not indicate multiple scheduled scan support.
>> +	 */
>> +	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI] &&
>> +	    cfg80211_legacy_sched_scan_active(rdev))
>>  		return -EINPROGRESS;
> 
> That probably doesn't go far enough - if legacy one is active then we
> probably shouldn't allow a new MULTI one either (or abandon the legacy
> one) so that older userspace doesn't get confused with multiple
> notifications from sched scans it didn't start.

I considered that although not taking the notifications into account.
Will change it. Abandoning the legacy one would be a behavioral change
so probably not acceptable, right?

>> +	if (rdev->sched_scan_req_count == rdev->wiphy.max_sched_scan_reqs)
>> +		return -ENOSPC;
> 
> Do we really want to do the double-accounting, just to avoid counting
> the list length here?

Ok. I have no strong preference.

>> +	/* leave request id zero for legacy request */
> 
> why? The ID would be ignored, so why special-case it?

It makes the function cfg80211_legacy_sched_scan_active() easier, ie.
not needing a is_legacy flag in struct cfg80211_sched_scan_request.

>> +static void cfg80211_del_sched_scan_req(struct
>> cfg80211_registered_device *rdev,
>> +					struct
>> cfg80211_sched_scan_request *req)
>> +{
>> +	list_del_rcu(&req->list);
>> +	kfree_rcu(req, rcu_head);
>> +	synchronize_rcu();
>> +	rdev->sched_scan_req_count--;
>> +}
> 
> That's bogus - either you use kfree_rcu() or synchronize_rcu() (the
> former is much better); combining both makes no sense.

Thanks. Both functions mentioned the rcu grace period so I was doubtful.
Will change it.

>> +bool cfg80211_legacy_sched_scan_active(struct
>> cfg80211_registered_device *rdev)
>> +{
>> +	struct cfg80211_sched_scan_request *req;
>> +
>> +	req = list_first_or_null_rcu(&rdev->sched_scan_req_list,
>> +				     struct
>> cfg80211_sched_scan_request, list);
>> +	/* request id 0 indicates legacy request in progress */
>> +	return req && !req->reqid;
>> +}
> 
> Ok, fair enough.

I guess your remark means this clarifies your earlier question about the
request id, right?

Regards,
Arend
