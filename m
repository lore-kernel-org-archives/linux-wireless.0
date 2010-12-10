Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0LJUD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:03:28 -0500
Subject: Re: [RFC v2 1/2] cfg80211/nl80211: add support for scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 21:03:26 +0100
Message-ID: <1292011406.3531.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:


> With this feature we
> can scan automatically for specific SSIDs (or any if not specified) at
> certain intervals.

I'd hope that "if not specified" actually means a passive scan like in
normal scanning, and you need to specify the wildcard if you want to
scan for it?

> +	u8 max_sched_scan_ssids;

shouldn't this be advertised in nl80211 as well?

> @@ -647,6 +648,11 @@ static void wdev_cleanup_work(struct work_struct *work)
>  		___cfg80211_scan_done(rdev, true);
>  	}
>  
> +	if (rdev->sched_scan_req &&
> +	    rdev->sched_scan_req->dev == wdev->netdev) {
> +		nl80211_sched_scan_stopped(rdev, wdev->netdev);
> +	}

Hmm, are you sure that shouldn't be a warning like the scan case? If the
driver didn't stop -- maybe this is still going on? I think instead the
netdev down notifier should actually ask the device to stop the sched
scan (core.c).


> +	if (!rdev->ops->sched_scan_start) {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (rdev->sched_scan_req) {
> +		return -EINPROGRESS;
> +	}

bit too many braces for my taste :)

> +	if (ie_len > wiphy->max_scan_ie_len)
> +		return -EINVAL;

So # SSIDs is different, but IE len is the same? Isn't that a bad
assumption to make?

> +	request->dev = dev;
> +	request->wiphy = &rdev->wiphy;
> +
> +	rdev->sched_scan_req = request;
> +
> +	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
> +	if (!err) {
> +		nl80211_send_sched_scan(rdev, dev,
> +					NL80211_CMD_START_SCHED_SCAN);
> +		dev_hold(dev);

I don't think you want the dev_hold here. That's a trick I used to warn
about scans that didn't finish when the interface went down. Here,
instead, since it's a longer-running process, you should do what I said
above -- stop the sched scan when the interface is going down.

> +	err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
> +	if (err)
> +		goto out;

return err; instead? There's no cleanup code at the out label :)

> +	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_STOP_SCHED_SCAN);
> +
> +	nl80211_sched_scan_stopped(rdev, dev);

Shouldn't the former be part of the latter function? And actually,
you'll want to roll it all into a helper function that you can call from
the netdev down notifier :)

johannes

