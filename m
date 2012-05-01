Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40882 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2EAJ31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 05:29:27 -0400
Received: by vcqp1 with SMTP id p1so2623573vcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 02:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACEkAT7=7V8zGpOXWCYwhuoaqEVD43gBgDifyuFgO0Cj6O=JYQ@mail.gmail.com>
References: <CACEkAT7=7V8zGpOXWCYwhuoaqEVD43gBgDifyuFgO0Cj6O=JYQ@mail.gmail.com>
Date: Tue, 1 May 2012 14:59:26 +0530
Message-ID: <CAD2nsn0yX=+ohhc-5OZV3RYrVtZEzqsBcDuBZoXfS-ypK0htmA@mail.gmail.com> (sfid-20120501_112941_257573_03853536)
Subject: Re: ar3012 new device id
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Andy Pyles <andy.pyles@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 1, 2012 at 4:20 AM, Andy Pyles <andy.pyles@gmail.com> wrote:
> I have a combination AR9485 / AR3012 device.
> To get the AR3012 device to work, I added a new device id shown in the
> patch below.
> After adding this patch, Bluetooth is working fine.

you found a chip yourself that has BT working with your patch :)

>
> /sys/kernel/debug/usb/devices output:
>
> T:  Bus=07 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=04ca ProdID=3004 Rev= 0.02
> S:  Manufacturer=Atheros Communications
> S:  Product=Bluetooth USB Host Controller
> S:  SerialNumber=Alaska Day 2006
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>
> ---
> lspci -vv :
>
> Bus 007 Device 002: ID 04ca:3004 Lite-On Technology Corp.
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               1.10
>  bDeviceClass          224 Wireless
>  bDeviceSubClass         1 Radio Frequency
>  bDeviceProtocol         1 Bluetooth
>  bMaxPacketSize0        64
>  idVendor           0x04ca Lite-On Technology Corp.
>  idProduct          0x3004
>  bcdDevice            0.02
>  iManufacturer           1
>  iProduct                2
>  iSerial                 3
>  bNumConfigurations      1
>  Configuration Descriptor:
> ...
>
>
> --
> diff -r -u compat-wireless-3.4-rc3-1-orig/drivers/bluetooth/ath3k.c
> compat-wireless-3.4-rc3-1/drivers/bluetooth/ath3k.c
> --- compat-wireless-3.4-rc3-1-orig/drivers/bluetooth/ath3k.c    2012-04-17
> 16:54:12.000000000 -0400
> +++ compat-wireless-3.4-rc3-1/drivers/bluetooth/ath3k.c 2012-04-30
> 18:10:25.279286665 -0400
> @@ -72,6 +72,7 @@
>
>        /* Atheros AR3012 with sflash firmware*/
>        { USB_DEVICE(0x0CF3, 0x3004) },
> +       { USB_DEVICE(0x04CA, 0x3004) },
>        { USB_DEVICE(0x0CF3, 0x311D) },
>        { USB_DEVICE(0x13d3, 0x3375) },
>        { USB_DEVICE(0x04CA, 0x3005) },
> @@ -93,6 +94,7 @@
>        { USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
> +       { USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
>
>        { }     /* Terminating entry */
> diff -r -u compat-wireless-3.4-rc3-1-orig/drivers/bluetooth/btusb.c
> compat-wireless-3.4-rc3-1/drivers/bluetooth/btusb.c
> --- compat-wireless-3.4-rc3-1-orig/drivers/bluetooth/btusb.c    2012-04-17
> 16:54:12.000000000 -0400
> +++ compat-wireless-3.4-rc3-1/drivers/bluetooth/btusb.c 2012-04-30
> 18:09:11.887284425 -0400
> @@ -130,6 +130,7 @@
>
>        /* Atheros 3012 with sflash firmware */
>        { USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
> +       { USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
>        { USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
