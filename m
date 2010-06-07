Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36368 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab0FGNmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:42:46 -0400
Subject: Re: [RFC PATCH] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>
In-Reply-To: <1275916761.29978.15.camel@jlt3.sipsolutions.net>
References: <1275915965-10124-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1275916761.29978.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 16:42:24 +0300
Message-ID: <1275918144.5277.30408.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 15:19 +0200, ext Johannes Berg wrote:
> On Mon, 2010-06-07 at 16:06 +0300, Juuso Oikarinen wrote:
> 
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -477,6 +477,9 @@ static int ieee80211_stop(struct net_device *dev)
> >  		cancel_work_sync(&sdata->u.mgd.chswitch_work);
> >  		cancel_work_sync(&sdata->u.mgd.monitor_work);
> >  		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
> > +#ifdef CONFIG_INET
> > +		cancel_work_sync(&sdata->u.mgd.arp_config_work);
> > +#endif
> 
> No can do, this is under RTNL and thus can't block waiting for a work
> that acquires the RTNL ... the work might already be running, waiting
> for the RTNL, by the time you get here. This will also get you a lockdep
> complaint.

The work-func escapes based on ieee80211_sdata_running before acquiring
the rtnl - hence here it should never get to the lock. I saw the same
being used in those other work funcs too. I was beginning work to try to
validate that, so it's not enough?

> This is why 
> 
> > @@ -379,7 +379,8 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
> >  	ifmgd = &sdata->u.mgd;
> >  	mutex_lock(&ifmgd->mtx);
> >  	if (ifmgd->associated)
> > -		ieee80211_set_arp_filter(sdata);
> > +		ieee80211_queue_work(&sdata->local->hw,
> > +				     &sdata->u.mgd.arp_config_work);
> >  	mutex_unlock(&ifmgd->mtx);
> 
> No need to do change it here since the rtnl is held outside.

Yes, I know rtnl is held outside. I changed this for two reasons. First,
I think it maybe better if the driver function is always called in the
same scope. Secondly, this gets rid of inetdevs intermediate
configurations (if you change IP address, it will first remove the
previous one, and immediately after add a new one, resulting in two
calls to the driver config function.)

> Also, and this applies to the change in mlme.c too, you must never put
> work that acquires the rtnl onto the mac80211 workqueue ... that's what
> you were trying to fix to start with!

> But because the interface might go away before your work runs, you're in
> a stupid situation where you can't really use a per-interface work
> either ... I think you probably need to have the work in ieee80211_local
> and iterate the interface list.

I thought about iterating the interface list. I assume you imply calling
the configure function for every interface.

Going still back to the current patch: assuming that you overlooked the
sdata_running() call in the arp_config_work() function, and we can after
all cancel_work_sync in _stop(), would using the kernel's default
workqueue solve the rtnl problem, or are the rtnl dependencies there
too?

-Juuso

> johannes
> 


