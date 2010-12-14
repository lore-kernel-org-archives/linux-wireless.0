Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:58965 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0LNRJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 12:09:42 -0500
Received: by gwb20 with SMTP id 20so686831gwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 09:09:41 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 14 Dec 2010 17:09:40 +0000
Message-ID: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com>
Subject: another device working
From: Eduardo Costa <ecosta.tmp@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

I've made my device work with p54 without any hassle, so I wanted to report it.

This is an usb adpator widely provided by telefonica, here in spain. A
search based on the first couple of numbers of it's mac address
(00:14:A5), reveals this is the vendor and the model:

http://www.gemtek.com.tw/pro_wubi100.html

A picture of it can be found here:

http://www.zero13wireless.net/wireless/Mods_Wireless/GW3887AIK-usb.jpg

I also took the EMF protection cover out to see what was inside, but
didn't take any pictures either.
If you might need them, just let me know; there is just another two
smaller chips under (an ISL, and other I don't rembember now).

Although the supplied windows drivers for this device are called
prisma02, and in fact match the ones supplied by sparklan for it's
model WL-682, I couldn't make it work with ndiswrapper, due to it
returning `0xc010005' on a permanent basis, which ndiswrapper's source
defines as sort of "unable to initialize due to chip not found or
chip/driver mistmatch".

Anyways, I just had to add the following line to
`drivers/net/wireless/p54/p54usb.c' on a stock 2.6.30 kernel, prior to
recompilation and installing the module to make it work:

 {USB_DEVICE (0x15a9, 0x0002)},   /* Gemtek WUBI-100GW 802.11g */

And about the firmware, it does work with stock p54's
`2.13.24.0.lm87.arm' found on the website, so I just had to copy it to
`/lib/firmware' while renaming it to `isl3887usb'.

Thanks so much for your code and support, and do not hetisate to
contact me if you need any further assistance on my side.

Regards,
