Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41127 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaK1MeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 07:34:16 -0500
Message-ID: <1417178052.27562.2.camel@sipsolutions.net> (sfid-20141128_133420_309019_F9041E06)
Subject: Re: [PATCH v8 2/2] nl80211: Convert sched_scan_req pointer to RCU
 pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 13:34:12 +0100
In-Reply-To: <1417083668-11958-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141127_112140_121468_F37E5F3F)
References: <1417083668-11958-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1417083668-11958-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141127_112140_121468_F37E5F3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/wireless/nl80211.c
> @@ -6077,30 +6078,34 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>  	if (rdev->sched_scan_req)
>  		return -EINPROGRESS;
>  
> -	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
> -							info->attrs);
> -	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
> +	sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
> +						  info->attrs);
> +
> +	err = PTR_ERR_OR_ZERO(sched_scan_req);
>  	if (err)
>  		goto out_err;
>  
> -	err = rdev_sched_scan_start(rdev, dev, rdev->sched_scan_req);
> +	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
> +
> +	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
>  	if (err)
>  		goto out_free;
>  
> -	rdev->sched_scan_req->dev = dev;
> -	rdev->sched_scan_req->wiphy = &rdev->wiphy;
> -
>  	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
> -		rdev->sched_scan_req->owner_nlportid = info->snd_portid;
> +		rtnl_dereference(rdev->sched_scan_req)->owner_nlportid =
> +			info->snd_portid;
> +
> +	rtnl_dereference(rdev->sched_scan_req)->dev = dev;
> +	rtnl_dereference(rdev->sched_scan_req)->wiphy = &rdev->wiphy;

This is still all wrong - you need to fully build the local variable and
then assign it after everything is done.

You can *probably* assign it only after calling the driver, in which
case you don't even need to kfree_rcu() below if it was never assigned
in failure cases.


>  out_free:
> -	kfree(rdev->sched_scan_req);
> +	kfree_rcu(sched_scan_req, rcu_head);
> +	rcu_assign_pointer(rdev->sched_scan_req, NULL);

use RCU_INIT_POINTER() for NULL values

>  out_err:
> -	rdev->sched_scan_req = NULL;

Also why did that move into a different label?

>  void cfg80211_sched_scan_results(struct wiphy *wiphy)
>  {
> +	struct cfg80211_sched_scan_request *sched_scan_req;
> +
>  	trace_cfg80211_sched_scan_results(wiphy);
>  	/* ignore if we're not scanning */
> -	if (wiphy_to_rdev(wiphy)->sched_scan_req)
> +
> +	rcu_read_lock();
> +	sched_scan_req = rcu_dereference(wiphy_to_rdev(wiphy)->sched_scan_req);
> +	rcu_read_unlock();

Umm. No no no. You probably don't want anything but rcu_access_pointer()
here, or do the rcu_read_lock() around all the users ...

> -	kfree(rdev->sched_scan_req);
> -	rdev->sched_scan_req = NULL;
> +	kfree_rcu(sched_scan_req, rcu_head);
> +
> +	rcu_assign_pointer(rdev->sched_scan_req, NULL);

You really need to do that the other way around...

Maybe you can find somebody else who has experience with RCU and is
willing to review your patches first? :)
s
Also - this patch really should come *first* in the series. Don't break
the code and fix it in the next patch, do it right once.

johanne

