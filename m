Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:18420 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbXCUPfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 11:35:47 -0400
Date: Wed, 21 Mar 2007 08:34:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Move eeprom_93cx6 from lib/ to drivers/misc/
Message-Id: <20070321083411.963e14f0.randy.dunlap@oracle.com>
In-Reply-To: <200703211137.51012.IvDoorn@gmail.com>
References: <200703211137.51012.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Mar 2007 11:37:50 +0100 Ivo van Doorn wrote:

> As requested, this will move the eeprom_93cx6 from its location in
> lib/ to drivers/misc/
> 
> Signed-off-by Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> eeprom_93cx6.c was moved with:
> cg-mv lib/eeprom_93cx6.c drivers/misc/eeprom_93cx6.c
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 80b199f..1af3e76 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -122,4 +122,12 @@ config SONY_LAPTOP
>  
>  	  Read <file:Documentation/sony-laptop.txt> for more information.

Thanks.  Looks fine except this one little nit:
The "---help---" line should only be indented by one tab.
The text under it is indented correctly.

> +config EEPROM_93CX6
> +	tristate "EEPROM 93CX6 support"
> +	  ---help---
> +	  This is a driver for the EEPROM chipsets 93c46 and 93c66.
> +	  The driver supports both read as well as write commands.
> +
> +	  When compiled as a module, this driver will be called "eeprom_93c6.ko".
> +
>  endmenu
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 7793ccd..f65b835 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
>  obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
>  obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
>  obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
> +obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
> diff --git a/lib/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
> similarity index 100%
> rename from lib/eeprom_93cx6.c
> rename to drivers/misc/eeprom_93cx6.c
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 0b275b7..8e91748 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -50,14 +50,6 @@ config LIBCRC32C
>  	  require M here.  See Castagnoli93.
>  	  Module will be libcrc32c.
>  
> -config EEPROM_93CX6
> -	tristate "EEPROM 93CX6 support"
> -	---help---
> -	This is a driver for the EEPROM chipsets 93c46 and 93c66.
> -	The driver supports both read as well as write commands.
> -
> -	When compiled as a module, this driver will be called "eeprom_93c6.ko".
> -
>  config AUDIT_GENERIC
>  	bool
>  	depends on AUDIT && !AUDIT_ARCH
> diff --git a/lib/Makefile b/lib/Makefile
> index 71ae5be..d7edaf3 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -56,8 +56,6 @@ obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
>  obj-$(CONFIG_SMP) += percpu_counter.o
>  obj-$(CONFIG_AUDIT_GENERIC) += audit.o
>  
> -obj-$(CONFIG_EEPROM_93CX6) += eeprom_93cx6.o
> -
>  obj-$(CONFIG_SWIOTLB) += swiotlb.o
>  obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
>  

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
