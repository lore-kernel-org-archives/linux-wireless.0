Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54608
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbXHFU0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 16:26:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcm43xx-mac80211: Add TX power set file to debugfs
Date: Mon, 6 Aug 2007 22:25:58 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b782f6.XGqOxV2KvXubz5jy%Larry.Finger@lwfinger.net>
In-Reply-To: <46b782f6.XGqOxV2KvXubz5jy%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708062225.58737.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 August 2007 22:22:14 Larry Finger wrote:
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> @@ -2762,12 +2762,11 @@ static int bcm43xx_dev_config(struct iee
>  	}
>  
>  	/* Adjust the desired TX power level. */
> -	if (conf->power_level != 0) {
> -		if (conf->power_level != phy->power_level) {
> -			phy->power_level = conf->power_level;
> -			bcm43xx_phy_xmitpower(dev);
> -		}
> -	}
> +	if (conf->power_level != 0 && phy->power_level == 0) {
> +		phy->power_level = conf->power_level;
> +	} else
> +		phy->power_level = 10;
> +	bcm43xx_phy_xmitpower(dev);

No, what's that? I disagree with that.
This breaks power adjustment.

>  
>  	/* Hide/Show the SSID (AP mode only). */
>  	if (conf->flags & IEEE80211_CONF_SSID_HIDDEN) {
> 
> 



-- 
Greetings Michael.
