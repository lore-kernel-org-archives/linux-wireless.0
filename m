Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:62647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1EMUBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 16:01:53 -0400
Message-ID: <4DCD8E13.9060502@oracle.com> (sfid-20110513_220157_455170_BFAD54B2)
Date: Fri, 13 May 2011 13:01:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ssb: fix pcicore build breakage
References: <20110513094657.5d38e959.randy.dunlap@oracle.com> <1305313621-7901-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1305313621-7901-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/11 12:07, John W. Linville wrote:
> drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
> drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
> drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/ssb/main.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index ee2937c..f8a13f8 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -1332,21 +1332,27 @@ EXPORT_SYMBOL(ssb_bus_powerup);
>  static void ssb_broadcast_value(struct ssb_device *dev,
>  				u32 address, u32 data)
>  {
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>  	/* This is used for both, PCI and ChipCommon core, so be careful. */
>  	BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
>  	BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
> +#endif
>  
> -	ssb_write32(dev, SSB_PCICORE_BCAST_ADDR, address);
> -	ssb_read32(dev, SSB_PCICORE_BCAST_ADDR); /* flush */
> -	ssb_write32(dev, SSB_PCICORE_BCAST_DATA, data);
> -	ssb_read32(dev, SSB_PCICORE_BCAST_DATA); /* flush */
> +	ssb_write32(dev, SSB_CHIPCO_BCAST_ADDR, address);
> +	ssb_read32(dev, SSB_CHIPCO_BCAST_ADDR); /* flush */
> +	ssb_write32(dev, SSB_CHIPCO_BCAST_DATA, data);
> +	ssb_read32(dev, SSB_CHIPCO_BCAST_DATA); /* flush */
>  }
>  
>  void ssb_commit_settings(struct ssb_bus *bus)
>  {
>  	struct ssb_device *dev;
>  
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>  	dev = bus->chipco.dev ? bus->chipco.dev : bus->pcicore.dev;
> +#else
> +	dev = bus->chipco.dev;
> +#endif
>  	if (WARN_ON(!dev))
>  		return;
>  	/* This forces an update of the cached registers. */


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
