Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57628
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763061AbXHCVjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 17:39:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Set antenna gains if not in sprom
Date: Fri, 3 Aug 2007 23:38:43 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b39d7d.4kGviB6QZBFl2jfv%Larry.Finger@lwfinger.net>
In-Reply-To: <46b39d7d.4kGviB6QZBFl2jfv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708032338.43593.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007 23:26:21 Larry Finger wrote:
> In the sprom for bcm43xx devices, any unprogrammed values are set to all ones.
> In the case of antenna gains, the specs indicate that a gain of 2 dBm should
> be set if no value is stored. This patch implements that provision.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> @@ -3805,6 +3805,12 @@ static void bcm43xx_sprom_fixup(struct s
>  	    bus->boardinfo.rev > 0x40)
>  		bus->sprom.r1.boardflags_lo |= BCM43xx_BFL_PACTRL;
>  
> +	/* Handle case when gain is not set in sprom */
> +	if (bus->sprom.r1.antenna_gain_a == 0xFF)
> +		bus->sprom.r1.antenna_gain_a = 2;
> +	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
> +		bus->sprom.r1.antenna_gain_bg = 2;
> +
>  	/* Convert Antennagain values to Q5.2 */
>  	bus->sprom.r1.antenna_gain_a <<= 2;
>  	bus->sprom.r1.antenna_gain_bg <<= 2;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Queued, thanks!

-- 
Greetings Michael.
