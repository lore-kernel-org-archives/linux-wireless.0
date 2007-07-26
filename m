Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35555
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760741AbXGZRda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 13:33:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Date: Thu, 26 Jul 2007 19:31:41 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
In-Reply-To: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707261931.41448.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 July 2007 18:33:01 Larry Finger wrote:
> A typo in the specs interchanges the branches in an if statement, which
> breaks operations for a BCM4306/rev 2 that has phy->analog == 1.
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ---
> 
> John and Michael,
> 
> This patch is made for the wireless-dev tree after the bcm43xx-mac80211
> directory has been moved into drivers/net/wireless, but it needs to be
> applied to the wireless-mb tree as well.
> 
> Larry
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> ===================================================================
> --- wireless-dev/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> @@ -1895,7 +1895,7 @@ void bcm43xx_phy_set_baseband_attenuatio
>  		bcm43xx_write16(dev, BCM43xx_MMIO_PHY0,
>  				(bcm43xx_read16(dev, BCM43xx_MMIO_PHY0)
>  				 & 0xFFF0) | baseband_attenuation);
> -	} else if (phy->analog == 1) {
> +	} else if (phy->analog != 1) {
>  		bcm43xx_phy_write(dev, BCM43xx_PHY_DACCTL,
>  				  (bcm43xx_phy_read(dev, BCM43xx_PHY_DACCTL)
>  				   & 0xFFC3) | (baseband_attenuation << 2));
> 
> 

Last time I checked this code it matched the specs. And that's not too
long ago.
Did the specs change?

-- 
Greetings Michael.
