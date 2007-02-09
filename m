Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56427
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423130AbXBISpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 13:45:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Fri, 9 Feb 2007 19:45:24 +0100
Cc: John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Joseph Jezak <josejx@gentoo.org>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
In-Reply-To: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702091945.25187.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 17:32, Larry Finger wrote:
> The specifications for the bcm43xx driver have been modified. This patch
> incorporates these changes in the code, which results in the BCM4311 and
> BCM4312 working. The name of one of the PHY parameters, previously known
> as "version", has been changed to "analog core version" .
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>

>  	if ((bcm->board_vendor != PCI_VENDOR_ID_BROADCOM) &&
>  	    (bcm->board_type != 0x0416)) {
> +		value = 0x2120;
>  		for (offset = 0x00A8 ; offset < 0x00C7; offset++) {
> -			bcm43xx_phy_write(bcm, offset,
> -					  (bcm43xx_phy_read(bcm, offset) + 0x2020)
> -					  & 0x3F3F);
> +			bcm43xx_phy_write(bcm, offset, value);

The specs are unclear at this point:
"Write the value to the offset"
Offset in which register type?

> @@ -933,6 +934,8 @@ static void bcm43xx_phy_initb6(struct bc
>  		                  bcm43xx_phy_read(bcm, 0x0802) | 0x0100);
>  		bcm43xx_phy_write(bcm, 0x042B,
>  		                  bcm43xx_phy_read(bcm, 0x042B) | 0x2000);
> +		bcm43xx_phy_write(bcm, 0x5B, 0x0000);
> +		bcm43xx_phy_write(bcm, 0x5C, 0x0000);
>  	}
>  
>  	/* Force to channel 7, even if not supported. */

Backup and reset old_channel later here, too.
Also, look at this:

# If the current channel is 8 or greater
   1. Set the channel to 1 
# Otherwise
   1. Set the channel to 13

> Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
> +++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
> @@ -1393,11 +1393,12 @@ u16 bcm43xx_radio_init2050(struct bcm43x
>  	backup[12] = bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT);
>  
>  	// Initialization
> -	if (phy->version == 0) {
> +	if (phy->analog == 0) {
>  		bcm43xx_write16(bcm, 0x03E6, 0x0122);
>  	} else {
> -		if (phy->version >= 2)
> -			bcm43xx_write16(bcm, 0x03E6, 0x0040);
> +		if (phy->analog >= 2)
> +			bcm43xx_write16(bcm, 0x0003, (bcm43xx_read16(bcm, 0x0003)
> +					& 0xFFBF) | 0x0040);

I think here is a specs bug.

>  		bcm43xx_write16(bcm, BCM43xx_MMIO_CHANNEL_EXT,
>  		                (bcm43xx_read16(bcm, BCM43xx_MMIO_CHANNEL_EXT) | 0x2000));
>  	}

-- 
Greetings Michael.
