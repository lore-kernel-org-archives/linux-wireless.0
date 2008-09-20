Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34492 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYITPpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 11:45:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for Motorola 7010 variant of BCM4306
Date: Sat, 20 Sep 2008 17:44:55 +0200
Cc: John W Linville <linville@tuxdriver.com>, bbullins@triad.rr.com,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
In-Reply-To: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809201744.55571.mb@bu3sch.de> (sfid-20080920_174550_869772_E28C99C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 September 2008 21:47:38 Larry Finger wrote:
> An additional BCM4306 has been found with the Bluetooth coexistence
> SPROM coding error.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> These devices work with bcm43xx, but not with b43. I'll let you
> decide if this is a regression.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> +++ wireless-testing/drivers/net/wireless/b43/main.c
> @@ -4545,7 +4545,8 @@ static void b43_sprom_fixup(struct ssb_b
>  		    IS_PDEV(pdev, BROADCOM, 0x4320,    DELL, 0x0003) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0015) ||
>  		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0014) ||
> -		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013))
> +		    IS_PDEV(pdev, BROADCOM, 0x4320, LINKSYS, 0x0013) ||
> +		    IS_PDEV(pdev, BROADCOM, 0x4320, MOTOROLA, 0x7010))
>  			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
>  	}
>  }
> 
> 

ACK


-- 
Greetings Michael.
