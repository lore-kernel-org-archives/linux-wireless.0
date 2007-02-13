Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33308
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXBMXCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 18:02:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix for 4311 and 02/07/07 specification changes
Date: Wed, 14 Feb 2007 00:02:05 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
In-Reply-To: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702140002.05727.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 February 2007 23:54, Larry Finger wrote:
> The specifications for the bcm43xx driver have been modified. This patch
> incorporates these changes in the code, which results in the BCM4311 and
> BCM4312 working. The name of one of the PHY parameters, previously known
> as "version", has been changed to "analog", short for  "analog core version" .
> 
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>

> @@ -750,7 +757,7 @@ static void bcm43xx_phy_initb5(struct bc
>  	if (radio->version == 0x2050)
>  		bcm43xx_phy_write(bcm, 0x0038, 0x0667);
>  
> -	if (phy->connected) {
> +	if (phy->type == BCM43xx_PHYTYPE_G) {

I don't think this is correct.
I think (didn't verify) the specs talk about the "gmode" here.
I think you have been misleaded by that. The "gmode" bit is
the "connected" bit in the old softmac driver.

-- 
Greetings Michael.
