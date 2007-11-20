Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbXKTQrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 11:47:22 -0500
Subject: Re: [RFC] mac80211: always have a valid master device mac address
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195564936.10920.21.camel@johannes.berg>
References: <1195517851.19479.24.camel@johannes.berg>
	 (sfid-20071120_123645_893727_38226573)  <1195564936.10920.21.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 11:43:51 -0500
Message-Id: <1195577031.3389.33.camel@localhost.localdomain> (sfid-20071120_164724_822609_A1DD2840)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-20 at 14:22 +0100, Johannes Berg wrote:
> On Tue, 2007-11-20 at 01:17 +0100, Johannes Berg wrote:
> > Once a while a driver will give us a bogus MAC address. This can be
> > remedied by the user by setting the MAC address on the wlanX interface,
> > but unfortunately one cannot change the address of the wmasterX
> > interface which results in wlanX going up but wmasterX refusing to. This
> > is pretty bad. This patch forces wmasterX to have a valid MAC address.
> > The actual address doesn't matter at all.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Or should we hardcode one and always use that instead of the device
> > address?
> 
> Hmm. Considering this. udev has trouble with devices with the same MAC
> address, maybe we *should* hardcode a different one? That'd also stop
> people from using the master device's MAC address as the "eeprom MAC"
> that should be gotten from sysfs instead. It's bound to happen ;)

It's a udev _rules_ problem, not a udev problem really.  Because
mac80211 was quite new, the udev rules weren't differentiating between
the wmaster and the wlan interfaces.  The rules need to be updated (and
have been for many distros) to check the 'type' attribute of the sysfs
dir of the device before deciding what to do with it.

Dan

> > --- everything.orig/net/mac80211/ieee80211.c	2007-11-20 00:25:03.008708602 +0100
> > +++ everything/net/mac80211/ieee80211.c	2007-11-20 00:27:09.278700356 +0100
> > @@ -1286,6 +1286,8 @@ int ieee80211_register_hw(struct ieee802
> >  		goto fail_dev;
> >  
> >  	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
> > +	if (!is_valid_ether_addr(local->mdev->dev_addr))
> > +		random_ether_addr(local->mdev->dev_addr);
> >  	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
> >  
> >  	result = register_netdevice(local->mdev);
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

