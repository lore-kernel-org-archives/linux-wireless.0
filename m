Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35372 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZBKWc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:32:58 -0500
Received: by ewy14 with SMTP id 14so361923ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 14:32:55 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Subject: Re: Sitecom WL-608 USB WiFi
Date: Wed, 11 Feb 2009 23:32:53 +0100
Cc: linux-wireless@vger.kernel.org
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
In-Reply-To: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902112332.53480.IvDoorn@gmail.com> (sfid-20090211_233302_407511_1B3D233E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I just baught a Sitecom WL-608 USB WIFI dongle and it seems it isn't supported out of the box yet. Here is some info on the device:

Looks like a new USB id. Since it isn't an 11n device it can only be a rt73usb or rt2500usb device.
Could you try below patch? My current bet is that the device contains the rt73 chipset,
so this will enable rt73usb to use the device.

Ivo

---

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 846996c..84f2ee8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2398,6 +2398,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	/* Senao */
 	{ USB_DEVICE(0x1740, 0x7100), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Sitecom */
+	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x90ac), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Surecom */

