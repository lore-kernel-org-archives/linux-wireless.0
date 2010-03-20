Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0CTQvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 12:51:36 -0400
Subject: Re: [RFC PATCHv5 2/2] mac80211: Add support for connection quality
 monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
In-Reply-To: <1268985801-25225-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1268985801-25225-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268985801-25225-3-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 09:50:48 -0700
Message-ID: <1269103848.4652.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-19 at 10:03 +0200, Juuso Oikarinen wrote:

> + * @IEEE80211_HW_SUPPORTS_CQM:
> + *	Hardware can do connection quality monitoring - i.e. it can monitor
> + *	connection quality related parameters, such as the RSSI level and
> + *	provide notifications if configured trigger levels are reached.

It doesn't really matter at this point, before we have any other CQM
data point implementations, but I would expect this to be CQM_RSSI,
CQM_BEACON_LOSS etc. in different flags eventually since not all might
be supported and one might want to allow some w/o the others?

> +static int ieee80211_set_cqm_config(struct wiphy *wiphy,
> +				    struct net_device *dev,
> +				    s32 rssi_thold, u8 rssi_hyst)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_vif *vif = &sdata->vif;
> +	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
> +
> +	if (vif->type != NL80211_IFTYPE_STATION)
> +		return -EOPNOTSUPP;

I think this check should probably be in cfg80211, it really doesn't
make sense in any other mode.

I'm sorry for making you go through iterations over and over again!

johannes

