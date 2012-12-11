Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKCPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 21:15:44 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1459589wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 18:15:43 -0800 (PST)
Message-ID: <50C6974B.5000206@gmail.com> (sfid-20121211_031555_626904_90911514)
Date: Tue, 11 Dec 2012 03:15:39 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: sikon@ubuntu.com, linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB
 Wi-Fi adapter
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maia Kozheva wrote:

> D-Link DWA-125/B1 is a relatively new USB Wi-Fi adapter, using a Ralink chipset \
> supported by the rt2800usb driver. Currently, to work around the problem (it's \
> missing in all present kernel versions, up to and including 3.7.x), I had to add this \
> to /etc/rc.local:
>
> echo 2001 3c1e >> /sys/bus/usb/drivers/rt2800usb/new_id
>
> After that, the device works without problems. Been using it for over a week with no \
> bugs in sight.
>
> The attached patch is trivial and simply adds the new USB ID to the list of devices \
> handled by rt2800usb.
>
>
> Signed-off-by: Maia Kozheva <sikon@ubuntu.com>
> diff -uprN a/drivers/net/wireless/rt2x00/rt2800usb.c \
>                 b/drivers/net/wireless/rt2x00/rt2800usb.c
> - --- a/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-09 15:30:39.051951506 +0700
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-09 15:31:07.679951314 +0700
> @@ -965,6 +965,7 @@ static struct usb_device_id rt2800usb_de
>  	{ USB_DEVICE(0x07d1, 0x3c15) },
>  	{ USB_DEVICE(0x07d1, 0x3c16) },
>  	{ USB_DEVICE(0x2001, 0x3c1b) },
> +	{ USB_DEVICE(0x2001, 0x3c1e) },
>  	/* Draytek */
>  	{ USB_DEVICE(0x07fa, 0x7712) },
>  	/* DVICO */

It looks like it's a RT5370 device: 
http://www.wikidevi.com/wiki/D-Link_DWA-125_rev_B1

It should go in CONFIG_RT2800USB_RT53XX

NACK
