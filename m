Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63292 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2JVF0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 01:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <1350882145.55725.YahooMailNeo@web125403.mail.ne1.yahoo.com>
References: <1350882145.55725.YahooMailNeo@web125403.mail.ne1.yahoo.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 22 Oct 2012 16:26:27 +1100
Message-ID: <CAGRGNgUkDAQaHXuBxR+uu=uoB0j=qfdHpXOtOTP2ZnU89mN1oA@mail.gmail.com> (sfid-20121022_072655_038725_54F2350D)
Subject: Re: [PATCH] Bluetooth: Add support for Atheros [04ca:3004]
To: Dwaine Garden VE3GIF <dwainegarden@rogers.com>
Cc: "linville@redhat.com" <linville@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@qca.qualcomm.com" <mcgrof@qca.qualcomm.com>,
	linux-bluetooth@vger.kernel.org, gustavo@padovan.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dwaine,

Firstly, you should really send this to the linux-bluetooth list and
Gustavo not to linux-wireless and John.

While linux-wireless is the catch-all place for everything relating to
wireless technology in Linux, bluetooth has it's own mailing list, and
bluetooth patches should be sent there first.

On Mon, Oct 22, 2012 at 4:02 PM, Dwaine Garden VE3GIF
<dwainegarden@rogers.com> wrote:
>
>
> Add another vendor specific ID for Atheros AR3012 device.
> This chip is wrapped by Lite-On Technology Corp.
>
> output of usb-devices:
> Bus 001 Device 008: ID 04ca:3004 Lite-On Technology Corp.
> Device Descriptor:
>   bLength                18
>
>  bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass          224 Wireless
>   bDeviceSubClass         1 Radio Frequency
>   bDeviceProtocol         1 Bluetooth
>   bMaxPacketSize0        64
>   idVendor           0x04ca Lite-On Technology Corp.
>   idProduct          0x3004
>   bcdDevice            0.02
>   iManufacturer           1 Atheros Communications
>
>  iProduct                2 Bluetooth USB Host Controller
>   iSerial                 3 Alaska Day 2006
>   bNumConfigurations      1
>
>
> Signed-off-by: Dwaine Garden <DwaineGarden@rogers.com>  ---

Secondly, while your patch looks correct to me (I'm no expert on the
hardware or drivers involved) it seems to be severely whitespace
damaged. You should read the Email Clients document under the
Documentation directory in your kernel tree (or read it online here:
http://stuff.mit.edu/afs/sipb/contrib/linux/Documentation/email-clients.txt
) and ensure that your email client is set up correctly to send
patches without damaging them.

> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index fc2de55..1486f15 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -75,6 +75,7 @@ static struct usb_device_id ath3k_table[] = {
> { USB_DEVICE(0x0CF3, 0x3004) },
> { USB_DEVICE(0x0CF3, 0x311D) },
> { USB_DEVICE(0x13d3, 0x3375) },
> +       { USB_DEVICE(0x04CA, 0x3004) },
> { USB_DEVICE(0x04CA, 0x3005) },
> { USB_DEVICE(0x13d3, 0x3362) },
> { USB_DEVICE(0x0CF3, 0xE004) },
> @@ -102,6 +103,7 @@ static struct usb_device_id ath3k_blist_tbl[] = {
> { USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x0cf3, 0x311D), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
> +       { USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
> {
>  USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index debda27..0529cee 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -132,6 +132,7 @@ static struct usb_device_id blacklist_table[] = {
> { USB_DEVICE(0x0cf3, 0x3004), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x0cf3, 0x311d), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x13d3, 0x3375), .driver_info = BTUSB_ATH3012 },
> +       { USB_DEVICE(0x04ca, 0x3004), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x04ca, 0x3005), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x13d3, 0x3362), .driver_info = BTUSB_ATH3012 },
> { USB_DEVICE(0x0cf3, 0xe004), .driver_info = BTUSB_ATH3012 },

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
