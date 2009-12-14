Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:62967 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932625AbZLNVL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 16:11:26 -0500
Message-ID: <4B2690E0.6050604@gmail.com>
Date: Mon, 14 Dec 2009 20:24:16 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] rt2x00: Fix rt2800usb detection in rt2800lib.
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com> <1260818004-22785-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1260818004-22785-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/09 20:13, John W. Linville wrote:
> From: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> rt2800lib incorrectly detected whether RT2800USB was enabled because
> it didn't account for a modularized RT2800USB driver.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> I'm merging this version based on Randy's feedback...
> 
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index eb1e1d0..6e13650 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -37,7 +37,7 @@
>  #include <linux/module.h>
>  
>  #include "rt2x00.h"
> -#ifdef CONFIG_RT2800USB
> +#if defined(CONFIG_RT2800USB) || defined(CONFIG_RT2800USB_MODULE)
>  #include "rt2x00usb.h"
>  #endif
>  #include "rt2800lib.h"
> @@ -1121,7 +1121,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>  
>  	if (rt2x00_intf_is_usb(rt2x00dev)) {
>  		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
> -#ifdef CONFIG_RT2800USB
> +#if defined(CONFIG_RT2800USB) || defined(CONFIG_RT2800USB_MODULE)
>  		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
>  					    USB_MODE_RESET, REGISTER_TIMEOUT);
>  #endif

Thanks, looks good to me.

---
Gertjan.
