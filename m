Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39899 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0KNI7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 03:59:37 -0500
Received: by iwn10 with SMTP id 10so5390191iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 00:59:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011131910.11947.IvDoorn@gmail.com>
References: <201011131908.15595.IvDoorn@gmail.com> <201011131909.50885.IvDoorn@gmail.com>
 <201011131910.11947.IvDoorn@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 14 Nov 2010 19:59:16 +1100
Message-ID: <AANLkTi=b5czEjEM8zD1ZUq0hNdeJg1wy7OS4-OhE6fO_@mail.gmail.com>
Subject: Re: [PATCH 3/9] rt2x00: Clean up Kconfig for RT2800 devices.
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IVD,

A minor nit:

On Sun, Nov 14, 2010 at 05:10, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> From: Gertjan van Wingerde <gwingerde@gmail.com>
>
> General clean up of the Kconfig part for RT28XX devices.
> Also remove the indications of non functional support for rt27xx/rt28xx/rt30xx
> devices, as this is no longer true. They just work fine.
> Finally, remove the experimental indications for rt27xx/rt28xx/rt30xx devices
> as that is no longer true. Keep the experimental indications for rt33xx/rt35xx
> devices, though.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/Kconfig |   47 ++++++++++++++--------------------
>  1 files changed, 19 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index f0f0152..f2be1d3 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -154,30 +150,24 @@ config RT2800USB
>        select RT2X00_LIB_CRYPTO
>        select CRC_CCITT
>        ---help---
> -         This adds experimental support for rt2800 wireless chipset family.
> +         This adds support for rt27xx/rt28xx wireless chipset family.
>          Supported chips: RT2770, RT2870 & RT3070.

Isn't RT3070 support selected below?

> -         Known issues:
> -         - support for RT2870 chips doesn't work with 802.11n APs yet
> -         - support for RT3070 chips is non-functional at the moment
> -
>          When compiled as a module, this driver will be called "rt2800usb.ko".
>
>  if RT2800USB
>
>  config RT2800USB_RT30XX
> -       bool "rt2800usb - Include support for rt30xx (USB) devices"
> +       bool "rt2800usb - Include support for rt30xx devices"
>        default y
>        ---help---
>          This adds support for rt30xx wireless chipset family to the
>          rt2800usb driver.
>          Supported chips: RT3070, RT3071 & RT3072

I.e. here?

> -         Support for these devices is non-functional at the moment and is
> -         intended for testers and developers.
> -
>  config RT2800USB_RT33XX
> -       bool "rt2800usb - Include support for rt33xx (USB) devices"
> +       bool "rt2800usb - Include support for rt33xx devices (EXPERIMENTAL)"
> +       depends on EXPERIMENTAL
>        default n
>        ---help---
>          This adds support for rt33xx wireless chipset family to the

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
