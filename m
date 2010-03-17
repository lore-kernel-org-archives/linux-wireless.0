Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0CQQPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:15:04 -0400
Subject: Re: [RFC PATCHv3 1/1] mac80211: Add support connection monitor in
 hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:15:03 -0700
Message-ID: <1268842503.5989.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + *
> + * When hardware connection monitoring is enabled with
> + * IEEE80211_HW_CONNECTION_MONITOR, this function will cause immediate change
> + * to disassociated state, without connection recovery attempts.

Tiny detail: putting a % in front of constants formats them nicer in the
html output.

> +static void ieee80211_beacon_loss_disassoc(struct ieee80211_sub_if_data *sdata)
> +{

I can see where you're coming from, but maybe this should be more like
ieee80211_driver_notify_disconnect() or something like that?


> +	printk(KERN_DEBUG "Beacon loss from AP %pM, "
> +	       "disconnected.\n", bssid);

printk lines are allowed to pass 80 chars to make grep easier. Also I
really think this should be more like "Connection to AP %pM lost." or
something like that?

>  void ieee80211_beacon_loss_work(struct work_struct *work)
>  {
>  	struct ieee80211_sub_if_data *sdata =
>  		container_of(work, struct ieee80211_sub_if_data,
>  			     u.mgd.beacon_loss_work);
>  
> -	ieee80211_mgd_probe_ap(sdata, true);
> +	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
> +		ieee80211_beacon_loss_disassoc(sdata);
> +	else
> +		ieee80211_mgd_probe_ap(sdata, true);
>  }

And I'm actually wondering now if using the same API is a good idea.
Yes, it makes some sense, but it's quite different yet? Maybe we should
have something like this:

static inline void ieee80211_beacon_loss(hw, vif)
{
	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
	__ieee80211_beacon_connection_loss(vif);
}

static inline void ieee80211_connection_loss(hw, vif)
{
	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
	__ieee80211_beacon_connection_loss(vif);
}

to make at least the external API easier to understand?

johannes

