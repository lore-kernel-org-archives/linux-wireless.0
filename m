Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42260 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0ASTkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:40:45 -0500
Message-ID: <4B560AB6.7090405@openwrt.org>
Date: Tue, 19 Jan 2010 20:40:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/2] compat: fix compile errors with CONFIG_FW_LOADER
 unset
References: <4B547031.60600@openwrt.org> <4B547076.5060006@openwrt.org> <20100119193545.GA8069@bombadil.infradead.org>
In-Reply-To: <20100119193545.GA8069@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-01-19 8:35 PM, Luis R. Rodriguez wrote:
> what about something like this? This is not tested on a system without
> FW_LOADER  yet, not sure if it works:
> 
> diff --git a/Makefile b/Makefile
> index 4843869..ad8a602 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -19,8 +19,13 @@ $(foreach ver,$(COMPAT_VERSIONS),$(eval export CONFIG_COMPAT_KERNEL_$(ver)=y))
>  endif
>  
>  ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
> +ifeq ($(CONFIG_FW_LOADER),y)
>   export CONFIG_COMPAT_FIRMWARE_CLASS=m
>  endif
> +ifeq ($(CONFIG_FW_LOADER_MODULE),y)
> + export CONFIG_COMPAT_FIRMWARE_CLASS=m
> +endif
> +endif
>  
>  obj-y += compat/
>  
> 
> Oh well this is just for compat.git but we'd do something similar on config.mk
> Testing to build compat.git should suffice though I think.
Sounds good.

- Felix
