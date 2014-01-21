Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaAUQDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:03:05 -0500
Message-ID: <1390320181.6199.64.camel@jlt4.sipsolutions.net> (sfid-20140121_170323_476321_5FD317E1)
Subject: Re: [RFC 5/5] cfg80211: implement cfg80211_get_station
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 21 Jan 2014 17:03:01 +0100
In-Reply-To: <1390302591-3352-6-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
	 <1390302591-3352-6-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 12:09 +0100, Antonio Quartulli wrote:

> +++ b/net/wireless/nl80211.c
> @@ -3780,6 +3780,28 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
>  	return genlmsg_reply(msg, info);
>  }
>  
> +int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
> +			 struct station_info *sinfo)

Not sure nl80211.c is the best place for this?

> +{
> +	struct cfg80211_registered_device *rdev;
> +	struct wireless_dev *wdev;
> +	int err;
> +
> +	wdev = dev->ieee80211_ptr;
> +	if (!wdev)
> +		return -EOPNOTSUPP;
> +
> +	rdev = wiphy_to_dev(wdev->wiphy);
> +	if (!rdev->ops->get_station)
> +		return -EOPNOTSUPP;
> +
> +	err = rdev_get_station(rdev, dev, mac_addr, sinfo);
> +	if (err)
> +		return err;
> +
> +	return 0;

Those "err" variable checks and whatever are just pointless -- this is
really just
return rdev_get_station(...)

> +}

Consider exporting it if you actually want to use your new function. :)

johannes

