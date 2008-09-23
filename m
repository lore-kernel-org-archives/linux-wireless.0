Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:2268 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYIWHHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2008 03:07:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so653244nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2008 00:07:49 -0700 (PDT)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
Date: Tue, 23 Sep 2008 09:07:45 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
References: <48D82A43.7040604@oracle.com>
In-Reply-To: <48D82A43.7040604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809230907.46130.IvDoorn@gmail.com> (sfid-20080923_090755_009593_BB9A33FB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 September 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> If RT2X00=y but RFKILL=m, these build errors happen:
> 
> (.text+0x7c7d6): undefined reference to `rfkill_free'
> rt2x00rfkill.c:(.text+0x7c830): undefined reference to `rfkill_force_state'
> (.text+0x7c88d): undefined reference to `rfkill_unregister'
> (.text+0x7c8cd): undefined reference to `rfkill_register'
> (.text+0x7ca1a): undefined reference to `rfkill_allocate'
> 
> so restrict RT2X00's RFKILL config level to that of the main RFKILL option.
> This is done by making the former a tristate instead of a bool
> config option.
> 
> 
> If RT2X00=y but LEDS_CLASS=m, these build errors happen:
> 
> (.text+0x11859f): undefined reference to `led_classdev_resume'
> (.text+0x1185b3): undefined reference to `led_classdev_resume'
> (.text+0x1185c7): undefined reference to `led_classdev_resume'
> (.text+0x1185e4): undefined reference to `led_classdev_suspend'
> (.text+0x1185f8): undefined reference to `led_classdev_suspend'
> (.text+0x11860c): undefined reference to `led_classdev_suspend'
> rt2x00leds.c:(.text+0x118620): undefined reference to `led_classdev_unregister'
> rt2x00leds.c:(.text+0x118695): undefined reference to `led_classdev_register'
> 
> so restrict RT2X00's LEDS config level to that of the main LEDS_CLASS option.
> This is done by making the former a tristate instead of a bool
> config option.

Is that really going to work correctly?
rfkill and leds support should be compiled into rt2x00lib.ko, which means that
should become a module instead of the rfkill/leds support part only.

Ivo

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/wireless/rt2x00/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- mmotm-2008-0922-0136.orig/drivers/net/wireless/rt2x00/Kconfig
> +++ mmotm-2008-0922-0136/drivers/net/wireless/rt2x00/Kconfig
> @@ -38,13 +38,13 @@ config RT2X00_LIB_CRYPTO
>  	depends on RT2X00_LIB
>  
>  config RT2X00_LIB_RFKILL
> -	boolean
> +	tristate
>  	depends on RT2X00_LIB
>  	depends on RFKILL
>  	default y
>  
>  config RT2X00_LIB_LEDS
> -	boolean
> +	tristate
>  	depends on RT2X00_LIB
>  	depends on NEW_LEDS
>  	depends on LEDS_CLASS
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


