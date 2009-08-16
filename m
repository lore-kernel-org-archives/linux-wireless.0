Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56905 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZHPL7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 07:59:16 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix deadlock
Date: Sun, 16 Aug 2009 13:59:15 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1250422358.17522.0.camel@johannes.local>
In-Reply-To: <1250422358.17522.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200908161359.16124.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 13:32:38 Johannes Berg wrote:
> When removing an interface with nl80211, cfg80211 will
> deadlock in the netdev notifier because we're already
> holding rdev->mtx and try to acquire it again to verify
> the scan has been done.
> 
> This bug was introduced by my patch
> "cfg80211: check for and abort dangling scan requests".
> 
> To fix this, move the dangling scan request check into
> wiphy_unregister(). This will not be able to catch all
> cases right away, but if the scan problem happens with
> a manual ifdown or so it will be possible to remedy it
> by removing the module/device.
> 
> Additionally, add comments about the deadlock scenario.
> 
> Reported-by: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Christian Lamparter <chunkeey@web.de>
> ---
>  net/wireless/core.c |   32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> --- wireless-testing.orig/net/wireless/core.c	2009-08-16 13:22:52.000000000 +0200
> +++ wireless-testing/net/wireless/core.c	2009-08-16 13:28:12.000000000 +0200
> @@ -586,9 +586,15 @@ void wiphy_unregister(struct wiphy *wiph
>  	 * get to lock contention here if userspace issues a command
>  	 * that identified the hardware by wiphy index.
>  	 */
> -	mutex_lock(&rdev->mtx);
> -	/* unlock again before freeing */
> -	mutex_unlock(&rdev->mtx);
> +	cfg80211_lock_rdev(rdev);
> +
> +	if (WARN_ON(rdev->scan_req)) {
> +		rdev->scan_req->aborted = true;
> +		___cfg80211_scan_done(rdev);
> +	}
> +
> +	cfg80211_unlock_rdev(rdev);
> +	flush_work(&rdev->scan_done_wk);
>  
>  	cfg80211_debugfs_rdev_del(rdev);
>  
> @@ -603,9 +609,7 @@ void wiphy_unregister(struct wiphy *wiph
>  
>  	mutex_unlock(&cfg80211_mutex);
>  
> -	flush_work(&rdev->scan_done_wk);
>  	cancel_work_sync(&rdev->conn_work);
> -	kfree(rdev->scan_req);
>  	flush_work(&rdev->event_work);
>  }
>  EXPORT_SYMBOL(wiphy_unregister);
> @@ -653,6 +657,11 @@ static int cfg80211_netdev_notifier_call
>  
>  	switch (state) {
>  	case NETDEV_REGISTER:
> +		/*
> +		 * NB: cannot take rdev->mtx here because this may be
> +		 * called within code protected by it when interfaces
> +		 * are added with nl80211.
> +		 */
>  		mutex_init(&wdev->mtx);
>  		INIT_LIST_HEAD(&wdev->event_list);
>  		spin_lock_init(&wdev->event_lock);
> @@ -730,13 +739,11 @@ static int cfg80211_netdev_notifier_call
>  #endif
>  		break;
>  	case NETDEV_UNREGISTER:
> -		cfg80211_lock_rdev(rdev);
> -
> -		if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == dev)) {
> -			rdev->scan_req->aborted = true;
> -			___cfg80211_scan_done(rdev);
> -		}
> -
> +		/*
> +		 * NB: cannot take rdev->mtx here because this may be
> +		 * called within code protected by it when interfaces
> +		 * are removed with nl80211.
> +		 */
>  		mutex_lock(&rdev->devlist_mtx);
>  		/*
>  		 * It is possible to get NETDEV_UNREGISTER
> @@ -755,7 +762,6 @@ static int cfg80211_netdev_notifier_call
>  #endif
>  		}
>  		mutex_unlock(&rdev->devlist_mtx);
> -		cfg80211_unlock_rdev(rdev);
>  		break;
>  	case NETDEV_PRE_UP:
>  		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
> 
> 
