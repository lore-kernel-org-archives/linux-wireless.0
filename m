Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48011 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbcA0M2k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 07:28:40 -0500
Message-ID: <1453897716.2351.5.camel@sipsolutions.net> (sfid-20160127_132843_675817_A137C4AE)
Subject: Re: [PATCH] wext: fix message delay/ordering
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beniamino Galvani <bgalvani@redhat.com>
Date: Wed, 27 Jan 2016 13:28:36 +0100
In-Reply-To: <1453897114.2351.4.camel@sipsolutions.net> (sfid-20160127_131839_160369_0C70BCFE)
References: <1453896850-22775-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20160127_131419_031860_43892E09) <1453897040.2351.3.camel@sipsolutions.net>
	 (sfid-20160127_131726_366051_5927EBBD) <1453897114.2351.4.camel@sipsolutions.net>
	 (sfid-20160127_131839_160369_0C70BCFE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-27 at 13:18 +0100, Johannes Berg wrote:
> > > +	if (state == NETDEV_UNREGISTER)
> > > +		wireless_nlevent_flush();
> > > 
> > It could be argued that the state check isn't really necessary and
> > should be removed to avoid ordering issues with up/down vs. wext,
> > but
> > this fixes the really strange issue where you get an RTM_NEWLINK
> > after
> > RTM_DELLINK (with the same ifidx), and I don't see how any software
> > would care much about the ordering otherwise.
> > 
> 
> Actually though, with the fix I still get:
> 
> 5: wlan1: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN group
> default 
>     link/ether 02:00:00:00:01:00 brd ff:ff:ff:ff:ff:ff
> 5: wlan1: <BROADCAST,MULTICAST,UP> 
>     link/ether 
> Deleted 5: wlan1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state
> DOWN group default 
>     link/ether 02:00:00:00:01:00 brd ff:ff:ff:ff:ff:ff
> 
> which is clearly odd (see the UP flag), so I'll change it.
> 

Doesn't help, since the wext netdev notifier is registered earlier and
thus runs earlier than the cfg80211 one that triggers the action ...

I'll fix that differently then.

johannes
