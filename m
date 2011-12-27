Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62524 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1L0Teu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 14:34:50 -0500
Received: by eekc4 with SMTP id c4so11863909eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2011 11:34:48 -0800 (PST)
References: <4efa0cfb.QRlP24Yb0ASrlhga%Larry.Finger@lwfinger.net>
In-Reply-To: <4efa0cfb.QRlP24Yb0ASrlhga%Larry.Finger@lwfinger.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <148B7541-93B0-42E9-800C-7309CEE0BCF0@gmail.com> (sfid-20111227_203457_428188_CE2196BF)
Cc: John W Linville <linville@tuxdriver.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
	"IvDoorn@gmail.com" <IvDoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH V2] rt2800usb: Move ID out of unknown
Date: Tue, 27 Dec 2011 20:34:52 +0100
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 dec. 2011, at 19:22, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Testing on the openSUSE wireless forum has shown that a Linksys
> WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
> written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> V2 - Place new ID with rest of Linksys devices.
> 
> Index: wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -976,6 +976,7 @@ static struct usb_device_id rt2800usb_de
>    { USB_DEVICE(0x13b1, 0x0031) },
>    { USB_DEVICE(0x1737, 0x0070) },
>    { USB_DEVICE(0x1737, 0x0071) },
> +    { USB_DEVICE(0x1737, 0x0077) },
>    /* Logitec */
>    { USB_DEVICE(0x0789, 0x0162) },
>    { USB_DEVICE(0x0789, 0x0163) },
> @@ -1173,7 +1174,6 @@ static struct usb_device_id rt2800usb_de
>    { USB_DEVICE(0x1740, 0x0605) },
>    { USB_DEVICE(0x1740, 0x0615) },
>    /* Linksys */
> -    { USB_DEVICE(0x1737, 0x0077) },
>    { USB_DEVICE(0x1737, 0x0078) },
>    /* Logitec */
>    { USB_DEVICE(0x0789, 0x0168) },
