Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:20826 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0KSKTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 05:19:48 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 02:19:35 -0800
Date: Fri, 19 Nov 2010 15:57:25 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: module unloading busted ?
Message-ID: <20101119102725.GA3126@vmraj-lnx.users.atheros.com>
References: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
 <20101118093725.GA3388@vmraj-lnx.users.atheros.com>
 <1290106515.3801.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1290106515.3801.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 12:25:15AM +0530, Johannes Berg wrote:
> On Thu, 2010-11-18 at 15:07 +0530, Rajkumar Manoharan wrote:
> > On Thu, Nov 18, 2010 at 12:56:00PM +0530, Luis R. Rodriguez wrote:
> > > 05:33 < mcgrof> so module unload on ath9k no longer works
> > > 06:11 < vmraj> mcgrof: module unload is not working for intel cards too
> > > 06:15 < vmraj> it can be reproduced by rmmod on active connection
> > > 
> > > I haven't yet figured out why. Anyone else with other modules experiencing this?
> > > 
> > cfg80211_netdev_notifier_call invokes dev_hold on NETDEV_DOWN which increments
> > Usage count. hence unregister_netdevice fails.
> 
> The cleanup_work should fix that up -- but I can see this being a corner
> case that the network stack no longer likes us for ...
>
Yes cleanup_work releases the device. By disabling ipv6 solves the issue.
Somewhere in ipv6 module, failed to release device.

sysctl -w net.ipv6.conf.all.disable_ipv6=1 solves the module unload problem.


--
Rajkumar
