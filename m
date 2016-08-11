Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52754 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbcHKMr1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:47:27 -0400
Message-ID: <1470919643.12075.7.camel@sipsolutions.net> (sfid-20160811_144730_779957_D1BCBA5A)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 14:47:23 +0200
In-Reply-To: <1470261735-2977-1-git-send-email-denkenz@gmail.com> (sfid-20160803_180614_643489_B91CE333)
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160803_180614_643489_B91CE333)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-03 at 17:02 -0500, Denis Kenzior wrote:
> 
> +static int nl80211_dump_interface_parse(struct sk_buff *skb,
> +				    struct netlink_callback *cb,
> +				    int *filter_wiphy)

Wrong indentation :)

>  static int nl80211_dump_interface(struct sk_buff *skb, struct
> netlink_callback *cb)
>  {
>  	int wp_idx = 0;
>  	int if_idx = 0;
>  	int wp_start = cb->args[0];
>  	int if_start = cb->args[1];
> +	int filter_wiphy = cb->args[2];
>  	struct cfg80211_registered_device *rdev;
>  	struct wireless_dev *wdev;
>  
> +	if (!wp_start && !if_start && !filter_wiphy) {

This seems incorrect - you're setting

> +		int ret;
> +
> +		filter_wiphy = -1;
> +
> +		ret = nl80211_dump_interface_parse(skb, cb,
> &filter_wiphy);

it here, but it can take the value 0, so !filter_wiphy seems wrong?

johannes
