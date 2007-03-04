Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46468
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXCDTDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 14:03:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Add firmware version to ethtool output
Date: Sun, 4 Mar 2007 20:02:39 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45eb1612.l8xsd6TwZVsRseAH%Larry.Finger@lwfinger.net>
In-Reply-To: <45eb1612.l8xsd6TwZVsRseAH%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703042002.39581.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 March 2007 19:55, Larry Finger wrote:
> As the removal of ethtool capability from bcm43xx has been NACKed,
> some useful functionality should be added.

I cannot follow this logics, sorry. ;)

> This patch changes it
> so that the firmware version is output.

I don't see how this is useful.
I really want to avoid having more ethtool stuff, as it will
only create compatibility issues for the future.
This doesn't give information that's not available elsewhere.

>  #include "bcm43xx.h"
> +#include "bcm43xx_main.h"
>  #include "bcm43xx_ethtool.h"
>  
>  #include <linux/netdevice.h>
> @@ -42,6 +43,8 @@ static void bcm43xx_get_drvinfo(struct n
>  	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
>  	strncpy(info->version, utsname()->release, sizeof(info->version));
>  	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
> +	snprintf(info->fw_version, sizeof(info->fw_version), "0x%x",
> +		 bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, BCM43xx_UCODE_REVISION));

This will crash when the device is not up.

-- 
Greetings Michael.
