Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0ASTfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:35:46 -0500
Date: Tue, 19 Jan 2010 14:35:45 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/2] compat: fix compile errors with CONFIG_FW_LOADER
	unset
Message-ID: <20100119193545.GA8069@bombadil.infradead.org>
References: <4B547031.60600@openwrt.org> <4B547076.5060006@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B547076.5060006@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 18, 2010 at 03:30:14PM +0100, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> --- a/compat/compat_firmware_class.c
> +++ b/compat/compat_firmware_class.c
> @@ -20,6 +20,8 @@
>  #include <linux/highmem.h>
>  #include <linux/firmware.h>
>  
> +#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
> +
>  #define to_dev(obj) container_of(obj, struct device, kobj)
>  
>  MODULE_AUTHOR("Manuel Estrada Sainz");
> @@ -724,3 +726,5 @@ module_exit(firmware_class_exit);
>  EXPORT_SYMBOL(release_firmware);
>  EXPORT_SYMBOL(request_firmware);
>  EXPORT_SYMBOL(request_firmware_nowait);
> +
> +#endif

Hm, that would end up still building the compat_firmware module though,
what about something like this? This is not tested on a system without
FW_LOADER  yet, not sure if it works:

diff --git a/Makefile b/Makefile
index 4843869..ad8a602 100644
--- a/Makefile
+++ b/Makefile
@@ -19,8 +19,13 @@ $(foreach ver,$(COMPAT_VERSIONS),$(eval export CONFIG_COMPAT_KERNEL_$(ver)=y))
 endif
 
 ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
+ifeq ($(CONFIG_FW_LOADER),y)
  export CONFIG_COMPAT_FIRMWARE_CLASS=m
 endif
+ifeq ($(CONFIG_FW_LOADER_MODULE),y)
+ export CONFIG_COMPAT_FIRMWARE_CLASS=m
+endif
+endif
 
 obj-y += compat/
 

Oh well this is just for compat.git but we'd do something similar on config.mk
Testing to build compat.git should suffice though I think.

  Luis
