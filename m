Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0FFJRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:17:23 -0400
Subject: Re: Locking in new ARP query filtering patch
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: juuso.oikarinen@nokia.com, linux-wireless@vger.kernel.org
In-Reply-To: <1275802426.1835.4408.camel@rchatre-DESK>
References: <1275802426.1835.4408.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 11:17:18 +0200
Message-ID: <1275815838.3615.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-05 at 22:33 -0700, reinette chatre wrote:

> [   92.026800] =======================================================
> [   92.030507] [ INFO: possible circular locking dependency detected ]
> [   92.030507] 2.6.34-04781-g2b2c009 #85
> [   92.030507] -------------------------------------------------------
> [   92.030507] modprobe/5225 is trying to acquire lock:
> [   92.030507]  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff8105b5c0>] flush_workq
> ueue+0x0/0xb0
> [   92.030507]
> [   92.030507] but task is already holding lock:
> [   92.030507]  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20
> [   92.030507]
> [   92.030507] which lock already depends on the new lock.

> [   92.030507] 1 lock held by modprobe/5225:
> [   92.030507]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff812b9ce2>] rtnl_lock+0x12/0x20

Suck, I should've caught that. Yes, because we need to flush the
mac80211 workqueue under RTNL we cannot acquire the RTNL while working
from it, so the ARP filter upload after associating needs to be further
deferred to a schedule_work(), which then needs to do a bunch of sanity
checking and I think might even need to iterate the iface list because
it might not be possible to make it depend on it.

> Here is the BUG:
> 
> [  132.460013] kernel BUG at /home/wifi/iwlwifi-2.6/net/mac80211/main.c:380!
> [  132.460013] invalid opcode: 0000 [#1] SMP

> [  132.460013] RIP: 0010:[<ffffffffa022fac2>]  [<ffffffffa022fac2>] ieee80211_alloc_hw+0x502/
> 0x520 [mac80211]

> [  132.460013]  [<ffffffffa02af53e>] iwl_alloc_all+0x1e/0x50 [iwlcore]

> The code in which the above appears is:
> (gdb) l *(ieee80211_alloc_hw+0x502)
> 0xaf2 is in ieee80211_alloc_hw (/home/wifi/iwlwifi-2.6/net/mac80211/main.c:380).
> 375	
> 376		ifmgd = &sdata->u.mgd;
> 377		mutex_lock(&ifmgd->mtx);
> 378		if (ifmgd->associated)
> 379			ieee80211_set_arp_filter(sdata);
> 380		mutex_unlock(&ifmgd->mtx);
> 381	
> 382		return NOTIFY_DONE;
> 383	}
> 384	#endif

Not sure why this appears as part of init? But anyway, the reason for
this is obvious -- we're not checking netif_running() in
ieee80211_ifa_changed, which we must since we only init the mutex as
part of open(). The fix would be to abort ieee80211_ifa_changed() if not
netif_running() -- before locking the mutex.

johannes

