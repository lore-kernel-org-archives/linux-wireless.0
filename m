Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46558
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946638AbXBIRLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 12:11:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Date: Fri, 9 Feb 2007 18:11:40 +0100
Cc: John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
In-Reply-To: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702091811.40683.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 February 2007 17:32, Larry Finger wrote:
> The specifications for the bcm43xx driver have been modified. This patch
> incorporates these changes in the code, which results in the BCM4311 and
> BCM4312 working. The name of one of the PHY parameters, previously known
> as "version", has been changed to "analog core version" .
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> ---

> @@ -729,19 +729,19 @@ static void bcm43xx_phy_initb5(struct bc
>  	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
>  	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
>  	u16 offset;
> +	u16 value;
> +	u8 old_channel;
>  
> -	if (phy->version == 1 &&
> -	    radio->version == 0x2050) {

Why do you delete the check to radio version.
It's still there in latest specs:
http://bcm-v4.sipsolutions.net/802.11/PHY/Init/B5

> +	if (phy->analog == 1)
>  		bcm43xx_radio_write16(bcm, 0x007A,
>  				      bcm43xx_radio_read16(bcm, 0x007A)
>  				      | 0x0050);
> -	}
>  	if ((bcm->board_vendor != PCI_VENDOR_ID_BROADCOM) &&
>  	    (bcm->board_type != 0x0416)) {
> +		value = 0x2120;
>  		for (offset = 0x00A8 ; offset < 0x00C7; offset++) {
> -			bcm43xx_phy_write(bcm, offset,
> -					  (bcm43xx_phy_read(bcm, offset) + 0x2020)
> -					  & 0x3F3F);
> +			bcm43xx_phy_write(bcm, offset, value);
> +			value += 0x0202;
>  		}

I don't see how this matches specs.

>  	}
>  	bcm43xx_phy_write(bcm, 0x0035,
> @@ -776,7 +776,7 @@ static void bcm43xx_phy_initb5(struct bc
>  				  bcm43xx_phy_read(bcm, BCM43xx_PHY_RADIO_BITFIELD) | (1 << 11));
>  	}
>  
> -	if (phy->version == 1 && radio->version == 0x2050) {

Dito.

> +	if (phy->analog == 1) {
>  		bcm43xx_phy_write(bcm, 0x0026, 0xCE00);
>  		bcm43xx_phy_write(bcm, 0x0021, 0x3763);
>  		bcm43xx_phy_write(bcm, 0x0022, 0x1BC3);
> @@ -787,14 +787,15 @@ static void bcm43xx_phy_initb5(struct bc
>  	bcm43xx_phy_write(bcm, 0x0030, 0x00C6);
>  	bcm43xx_write16(bcm, 0x03EC, 0x3F22);
>  
> -	if (phy->version == 1 && radio->version == 0x2050)

Dito.

> +	if (phy->analog == 1)
>  		bcm43xx_phy_write(bcm, 0x0020, 0x3E1C);
>  	else
>  		bcm43xx_phy_write(bcm, 0x0020, 0x301C);
>  
> -	if (phy->version == 0)
> +	if (phy->analog == 0)
>  		bcm43xx_write16(bcm, 0x03E4, 0x3000);
>  
> +	old_channel = radio->channel;
>  	/* Force to channel 7, even if not supported. */
>  	bcm43xx_radio_selectchannel(bcm, 7, 0);
>  
> @@ -816,11 +817,11 @@ static void bcm43xx_phy_initb5(struct bc
>  
>  	bcm43xx_radio_write16(bcm, 0x007A, bcm43xx_radio_read16(bcm, 0x007A) | 0x0007);
>  
> -	bcm43xx_radio_selectchannel(bcm, BCM43xx_RADIO_DEFAULT_CHANNEL_BG, 0);
> +	bcm43xx_radio_selectchannel(bcm, old_channel, 0);
>  
>  	bcm43xx_phy_write(bcm, 0x0014, 0x0080);
>  	bcm43xx_phy_write(bcm, 0x0032, 0x00CA);
> -	bcm43xx_phy_write(bcm, 0x88A3, 0x002A);
> +	bcm43xx_phy_write(bcm, 0x002A, 0x88A3);

Well, this seems correct, but specs are still different. From where did you get this?


Well, I don't review the rest until you say to which specs you did the changes. ;)

-- 
Greetings Michael.
