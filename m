Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:42051 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYDFPUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 11:20:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: fix bcm4303 crash
Date: Sun, 6 Apr 2008 17:20:02 +0200
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080406170507.16992935@polimi.it>
In-Reply-To: <20080406170507.16992935@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804061720.02381.mb@bu3sch.de> (sfid-20080406_162100_610117_1EB14EA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 April 2008 17:05:07 Stefano Brivio wrote:
> This fixes an hard crash which happened upon driver loading on bcm4303 rev.
> 2 devices.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

ACK

> ---
> John, this is for 2.6.26.

Why not 2.6.25?

> ---
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index e123719..4bc0e8b 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -1101,6 +1101,12 @@ int ssb_bus_may_powerdown(struct ssb_bus *bus)
>  		goto out;
>  
>  	cc = &bus->chipco;
> +
> +	if (!cc->dev)
> +		goto out;
> +	if (cc->dev->id.revision < 5)
> +		goto out;
> +
>  	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
>  	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
>  	if (err)
> 
> 
> --
> Ciao
> Stefano
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> 
> 



-- 
Greetings Michael.
