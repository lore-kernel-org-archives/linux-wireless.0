Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50750
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422714AbXBURUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 12:20:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/3] d80211: Split antenna selection into TX and RX antenna
Date: Wed, 21 Feb 2007 18:19:51 +0100
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702211702.47410.IvDoorn@gmail.com> <200702211751.27245.mb@bu3sch.de> <200702211806.44665.IvDoorn@gmail.com>
In-Reply-To: <200702211806.44665.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702211819.52114.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 February 2007 18:06, Ivo van Doorn wrote:
> diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> index cdce227..1256549 100644
> --- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> +++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c
> @@ -2606,22 +2606,12 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
>  	struct bcm43xx_phy *phy;
>  	unsigned long flags;
>  	unsigned int new_phymode = 0xFFFF;
> -	int antenna = -1;
> +	int antenna_tx;
> +	int antenna_rx;
>  	int err = 0;
>  
> -	switch (conf->antenna_sel) {
> -	case 0: /* default/diversity */
> -		antenna = BCM43xx_ANTENNA_DEFAULT;
> -		break;
> -	case 1: /* Antenna 0 */
> -		antenna = BCM43xx_ANTENNA0;
> -		break;
> -	case 2: /* Antenna 1 */
> -		antenna = BCM43xx_ANTENNA1;
> -		break;
> -	default:
> -		assert(0);
> -	}
> +	antenna_tx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_tx);
> +	antenna_rx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_rx);
>  
>  	mutex_lock(&wl->mutex);
>  
> @@ -2682,8 +2672,8 @@ static int bcm43xx_dev_config(struct ieee80211_hw *hw,
>  	}
>  
>  	/* Antennas for RX and management frame TX. */
> -	bcm43xx_mgmtframe_txantenna(dev, antenna);
> -	bcm43xx_set_rx_antenna(dev, antenna);
> +	bcm43xx_mgmtframe_txantenna(dev, antenna_tx);
> +	bcm43xx_set_rx_antenna(dev, antenna_rx);
>  
>  	/* Update templates for AP mode. */
>  	if (bcm43xx_is_mode(wl, IEEE80211_IF_TYPE_AP))
> diff --git a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
> index e56efc1..bba6606 100644
> --- a/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
> +++ b/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.h
> @@ -110,6 +110,22 @@ int bcm43xx_is_ofdm_rate(int rate)
>  }
>  
>  static inline
> +int bcm43xx_antenna_from_ieee80211(u8 antenna)
> +{
> +	switch (antenna) {
> +	case 0: /* default/diversity */
> +		return BCM43xx_ANTENNA_DEFAULT;
> +	case 1: /* Antenna 0 */
> +		return BCM43xx_ANTENNA0;
> +	case 2: /* Antenna 1 */
> +		return BCM43xx_ANTENNA1;
> +	default:
> +		assert(0);
> +		return -EINVAL;
> +	}
> +}

No, there is no need to inline. Simple static in main.c above
the config callback, please. :)
And simply return BCM43xx_ANTENNA_DEFAULT for the default:
case, so it doesn't break immediately, if someone decides
to add something to d80211.

...But we've almost got it :D
After that you'll get my sign-off.

-- 
Greetings Michael.
