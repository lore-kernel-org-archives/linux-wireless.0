Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60721
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXBVQIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 11:08:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix for 4311 and 02/07/07 specification changes
Date: Thu, 22 Feb 2007 17:07:43 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
In-Reply-To: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702221707.43730.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 February 2007 23:54, Larry Finger wrote:
> The specifications for the bcm43xx driver have been modified. This patch
> incorporates these changes in the code, which results in the BCM4311 and
> BCM4312 working. The name of one of the PHY parameters, previously known
> as "version", has been changed to "analog", short for  "analog core version" .
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ---

Sorry for the late review. If this is already applied,
please create a patch on top of it.

> @@ -835,61 +843,24 @@ static void bcm43xx_phy_initb6(struct bc
>  	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
>  	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
>  	u16 offset, val;
> +	u8 old_channel;
>  
>  	bcm43xx_phy_write(bcm, 0x003E, 0x817A);
>  	bcm43xx_radio_write16(bcm, 0x007A,
>  	                      (bcm43xx_radio_read16(bcm, 0x007A) | 0x0058));
> -	if ((radio->manufact == 0x17F) &&
> -	    (radio->version == 0x2050) &&
> -	    (radio->revision == 3 ||
> -	     radio->revision == 4 ||
> -	     radio->revision == 5)) {
> -		bcm43xx_radio_write16(bcm, 0x0051, 0x001F);
> -		bcm43xx_radio_write16(bcm, 0x0052, 0x0040);
> -		bcm43xx_radio_write16(bcm, 0x0053, 0x005B);
> -		bcm43xx_radio_write16(bcm, 0x0054, 0x0098);
> +	if (radio->revision == 4 ||
> +	     radio->revision == 5) {
> +		bcm43xx_radio_write16(bcm, 0x0051, 0x0037);
> +		bcm43xx_radio_write16(bcm, 0x0052, 0x0070);
> +		bcm43xx_radio_write16(bcm, 0x0053, 0x00B3);
> +		bcm43xx_radio_write16(bcm, 0x0054, 0x009B);
>  		bcm43xx_radio_write16(bcm, 0x005A, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x005B, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);

Here should also be a "MicrocodeFlagsBitfield", which is HostFlags, write.

>  	bcm43xx_phy_write(bcm, 0x0038, 0x0668);
>  	bcm43xx_radio_set_txpower_bg(bcm, 0xFFFF, 0xFFFF, 0xFFFF);
> -	if (radio->version == 0x2050) {
> -		if (radio->revision == 3 ||
> -		    radio->revision == 4 ||
> -		    radio->revision == 5)
> -			bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);
> -		else if (radio->revision <= 2)
> -			bcm43xx_radio_write16(bcm, 0x005D, 0x000D);
> -	}
> +	if (radio->revision <= 5)
> +		bcm43xx_phy_write(bcm, 0x005D, bcm43xx_phy_read(bcm, 0x005D) | 0x0003);

The above should be
  MaskSet PHYRegister 0x5D with mask 0xFF80 and set with 3


The rest is OK. Thanks for the patch!

-- 
Greetings Michael.
