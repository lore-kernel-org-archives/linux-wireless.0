Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2FTIkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:40:06 -0400
Message-ID: <1340181600.4655.34.camel@jlt3.sipsolutions.net> (sfid-20120620_104013_479030_02593FA0)
Subject: Re: [PATCH v2 1/7] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 10:40:00 +0200
In-Reply-To: <1340111463-4554-1-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:10 +0300, Victor Goldenshtein wrote:

> +	NL80211_CMD_RADAR_DETECT,

Is there no need to ever stop radar detection?

> + * @radar_detect_timeout: this timeout indicates the end of the channel
> + *	availability check for radar channels, only after this period the
> + *	user may initiate the tx on the channel.

units? internal use, or for use by drivers? should it really be stored
in the global channel struct that could be shared for multiple devices?

>  /**
> + * cfg80211_radar_detected - radar detection event
> + * @dev: network device
> + * @freq: radar detected on this channel frequency (in MHz)
> + * @gfp: context flags
> + *
> + * This function is called when a radar is detected on the current channel.
> + */
> +void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp);

Better to pass the channel pointer?

> +u16 cfg80211_calculate_bitrate(struct rate_info *rate);

??

> +void cfg80211_radar_detected(struct net_device *dev, u16 freq, gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct wiphy *wiphy = wdev->wiphy;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +	struct ieee80211_channel *chan;
> +
> +	chan = ieee80211_get_channel(&rdev->wiphy, freq);
> +	if (chan)
> +		chan->radar_detect_timeout = 0;

So how do you distinguish between having ever done radar detection and
never even having started it? Also, jiffies + ... can return 0.


How do you intend to handle HT40?

johannes

