Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:54148 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0AGEKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 23:10:22 -0500
Date: Thu, 7 Jan 2010 05:10:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: sedat.dilek@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
Message-ID: <20100107041018.GG1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local> <2d0a357f1001061431i7b306da7v2bf8717a3d3ab0cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2d0a357f1001061431i7b306da7v2bf8717a3d3ab0cc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 06, 2010 at 11:31:10PM +0100, Sedat Dilek wrote:

> Why are there two different ".ndo_set_mac_address" in [1]?
> 
>  static const struct net_device_ops ieee80211_dataif_ops = {
> ...
>  	.ndo_set_mac_address 	= ieee80211_change_mac,
> +	.ndo_select_queue	= ieee80211_netdev_select_queue,
>  };
> 
>  static const struct net_device_ops ieee80211_monitorif_ops = {
> ...
>  	.ndo_set_mac_address 	= eth_mac_addr,
> +	.ndo_select_queue	= ieee80211_monitor_select_queue,
>  };

Because a different queue selection algorithm is needed for
monitor (ieee80211_monitor_select_queue) and non-monitor
(ieee80211_netdev_select_queue) interfaces.  The commit message
mentions this.
