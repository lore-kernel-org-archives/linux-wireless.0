Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49391 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbZHNUPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:15:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix sparse warnings
Date: Fri, 14 Aug 2009 22:15:37 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
In-Reply-To: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908142215.38112.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 00:15:07 Larry Finger wrote:
> The b43 driver generates the following sparse warnings:
> 
>   CHECK   drivers/net/wireless/b43/phy_g.c
> drivers/net/wireless/b43/phy_g.c:974:35: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
>   CHECK   drivers/net/wireless/b43/wa.c
> drivers/net/wireless/b43/wa.c:385:53: warning: cast truncates bits from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:403:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:405:48: warning: cast truncates bits from constant value (ffff00ff becomes ff)
> drivers/net/wireless/b43/wa.c:415:50: warning: cast truncates bits from constant value (ffff0fff becomes fff)
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> There is no hurry for this material.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c
> +++ wireless-testing/drivers/net/wireless/b43/phy_g.c
> @@ -971,7 +971,7 @@ b43_radio_interference_mitigation_enable
>  		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
>  
>  		if (phy->rev >= 3) {
> -			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
> +			b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));

Uh come on...
The u16 cast already is stupid as hell, but this is becoming braindead.
The code is perfectly fine. Sparse should instead provide an option to disable
this fragile check.

-- 
Greetings, Michael.
