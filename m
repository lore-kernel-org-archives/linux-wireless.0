Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab0EYJNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 05:13:07 -0400
Subject: Re: [RFC PATCH] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274773685-11168-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1274773685-11168-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 11:13:22 +0200
Message-ID: <1274778802.3635.30.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-25 at 10:48 +0300, Juuso Oikarinen wrote:

> +struct in_ifaddr;
> +

I think you should include a header file for that, or was there a reason
you didn't?

> + * @configure_ip_filter: Configuration function for IP address based filters,
> + *      such as an ARP query filter. This function is called with all the IP
> + *      addresses configured to the interface as argument - all frames targeted
> + *      to any of these addresses should pass through.

Huh ok I thought you wanted ARP filtering, not IP filtering. You need to
be more explicit about what this should do. IP filtering is not useful
since those frames will be unicast on the ethernet layer. I think this
should be more focused on ARP filtering.

Additionally, it needs to be very explicit that it must filter ONLY ARP
packets that do not match any of the given IP addresses. If, for
example, the hardware can only handle 2 addresses, but you have 3 in the
list, the filter must be turned off. Any packet that the device cannot
parse properly must also be passed through. All such things should be
documented.

> +struct in_ifaddr;

You should get the right include too.

> +static inline int drv_configure_ip_filter(struct ieee80211_hw *hw,
> +					  struct in_ifaddr *ifa_list)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	int ret = 0;
> +
> +	if (local->ops->configure_ip_filter)
> +		ret = local->ops->configure_ip_filter(hw, ifa_list);
> +	return ret;
> +}

Tracing would be nice, you should even able able to trace all addresses
in a variable-length array.

> @@ -330,6 +330,7 @@ static int ieee80211_open(struct net_device *dev)
>  	if (sdata->vif.type == NL80211_IFTYPE_STATION)
>  		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
>  
> +	ieee80211_set_arp_filter(dev);

That seems unnecessary if drivers assume that there are no addresses to
start with?

BTW, how will drivers deal with getting this while unassociated? If, for
example, I set an address before associating, you'll get it while
unassociated and not again when associated. Another thing to document --
driver needs to handle that, DHCP is not everything :)

> +static int ieee80211_ifa_changed(struct notifier_block *nb,
> +				 unsigned long data, void *arg)
> +{
> +	struct in_ifaddr *ifa = arg;
> +	struct ieee80211_local *local =
> +		container_of(nb, struct ieee80211_local,
> +			     ifa_notifier);
> +	struct net_device *ndev = ifa->ifa_dev->dev;
> +	struct wireless_dev *wdev = ndev->ieee80211_ptr;
> +
> +	if (!wdev)
> +		return NOTIFY_DONE;
> +
> +	if (wdev->wiphy != local->hw.wiphy)
> +		return NOTIFY_DONE;
> +
> +	ieee80211_set_arp_filter(ndev);
> +	return NOTIFY_DONE;
> +}

This is obviously broken when you have multiple virtual interfaces, so
you either need to build a common list of IP addresses, or punt the
problem to the driver and give the callback an ieee80211_vif argument
and clearly document that the driver will have to keep track of it for
each interface.

johannes

