Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0JNHLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 03:11:38 -0400
Subject: Re: [PATCH 1/6] Add nl80211 calls for bitrate threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101013224851.658E120478@glenhelen.mtv.corp.google.com>
References: <20101013224851.658E120478@glenhelen.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 09:12:19 +0200
Message-ID: <1287040339.4641.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 15:06 -0700, Paul Stewart wrote:

> +static int nl80211_set_cqm_bitrate(struct genl_info *info,
> +					   u32 trigger_rate)
> +{
> +	struct cfg80211_registered_device *rdev;
> +	struct wireless_dev *wdev;
> +	struct net_device *dev;
> +	int err;
> +
> +	rtnl_lock();
> +
> +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> +	if (err)
> +		goto unlock_rdev;

Err, what kernel is this against? It's going to deadlock in
wireless-next...

> +	err = rdev->ops->set_cqm_bitrate_config(wdev->wiphy, dev, trigger_rate);

This won't compile after just the first patch -- merge 1 and 2.

johannes

