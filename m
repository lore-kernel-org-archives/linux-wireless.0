Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43538 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0GHDjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jul 2010 23:39:54 -0400
From: "Ghorai, Sukumar" <s-ghorai@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, "Ben-cohen, Ohad" <ohadb@ti.com>
Date: Thu, 8 Jul 2010 09:09:22 +0530
Subject: RE: [PATCH 04/15] mmc: support embedded data field in mmc_host
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B030E10C9B5@dbde02.ent.ti.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
 <1278376666-3509-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-5-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of Ohad Ben-Cohen
> Sent: Tuesday, July 06, 2010 6:08 AM
> To: linux-wireless@vger.kernel.org; linux-mmc@vger.kernel.org; linux-
> omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
> Chikkature Rajashekar, Madhusudhan; Luciano Coelho; akpm@linux-
> foundation.org; San Mehat; Ben-cohen, Ohad
> Subject: [PATCH 04/15] mmc: support embedded data field in mmc_host
> 
> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Add support to set/get mmc_host private embedded
> data.
> 
> This is needed to allow software to dynamically
> create (and remove) SDIO functions which represents
> embedded SDIO devices.
> 
> Typically, it will be used to set the context of
> a driver that is creating a new SDIO function
> (and would then expect to be able to get that context
> back upon creation of the new sdio func).
> 
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---
>  drivers/mmc/core/Kconfig |    8 ++++++++
>  include/linux/mmc/host.h |   16 ++++++++++++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index bb22ffd..ab27eb3 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -16,3 +16,11 @@ config MMC_UNSAFE_RESUME
> 
>  	  This option sets a default which can be overridden by the
>  	  module parameter "removable=0" or "removable=1".
> +
> +config MMC_EMBEDDED_SDIO
> +	boolean "MMC embedded SDIO device support"
> +	help
> +	  If you say Y here, support will be added for embedded SDIO
> +	  devices (e.g. hardwired embedded WLAN SDIO devices).
> +	  Such devices require software support for emulating
> +	  card detect events.
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f65913c..9a48486 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -209,6 +209,10 @@ struct mmc_host {
>  	struct led_trigger	*led;		/* activity led */
>  #endif
> 
> +#ifdef CONFIG_MMC_EMBEDDED_SDIO
> +	void			*embedded_data;
> +#endif
> +
>  	struct dentry		*debugfs_root;
> 
>  	unsigned long		private[0] ____cacheline_aligned;
> @@ -264,5 +268,17 @@ static inline void mmc_set_disable_delay(struct
> mmc_host *host,
>  	host->disable_delay = disable_delay;
>  }
> 
> +#ifdef CONFIG_MMC_EMBEDDED_SDIO
> +static inline void *mmc_get_embedded_data(struct mmc_host *host)
> +{
> +	return host->embedded_data;
> +}
> +
> +static inline void mmc_set_embedded_data(struct mmc_host *host, void
> *data)
> +{
> +	host->embedded_data = data;
> +}
> +#endif
> +
[Ghorai] we can avoid CONFIG_MMC_EMBEDDED_SDIO flag itself. Why we are passing fixed data? We can enquire form card for the functions, features,.. and at runtime itself. And we are adding many compile-time/kconfig options in this patch series.
>  #endif
> 
> --
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
