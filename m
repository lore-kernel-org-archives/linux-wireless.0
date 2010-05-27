Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54057 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0E0LUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 07:20:42 -0400
Subject: Re: [RFC PATCHv5] mac80211: Add support for hardware ARP query
 filtering
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274958697.3669.33.camel@jlt3.sipsolutions.net>
References: <1274958042-25573-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274958697.3669.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 14:22:13 +0300
Message-ID: <1274959333.5277.3472.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 13:11 +0200, ext Johannes Berg wrote:
> On Thu, 2010-05-27 at 14:00 +0300, Juuso Oikarinen wrote:
> 
> [...]
> 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> 
> Btw, a patch changelog after the --- would be good.
> 
> Like, for example,
> 
> v5: no changes, still don't fix interface type crash
> 
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
> > +	ifmgd = &sdata->u.mgd;
> > +	mutex_lock(&ifmgd->mtx);
> > +	if (ifmgd->associated)
> > +		ieee80211_set_arp_filter(sdata);
> > +	mutex_unlock(&ifmgd->mtx);
> > +
> > +	return NOTIFY_DONE;
> > +}
> 
> Ok ...
> 
> Was I not clear enough? I thought I was or you'd have asked, but I can
> spell it out too:
> 
>         This *will* crash if you use an interface of a type other than
>         managed/station. You need to check the interface type here and
>         document that the callback will only be invoked for managed mode
>         interfaces.

Hmm,

I'm sorry. This time I appear to have forgotten to commit :'(

I had added this:

        /* ARP filtering is only supported in managed mode */
        if (sdata->vif.type != NL80211_IFTYPE_STATION)
                return NOTIFY_DONE;

And even tested that with ad-hoc. I'll just have to go again.

-Juuso

> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


