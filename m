Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58945 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZBPQPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 11:15:53 -0500
Date: Mon, 16 Feb 2009 11:11:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Viktor =?utf-8?B?SWxpamHFoWnEhw==?= <viktor.ilijasic@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 not handling my usb card
Message-ID: <20090216161157.GB2870@tuxdriver.com> (sfid-20090216_171557_845548_E8C9819A)
References: <63d38a500902152114o7b3c0f91j571a1e1d62e31d24@mail.gmail.com> <63d38a500902152133y264b783cl76800ed3efa46dd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <63d38a500902152133y264b783cl76800ed3efa46dd4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 06:33:10AM +0100, Viktor Ilija=C5=A1i=C4=87 wro=
te:

> The card is AirLive WL1600USB, PCI/USB ID 1b75:8187,
> url: http://www.airlive.com/product/product_3.jsp?pdid=3DPD1223473034=
861
>=20
> I somehow have the feeling that the PCI/USB ID of this card is
> unrecognized by the module (if the module even recognizes hardware
> only by it's ID), since this is rather obscure ID (google only return=
s
> 2 results for that ID). I'm no expert, I might be wrong.

You might try applying the patch below and rebuilding your kernel.
Does that get the driver to recognize the device?

John

---

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/w=
ireless/rtl818x/rtl8187_dev.c
index 82bd47e..5da2bd7 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -59,6 +59,8 @@ static struct usb_device_id rtl8187_table[] __devinit=
data =3D {
 	{USB_DEVICE(0x0df6, 0x0028), .driver_info =3D DEVICE_RTL8187B},
 	/* Abocom */
 	{USB_DEVICE(0x13d1, 0xabe6), .driver_info =3D DEVICE_RTL8187},
+	/* AirLive */
+	{USB_DEVICE(0x1b75, 0x8187), .driver_info =3D DEVICE_RTL8187},
 	{}
 };
=20

--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
