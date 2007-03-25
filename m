Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45202
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbXCYONi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 10:13:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
Date: Sun, 25 Mar 2007 16:13:23 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
In-Reply-To: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703251613.23880.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 March 2007 15:45, Larry Finger wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> Recent changes in the specs that were introduced in commit 
> 740ac4fb08866d702be90f167665d03759bd27d0 were incorrect and resulted in machine check
> errors on the PPC architecture for G PHY's with a revision number equal to 1. The
> two offending changes are reverted.

I'm not sure this patch is complete.
Joseph made changes to the specs that should fix the issue completely.
I didn't look at the changes, yet.

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This fix should be applied to wireless-2.6 and set to 'upstream-fixes'. I hope is makes
> it into 2.6.21 before the final release. The debugging of this issue was mostly done
> by David with additional help by Pavil Roskin.
> 
> Larry
> 
> 
> Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> +++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
> @@ -762,7 +762,7 @@ static void bcm43xx_phy_initb5(struct bc
>  	if (radio->version == 0x2050)
>  		bcm43xx_phy_write(bcm, 0x0038, 0x0667);
>  
> -	if (phy->type == BCM43xx_PHYTYPE_G) {
> +	if (phy->connected) {
>  		if (radio->version == 0x2050) {
>  			bcm43xx_radio_write16(bcm, 0x007A,
>  					      bcm43xx_radio_read16(bcm, 0x007A)
> @@ -1197,7 +1197,7 @@ static void bcm43xx_phy_initg(struct bcm
>  		bcm43xx_phy_write(bcm, 0x0811, 0x0400);
>  		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
>  	}
> -	if (phy->connected) {
> +	if (phy->rev >= 2 && phy->connected) {
>  		tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
>  		if (tmp < 6) {
>  			bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
> 
> 

-- 
Greetings Michael.
