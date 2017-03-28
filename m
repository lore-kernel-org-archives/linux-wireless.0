Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59392 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752034AbdC1MfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 08:35:15 -0400
Message-ID: <1490704473.18052.1.camel@sipsolutions.net> (sfid-20170328_143652_459787_7AB43CDB)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Date: Tue, 28 Mar 2017 14:34:33 +0200
In-Reply-To: <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_112615_711798_FE2BF116)
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
         <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170328_112615_711798_FE2BF116)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Changing the checks in
> wiphy_resume() to only access the struct
> cfg80211_registered_device::ops
> when the wiphy instance is registered.

[...]

> +++ b/net/wireless/sysfs.c
> @@ -132,12 +132,10 @@ static int wiphy_resume(struct device *dev)
>  	/* Age scan results with time spent in suspend */
>  	cfg80211_bss_age(rdev, get_seconds() - rdev->suspend_at);
>  
> -	if (rdev->ops->resume) {
> -		rtnl_lock();
> -		if (rdev->wiphy.registered)
> -			ret = rdev_resume(rdev);
> -		rtnl_unlock();
> -	}
> +	rtnl_lock();
> +	if (rdev->wiphy.registered && rdev->ops->resume)
> +		ret = rdev_resume(rdev);
> +	rtnl_unlock();

Hmm? Commit message seems ... old perhaps?

johannes
