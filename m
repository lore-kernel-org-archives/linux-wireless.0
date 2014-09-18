Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50532 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbaIRVZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 17:25:39 -0400
Message-ID: <1411075535.2034.5.camel@jlt4.sipsolutions.net> (sfid-20140918_232546_066149_8F28AF6F)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 18 Sep 2014 23:25:35 +0200
In-Reply-To: <1410467723-2550-1-git-send-email-vadim4j@gmail.com> (sfid-20140911_224347_007930_B9E673A0)
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20140911_224347_007930_B9E673A0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 23:35 +0300, Vadim Kochan wrote:
> Added new netdev_ops callback for setting namespace in specific
> for this device way

> +++ b/include/linux/netdevice.h
> @@ -997,6 +997,8 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
>   *	Callback to use for xmit over the accelerated station. This
>   *	is used in place of ndo_start_xmit on accelerated net
>   *	devices.
> + * int (*ndo_set_netns)(struct net_device *dev, struct net *net);
> + *      Callback to set net namespace in specific way for this device.

For the record, I don't consider it appropriate to set the net namespace
on one netdev and end up with multiple netdevs switching namespaces ...

As a result, I don't think this should done.

johannes

