Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:38911 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZHQTWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 15:22:39 -0400
Received: by fxm11 with SMTP id 11so2478298fxm.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 12:22:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250530052-14783-14-git-send-email-lrodriguez@atheros.com>
References: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
	<1250530052-14783-14-git-send-email-lrodriguez@atheros.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 Aug 2009 21:22:20 +0200
Message-ID: <69e28c910908171222g17e9563csd38dadfcc8fe0bae@mail.gmail.com>
Subject: Re: [PATCH v5 13/33] wireless: move AIRO_CS closer to AIRO_CS
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 7:27 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/Kconfig |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index b489d9c..b03035f 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -213,6 +213,26 @@ config AIRO
>
>          The driver can be compiled as a module and will be named "airo".
>
> +config AIRO_CS
> +       tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
> +       depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
> +       select WIRELESS_EXT
> +       select CRYPTO
> +       select CRYPTO_AES
> +       ---help---
> +         This is the standard Linux driver to support Cisco/Aironet PCMCIA
> +         802.11 wireless cards.  This driver is the same as the Aironet
> +         driver part of the Linux Pcmcia package.
> +         It supports the new 802.11b cards from Cisco (Cisco 34X, Cisco 35X
> +         - with or without encryption) as well as card before the Cisco
> +         acquisition (Aironet 4500, Aironet 4800, Aironet 4800B). It also
> +         supports OEM of Cisco such as the DELL TrueMobile 4800 and Xircom
> +         802.11b cards.
> +
> +         This driver support both the standard Linux Wireless Extensions
> +         and Cisco proprietary API, so both the Linux Wireless Tools and the
> +         Cisco Linux utilities can be used to configure the card.
> +
>  config ATMEL_80211
>        bool "Atmel"
>        depends on WLAN_80211
> @@ -265,26 +285,6 @@ config AT76C50X_USB
>
>  endif # ATMEL_80211
>
> -config AIRO_CS
> -       tristate "Cisco/Aironet 34X/35X/4500/4800 PCMCIA cards"
> -       depends on PCMCIA && (BROKEN || !M32R) && WLAN_80211
> -       select WIRELESS_EXT
> -       select CRYPTO
> -       select CRYPTO_AES
> -       ---help---
> -         This is the standard Linux driver to support Cisco/Aironet PCMCIA
> -         802.11 wireless cards.  This driver is the same as the Aironet
> -         driver part of the Linux Pcmcia package.
> -         It supports the new 802.11b cards from Cisco (Cisco 34X, Cisco 35X
> -         - with or without encryption) as well as card before the Cisco
> -         acquisition (Aironet 4500, Aironet 4800, Aironet 4800B). It also
> -         supports OEM of Cisco such as the DELL TrueMobile 4800 and Xircom
> -         802.11b cards.
> -
> -         This driver support both the standard Linux Wireless Extensions
> -         and Cisco proprietary API, so both the Linux Wireless Tools and the
> -         Cisco Linux utilities can be used to configure the card.
> -
>  config PCMCIA_WL3501
>       tristate "Planet WL3501 PCMCIA cards"
>       depends on EXPERIMENTAL && PCMCIA && WLAN_80211
> --
> 1.6.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

AIRO_CS has an identity crisis again...

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
