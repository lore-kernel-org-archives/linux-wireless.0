Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43860 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933062AbcK1OsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:48:02 -0500
Message-ID: <1480344479.8107.60.camel@sipsolutions.net> (sfid-20161128_154805_842740_78514B62)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 28 Nov 2016 15:47:59 +0100
In-Reply-To: <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com> (sfid-20161106_030854_712830_960200F6)
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
         <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com>
         (sfid-20161106_030854_712830_960200F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @set_cqm_rssi_range_config: Configure two RSSI thresholds in the
> > + *	connection quality monitor.  Even if the driver implements both the
> > + *	single threshold and low/high thresholds mechanisms, it should assume
> + *	only one is active at any time.

Why would a driver still (be allowed to!) implement both?

> +	int	(*set_cqm_rssi_range_config)(struct wiphy *wiphy,
> +					     struct net_device *dev,
> +					     s32 rssi_low, s32 rssi_high);

Seems there still should be a hysteresis? Or am I misunderstanding the
intent here? I.e. isn't it meant to report low/medium/high later?

> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 33026e1..7da1056 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h

I'd prefer you split cfg80211 and mac80211 patches, i.e. provide the
new API first and then implement it in mac80211 separately.

> +void cfg80211_cqm_config_free(struct wireless_dev *wdev)
> +{
> +	if (!wdev->cqm_config)
> +		return;
> +
> +	kfree(wdev->cqm_config->rssi_thresholds);
> +	kfree(wdev->cqm_config);
> +	wdev->cqm_config = NULL;
> +}

You can save this complexity by just making the cqm_config struct have
all the thresholds inside itself - pretty easy to allocate by just
counting them first.

johannes
