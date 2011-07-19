Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48286 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSUrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 16:47:08 -0400
Date: Tue, 19 Jul 2011 16:42:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/4] bcma: allow setting FAST clockmode for a core
Message-ID: <20110719204246.GB2477@tuxdriver.com> (sfid-20110719_224712_756234_7E32E59F)
References: <1310857566-2876-1-git-send-email-zajec5@gmail.com>
 <1310857566-2876-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1310857566-2876-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/bcma/core.o
drivers/bcma/core.c: In function ‘bcma_core_set_clockmode’:
drivers/bcma/core.c:65:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
drivers/bcma/core.c:65:22: note: each undeclared identifier is reported only once for each function it appears in
drivers/bcma/core.c:65:73: error: ‘BCMA_CLKCTLST_FORCEHT’ undeclared (first use in this function)
drivers/bcma/core.c:69:8: error: ‘BCMA_CLKCTLST_HAVEHT’ undeclared (first use in this function)
drivers/bcma/core.c: In function ‘bcma_core_pll_ctl’:
drivers/bcma/core.c:89:35: error: ‘BCMA_CLKCTLST_EXTRESREQ’ undeclared (first use in this function)
drivers/bcma/core.c:90:38: error: ‘BCMA_CLKCTLST_EXTRESST’ undeclared (first use in this function)
drivers/bcma/core.c:93:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
make[2]: *** [drivers/bcma/core.o] Error 1
make[1]: *** [drivers/bcma] Error 2
make: *** [drivers] Error 2

On Sun, Jul 17, 2011 at 01:06:04AM +0200, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/core.c       |   31 +++++++++++++++++++++++++++++++
>  include/linux/bcma/bcma.h |    8 +++++++-
>  2 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
> index 1ec7d45..0686b1b 100644
> --- a/drivers/bcma/core.c
> +++ b/drivers/bcma/core.c
> @@ -50,3 +50,34 @@ int bcma_core_enable(struct bcma_device *core, u32 flags)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(bcma_core_enable);
> +
> +void bcma_core_set_clockmode(struct bcma_device *core,
> +			     enum bcma_clkmode clkmode)
> +{
> +	u16 i;
> +
> +	WARN_ON(core->id.id != BCMA_CORE_CHIPCOMMON &&
> +		core->id.id != BCMA_CORE_PCIE &&
> +		core->id.id != BCMA_CORE_80211);
> +
> +	switch (clkmode) {
> +	case BCMA_CLKMODE_FAST:
> +		bcma_set32(core, BCMA_CLKCTLST, BCMA_CLKCTLST_FORCEHT);
> +		udelay(64);
> +		for (i = 0; i < 1500; i++) {
> +			if (bcma_read32(core, BCMA_CLKCTLST) &
> +			    BCMA_CLKCTLST_HAVEHT) {
> +				i = 0;
> +				break;
> +			}
> +			udelay(10);
> +		}
> +		if (i)
> +			pr_err("HT force timeout\n");
> +		break;
> +	case BCMA_CLKMODE_DYNAMIC:
> +		pr_warn("Dynamic clockmode not supported yet!\n");
> +		break;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(bcma_core_set_clockmode);
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index 6e5dc7b..37017c1 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -25,6 +25,11 @@ struct bcma_chipinfo {
>  	u8 pkg;
>  };
>  
> +enum bcma_clkmode {
> +	BCMA_CLKMODE_FAST,
> +	BCMA_CLKMODE_DYNAMIC,
> +};
> +
>  struct bcma_host_ops {
>  	u8 (*read8)(struct bcma_device *core, u16 offset);
>  	u16 (*read16)(struct bcma_device *core, u16 offset);
> @@ -253,6 +258,7 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
>  extern bool bcma_core_is_enabled(struct bcma_device *core);
>  extern void bcma_core_disable(struct bcma_device *core, u32 flags);
>  extern int bcma_core_enable(struct bcma_device *core, u32 flags);
> -
> +extern void bcma_core_set_clockmode(struct bcma_device *core,
> +				    enum bcma_clkmode clkmode);
>  
>  #endif /* LINUX_BCMA_H_ */
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
