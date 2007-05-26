Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50666
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbXEZRTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 13:19:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
Date: Sat, 26 May 2007 19:19:38 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net>
In-Reply-To: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705261919.39143.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 19:09:34 Larry Finger wrote:
> Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> ===================================================================
> --- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> +++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
> @@ -4122,6 +4122,10 @@ void bcm43xx_radio_set_txpower_bg(struct
>  	tx_magn = _tx_magn;
>  	phy->bbatt = baseband_attenuation;
>  	phy->rfatt = radio_attenuation;
> +	if (tx_bias == 0xFF) {
> +		bcm43xx_lo_g_measure(dev);
> +		tx_bias = phy->lo_control->tx_bias;
> +	}
>  
>  	/* Set Baseband Attenuation on device. */
>  	bcm43xx_phy_set_baseband_attenuation(dev, baseband_attenuation);

Ok, on which specification bits is this actually based? :)
txpower_bg still needs a rewrite, and I have a patch for that in
the pipeline, but it's still buggy due to missing specs stuff.

-- 
Greetings Michael.
