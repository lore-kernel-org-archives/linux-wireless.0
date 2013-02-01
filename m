Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:46952 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BANdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 08:33:02 -0500
Received: by mail-ia0-f182.google.com with SMTP id w33so5358977iag.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2013 05:33:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359562453-31781-1-git-send-email-xose.vazquez@gmail.com>
References: <1359562453-31781-1-git-send-email-xose.vazquez@gmail.com>
Date: Fri, 1 Feb 2013 14:33:01 +0100
Message-ID: <CAL1gcdNsEyAUtPmn0nQ5z-+v7_T+jdMdeTeZhVpTc33ubMkE7Q@mail.gmail.com> (sfid-20130201_143306_515367_06E70A2A)
Subject: Re: [PATCH wireless-next] wireless: rt2x00: rt2800usb add/identify ids
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 30, 2013 at 5:14 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Devices were taken from Ralink Linux drivers:
> - RT5370
> 0x043e, 0x7a32
> 0x043e, 0x7a42
> 0x0471, 0x2126
> 0x0471, 0x2180
> 0x0471, 0x2181
> 0x0471, 0x2182
>
> Identify these ones:
> 0x04da, 0x23f6 in CONFIG_RT2800USB_RT53XX is a Panasonic device
> 0x07d1, 0x3c17 in RT2800USB_UNKNOWN is a RT3070
> 0x0586, 0x341a in RT2800USB_UNKNOWN is a RT3070
>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: users@rt2x00.serialmonkey.com
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 4721cad..1cbf20a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -968,6 +968,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x07d1, 0x3c13) },
>         { USB_DEVICE(0x07d1, 0x3c15) },
>         { USB_DEVICE(0x07d1, 0x3c16) },
> +       { USB_DEVICE(0x07d1, 0x3c17) },
>         { USB_DEVICE(0x2001, 0x3c1b) },
>         /* Draytek */
>         { USB_DEVICE(0x07fa, 0x7712) },
> @@ -1115,6 +1116,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         /* Zyxel */
>         { USB_DEVICE(0x0586, 0x3416) },
>         { USB_DEVICE(0x0586, 0x3418) },
> +       { USB_DEVICE(0x0586, 0x341a) },
>         { USB_DEVICE(0x0586, 0x341e) },
>         { USB_DEVICE(0x0586, 0x343e) },
>  #ifdef CONFIG_RT2800USB_RT33XX
> @@ -1166,6 +1168,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  #ifdef CONFIG_RT2800USB_RT53XX
>         /* Arcadyan */
>         { USB_DEVICE(0x043e, 0x7a12) },
> +       { USB_DEVICE(0x043e, 0x7a32) },
>         /* Azurewave */
>         { USB_DEVICE(0x13d3, 0x3329) },
>         { USB_DEVICE(0x13d3, 0x3365) },
> @@ -1177,16 +1180,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x2001, 0x3c1e) },
>         /* LG innotek */
>         { USB_DEVICE(0x043e, 0x7a22) },
> +       { USB_DEVICE(0x043e, 0x7a42) },
>         /* Panasonic */
>         { USB_DEVICE(0x04da, 0x1801) },
>         { USB_DEVICE(0x04da, 0x1800) },
> +       { USB_DEVICE(0x04da, 0x23f6) },
>         /* Philips */
>         { USB_DEVICE(0x0471, 0x2104) },
> +       { USB_DEVICE(0x0471, 0x2126) },
> +       { USB_DEVICE(0x0471, 0x2180) },
> +       { USB_DEVICE(0x0471, 0x2181) },
> +       { USB_DEVICE(0x0471, 0x2182) },
>         /* Ralink */
>         { USB_DEVICE(0x148f, 0x5370) },
>         { USB_DEVICE(0x148f, 0x5372) },
> -       /* Unknown */
> -       { USB_DEVICE(0x04da, 0x23f6) },
>  #endif
>  #ifdef CONFIG_RT2800USB_UNKNOWN
>         /*
> @@ -1223,7 +1230,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x18c5, 0x0008) },
>         /* D-Link */
>         { USB_DEVICE(0x07d1, 0x3c0b) },
> -       { USB_DEVICE(0x07d1, 0x3c17) },
>         /* Encore */
>         { USB_DEVICE(0x203d, 0x14a1) },
>         /* Gemtek */
> @@ -1261,8 +1267,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x083a, 0xc522) },
>         { USB_DEVICE(0x083a, 0xd522) },
>         { USB_DEVICE(0x083a, 0xf511) },
> -       /* Zyxel */
> -       { USB_DEVICE(0x0586, 0x341a) },
>  #endif
>         { 0, }
>  };
> --
> 1.7.11.7



--
---
Gertjan
