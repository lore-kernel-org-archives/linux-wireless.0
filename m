Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34040 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab2DWJ6e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 05:58:34 -0400
Received: by lahj13 with SMTP id j13so8979229lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 02:58:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334620232-5558-1-git-send-email-xose.vazquez@gmail.com>
References: <1334620232-5558-1-git-send-email-xose.vazquez@gmail.com>
Date: Mon, 23 Apr 2012 11:58:33 +0200
Message-ID: <CAL1gcdNXcgXx7Eru-LVWNAnZ06QHhD5Q=d27S-mN3VmdT-=DDg@mail.gmail.com> (sfid-20120423_115838_936817_60E8915B)
Subject: Re: [PATCH v2] wireless: rt2x00: rt2800usb add more devices ids
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com,
	helmut.schaa@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2012 at 1:50 AM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> They were taken from ralink drivers:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO
>
> 0x1eda,0x2210 RT3070 Airties
>
> 0x083a,0xb511 RT3370 Panasonic
> 0x0471,0x20dd RT3370 Philips
>
> 0x1690,0x0764 RT35xx Askey
> 0x0df6,0x0065 RT35xx Sitecom
> 0x0df6,0x0066 RT35xx Sitecom
> 0x0df6,0x0068 RT35xx Sitecom
>
> 0x2001,0x3c1c RT5370 DLink
> 0x2001,0x3c1d RT5370 DLink
>
> 2001 is D-Link not Alpha

Apparently these devices are shared between Alpha and D-Link with the
same USB ID. However, I have no problem with listing them as D-Link.

>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 001735f..5851be7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -922,6 +922,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x1482, 0x3c09) },
>        /* AirTies */
>        { USB_DEVICE(0x1eda, 0x2012) },
> +       { USB_DEVICE(0x1eda, 0x2210) },
>        { USB_DEVICE(0x1eda, 0x2310) },
>        /* Allwin */
>        { USB_DEVICE(0x8516, 0x2070) },
> @@ -1134,6 +1135,10 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  #ifdef CONFIG_RT2800USB_RT33XX
>        /* Belkin */
>        { USB_DEVICE(0x050d, 0x945b) },
> +       /* Panasonic */
> +       { USB_DEVICE(0x083a, 0xb511) },
> +       /* Philips */
> +       { USB_DEVICE(0x0471, 0x20dd) },
>        /* Ralink */
>        { USB_DEVICE(0x148f, 0x3370) },
>        { USB_DEVICE(0x148f, 0x8070) },
> @@ -1145,6 +1150,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x8516, 0x3572) },
>        /* Askey */
>        { USB_DEVICE(0x1690, 0x0744) },
> +       { USB_DEVICE(0x1690, 0x0764) },
>        /* Cisco */
>        { USB_DEVICE(0x167b, 0x4001) },
>        /* EnGenius */
> @@ -1159,20 +1165,25 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* Sitecom */
>        { USB_DEVICE(0x0df6, 0x0041) },
>        { USB_DEVICE(0x0df6, 0x0062) },
> +       { USB_DEVICE(0x0df6, 0x0065) },
> +       { USB_DEVICE(0x0df6, 0x0066) },
> +       { USB_DEVICE(0x0df6, 0x0068) },
>        /* Toshiba */
>        { USB_DEVICE(0x0930, 0x0a07) },
>        /* Zinwell */
>        { USB_DEVICE(0x5a57, 0x0284) },
>  #endif
>  #ifdef CONFIG_RT2800USB_RT53XX
> -       /* Alpha */
> -       { USB_DEVICE(0x2001, 0x3c15) },
> -       { USB_DEVICE(0x2001, 0x3c19) },
>        /* Arcadyan */
>        { USB_DEVICE(0x043e, 0x7a12) },
>        /* Azurewave */
>        { USB_DEVICE(0x13d3, 0x3329) },
>        { USB_DEVICE(0x13d3, 0x3365) },
> +       /* D-Link */
> +       { USB_DEVICE(0x2001, 0x3c15) },
> +       { USB_DEVICE(0x2001, 0x3c19) },
> +       { USB_DEVICE(0x2001, 0x3c1c) },
> +       { USB_DEVICE(0x2001, 0x3c1d) },
>        /* LG innotek */
>        { USB_DEVICE(0x043e, 0x7a22) },
>        /* Panasonic */
> --
> 1.7.6.5
>



-- 
---
Gertjan
