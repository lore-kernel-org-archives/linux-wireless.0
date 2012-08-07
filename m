Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2HGQUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:36 -0400
Message-ID: <1344356425.4766.0.camel@jlt3.sipsolutions.net> (sfid-20120807_182047_993111_3B7FBF42)
Subject: Re: [PATCH] cfg80211: Fix for crash in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Srinivasan B <srinivasanb@posedge.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Tue, 07 Aug 2012 18:20:25 +0200
In-Reply-To: <50211696.40607@posedge.com>
References: <5020BF4F.2090304@posedge.com>
	 <1344339753.15172.0.camel@jlt3.sipsolutions.net>
	 <50211696.40607@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-07 at 18:52 +0530, Mahesh Palivela wrote:

> >>                       dev->ethtools_ops is assigned during
> >> NETDEV_REGISTER and the same can be cleared during NETDEV_UNREGISTER.
> >
> > This doesn't make any sense to me at all.
> >
> cleanup of ethtools_ops pointer is required upon netdev_unreg 
> notification. we are assigning this pointer to cfg80211_ethtool_ops on 
> netdev_reg notification. Is it not required?
> 
> we have seen crash when keeping cfg80211 and mac80211 loaded and lmac 
> driver unloaded. With this fix, we didn't see crash. Crash doesn't 
> happen right away. Only when some operation trying to access ethtool_ops.

I don't see how anything could access ethtool_ops after the netdev is
unregistered.

johannes

