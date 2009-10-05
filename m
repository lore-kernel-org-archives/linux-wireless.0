Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40488
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932383AbZJEJWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2009 05:22:44 -0400
Date: Mon, 05 Oct 2009 02:22:39 -0700 (PDT)
Message-Id: <20091005.022239.95915308.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, miles.lane@gmail.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wext: let get_wireless_stats() sleep
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254734159.22426.6.camel@johannes.local>
References: <1254734159.22426.6.camel@johannes.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 Oct 2009 11:15:59 +0200

> A number of drivers (recently including cfg80211-based ones)
> assume that all wireless handlers, including statistics, can
> sleep and they often also implicitly assume that the rtnl is
> held around their invocation. This is almost always true now
> except when reading from sysfs:
 ...
> Fix this by using the rtnl instead of dev_base_lock.
> 
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Fair enough, applied, thanks!
