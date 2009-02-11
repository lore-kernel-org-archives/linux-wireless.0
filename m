Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:52685 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbZBKWvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:51:33 -0500
Received: by fxm13 with SMTP id 13so1329667fxm.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 14:51:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902112332.53480.IvDoorn@gmail.com>
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
	 <200902112332.53480.IvDoorn@gmail.com>
Date: Wed, 11 Feb 2009 22:51:29 +0000
Message-ID: <3ace41890902111451n6c9cbdc4me410609479b1ac4f@mail.gmail.com> (sfid-20090211_235136_750740_8DBAB231)
Subject: Re: Sitecom WL-608 USB WiFi
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added the WL-603 to the zd1211rw driver in wireless-testing a couple
of weeks. ago.
zd1211rw: adding Sitecom WL-603 (0df6:0036) to the USB id list

Here was the entry - could you try adding a similiar line (using
0x003f for your device, instead of 0x0036 shown here) and report back
if the WL608 is similiar to the WL 603 except by the ID?

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c
b/drivers/net/wireless/zd1211rw/zd_usb.c
index b5db57d..17527f7 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -84,6 +84,7 @@ static struct usb_device_id usb_ids[] = {
        { USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
        { USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
        { USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
+       { USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
        /* "Driverless" devices that need ejecting */
        { USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
        { USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },


On Wed, Feb 11, 2009 at 10:32 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>> I just baught a Sitecom WL-608 USB WIFI dongle and it seems it isn't supported out of the box yet. Here is some info on the device:
>
> Looks like a new USB id. Since it isn't an 11n device it can only be a rt73usb or rt2500usb device.
> Could you try below patch? My current bet is that the device contains the rt73 chipset,
> so this will enable rt73usb to use the device.
>
> Ivo
>
> ---
>
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 846996c..84f2ee8 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2398,6 +2398,7 @@ static struct usb_device_id rt73usb_device_table[] = {
>        /* Senao */
>        { USB_DEVICE(0x1740, 0x7100), USB_DEVICE_DATA(&rt73usb_ops) },
>        /* Sitecom */
> +       { USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x0df6, 0x90ac), USB_DEVICE_DATA(&rt73usb_ops) },
>        /* Surecom */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
