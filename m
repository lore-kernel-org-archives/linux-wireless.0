Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62275 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1BIQSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 11:18:33 -0500
Received: by vws16 with SMTP id 16so197860vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 08:18:32 -0800 (PST)
Message-ID: <4D52BE92.5070503@lwfinger.net>
Date: Wed, 09 Feb 2011 10:19:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: George Kashperko <george@znau.edu.ua>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: SSB AI support code ([RFC3/11] SSB irqflag device op)
References: <1297258590.17400.37.camel@dev.znau.edu.ua> <1297261973.18053.20.camel@dev.znau.edu.ua>
In-Reply-To: <1297261973.18053.20.camel@dev.znau.edu.ua>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 08:32 AM, George Kashperko wrote:
> From: George Kashperko <george@znau.edu.ua>
> 
> SB- and AI-style buses read irq flags from different locations.
> SB-ones read them from TPSFLAG whereas AI-ones from core oob register.
> In order to support both SB- and AI-style buses transparently
> irq flag accessor is implemented as ssb device op.
> Signed-off-by: George Kashperko <george@znau.edu.ua>
> ---
>  drivers/ssb/driver_mipscore.c       |    2 +-
>  drivers/ssb/main.c                  |    1 +
>  include/linux/ssb/ssb.h             |    5 +++++
>  include/linux/ssb/ssb_driver_mips.h |    1 +
>  4 files changed, 8 insertions(+), 1 deletion(-)
> --- linux-next-20110203.orig/drivers/ssb/driver_mipscore.c	2011-02-01 05:05:49.000000000 +0200
> +++ linux-next-20110203/drivers/ssb/driver_mipscore.c	2011-02-07 16:39:46.000000000 +0200
> @@ -47,7 +47,7 @@ static const u32 ipsflag_irq_shift[] = {
>  	SSB_IPSFLAG_IRQ4_SHIFT,
>  };
>  
> -static inline u32 ssb_irqflag(struct ssb_device *dev)
> +u32 ssb_irqflag_sb(struct ssb_device *dev)
>  {
>  	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
>  	if (tpsflag)
> --- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-07 16:35:50.000000000 +0200
> +++ linux-next-20110203/drivers/ssb/main.c	2011-02-07 16:49:40.000000000 +0200
> @@ -1367,6 +1367,7 @@ static const struct ssb_bus_ops ssb_ssb_
>  	.device_disable		= ssb_device_disable_sb,
>  	.admatch_base		= ssb_admatch_base_sb,
>  	.admatch_size		= ssb_admatch_size_sb,
> +	.irqflag		= ssb_irqflag_sb,
>  };
>  
>  static int __init ssb_modinit(void)
> --- linux-next-20110203.orig/include/linux/ssb/ssb_driver_mips.h	2011-02-01 05:05:49.000000000 +0200
> +++ linux-next-20110203/include/linux/ssb/ssb_driver_mips.h	2011-02-07 16:39:10.000000000 +0200
> @@ -29,6 +29,7 @@ extern void ssb_mipscore_init(struct ssb
>  extern u32 ssb_cpu_clock(struct ssb_mipscore *mcore);
>  
>  extern unsigned int ssb_mips_irq(struct ssb_device *dev);
> +extern u32 ssb_irqflag_sb(struct ssb_device *dev);
>  
>  
>  #else /* CONFIG_SSB_DRIVER_MIPS */
> --- linux-next-20110203.orig/include/linux/ssb/ssb.h	2011-02-07 16:35:50.000000000 +0200
> +++ linux-next-20110203/include/linux/ssb/ssb.h	2011-02-07 16:38:34.000000000 +0200
> @@ -124,6 +124,7 @@ struct ssb_bus_ops {
>  	void (*device_disable)(struct ssb_device *dev, u32 core_specific_flags);
>  	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
>  	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
> +	u32 (*irqflag)(struct ssb_device *dev);
>  };
>  
>  
> @@ -485,6 +486,10 @@ static inline u32 ssb_admatch_size(struc
>  {
>  	return dev->ops->admatch_size(dev, adm);
>  }
> +static inline u32 ssb_irqflag(struct ssb_device *dev)
> +{
> +	return dev->ops->irqflag(dev);
> +}
>  
>  
>  /* The SSB DMA API. Use this API for any DMA operation on the device.
> 
> 
> 
> --

This one fails to compile with the following error:

drivers/ssb/main.c:1370:14: error: ‘ssb_irqflag_sb’ undeclared here (not in a
function)
make[1]: *** [drivers/ssb/main.o] Error 1
make: *** [drivers/ssb/] Error 2

Larry
