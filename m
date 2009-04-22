Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50932 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDVX3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 19:29:01 -0400
Received: by fxm2 with SMTP id 2so258003fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 16:28:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904221953.23265.eugene.sobol@promwad.com>
References: <200904221953.23265.eugene.sobol@promwad.com>
Date: Thu, 23 Apr 2009 00:28:59 +0100
Message-ID: <3ace41890904221628y17d558f7y17bf091afc346d7@mail.gmail.com> (sfid-20090423_012906_748693_76F46DCB)
Subject: Re: rtl8187 diversity
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Eugene Sobol <eugene.sobol@promwad.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks a lot for working on the patch; I see Larry has already given
some feedback - more below.

On Wed, Apr 22, 2009 at 5:53 PM, Eugene Sobol <eugene.sobol@promwad.com=
> wrote:

> diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_d=
ev.c compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c
> --- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187_dev.c =A0=
 =A0 2008-09-15 19:57:24.000000000 +0300
> +++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187_dev.c =A0200=
9-04-22 18:04:01.000000000 +0300
> @@ -45,6 +45,9 @@
> =A0 =A0 =A0 =A0{USB_DEVICE(0x03f0, 0xca02), .driver_info =3D DEVICE_R=
TL8187},
> =A0 =A0 =A0 =A0/* Sitecom */
> =A0 =A0 =A0 =A0{USB_DEVICE(0x0df6, 0x000d), .driver_info =3D DEVICE_R=
TL8187},
> +
> + =A0 =A0 =A0 {USB_DEVICE(0x13d1, 0xabe6), .driver_info =3D DEVICE_RT=
L8187},
> +
> =A0 =A0 =A0 =A0{}
> =A0};
>

Support for new hardware should/could be a separate patch; also some
notes about make/vendor would be nice, about the device.


> @@ -1123,6 +1229,7 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0chip_name =3D "RTL8187=
vB (default)";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->ant_diversity_ena=
bled =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*

Switching on antenna diversity for all 8187L? I don't know what
side-effect there might be - (particularly for device which hasn't got
double-antenna). It is probably better to move this out of the loop
and conditioning on the vid/pid - i.e. specific to your device, for
the time being.

I am just a little concerned that the code should not have side effect
on devices not having double-antenna - for general testing/reviewing
is fine, but I think we need some way of auto-detection or runtime
switching (via iwpriv, etc), rather than compile-time change.

> diff -urN compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h=
 compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h
> --- compat-wireless-2.6-old.orig/drivers/net/wireless/rtl8187.h 2008-=
09-04 00:04:20.000000000 +0300
> +++ compat-wireless-2.6-old/drivers/net/wireless/rtl8187.h =A0 =A0 =A0=
2009-04-22 16:51:13.000000000 +0300
> @@ -82,11 +82,24 @@
> =A0 =A0 =A0 =A0DEVICE_RTL8187B
> =A0};
>
> +#define VAL_ARRAY_SIZE 10
> +#define ANTSEL 0xFF9F
> +
> +struct rtl8187_ant_diversity {
> +
> + =A0 =A0int count;
> + =A0 =A0 =A0 u8 agc_array[VAL_ARRAY_SIZE];
> +
> + =A0 =A0u8 switch_to;
> + =A0 =A0u8 curr_ant_index;
> +} __attribute__ ((packed));
> +
> =A0struct rtl8187_priv {
> =A0 =A0 =A0 =A0/* common between rtl818x drivers */
> =A0 =A0 =A0 =A0struct rtl818x_csr *map;
> =A0 =A0 =A0 =A0const struct rtl818x_rf_ops *rf;
> =A0 =A0 =A0 =A0struct ieee80211_vif *vif;
> + =A0 =A0 =A0 struct ieee80211_hw *hw;
> =A0 =A0 =A0 =A0int mode;
> =A0 =A0 =A0 =A0/* The mutex protects the TX loopback state.
> =A0 =A0 =A0 =A0 * Any attempt to set channels concurrently locks the =
device.

This looks wrong - there are existing means for accessing the
hardware, should not need to add another struct there.

Thanks for the work.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
