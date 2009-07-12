Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:59489 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbZGLUVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 16:21:43 -0400
Received: by bwz23 with SMTP id 23so509563bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 13:21:42 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 12 Jul 2009 22:16:26 +0200
Message-ID: <328c675a0907121316r7dacda0fr94b3b56a6c023d86@mail.gmail.com>
Subject: Add device string to zd1211rw
From: =?ISO-8859-1?Q?Adri=E1n_Cereto?= <ssorgatem@esdebian.org>
To: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a wireless adapter with the following device string from lsusb:
"ID 083a:e501 Accton Technology Corp. ZD1211B"

It's device string was not in the zd1211rw driver, so I wondered what
would happen if I added it to zd_usb.c... and voilà, now it works
great ;) (i'm writing this connected with that adapter)

I've tried it with compat-wireless-2.6.30, with kernels 2.6.28 (ubuntu
9.04) and 2.6.30 (debian sid), and it works. I've tried to do it with
the bleeding edge compat-wireless, but it wouldn't compile on any of
my machines (the stable version compiled just fine, though).

The only thing I did was to put the following line in the device
string list in drivers/net/wireless/zd1211rw/zd_usb.c:

       { USB_DEVICE(0x083a, 0xe501), .driver_info = DEVICE_ZD1211B }

Do I need to send you a patch?
(if it weren't such a minute modification I wouldn't doubt it)
I've never done it before, but i'll learn to do it if necessary ;).

If you need more testing on this device, count me.
