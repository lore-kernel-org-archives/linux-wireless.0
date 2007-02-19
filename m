Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34466 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932609AbXBSUh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:37:28 -0500
Date: Mon, 19 Feb 2007 21:37:16 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 03/10] introduce wiphy concept
Message-ID: <20070219213716.183719c9@griffin.suse.cz>
In-Reply-To: <20070215144257.530315000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
	<20070215144257.530315000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 15:42:44 +0100, Johannes Berg wrote:
> For the future:
> 
> Maybe instead of having ieee80211_ptr point to a struct wireless_dev
> (which can be allocated along with the netdev) we should mandate that
> each wireless netdev is allocated via a new function that puts the
> wireless_dev struct as the first part of the private area of the netdev,
> that way getting to it is just a simple addition instead of following
> a pointer... and we can also drop ieee80211_ptr from struct net_device.

Currently, you need to distinguish whether some random net_device is
wireless device or not at some places. At least d80211 needs that (yes,
ifindex doesn't wrap often, so those are just safety checks, but - well
- I'd like to be safe).

How can this be effectively achieved if ieee80211_ptr is dropped?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
