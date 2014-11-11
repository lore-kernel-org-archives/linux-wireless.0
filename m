Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKKO4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 09:56:49 -0500
Message-ID: <1415717806.2163.8.camel@sipsolutions.net> (sfid-20141111_155651_844984_7D11A645)
Subject: Re: [PATCH] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Nov 2014 15:56:46 +0100
In-Reply-To: <1415716059-608-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141111_152746_888050_18874AA2)
References: <1415716059-608-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141111_152746_888050_18874AA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-11 at 16:27 +0200, Jukka Rissanen wrote:

> +static void nl80211_sched_scan_stop_wk(struct work_struct *work)
> +{
> +	struct cfg80211_sched_scan_request *req;
> +	struct cfg80211_registered_device *rdev;
> +
> +	req = container_of(work, struct cfg80211_sched_scan_request,
> +			   sched_scan_stop_wk);
> +
> +	rdev = wiphy_to_rdev(req->wiphy);
> +
> +	rtnl_lock();
> +	__cfg80211_stop_sched_scan(rdev, false);
> +	rtnl_unlock();
> +}

I think you'll need to do something like flush this (which probably
isn't possible due to RTNL usage) when the interface disappears?
Otherwise interface going down and socket closure could race, ifdown
causing the request to be aborted by socket closure having scheduled the
work ... that'd be troubling.

johannes

