Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0KDUrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:47:00 -0400
Subject: Re: [RFC 01/15] nl80211: add periodic scan commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-2-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-2-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:42:14 -0400
Message-ID: <1288885334.3659.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:

> +	rtnl_lock();
> +
> +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> +	if (err)
> +		goto out_rtnl;
> +
> +	if (!netif_running(dev)) {
> +		err = -ENETDOWN;
> +		goto out;
> +	}

ahem. we have infrastructure for this now.


> +		.doit = nl80211_start_periodic,

> +		.doit = nl80211_stop_periodic,

> +void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
> +			   struct net_device *netdev, u32 cmd);

I think you should add _scan to all these names.

johannes

