Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57669 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HUP3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Aug 2011 11:29:07 -0400
Received: by iye16 with SMTP id 16so8804851iye.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Aug 2011 08:29:06 -0700 (PDT)
Message-ID: <4E51243F.9030709@lwfinger.net> (sfid-20110821_172918_484936_AE5729D5)
Date: Sun, 21 Aug 2011 10:29:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43/legacy: Remove firmware IDs
References: <20110821172447.4d8725da@milhouse>
In-Reply-To: <20110821172447.4d8725da@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2011 10:24 AM, Michael Büsch wrote:
> This removes the "FWxx" ID strings from the b43 and b43legacy
> drivers. They were once used to match a specific driver revision
> to a set of firmware files. However, this is hardly useful today.
> Additionally, the IDs are not updated and maintained properly, so
> they might mislead users.
>
> Signed-off-by: Michael Buesch<m@bues.ch>
>
> ---
>
> This is stuff for -next.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

>
> Index: wireless-testing/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2011-08-21 14:11:32.230841828 +0200
> +++ wireless-testing/drivers/net/wireless/b43/b43.h	2011-08-21 14:12:03.778998292 +0200
> @@ -17,11 +17,6 @@
>   #include "phy_common.h"
>
>
> -/* The unique identifier of the firmware that's officially supported by
> - * this driver version. */
> -#define B43_SUPPORTED_FIRMWARE_ID	"FW13"
> -
> -
>   #ifdef CONFIG_B43_DEBUG
>   # define B43_DEBUG	1
>   #else
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2011-08-21 14:12:08.859023457 +0200
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2011-08-21 14:13:27.587413841 +0200
> @@ -66,7 +66,6 @@
>   MODULE_AUTHOR("Gábor Stefanik");
>   MODULE_LICENSE("GPL");
>
> -MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
>   MODULE_FIRMWARE("b43/ucode11.fw");
>   MODULE_FIRMWARE("b43/ucode13.fw");
>   MODULE_FIRMWARE("b43/ucode14.fw");
> @@ -5416,8 +5415,7 @@
>   	feat_sdio = "S";
>   #endif
>   	printk(KERN_INFO "Broadcom 43xx driver loaded "
> -	       "[ Features: %s%s%s%s%s, Firmware-ID: "
> -	       B43_SUPPORTED_FIRMWARE_ID " ]\n",
> +	       "[ Features: %s%s%s%s%s ]\n",
>   	       feat_pci, feat_pcmcia, feat_nphy,
>   	       feat_leds, feat_sdio);
>   }
> Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h	2011-08-21 14:14:36.575755946 +0200
> +++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h	2011-08-21 14:14:44.627795873 +0200
> @@ -22,10 +22,6 @@
>   #include "phy.h"
>
>
> -/* The unique identifier of the firmware that's officially supported by this
> - * driver version. */
> -#define B43legacy_SUPPORTED_FIRMWARE_ID	"FW10"
> -
>   #define B43legacy_IRQWAIT_MAX_RETRIES	20
>
>   /* MMIO offsets */
> Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2011-08-21 14:14:47.879811994 +0200
> +++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2011-08-21 14:15:27.028006541 +0200
> @@ -60,7 +60,6 @@
>   MODULE_AUTHOR("Michael Buesch");
>   MODULE_LICENSE("GPL");
>
> -MODULE_FIRMWARE(B43legacy_SUPPORTED_FIRMWARE_ID);
>   MODULE_FIRMWARE("b43legacy/ucode2.fw");
>   MODULE_FIRMWARE("b43legacy/ucode4.fw");
>
> @@ -3947,8 +3946,7 @@
>   	feat_dma = "D";
>   #endif
>   	printk(KERN_INFO "Broadcom 43xx-legacy driver loaded "
> -	       "[ Features: %s%s%s%s, Firmware-ID: "
> -	       B43legacy_SUPPORTED_FIRMWARE_ID " ]\n",
> +	       "[ Features: %s%s%s%s ]\n",
>   	       feat_pci, feat_leds, feat_pio, feat_dma);
>   }
>
>
>

