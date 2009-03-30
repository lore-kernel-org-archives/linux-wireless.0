Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35824 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZC3Uyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:54:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43legacy: Do not select HW_RANDOM
Date: Mon, 30 Mar 2009 22:53:25 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <49d0e498.VVNw6/FIi1OemoLq%Larry.Finger@lwfinger.net>
In-Reply-To: <49d0e498.VVNw6/FIi1OemoLq%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903302253.25710.mb@bu3sch.de> (sfid-20090330_225457_207376_3FB10097)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 March 2009 17:26:16 Larry Finger wrote:
> Auto-depend on HW_RANDOM, rather than "select"ing it.
> This way the user has the choice to enable or disable HWRNG support.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John, please queue for 2.6.31.
> 
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43legacy/Kconfig
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/Kconfig
> +++ wireless-testing/drivers/net/wireless/b43legacy/Kconfig
> @@ -3,7 +3,6 @@ config B43LEGACY
>  	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
>  	select SSB
>  	select FW_LOADER
> -	select HW_RANDOM
>  	---help---
>  	  b43legacy is a driver for 802.11b devices from Broadcom (BCM4301 and
>  	  BCM4303) and early model 802.11g chips (BCM4306 Ver. 2) used in the
> @@ -51,6 +50,13 @@ config B43LEGACY_RFKILL
>  	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43LEGACY)
>  	default y
>  
> +# This config option automatically enables b43 HW-RNG support,
> +# if the HW-RNG core is enabled.
> +config B43legacy_HWRNG
> +	bool
> +	depends on B43legacy && (HW_RANDOM = y || HW_RANDOM = B43legacy)

It seems like the symbol is B43LEGACY (uppercase).
Can you also change the new symbol to B43LEGACY_HWRNG, just for consistency with
all other symbols?

> +	default y
> +


-- 
Greetings, Michael.
