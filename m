Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab0FOJ36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 05:29:58 -0400
Subject: Re: [RFC PATCH] nl80211/cfg80211/mac80211: Add support for setting
 transmit power
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1276593453-27818-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1276593453-27818-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 11:29:55 +0200
Message-ID: <1276594195.3648.54.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 12:17 +0300, Juuso Oikarinen wrote:

> + * @NL80211_CMD_SET_TX_POWER: Set the used transmit power level (using
> + *	%NL80211_ATTR_TX_POWER_SETTING and %NL80211_ATTR_TX_POWER_LEVEL).

We have a lot of such settings (RTS threshold, coverage class, ...) done
with SET_WIPHY, shouldn't this also be done there?

> +	/*
> +	 * Though the nl80211 supports negative mBm values, the interface
> +	 * below it does not, for now.
> +	 */
> +	if (mbm < 0) {
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	rtnl_lock();
> +
> +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> +	if (err)
> +		goto unlock_rdev;
> +
> +	wdev = dev->ieee80211_ptr;
> +
> +	if (!rdev->ops->set_tx_power) {
> +		return -EOPNOTSUPP;
> +		goto unlock_rdev;
> +	}
> +
> +	err = rdev->ops->set_tx_power(wdev->wiphy, type, MBM_TO_DBM(mbm));

I think the API mismatch should be handled in mac80211 rather than
cfg80211, that goes for both the negative values (actually, shouldn't
that be non-positive for mac80211?) and mBm vs. dBm -- and mac80211
should probably reject fractional dBm values for now.

johannes

