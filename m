Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41872 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1L1UOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 15:14:46 -0500
Received: by vbbfc26 with SMTP id fc26so9836409vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 12:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4efa0cfb.QRlP24Yb0ASrlhga%Larry.Finger@lwfinger.net>
References: <4efa0cfb.QRlP24Yb0ASrlhga%Larry.Finger@lwfinger.net>
Date: Wed, 28 Dec 2011 21:14:46 +0100
Message-ID: <CAOZOX0VWb_DvvqCDZoLMrN+3vY4PeOO+2DNFjO356EYPHAwpeA@mail.gmail.com> (sfid-20111228_211450_240823_C9C96BF7)
Subject: Re: [PATCH V2] rt2800usb: Move ID out of unknown
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, helmut.schaa@googlemail.com,
	gwingerde@gmail.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 27, 2011 at 7:22 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Testing on the openSUSE wireless forum has shown that a Linksys
> WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
> written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>
> V2 - Place new ID with rest of Linksys devices.
>
> Index: wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -976,6 +976,7 @@ static struct usb_device_id rt2800usb_de
>        { USB_DEVICE(0x13b1, 0x0031) },
>        { USB_DEVICE(0x1737, 0x0070) },
>        { USB_DEVICE(0x1737, 0x0071) },
> +       { USB_DEVICE(0x1737, 0x0077) },
>        /* Logitec */
>        { USB_DEVICE(0x0789, 0x0162) },
>        { USB_DEVICE(0x0789, 0x0163) },
> @@ -1173,7 +1174,6 @@ static struct usb_device_id rt2800usb_de
>        { USB_DEVICE(0x1740, 0x0605) },
>        { USB_DEVICE(0x1740, 0x0615) },
>        /* Linksys */
> -       { USB_DEVICE(0x1737, 0x0077) },
>        { USB_DEVICE(0x1737, 0x0078) },
>        /* Logitec */
>        { USB_DEVICE(0x0789, 0x0168) },
