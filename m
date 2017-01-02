Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37096 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932118AbdABKoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 05:44:04 -0500
Message-ID: <1483353841.4596.2.camel@sipsolutions.net> (sfid-20170102_114407_825287_A207398F)
Subject: Re: [RFC] nl80211: allow multiple active scheduled scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
Date: Mon, 02 Jan 2017 11:44:01 +0100
In-Reply-To: <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481645071.20412.30.camel@sipsolutions.net>
         <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	/*
> +	 * allow only one legacy scheduled scan if user-space
> +	 * does not indicate multiple scheduled scan support.
> +	 */
> +	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI] &&
> +	    cfg80211_legacy_sched_scan_active(rdev))
>  		return -EINPROGRESS;

That probably doesn't go far enough - if legacy one is active then we
probably shouldn't allow a new MULTI one either (or abandon the legacy
one) so that older userspace doesn't get confused with multiple
notifications from sched scans it didn't start.
 
> +	if (rdev->sched_scan_req_count == rdev->wiphy.max_sched_scan_reqs)
> +		return -ENOSPC;

Do we really want to do the double-accounting, just to avoid counting
the list length here?

> +	/* leave request id zero for legacy request */

why? The ID would be ignored, so why special-case it?

> +static void cfg80211_del_sched_scan_req(struct
> cfg80211_registered_device *rdev,
> +					struct
> cfg80211_sched_scan_request *req)
> +{
> +	list_del_rcu(&req->list);
> +	kfree_rcu(req, rcu_head);
> +	synchronize_rcu();
> +	rdev->sched_scan_req_count--;
> +}

That's bogus - either you use kfree_rcu() or synchronize_rcu() (the
former is much better); combining both makes no sense.

> +bool cfg80211_legacy_sched_scan_active(struct
> cfg80211_registered_device *rdev)
> +{
> +	struct cfg80211_sched_scan_request *req;
> +
> +	req = list_first_or_null_rcu(&rdev->sched_scan_req_list,
> +				     struct
> cfg80211_sched_scan_request, list);
> +	/* request id 0 indicates legacy request in progress */
> +	return req && !req->reqid;
> +}

Ok, fair enough.

johannes
