Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3LENJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 08:09:19 -0500
Message-ID: <1386248952.4182.1.camel@jlt4.sipsolutions.net> (sfid-20131205_140922_976451_7EB0F98B)
Subject: Re: [PATCH v2 3/6] cfg80211: Enable GO operation on additional
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Thu, 05 Dec 2013 14:09:12 +0100
In-Reply-To: <1386098166-24196-4-git-send-email-ilan.peer@intel.com> (sfid-20131203_201542_768088_0385761E)
References: <1386098166-24196-1-git-send-email-ilan.peer@intel.com>
	 <1386098166-24196-4-git-send-email-ilan.peer@intel.com>
	 (sfid-20131203_201542_768088_0385761E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 21:16 +0200, Ilan Peer wrote:

> +#ifdef CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS
> +/* For GO only, check if the channel can be used under permissive conditions
> + * mandated by the some regulatory bodies, i.e., the channel is marked with
> + * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
> + * associated to an AP on the same channel or on the same UNII band
> + * (assuming that the AP is an authorized master).
> + */
> +static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
> +					struct ieee80211_channel *chan)
> +{

Seems like you could move the ifdef here ...

> +	struct wireless_dev *wdev_iter;
> +
> +	ASSERT_RTNL();
> +
> +	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
> +		return false;
> +
> +	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
> +		struct ieee80211_channel *other_chan = NULL;
> +
> +		if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
> +		    !netif_running(wdev_iter->netdev))
> +				continue;
> +
> +		wdev_lock(wdev_iter);
> +		if (wdev_iter->current_bss)
> +			other_chan = wdev_iter->current_bss->pub.channel;
> +		wdev_unlock(wdev_iter);
> +
> +		if (!other_chan)
> +			continue;
> +
> +		if (chan == other_chan) {
> +			return true;
> +		} else if (chan->band == IEEE80211_BAND_5GHZ) {
> +			int r1 = cfg80211_get_unii(chan->center_freq);
> +			int r2 = cfg80211_get_unii(other_chan->center_freq);
> +
> +			if (r1 != -EINVAL && r1 == r2)
> +				return true;
> +		}
> +	}

and here instead of duplicating the function prototype

> +	return false;
> +}

johannes

