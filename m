Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45185
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966269AbXDGSr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 14:47:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix error in initiallizing max RSSI and max signal
Date: Sat, 7 Apr 2007 20:47:23 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4617dc25.vXqEEvwca/gaq2Cw%Larry.Finger@lwfinger.net>
In-Reply-To: <4617dc25.vXqEEvwca/gaq2Cw%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200704072047.24192.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 07 April 2007 20:00, Larry Finger wrote:
> In bcm43xx-mac80211, the max_rssi and max_signal values sent to mac80211 are reversed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This is wireless-dev material.

I applied it to my tree, thanks.

> Michael,
> 
> It can also be applied to the mb tree.
> 
> Larry
> 
>  bcm43xx_main.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> +++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> @@ -3760,8 +3760,8 @@ static int bcm43xx_wireless_init(struct 
>  		    IEEE80211_HW_MONITOR_DURING_OPER |
>  		    IEEE80211_HW_DEVICE_HIDES_WEP |
>  		    IEEE80211_HW_WEP_INCLUDE_IV;
> -	hw->max_rssi = -110;
> -	hw->max_signal = BCM43xx_RX_MAX_SSI;
> +	hw->max_signal = -110;
> +	hw->max_rssi = BCM43xx_RX_MAX_SSI;
>  	hw->max_noise = -110;
>  	hw->queues = 1;
>  	SET_IEEE80211_DEV(hw, dev->dev);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Greetings Michael.
