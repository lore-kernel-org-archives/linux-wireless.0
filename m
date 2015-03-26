Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33754 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbCZAvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 20:51:03 -0400
Message-ID: <551357F3.4020406@lwfinger.net> (sfid-20150326_015122_308939_71B10198)
Date: Wed, 25 Mar 2015 19:50:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add new device ID
References: <1427318311-5690-1-git-send-email-marex@denx.de>
In-Reply-To: <1427318311-5690-1-git-send-email-marex@denx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2015 04:18 PM, Marek Vasut wrote:
> Add new ID for ASUS N10 WiFi dongle.
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 1 +
>   1 file changed, 1 insertion(+)
>
> Bus 001 Device 004: ID 0b05:17ba ASUSTek Computer, Inc.
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x0b05 ASUSTek Computer, Inc.
>    idProduct          0x17ba
>    bcdDevice            2.00
>    iManufacturer           1 Realtek
>    iProduct                2 802.11n WLAN Adapter
>    iSerial                 3 00e04c000001
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           46
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          0
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           4
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x02  EP 2 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x03  EP 3 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x84  EP 4 IN
>          bmAttributes            3
>            Transfer Type            Interrupt
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0040  1x 64 bytes
>          bInterval               1
> Device Qualifier (for other device speed):
>    bLength                10
>    bDescriptorType         6
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    bNumConfigurations      1
> Device Status:     0x0000
>    (Bus Powered)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 90a714c..d451d2b 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -360,6 +360,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>   	{RTL_USB_DEVICE(0x04f2, 0xaffb, rtl92cu_hal_cfg)}, /*Xavi*/
>   	{RTL_USB_DEVICE(0x04f2, 0xaffc, rtl92cu_hal_cfg)}, /*Xavi*/
>   	{RTL_USB_DEVICE(0x2019, 0x1201, rtl92cu_hal_cfg)}, /*Planex-Vencer*/
> +	{RTL_USB_DEVICE(0x0b05, 0x17ba, rtl92cu_hal_cfg)}, /*ASUS-Edimax*/
>
>   	/****** 8192CU ********/
>   	{RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)}, /*Belcom-SurfN300*/
>

The full dump from lsusb is a bit much for a commit message. All you need is the 
one line from lsusb with no switches set.

According to the Vendor driver, which the comment indicates as the source of 
part of your patch, this particular device belongs in the "Customer ID" section 
under 8188CU, not where you placed it. In addition, I like to keep the USB IDs 
in numerical order within each section. Accordingly, your new ID should be 
between 0846:9041 and 0bda:5088.

I am assuming that you have such a device. A statement that this change allows 
it to work should be in the commit message. If you have not tested, then you 
need to state that.

Larry

