Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0FGNTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:19:23 -0400
Subject: Re: [RFC PATCH] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <1275915965-10124-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1275915965-10124-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 15:19:21 +0200
Message-ID: <1275916761.29978.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 16:06 +0300, Juuso Oikarinen wrote:

> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -477,6 +477,9 @@ static int ieee80211_stop(struct net_device *dev)
>  		cancel_work_sync(&sdata->u.mgd.chswitch_work);
>  		cancel_work_sync(&sdata->u.mgd.monitor_work);
>  		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
> +#ifdef CONFIG_INET
> +		cancel_work_sync(&sdata->u.mgd.arp_config_work);
> +#endif

No can do, this is under RTNL and thus can't block waiting for a work
that acquires the RTNL ... the work might already be running, waiting
for the RTNL, by the time you get here. This will also get you a lockdep
complaint.

This is why 

> @@ -379,7 +379,8 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
>  	ifmgd = &sdata->u.mgd;
>  	mutex_lock(&ifmgd->mtx);
>  	if (ifmgd->associated)
> -		ieee80211_set_arp_filter(sdata);
> +		ieee80211_queue_work(&sdata->local->hw,
> +				     &sdata->u.mgd.arp_config_work);
>  	mutex_unlock(&ifmgd->mtx);

No need to do change it here since the rtnl is held outside.

Also, and this applies to the change in mlme.c too, you must never put
work that acquires the rtnl onto the mac80211 workqueue ... that's what
you were trying to fix to start with!

But because the interface might go away before your work runs, you're in
a stupid situation where you can't really use a per-interface work
either ... I think you probably need to have the work in ieee80211_local
and iterate the interface list.

johannes

