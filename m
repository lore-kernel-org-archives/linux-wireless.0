Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47559 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2LUHRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 02:17:30 -0500
Message-ID: <1356074247.29264.11.camel@aeonflux> (sfid-20121221_081734_835208_26921592)
Subject: Re: [RFC/RFT] rtk_btusb: Bluetooth driver for Realtek RTL8723AE
 combo device
From: Marcel Holtmann <marcel@holtmann.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Champion Chen <champion_chen@realsil.com.cn>
Date: Fri, 21 Dec 2012 08:17:27 +0100
In-Reply-To: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356058371-17152-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> This new driver works with the RTL8723AE wireless/BT combo device. The
> corresponding firmware has been submitted to linux-firmware.
> 
> Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/bluetooth/Kconfig     |   10 +
>  drivers/bluetooth/Makefile    |    1 +
>  drivers/bluetooth/rtk_btusb.c | 1649 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1660 insertions(+)
>  create mode 100644 drivers/bluetooth/rtk_btusb.c
>
> diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
> index e9f203e..efd3766 100644
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -241,4 +241,14 @@ config BT_WILINK
>  
>  	  Say Y here to compile support for Texas Instrument's WiLink7 driver
>  	  into the kernel or say M to compile it as module.
> +
> +config BT_RTKUSB
> +	tristate "Realtek BT driver for RTL8723AE"
> +	select FW_LOADER
> +	help
> +	  This enables the Bluetooth driver for the Realtek RTL8723AE Wifi/BT
> +	  combo device.
> +
> +	  Say Y here to compile support for these devices into the kernel
> +	  or say M to build it as a module.
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index 4afae20..167ccc0 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
>  obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
>  obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
>  obj-$(CONFIG_BT_WILINK)		+= btwilink.o
> +obj-$(CONFIG_BT_RTKUSB)		+= rtk_btusb.o
>  
>  btmrvl-y			:= btmrvl_main.o
>  btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
> diff --git a/drivers/bluetooth/rtk_btusb.c b/drivers/bluetooth/rtk_btusb.c
> new file mode 100644
> index 0000000..31c128a
> --- /dev/null
> +++ b/drivers/bluetooth/rtk_btusb.c
> @@ -0,0 +1,1650 @@
> +/*
> + *
> + *  Realtek Bluetooth USB driver
> + *
> + *  Copyright (C) 2012-2015  Edward Bian <edward_bian@realsil.com.cn>
> + *

NAK. This is pretty much a blunt copy of btusb.c and not acceptable.

And last time I checked, I own a big portion of btusb.c and I find it
funny how that copyright just got replaced. 2015? Really? Time travel
much lately ;)

There have been patches for hdev->setup stage and discussions on
creating a mini-driver approach on the mailing list. That is the way to
go.

Regards

Marcel


