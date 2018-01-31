Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58132 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753220AbeAaVxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:53:43 -0500
Message-ID: <1517435621.2189.67.camel@sipsolutions.net> (sfid-20180131_225346_409309_71F06C0C)
Subject: Re: [PATCH 5/6] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 22:53:41 +0100
In-Reply-To: <20180131213329.25322-6-denkenz@gmail.com> (sfid-20180131_223349_476233_D75A8C24)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-6-denkenz@gmail.com>
         (sfid-20180131_223349_476233_D75A8C24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	const u8 *buf;
> +	size_t len;
> +	u8 *dest;
> +	u16 proto;
> +	bool noencrypt;
> +	int err;
> +
> +	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +				     NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211))
> +		return -EOPNOTSUPP;
> +
> +	if (!rdev->ops->tx_control_port)
> +		return -EOPNOTSUPP;

I wonder if maybe we should accept this command only from the socket
owner? Is there a use case for something else?

Actually, then again, that's awkward because doing events and commands
on the same socket doesn't mix all _that_ well. Perhaps we just need to
fix that problem in libnl or something and be done with it ...

johannes
