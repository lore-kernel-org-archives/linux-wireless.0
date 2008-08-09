Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:27742 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYHIPJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2008 11:09:13 -0400
Received: by yx-out-2324.google.com with SMTP id 8so443938yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Aug 2008 08:09:12 -0700 (PDT)
Message-ID: <22bd28110808090809x6eb88c2ct97586a0e33f2f96@mail.gmail.com> (sfid-20080809_170919_042799_EFCB0833)
Date: Sat, 9 Aug 2008 17:09:12 +0200
From: "=?ISO-8859-1?Q?matthieu_Barth=E9lemy?=" <bonsouere@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: rtl8187 new ProductId patch
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I didn't see any previous post about this material, so here is the patc=
h.
It adds support for some Netgear WG111v3, with ProductId 0x4260.

It works for me in infrastructure mode, without encryption and with
WEP ASCII key. I can't test other encryption schemes.
Patch is against 2.6.27-rc2.

--- rtl8187_dev.c.old   2008-08-09 17:04:46.000000000 +0200
+++ rtl8187_dev.c       2008-08-09 16:42:22.000000000 +0200
@@ -40,6 +40,7 @@
        /* Netgear */
        {USB_DEVICE(0x0846, 0x6100), .driver_info =3D DEVICE_RTL8187},
        {USB_DEVICE(0x0846, 0x6a00), .driver_info =3D DEVICE_RTL8187},
+       {USB_DEVICE(0x0846, 0x4260), .driver_info =3D DEVICE_RTL8187B},
        /* HP */
        {USB_DEVICE(0x03f0, 0xca02), .driver_info =3D DEVICE_RTL8187},
        /* Sitecom */


Regards,

Matthieu Barth=E9lemy
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
