Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37891 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaKLMQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 07:16:00 -0500
Message-ID: <1415794552.1798.2.camel@sipsolutions.net> (sfid-20141112_131604_846326_5FB6B1C9)
Subject: Re: [PATCH v3 2/2] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Nov 2014 13:15:52 +0100
In-Reply-To: <1415794139-7124-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141112_130909_519151_DCCF3FB0)
References: <1415794139-7124-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415794139-7124-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141112_130909_519151_DCCF3FB0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-12 at 14:08 +0200, Jukka Rissanen wrote:

> @@ -850,8 +852,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
>  		break;
>  	case NL80211_IFTYPE_P2P_CLIENT:
>  	case NL80211_IFTYPE_STATION:
> -		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
> +		if (sched_scan_req && dev == sched_scan_req->dev) {
> +			cancel_work_sync(&sched_scan_req->sched_scan_stop_wk);
>  			__cfg80211_stop_sched_scan(rdev, false);
> +		}
>  
>  #ifdef CONFIG_CFG80211_WEXT
>  		kfree(wdev->wext.ie);
> @@ -991,6 +995,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>  
>  		if (WARN_ON(rdev->sched_scan_req &&
>  			    rdev->sched_scan_req->dev == wdev->netdev)) {
> +			struct cfg80211_sched_scan_request *sched_scan_req =
> +				rdev->sched_scan_req;
> +
> +			cancel_work_sync(&sched_scan_req->sched_scan_stop_wk);
>  			__cfg80211_stop_sched_scan(rdev, false);
>  		}
>  

This can cause deadlocks as it's done with the RTNL held, yet the work
acquires the RTNL.

johannes

