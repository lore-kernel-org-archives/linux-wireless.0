Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2052 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762615AbXGZRhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 13:37:32 -0400
Date: Thu, 26 Jul 2007 13:21:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Message-ID: <20070726172138.GA6068@tuxdriver.com>
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2007 at 11:33:01AM -0500, Larry Finger wrote:
> A typo in the specs interchanges the branches in an if statement, which
> breaks operations for a BCM4306/rev 2 that has phy->analog == 1.

> @@ -1895,7 +1895,7 @@ void bcm43xx_phy_set_baseband_attenuatio
>  		bcm43xx_write16(dev, BCM43xx_MMIO_PHY0,
>  				(bcm43xx_read16(dev, BCM43xx_MMIO_PHY0)
>  				 & 0xFFF0) | baseband_attenuation);
> -	} else if (phy->analog == 1) {
> +	} else if (phy->analog != 1) {
>  		bcm43xx_phy_write(dev, BCM43xx_PHY_DACCTL,
>  				  (bcm43xx_phy_read(dev, BCM43xx_PHY_DACCTL)
>  				   & 0xFFC3) | (baseband_attenuation << 2));

Larry,

How does this relate to the bcm43xx patch you asked me to revert
(and has been reverted in F-7)?  That one change "==" to ">", while
this one changes "==" to "!=".  Instead of reverting the other,
should it do the same thing as this?

John
-- 
John W. Linville
linville@tuxdriver.com
