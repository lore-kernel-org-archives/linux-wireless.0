Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab0E0JYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 05:24:21 -0400
Subject: Re: [RFC PATCHv4] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274951799-18615-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274951799-18615-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 11:24:19 +0200
Message-ID: <1274952259.3669.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 12:16 +0300, Juuso Oikarinen wrote:

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

Still broken, you misunderstood my comment.

johannes

