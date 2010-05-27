Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0E0LLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 07:11:40 -0400
Subject: Re: [RFC PATCHv5] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274958042-25573-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274958042-25573-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 13:11:37 +0200
Message-ID: <1274958697.3669.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 14:00 +0300, Juuso Oikarinen wrote:

[...]

> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Btw, a patch changelog after the --- would be good.

Like, for example,

v5: no changes, still don't fix interface type crash


> +static int ieee80211_ifa_changed(struct notifier_block *nb,
> +				 unsigned long data, void *arg)
> +{
> +	struct in_ifaddr *ifa = arg;
> +	struct ieee80211_local *local =
> +		container_of(nb, struct ieee80211_local,
> +			     ifa_notifier);
> +	struct net_device *ndev = ifa->ifa_dev->dev;
> +	struct wireless_dev *wdev = ndev->ieee80211_ptr;
> +	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_if_managed *ifmgd;
> +
> +	/* Make sure it's our interface that got changed */
> +	if (!wdev)
> +		return NOTIFY_DONE;
> +
> +	if (wdev->wiphy != local->hw.wiphy)
> +		return NOTIFY_DONE;
> +
> +	/* We are concerned about IP addresses only when associated */
> +	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
> +	ifmgd = &sdata->u.mgd;
> +	mutex_lock(&ifmgd->mtx);
> +	if (ifmgd->associated)
> +		ieee80211_set_arp_filter(sdata);
> +	mutex_unlock(&ifmgd->mtx);
> +
> +	return NOTIFY_DONE;
> +}

Ok ...

Was I not clear enough? I thought I was or you'd have asked, but I can
spell it out too:

        This *will* crash if you use an interface of a type other than
        managed/station. You need to check the interface type here and
        document that the callback will only be invoked for managed mode
        interfaces.

johannes

