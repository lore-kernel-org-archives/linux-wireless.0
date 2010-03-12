Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab0CLMAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 07:00:22 -0500
Subject: Re: [RFC PATCH 1/2] cfg80211: Add roaming trigger support to
 nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268393671-5498-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268393671-5498-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 04:00:13 -0800
Message-ID: <1268395213.4828.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-12 at 13:34 +0200, Juuso Oikarinen wrote:
> Add support for basic configuration of a roaming RSSI trigger to the nl80211
> interface, and basic support for notifying about trigger events.

Cool.

> +	NL80211_ATTR_RTRIG_RSSI_STATE,
> +	NL80211_ATTR_RTRIG_RSSI_THOLD,
> +	NL80211_ATTR_RTRIG_RSSI_HYST,
> +	NL80211_ATTR_RTRIG_LEVEL,

IMHO we should have one NL80211_ATTR_ROAM_TRIGGER_CONFIG or something
like that which nests NL80211_RTRIG_ATTR_* from a separate attribute
namespace (note the transposition to tell which namespace they belong
to) so it's easier to understand when extended.

> +enum nl80211_rtrig_rssi_state {
> +	NL80211_RTRIG_RSSI_DISABLED,
> +	NL80211_RTRIG_RSSI_ENABLED,
> +};

Shouldn't _STATE be implicitly enabled when you give the required
attributes? Missing docstrings too.

Also overall I'm not sure this should be called roam_trigger at all. It
will eventually trigger roaming in userspace, but I think the actual
feature it implements in the kernel/device side is better called
something like "connection quality monitoring".

> +/**
> + * enum ieee80211_roam_trigger_level - supported frequency bands

??

> + * @IEEE80211_ROAM_TRIGGER_LOW: current RSSI level is below the threshold
> + * @IEEE80211_ROAM_TRIGGER_HIGH: current RSSI level is above the threshold
> + */

> +
> +enum ieee80211_roam_trigger_level {
> +	IEEE80211_ROAM_TRIGGER_LEVEL_LOW,
> +	IEEE80211_ROAM_TRIGGER_LEVEL_HIGH,
> +};

You should just reuse the nl80211 enum.

> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 7fdb940..c8156d6 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -713,6 +713,18 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
>  				wdev->ps = false;
>  			}
>  
> +		wdev->rtrig_rssi = false;
> +		wdev->rtrig_rssi_thold = -75;
> +		wdev->rtrig_rssi_hyst = 2;
> +		if (rdev->ops->set_roam_trigger)
> +			if (rdev->ops->set_roam_trigger(wdev->wiphy, dev,
> +							wdev->rtrig_rssi,
> +							wdev->rtrig_rssi_thold,
> +							wdev->rtrig_rssi_hyst)) {
> +				/* assume this means it's off */
> +				wdev->rtrig_rssi = false;
> +			}

I'm not sure I agree this should be enabled by default ... it needs
software listening to it anyway so that software can just enable it.

Also, you don't need to keep track of rtrig_rssi etc. in the wdev since
you never read those variables again, unless you want to add code to
export them again when the interface configuration is dumped out.

Either way, it's a good start, thanks for doing this work.

johannes

