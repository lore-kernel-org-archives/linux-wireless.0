Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35923 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYJKNlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:41:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: make retry limits part of hw config
Date: Sat, 11 Oct 2008 15:41:14 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <1223682835.29811.10.camel@johannes.berg>
In-Reply-To: <1223682835.29811.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810111541.14983.mb@bu3sch.de> (sfid-20081011_154150_246410_CB1A75D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 11 October 2008 01:53:55 Johannes Berg wrote:
>  static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
>  {
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
> @@ -3333,6 +3349,20 @@ static int b43_op_config(struct ieee8021
>  
>  	mutex_lock(&wl->mutex);
>  
> +	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
> +		dev = wl->current_dev;
> +		if (unlikely(!dev || (b43_status(dev) < B43_STAT_INITIALIZED))) {
> +			err = -ENODEV;
> +			goto out_unlock_mutex;
> +		}
> +		b43_set_retry_limits(dev, conf->short_frame_max_tx_count,
> +					  conf->long_frame_max_tx_count);
> +		changed &= ~IEEE80211_CONF_CHANGE_RETRY_LIMITS;
> +	}
> +
> +	if (!changed)
> +		goto out_unlock_mutex;
> +
>  	/* Switch the band (if necessary). This might change the active core. */
>  	err = b43_switch_band(wl, conf->channel);
>  	if (err)

This must be done _after_ bandswitch. (You also have a valid dev pointer there.
Just do it after the checks done there).

> @@ -2570,10 +2584,27 @@ static int b43legacy_op_dev_config(struc
>  	int err = 0;
>  	u32 savedirqs;
>  
> +	mutex_lock(&wl->mutex);
> +	dev = wl->current_dev;
> +
> +	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
> +		if (unlikely(!dev ||
> +			     (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED))) {
> +			err = -ENODEV;
> +			goto out_unlock_mutex;
> +		}
> +		b43legacy_set_retry_limits(dev,
> +					   conf->short_frame_max_tx_count,
> +					   conf->long_frame_max_tx_count);
> +		changed &= ~IEEE80211_CONF_CHANGE_RETRY_LIMITS;
> +	}
> +
> +	if (!changed)
> +		goto out_unlock_mutex;
> +
>  	antenna_tx = B43legacy_ANTENNA_DEFAULT;
>  	antenna_rx = B43legacy_ANTENNA_DEFAULT;
>  
> -	mutex_lock(&wl->mutex);
>  	dev = wl->current_dev;

This also is a bit fishy.

>  	phy = &dev->phy;
>  
> @@ -2989,20 +3020,6 @@ static void b43legacy_imcfglo_timeouts_w
>  #endif /* CONFIG_SSB_DRIVER_PCICORE */
>  }
>  

-- 
Greetings Michael.
