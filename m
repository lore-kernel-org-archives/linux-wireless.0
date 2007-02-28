Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35100
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189AbXB1ROr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:14:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix errors in specs to code translation in B6PHY init
Date: Wed, 28 Feb 2007 18:14:00 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45e4a43f.BEt7jx5dMLQiM3wz%Larry.Finger@lwfinger.net>
In-Reply-To: <45e4a43f.BEt7jx5dMLQiM3wz%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281814.00713.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 February 2007 22:35, Larry Finger wrote:
> There are three errors in the transcription of the latest revision to the
> B6PHY init specifications.

NACK

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch should be applied to wireless-2.6 and sent upstream to 2.6.21-rcX.
> 
> Larry
> 
> Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> +++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> @@ -859,6 +859,9 @@ static void bcm43xx_phy_initb6(struct bc
>  		bcm43xx_radio_write16(bcm, 0x005D, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x005E, 0x0088);
>  		bcm43xx_radio_write16(bcm, 0x007D, 0x0088);
> +		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
> +				bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
> +				| 0x00000200);

This is wrong.

Set bit 0x200 in the MicrocodeFlagsBitfield
http://bcm-specs.sipsolutions.net/MicrocodeFlagsBitfield

-- 
Greetings Michael.
