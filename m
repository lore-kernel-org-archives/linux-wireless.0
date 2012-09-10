Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2IJKwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 06:52:41 -0400
Message-ID: <1347274394.4272.8.camel@jlt4.sipsolutions.net> (sfid-20120910_125244_802039_1D666F9E)
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 12:53:14 +0200
In-Reply-To: <1344426823-1795-2-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-2-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 14:53 +0300, Victor Goldenshtein wrote:

> + * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.

How will you know what kind of radar detection is supported? That is, HT
20, HT 40, in the future VHT80/160/80+80?

> +	int	(*start_radar_detection)(struct wiphy *wiphy,
> +					 struct net_device *dev,
> +					 struct ieee80211_channel *chan);

Channel type/bandwidth might be needed?

> +void cfg80211_radar_detected(struct net_device *dev,
> +			     struct ieee80211_channel *chan, gfp_t gfp);

Is the channel parameter useful? Only one detection can be triggered at
any given time.

>  void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> @@ -1006,3 +1008,39 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
>  	return nl80211_unexpected_4addr_frame(dev, addr, gfp);
>  }
>  EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
> +
> +int cfg80211_start_radar_detection(struct cfg80211_registered_device *rdev,
> +				   struct net_device *dev,
> +				   struct ieee80211_channel *chan)
> +{
> +	int err;
> +
> +	if (!rdev->ops->start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, chan);
> +	if (!err)
> +		chan->radar_detect_timeout = jiffies +
> +			msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
> +	else {
> +		chan->radar_detect_timeout = 0;
> +		chan->cac_type = 0;
> +	}

You're not setting cac_type in the good case, and also
radar_detect_timeout can actually be 0 in the good case due to jiffies
wrap. How is that handled?

> +	chan->cac_type = 0;

Also here and above you should use channel type enums. In fact, 0 is
"NOHT". Oops. Need a boolean I guess that indicates validity.

> +	bool dfs_supported = (rdev->wiphy.features & NL80211_FEATURE_DFS);

why bother with the variable?

> +	if (!chan || !(chan->flags & IEEE80211_CHAN_RADAR))
> +		return -EINVAL;
> +
> +	if (chan->cac_type)
> +		return -EBUSY;
> +
> +	chan->cac_type = cac_type;

Aha. But these things probably should be in the function:

> +	return cfg80211_start_radar_detection(rdev, dev, chan);

so it's actually a potentially useful function for other places.
Otherwise you could just manually inline it here, I see no issues with
that either.

johannes

