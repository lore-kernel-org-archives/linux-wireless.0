Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.locum.ru ([193.106.93.111]:54312 "EHLO mail.locum.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab2LKEjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 23:39:02 -0500
Message-ID: <50C6B8E0.4080801@ubuntu.com> (sfid-20121211_053907_553379_BEDB9441)
Date: Tue, 11 Dec 2012 11:38:56 +0700
From: Maia Kozheva <sikon@ubuntu.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] Add support for 2001:3c1e (D-Link DWA-125 rev B1) USB
 Wi-Fi adapter
References: <50C6974B.5000206@gmail.com>
In-Reply-To: <50C6974B.5000206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Someone who physically disassembled the device confirms that its chipset is Ralink RT5370n.

Fixed the patch.

Signed-off-by: Maia Kozheva <sikon@ubuntu.com>
diff -uprN a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
--- a/drivers/net/wireless/rt2x00/rt2800usb.c	2012-11-28 04:21:31.000000000 +0700
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c	2012-12-11 11:34:35.889131671 +0700
@@ -1169,6 +1169,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x2001, 0x3c19) },
 	{ USB_DEVICE(0x2001, 0x3c1c) },
 	{ USB_DEVICE(0x2001, 0x3c1d) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
 	/* Panasonic */


Op 11-12-12 09:15, Xose Vazquez Perez schreef:
> It looks like it's a RT5370 device:
> http://www.wikidevi.com/wiki/D-Link_DWA-125_rev_B1
> 
> It should go in CONFIG_RT2800USB_RT53XX
> 
> NACK
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

