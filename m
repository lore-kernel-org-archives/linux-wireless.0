Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60339
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXCDM63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 07:58:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: do not rebuild when kernel version changes
Date: Sun, 4 Mar 2007 13:57:32 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45ea5f3c.mlfmHoZ11OcoG/sT%Larry.Finger@lwfinger.net>
In-Reply-To: <45ea5f3c.mlfmHoZ11OcoG/sT%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703041357.33238.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 March 2007 06:55, Larry Finger wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> 
> In bcm43xx_ethtool, UTS_RELEASE is used. Replacing this with utsname()->release
> avoids rebuilding this module each time the kernel version changes.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> As the ethtool removal was NACKed by Jeff, we need to do this one.

What the fuck, why?

> Larry
> 
> ===
> 
> diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> index c947025..d2df6a0 100644
> --- a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> +++ b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
> @@ -32,7 +32,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/pci.h>
>  #include <linux/string.h>
> -#include <linux/utsrelease.h>
> +#include <linux/utsname.h>
>  
>  
>  static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> @@ -40,7 +40,7 @@ static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
>  	struct bcm43xx_private *bcm = bcm43xx_priv(dev);
>  
>  	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> -	strncpy(info->version, UTS_RELEASE, sizeof(info->version));
> +	strncpy(info->version, utsname()->release, sizeof(info->version));
>  	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
>  }
>  
> -
> 
> 
> 

-- 
Greetings Michael.
