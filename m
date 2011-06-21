Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36740 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUVzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 17:55:36 -0400
Received: by yxi11 with SMTP id 11so94022yxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 14:55:35 -0700 (PDT)
Date: Tue, 21 Jun 2011 18:55:51 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	sameo@linux.intel.com, johannes@sipsolutions.net,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC][PATCH v2 2/7] NFC: add nfc subsystem core
Message-ID: <20110621215551.GF2628@joana> (sfid-20110621_235544_353552_6B1FD4AB)
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
 <1308592212-5755-3-git-send-email-aloisio.almeida@openbossa.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308592212-5755-3-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Aloisio Almeida Jr <aloisio.almeida@openbossa.org> [2011-06-20 14:50:07 -0300]:

> From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> 
> The NFC subsystem core is responsible for providing the device driver
> interface. It is also responsible for providing an interface to the control
> operations and data exchange.
> 
> Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/Kconfig      |    2 -
>  drivers/Makefile     |    1 +
>  drivers/nfc/Kconfig  |   16 +--
>  drivers/nfc/Makefile |    2 +
>  include/net/nfc.h    |  131 +++++++++++++++++++
>  net/Kconfig          |    1 +
>  net/Makefile         |    1 +
>  net/nfc/Kconfig      |   24 ++++
>  net/nfc/Makefile     |    9 ++
>  net/nfc/core.c       |  345 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/nfc/nfc.h        |   71 ++++++++++
>  11 files changed, 588 insertions(+), 15 deletions(-)
>  create mode 100644 include/net/nfc.h
>  create mode 100644 net/nfc/Kconfig
>  create mode 100644 net/nfc/Makefile
>  create mode 100644 net/nfc/core.c
>  create mode 100644 net/nfc/nfc.h
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 61631ed..a56b0b8 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -92,8 +92,6 @@ source "drivers/memstick/Kconfig"
>  
>  source "drivers/leds/Kconfig"
>  
> -source "drivers/nfc/Kconfig"
> -
>  source "drivers/accessibility/Kconfig"
>  
>  source "drivers/infiniband/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index a29527f..843cd31 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -120,3 +120,4 @@ obj-y				+= ieee802154/
>  obj-y				+= clk/
>  
>  obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
> +obj-$(CONFIG_NFC)		+= nfc/
> diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
> index ea15800..7809289 100644
> --- a/drivers/nfc/Kconfig
> +++ b/drivers/nfc/Kconfig
> @@ -2,17 +2,8 @@
>  # Near Field Communication (NFC) devices
>  #
>  
> -menuconfig NFC_DEVICES
> -	bool "Near Field Communication (NFC) devices"
> -	default n
> -	---help---
> -	  You'll have to say Y if your computer contains an NFC device that
> -	  you want to use under Linux.
> -
> -	  You can say N here if you don't have any Near Field Communication
> -	  devices connected to your computer.
> -
> -if NFC_DEVICES
> +menu "Near Field Communication (NFC) devices"
> +	depends on NFC
>  
>  config PN544_NFC
>  	tristate "PN544 NFC driver"
> @@ -26,5 +17,4 @@ config PN544_NFC
>  	  To compile this driver as a module, choose m here. The module will
>  	  be called pn544.
>  
> -
> -endif # NFC_DEVICES
> +endmenu
> diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
> index a4efb16..25296f0 100644
> --- a/drivers/nfc/Makefile
> +++ b/drivers/nfc/Makefile
> @@ -3,3 +3,5 @@
>  #
>  
>  obj-$(CONFIG_PN544_NFC)		+= pn544.o
> +
> +ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
> diff --git a/include/net/nfc.h b/include/net/nfc.h
> new file mode 100644
> index 0000000..11d63dc
> --- /dev/null
> +++ b/include/net/nfc.h
> @@ -0,0 +1,131 @@
> +/*
> + * Copyright (C) 2011 Instituto Nokia de Tecnologia
> + *
> + * Authors:
> + *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> + *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the
> + * Free Software Foundation, Inc.,
> + * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#ifndef __NET_NFC_H
> +#define __NET_NFC_H
> +
> +#include <linux/device.h>
> +#include <linux/skbuff.h>
> +
> +struct nfc_dev;
> +
> +/**
> + * data_exchange_cb_t - Definition of nfc_data_exchange callback
> + *
> + * @context: nfc_data_exchange cb_context parameter
> + * @skb: response data
> + * @err: If an error has occurred during data exchange, it is the
> + *	error number. Zero means no error.
> + *
> + * When a rx or tx package is lost or corrupted or the target gets out
> + * of the operating field, err is -EIO.
> + */
> +typedef void (*data_exchange_cb_t)(void *context, struct sk_buff *skb,
> +								int err);
> +
> +struct nfc_ops {
> +	int (*start_poll)(struct nfc_dev *dev, u32 protocols);
> +	void (*stop_poll)(struct nfc_dev *dev);
> +	int (*activate_target)(struct nfc_dev *dev, u32 target_idx,
> +							u32 protocol);
> +	void (*deactivate_target)(struct nfc_dev *dev, u32 target_idx);
> +	int (*data_exchange)(struct nfc_dev *dev, u32 target_idx,
> +				struct sk_buff *skb, data_exchange_cb_t cb,
> +							void *cb_context);
> +};
> +
> +struct nfc_dev {
> +	unsigned idx;
> +	struct device dev;
> +	bool polling;
> +	u32 supported_protocols;
> +
> +	struct nfc_ops *ops;
> +};
> +#define to_nfc_dev(_dev) container_of(_dev, struct nfc_dev, dev)
> +
> +extern struct class nfc_class;
> +
> +struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
> +					u32 supported_protocols);
> +
> +/**
> + * nfc_free_device - free nfc device
> + *
> + * @dev: The nfc device to free
> + */
> +static inline void nfc_free_device(struct nfc_dev *dev)
> +{
> +	put_device(&dev->dev);
> +}
> +
> +int nfc_register_device(struct nfc_dev *dev);
> +
> +void nfc_unregister_device(struct nfc_dev *dev);
> +
> +/**
> + * nfc_set_parent_dev - set the parent device
> + *
> + * @nfc_dev: The nfc device whose parent is being set
> + * @dev: The parent device
> + */
> +static inline void nfc_set_parent_dev(struct nfc_dev *nfc_dev,
> +					struct device *dev)
> +{
> +	nfc_dev->dev.parent = dev;
> +}
> +
> +/**
> + * nfc_set_drvdata - set driver specifc data
> + *
> + * @dev: The nfc device
> + * @data: Pointer to driver specifc data
> + */
> +static inline void nfc_set_drvdata(struct nfc_dev *dev, void *data)
> +{
> +	dev_set_drvdata(&dev->dev, data);
> +}
> +
> +/**
> + * nfc_get_drvdata - get driver specifc data
> + *
> + * @dev: The nfc device
> + */
> +static inline void *nfc_get_drvdata(struct nfc_dev *dev)
> +{
> +	return dev_get_drvdata(&dev->dev);
> +}
> +
> +/**
> + * nfc_device_name - get the nfc device name
> + *
> + * @dev: The nfc device whose name to return
> + */
> +static inline const char *nfc_device_name(struct nfc_dev *dev)
> +{
> +	return dev_name(&dev->dev);
> +}
> +
> +struct sk_buff *nfc_alloc_skb(unsigned int size, gfp_t gfp);
> +
> +#endif /* __NET_NFC_H */
> diff --git a/net/Kconfig b/net/Kconfig
> index 878151c..a073148 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -322,6 +322,7 @@ source "net/rfkill/Kconfig"
>  source "net/9p/Kconfig"
>  source "net/caif/Kconfig"
>  source "net/ceph/Kconfig"
> +source "net/nfc/Kconfig"
>  
>  
>  endif   # if NET
> diff --git a/net/Makefile b/net/Makefile
> index a51d946..acdde49 100644
> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -68,3 +68,4 @@ obj-$(CONFIG_WIMAX)		+= wimax/
>  obj-$(CONFIG_DNS_RESOLVER)	+= dns_resolver/
>  obj-$(CONFIG_CEPH_LIB)		+= ceph/
>  obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
> +obj-$(CONFIG_NFC)		+= nfc/
> diff --git a/net/nfc/Kconfig b/net/nfc/Kconfig
> new file mode 100644
> index 0000000..4d5609c
> --- /dev/null
> +++ b/net/nfc/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# NFC sybsystem configuration
> +#
> +
> +menuconfig NFC
> +	depends on NET && EXPERIMENTAL
> +	tristate "NFC subsystem support (EXPERIMENTAL)"
> +	default n
> +	help
> +	  Say Y here if you want to build support for NFC (Near field
> +	  communication) devices.
> +
> +	  To compile this support as a module, choose M here: the module will
> +	  be called nfc.
> +
> +config NFC_DEBUG
> +	bool "NFC verbose debug messages"
> +        depends on NFC
> +        help
> +	  Say Y here if you want the NFC core and drivers to produce a bunch
> +	  of debug messages to the system log. Select this if you are having a
> +	  problem with NFC support and want to see more of what is going on.

I think that use only dynamic debug is a lot nicer. I don't see a point to
have a NFC debug option in Kconfig. We've been using dynamic debug in the
Bluetooth subsystem for a while and it works fine. If we have dynamic debug
there is no need to recompile a module to add debug support to it.

Also it's a good idea use macros for pr_debug, instead of calling it every
time with the same paramenters (__func__, for example). In the Bluetooth
subsystem we do like this:

#define BT_INFO(fmt, arg...) printk(KERN_INFO "Bluetooth: " fmt "\n" , ## arg)
#define BT_ERR(fmt, arg...)  printk(KERN_ERR "%s: " fmt "\n" , __func__ , ##
arg)
#define BT_DBG(fmt, arg...)  pr_debug("%s: " fmt "\n" , __func__ , ## arg)

	Gustavo
