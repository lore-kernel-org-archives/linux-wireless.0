Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab0JAQGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 12:06:02 -0400
Subject: Re: [PATCH 2/3] cfg80211: patches to allow setting the WDS peer
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1285946441-20152-3-git-send-email-bjordan@rajant.com>
References: <1285946441-20152-1-git-send-email-bjordan@rajant.com>
	 <1285946441-20152-3-git-send-email-bjordan@rajant.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 18:05:59 +0200
Message-ID: <1285949159.3739.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 11:20 -0400, Bill Jordan wrote:

> +static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev;
> +	struct wireless_dev *wdev;
> +	struct net_device *dev;
> +	u8 *bssid;
> +	int err;
> +
> +	if (!info->attrs[NL80211_ATTR_MAC])
> +		return -EINVAL;
> +
> +	rtnl_lock();
> +
> +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> +	if (err)
> +		goto unlock_rtnl;
> +
> +	wdev = dev->ieee80211_ptr;

I think this (or maybe the mac80211 bit, but I think here makes more
sense) needs to check !netif_running(), otherwise you can change the
peer without it taking effect, or something like that? Sorry, should've
noted that earlier.

johannes

