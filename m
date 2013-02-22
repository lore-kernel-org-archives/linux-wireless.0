Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3BVUbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:31:05 -0500
Message-ID: <1361565061.3420.13.camel@jlt4.sipsolutions.net> (sfid-20130222_213109_828933_8EA6495D)
Subject: Re: [RFC 1/2] mac80211: disconnect on suspend in managed mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Feb 2013 21:31:01 +0100
In-Reply-To: <20130221102939.GA19443@redhat.com>
References: <20130219164714.GA27140@redhat.com>
	 <1361354804.8629.15.camel@jlt4.sipsolutions.net>
	 <20130221102939.GA19443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-21 at 11:29 +0100, Stanislaw Gruszka wrote:

> --- a/net/wireless/sysfs.c
> +++ b/net/wireless/sysfs.c
> @@ -86,16 +86,21 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
>  static int wiphy_suspend(struct device *dev, pm_message_t state)
>  {
>  	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
> +	struct wireless_dev *wdev;
>  	int ret = 0;
>  
>  	rdev->suspend_at = get_seconds();
>  
> -	if (rdev->ops->suspend) {
> -		rtnl_lock();
> -		if (rdev->wiphy.registered)
> +	rtnl_lock();
> +	if (rdev->wiphy.registered) {
> +		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
> +			cfg80211_leave(rdev, wdev);
> +
> +		if (rdev->ops->suspend)
>  			ret = rdev_suspend(rdev);

I think this would break WoWLAN?

johannes

