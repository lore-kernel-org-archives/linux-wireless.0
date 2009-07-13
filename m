Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56224 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZGMUXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:23:07 -0400
Received: by fxm18 with SMTP id 18so2431034fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 13:23:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <328c675a0907121316r7dacda0fr94b3b56a6c023d86@mail.gmail.com>
References: <328c675a0907121316r7dacda0fr94b3b56a6c023d86@mail.gmail.com>
Date: Mon, 13 Jul 2009 21:23:05 +0100
Message-ID: <3ace41890907131323t10c5bc15oac1714e63289abd@mail.gmail.com>
Subject: Re: Add device string to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Adri=E1n_Cereto?= <ssorgatem@esdebian.org>
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 12, 2009 at 9:16 PM, Adrián Cereto<ssorgatem@esdebian.org> wrote:
> I have a wireless adapter with the following device string from lsusb:
> "ID 083a:e501 Accton Technology Corp. ZD1211B"
>
> It's device string was not in the zd1211rw driver, so I wondered what
> would happen if I added it to zd_usb.c... and voilà, now it works
> great ;) (i'm writing this connected with that adapter)
>
> I've tried it with compat-wireless-2.6.30, with kernels 2.6.28 (ubuntu
> 9.04) and 2.6.30 (debian sid), and it works. I've tried to do it with
> the bleeding edge compat-wireless, but it wouldn't compile on any of
> my machines (the stable version compiled just fine, though).

compat-wireless latest-and-greatest is a bit broken lately, in the
last week or so. You are not the only one affected - Luis is working
on it, I think.

>
> The only thing I did was to put the following line in the device
> string list in drivers/net/wireless/zd1211rw/zd_usb.c:
>
>       { USB_DEVICE(0x083a, 0xe501), .driver_info = DEVICE_ZD1211B }
>
> Do I need to send you a patch?
> (if it weren't such a minute modification I wouldn't doubt it)
> I've never done it before, but i'll learn to do it if necessary ;).

A patch is not necessary, but having the RF type line from your dmesg
would be good.

>
> If you need more testing on this device, count me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
