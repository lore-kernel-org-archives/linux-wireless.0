Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20253 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0E0JDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 05:03:25 -0400
Subject: Re: [RFC PATCHv3] mac80211: Add support for hardware ARP query
 filtering
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274948667.3669.19.camel@jlt3.sipsolutions.net>
References: <1274940287-18980-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274948667.3669.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 12:05:17 +0300
Message-ID: <1274951117.5277.3155.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 10:24 +0200, ext Johannes Berg wrote:
> On Thu, 2010-05-27 at 09:04 +0300, Juuso Oikarinen wrote:
> 
> > +static int ieee80211_ifa_changed(struct notifier_block *nb,
> > +				 unsigned long data, void *arg)
> > +{
> > +	struct in_ifaddr *ifa = arg;
> > +	struct ieee80211_local *local =
> > +		container_of(nb, struct ieee80211_local,
> > +			     ifa_notifier);
> > +	struct net_device *ndev = ifa->ifa_dev->dev;
> > +	struct wireless_dev *wdev = ndev->ieee80211_ptr;
> > +	struct ieee80211_sub_if_data *sdata;
> > +	struct ieee80211_if_managed *ifmgd;
> > +
> > +	/* Make sure it's our interface that got changed */
> > +	if (!wdev)
> > +		return NOTIFY_DONE;
> > +
> > +	if (wdev->wiphy != local->hw.wiphy)
> > +		return NOTIFY_DONE;
> > +
> > +	/* We are concerned about IP addresses only when associated */
> > +	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
> > +	mutex_lock(&sdata->u.mgd.mtx);
> > +	ifmgd = &sdata->u.mgd;
> > +	if (ifmgd->associated)
> > +		ieee80211_set_arp_filter(sdata);
> > +	mutex_unlock(&sdata->u.mgd.mtx);
> 
> I'm sure this will fail in interesting ways since nothing guarantees
> that this interface is in managed mode.

S***, I need a vacation. This is bound to fail even if the interface is
in managed mode, as it's not protecting the right thing. 

I was already looking at the ifmgd->mtx but somehow managed to
copy-paste this one :(

-Juuso

> johannes
> 


