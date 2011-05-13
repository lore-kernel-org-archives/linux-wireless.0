Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33406 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab1EMTwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:52:33 -0400
Received: by qwk3 with SMTP id 3so1452241qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 12:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305313621-7901-1-git-send-email-linville@tuxdriver.com>
References: <20110513094657.5d38e959.randy.dunlap@oracle.com>
	<1305313621-7901-1-git-send-email-linville@tuxdriver.com>
Date: Fri, 13 May 2011 21:52:31 +0200
Message-ID: <BANLkTi=x+tyr6TnyZ+pZuM7y=a8SxEOoJw@mail.gmail.com> (sfid-20110513_215236_087383_8468D862)
Subject: Re: [PATCH v3] ssb: fix pcicore build breakage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/13 John W. Linville <linville@tuxdriver.com>:
> drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
> drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
> drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'
>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/ssb/main.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index ee2937c..f8a13f8 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -1332,21 +1332,27 @@ EXPORT_SYMBOL(ssb_bus_powerup);
>  static void ssb_broadcast_value(struct ssb_device *dev,
>                                u32 address, u32 data)
>  {
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>        /* This is used for both, PCI and ChipCommon core, so be careful. */
>        BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
>        BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
> +#endif
>
> -       ssb_write32(dev, SSB_PCICORE_BCAST_ADDR, address);
> -       ssb_read32(dev, SSB_PCICORE_BCAST_ADDR); /* flush */
> -       ssb_write32(dev, SSB_PCICORE_BCAST_DATA, data);
> -       ssb_read32(dev, SSB_PCICORE_BCAST_DATA); /* flush */
> +       ssb_write32(dev, SSB_CHIPCO_BCAST_ADDR, address);
> +       ssb_read32(dev, SSB_CHIPCO_BCAST_ADDR); /* flush */
> +       ssb_write32(dev, SSB_CHIPCO_BCAST_DATA, data);
> +       ssb_read32(dev, SSB_CHIPCO_BCAST_DATA); /* flush */
>  }
>
>  void ssb_commit_settings(struct ssb_bus *bus)
>  {
>        struct ssb_device *dev;
>
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>        dev = bus->chipco.dev ? bus->chipco.dev : bus->pcicore.dev;
> +#else
> +       dev = bus->chipco.dev;
> +#endif
>        if (WARN_ON(!dev))
>                return;
>        /* This forces an update of the cached registers. */
> --
> 1.7.4.4

Acked-by: Rafał Miłecki <zajec5@gmail.com>

-- 
Rafał
