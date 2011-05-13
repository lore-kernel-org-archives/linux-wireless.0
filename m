Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:52044 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082Ab1EMNnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:43:41 -0400
Subject: Re: [PATCH] ssb: fix pcicore build breakage
From: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <1305293189-20605-1-git-send-email-linville@tuxdriver.com>
References: <20110512161914.e16be4d3.randy.dunlap@oracle.com>
	 <1305293189-20605-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:43:34 +0200
Message-ID: <1305294214.12573.3.camel@maggie> (sfid-20110513_154344_754486_C705E94F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 09:26 -0400, John W. Linville wrote: 
> drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
> drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
> drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/ssb/main.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index ee2937c..a53fc4d 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -1332,6 +1332,7 @@ EXPORT_SYMBOL(ssb_bus_powerup);
>  static void ssb_broadcast_value(struct ssb_device *dev,
>  				u32 address, u32 data)
>  {
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>  	/* This is used for both, PCI and ChipCommon core, so be careful. */
>  	BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
>  	BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
> @@ -1340,6 +1341,7 @@ static void ssb_broadcast_value(struct ssb_device *dev,
>  	ssb_read32(dev, SSB_PCICORE_BCAST_ADDR); /* flush */
>  	ssb_write32(dev, SSB_PCICORE_BCAST_DATA, data);
>  	ssb_read32(dev, SSB_PCICORE_BCAST_DATA); /* flush */
> +#endif
>  }
>  
>  void ssb_commit_settings(struct ssb_bus *bus)

This clearly is incorrect. Read the comment, please.

-- 
Greetings Michael.

