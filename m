Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34532 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0KYOxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:53:05 -0500
Received: by qwb7 with SMTP id 7so1041556qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Nov 2010 06:53:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290696517-20437-2-git-send-email-hauke@hauke-m.de>
References: <1290696517-20437-1-git-send-email-hauke@hauke-m.de> <1290696517-20437-2-git-send-email-hauke@hauke-m.de>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Thu, 25 Nov 2010 14:52:44 +0000
Message-ID: <AANLkTi=7AYqV5HT29mxuSiOdPEkJEmoGGZ8o6QzB9bh=@mail.gmail.com>
Subject: Re: [PATCH 2/5] compat-wireless: correct rt2x00 config options
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Nov 25, 2010 at 14:48, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> * Do not add PCI IDs for not jet supported devices.
> * remove some not included config options and add some newly introduced
> options
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  config.mk |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/config.mk b/config.mk
> index ee20543..0f58320 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -312,10 +312,8 @@ CONFIG_RT2400PCI=m
>  CONFIG_RT2500PCI=m
>  ifdef CONFIG_CRC_CCITT
>  CONFIG_RT2800PCI=m
> -CONFIG_RT2800PCI_PCI=y
> -# CONFIG_RT2800PCI_RT30XX=y
> +# CONFIG_RT2800PCI_RT33XX=y
>  # CONFIG_RT2800PCI_RT35XX=y
> -# CONFIG_RT2800PCI_SOC=y
>  endif #CONFIG_CRC_CCITT
>  NEED_RT2X00=y
>
> @@ -324,7 +322,6 @@ NEED_RT2X00=y
>  # driver as we're in the PCI section.
>  ifdef CONFIG_CRC_ITU_T
>  CONFIG_RT61PCI=m
> -NEED_RT2X00_FIRMWARE=y
>  endif #CONFIG_CRC_ITU_T
>
>  CONFIG_MWL8K=m
> @@ -435,8 +432,8 @@ CONFIG_ATH9K_HTC=m
>  CONFIG_RT2500USB=m
>  ifdef CONFIG_CRC_CCITT
>  CONFIG_RT2800USB=m
> -CONFIG_RT2800USB_RT30XX=y
> -CONFIG_RT2800USB_RT35XX=y
> +# CONFIG_RT2800USB_RT33XX=y
> +# CONFIG_RT2800USB_RT35XX=y
>  CONFIG_RT2800USB_UNKNOWN=y
>  endif #CONFIG_CRC_CCITT
>  CONFIG_RT2X00_LIB_USB=m
> @@ -444,7 +441,6 @@ NEED_RT2X00=y
>  # RT73USB requires firmware
>  ifdef CONFIG_CRC_ITU_T
>  CONFIG_RT73USB=m
> -NEED_RT2X00_FIRMWARE=y
>  endif #CONFIG_CRC_ITU_T
>
>  ifdef CONFIG_COMPAT_KERNEL_27
> @@ -550,6 +546,7 @@ CONFIG_RT2800_LIB=m
>  CONFIG_RT2X00_LIB_HT=y
>  CONFIG_RT2X00_LIB_FIRMWARE=y
>  CONFIG_RT2X00_LIB_CRYPTO=y
> +# CONFIG_RT2X00_LIB_SOC=y
>  ifdef CONFIG_COMPAT_KERNEL_25
>  CONFIG_RT2X00_LIB_LEDS=n
>  else #CONFIG_COMPAT_KERNEL_25
> @@ -559,10 +556,6 @@ endif #CONFIG_COMPAT_KERNEL_25
>  # CONFIG_RT2X00_LIB_DEBUGFS
>  endif
>
> -ifeq ($(NEED_RT2X00_FIRMWARE),y)
> -CONFIG_RT2X00_LIB_FIRMWARE=y
> -endif
> -
>  # p54
>  CONFIG_P54_COMMON=m
>  CONFIG_P54_LEDS=y
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I would humble say NAK to parts of this, as at least these devices
need firmware:

 CONFIG_RT61PCI=m
-NEED_RT2X00_FIRMWARE=y

 CONFIG_RT73USB=m
-NEED_RT2X00_FIRMWARE=y

But, as I'm not really an expert to Kconfig, it may or may not be true.

Luis Correia
rt2x00 project admin
