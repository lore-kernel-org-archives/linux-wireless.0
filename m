Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:34287 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbcEJMx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 08:53:59 -0400
Received: by mail-vk0-f45.google.com with SMTP id m188so14320945vka.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2016 05:53:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4Xxq89fe4kkqb68mKTL4BpDKgFYWuseQqGzfWNc9zzUWHECg@mail.gmail.com>
References: <CAD4Xxq89fe4kkqb68mKTL4BpDKgFYWuseQqGzfWNc9zzUWHECg@mail.gmail.com>
Date: Tue, 10 May 2016 22:53:58 +1000
Message-ID: <CAD4Xxq-OPF1_Ne3XxAm2krA=aMmpZWvb6wRnWMpbbWDiD4g-5g@mail.gmail.com> (sfid-20160510_145404_635111_157DBC7D)
Subject: Re: Realtek USB WiFi rtl8192eu
From: Fisher Grubb <fisher.grubb@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

The version of driver which I think came on my CD is
rtl8192EU_linux_v4.2.2_7585.20130524

Here's a page which may have the original code:
https://sites.google.com/site/easylinuxtipsproject/reserve-7

Here's another Github repository that claims to be more regularly
updated and links to a D-Link version of the driver (using same
Realtek chip):
https://github.com/Mange/rtl8192eu-linux-driver

Fisher

On Tue, May 10, 2016 at 10:41 PM, Fisher Grubb <fisher.grubb@gmail.com> wrote:
> Hi all,
>
> I don't know if this stick's driver is in the process of being
> incorporated into the Kernel drivers, I havn't seen so yet.
>
> I've put the full lsusb -v at end of email as its a lot of stuff.
>
> Please let me know if any other info is needed about it, I'm not a
> programmer but I have reasonable intermediate Linux knowledge.
>
> I have been commonly using this stick with my ARM based BeagleBone
> Black board, others commonly use it with their ARM based Raspberry
> PIs.
>
> lsusb gives:
>
> Bus 002 Device 003: ID 0bda:818b Realtek Semiconductor Corp.
>
> I'm not sure when Realtek released this version of their WiFi chip,
> Linux source code comes on the driver CD, but usually doesn't compile
> as it seems to be for older systems.
>
> I've found 2 DKMS deb files that work, as well as somone's modified
> source code on Github.
>
> Its still buggy and I don't think gives signal strength etc.
>
> Here's a link to modified source code on Github that compiled for me
> and worked when the DKMS debs didn't:
>
> https://github.com/bhuvanchandra/rtl8192eu
>
> Here's a link to the 2 deb DKMS packages, usually one compiles and
> works (the one with -2 at end of file name), it didn't compile on
> Debian 7.9 on my BeagleBone Black board the other night,   the other
> one did, though I couldn't get it to work with the wex driver using
> wpa_supplicant, complained of ioctl "operation not permitted" etc.
>
> http://laptopke.be/files/Debian/
> http://users.telenet.be/x86_64/Debian/
>
> Hopefully this can be properly incorporated and standardised with most
> commonly used driver/extensions etc as I understand that Realtek
> drivers don't conform properly with the Kernel wireless extensions.
>
>
> sudo lsusb -v:
>
> Bus 002 Device 003: ID 0bda:818b Realtek Semiconductor Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x0bda Realtek Semiconductor Corp.
>   idProduct          0x818b
>   bcdDevice            2.00
>   iManufacturer           1 Realtek
>   iProduct                2 802.11n NIC
>   iSerial                 3 00e04c000001
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           53
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           5
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              2 802.11n NIC
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x05  EP 5 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x06  EP 6 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x87  EP 7 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               3
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x08  EP 8 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Binary Object Store Descriptor:
>   bLength                 5
>   bDescriptorType        15
>   wTotalLength           12
>   bNumDeviceCaps          1
>   USB 2.0 Extension Device Capability:
>     bLength                 7
>     bDescriptorType        16
>     bDevCapabilityType      2
>     bmAttributes   0x00000002
>       Link Power Management (LPM) Supported
> Device Status:     0x0001
>   Self Powered
