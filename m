Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaKSR6e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:58:34 -0500
Message-ID: <1416419911.9374.14.camel@sipsolutions.net> (sfid-20141119_185836_726097_C31E3F95)
Subject: Re: [PATCH v5 2/2] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 18:58:31 +0100
In-Reply-To: <1415892315-2911-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_162954_070889_EBEB661D)
References: <1415892315-2911-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1415892315-2911-3-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141113_162954_070889_EBEB661D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-13 at 17:25 +0200, Jukka Rissanen wrote:

> @@ -12127,6 +12130,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
>  
>  	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
>  		bool schedule_destroy_work = false;
> +		bool schedule_scan_stop = false;
> +		struct cfg80211_sched_scan_request *req = rdev->sched_scan_req;
> +
> +		if (req && req->owner_nlportid == notify->portid &&
> +		    notify->portid)
> +			schedule_scan_stop = true;
>  
>  		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list) {
>  			cfg80211_mlme_unregister_socket(wdev, notify->portid);

This is racy, it'll probably cause crashes at some point.

johannes

