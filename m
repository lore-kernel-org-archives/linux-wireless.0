Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49417
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXBOPKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:10:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 07/10] bcm43xx-d80211: update for wiphy api
Date: Thu, 15 Feb 2007 16:09:58 +0100
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
References: <20070215144241.847938000@sipsolutions.net> <20070215144259.397393000@sipsolutions.net>
In-Reply-To: <20070215144259.397393000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702151609.58861.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 February 2007 15:42, Johannes Berg wrote:
> update bcm43xx-d80211.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK for this.

> ---
> Really bcm43xx should be using the new wiphy debugfs stuff as well,
> but I can't figure out what the hell it is doing when multiple
> devices exist in a system. Thing is the new debugfs dir is only

What do you mean? It registers multiple ieee80211_hw, of course.
Look at bcm43xx_wireless_init(), that's per-card (not per core).

> created for d80211 drivers when calling register_hw() and all items
> must be gone from it when calling free_hw()...
> 
> ---
>  drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c |    2 +-
>  drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c    |   15 ++++++---------
>  2 files changed, 7 insertions(+), 10 deletions(-)
> 
> --- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-15 13:50:28.967940064 +0100
> +++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_main.c	2007-02-15 14:01:33.486635438 +0100
> @@ -3282,7 +3282,7 @@ static int bcm43xx_wireless_core_init(st
>  	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
>  	bcm43xx_macfilter_clear(dev, BCM43xx_MACFILTER_ASSOC);
>  	bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_SELF,
> -			      (u8 *)(wl->hw->perm_addr));
> +			      (u8 *)(wl->hw->wiphy->perm_addr));
>  	bcm43xx_security_init(dev);
>  	bcm43xx_measure_channel_change_time(dev);
>  
> @@ -3743,14 +3743,11 @@ static int bcm43xx_wireless_init(struct 
>  		    IEEE80211_HW_WEP_INCLUDE_IV;
>  	hw->maxssi = BCM43xx_RX_MAX_SSI;
>  	hw->queues = 1;
> -	hw->dev = &dev->dev;
> -	if (is_valid_ether_addr(sprom->r1.et1mac)) {
> -		memcpy(hw->perm_addr, sprom->r1.et1mac,
> -		       ARRAY_SIZE(hw->perm_addr));
> -	} else {
> -		memcpy(hw->perm_addr, sprom->r1.il0mac,
> -		       ARRAY_SIZE(hw->perm_addr));
> -	}
> +	SET_IEEE80211_DEV(hw, &dev->dev);
> +	if (is_valid_ether_addr(sprom->r1.et1mac))
> +		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
> +	else
> +		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
>  
>  	/* Get and initialize struct bcm43xx_wl */
>  	wl = hw_to_bcm43xx_wl(hw);
> --- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-15 13:50:28.917940064 +0100
> +++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_debugfs.c	2007-02-15 14:02:18.646635438 +0100
> @@ -308,7 +308,7 @@ void bcm43xx_debugfs_add_device(struct b
>  
>  	dev->dfsentry = e;
>  
> -	snprintf(devdir, sizeof(devdir), "wiphy%d", dev->wl->hw->index);
> +	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
>  	e->subdir = debugfs_create_dir(devdir, fs.root);
>  	e->dentry_tsf = debugfs_create_file("tsf", 0666, e->subdir,
>  	                                    dev, &tsf_fops);
> 
> --
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Greetings Michael.
