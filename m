Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37586 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933242AbcJRTaj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:30:39 -0400
Received: by mail-it0-f43.google.com with SMTP id m138so8266691itm.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 12:30:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com> <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Tue, 18 Oct 2016 22:30:37 +0300
Message-ID: <CANUX_P1CaQZwc-=L4U9n+n5kfXW7H3-L05EDeXFYVvh2fddO8A@mail.gmail.com> (sfid-20161018_213043_155209_4D0DCC1C)
Subject: Re: Intel 7260 not working on 4.4.24 / armv7
To: Oliver Zemann <oliver.zemann@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 18, 2016 at 7:22 PM, Oliver Zemann <oliver.zemann@gmail.com> wrote:
> Because of the problems with the ath10 card, i bought an intel 7260 (mpcie)
> wifi card. Unfortunately it is also not working.
> I get tons of those messages:
>
> [  175.777030] usb 1-1: new full-speed USB device number 2 using orion-ehci
> [  175.933953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
> [  175.940681] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [  175.966954] Bluetooth: hci0: read Intel version: 3707100180012d0d00
> [  175.973313] Bluetooth: hci0: Intel Bluetooth firmware file:
> intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
> [  176.183954] Bluetooth: hci0: Intel Bluetooth firmware patch completed and
> activated
> [  176.749831] usb 1-1: USB disconnect, device number 2
> [  177.076993] usb 1-1: new full-speed USB device number 3 using orion-ehci
> [  177.233953] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
> [  177.240682] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0
> [  177.266957] Bluetooth: hci0: read Intel version: 3707100180012d0d00
> [  177.273316] Bluetooth: hci0: Intel Bluetooth firmware file:
> intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
> [  177.482955] Bluetooth: hci0: Intel Bluetooth firmware patch completed and
> activated
> [  178.046910] usb 1-1: USB disconnect, device number 3
> [  178.376958] usb 1-1: new full-speed USB device number 4 using orion-ehci
> [  178.533954] usb 1-1: New USB device found, idVendor=8087, idProduct=07dc
> [  178.540682] usb 1-1: New USB device strings: Mfr=0, Product=0,
> SerialNumber=0

Hmm... bad connectors? USB seems to think that the device keeps disconnecting.
But that's the BT part.

> some information about the card:
> Bus 001 Device 011: ID 8087:07dc Intel Corp.
> Couldn't open device, some information will be missing
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          224 Wireless
>   bDeviceSubClass         1 Radio Frequency
>   bDeviceProtocol         1 Bluetooth
>   bMaxPacketSize0        64
>   idVendor           0x8087 Intel Corp.
>   idProduct          0x07dc
>   bcdDevice            0.01
>   iManufacturer           0
>   iProduct                0
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          177
>     bNumInterfaces          2
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              100mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0009  1x 9 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0009  1x 9 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       2
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0011  1x 17 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0011  1x 17 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       3
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0019  1x 25 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0019  1x 25 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       4
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0021  1x 33 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0021  1x 33 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       5
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0031  1x 49 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0031  1x 49 bytes
>         bInterval               1
>
>
> [root@alarm log]# uname -a
> Linux alarm 4.4.24-2-ARCH #1 SMP Fri Oct 14 01:04:22 MDT 2016 armv7l
> GNU/Linux
>
> What's confusing me is that this device is connected through pcie, not usb.
> When i use lspci i get:
> [root@alarm log]# lspci
> 00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
> 00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev 04)
> 02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac Wireless
> Network Adapter (rev ff)
>
> So the other card is seen as pci device, but the intel is not. I am really
> lost now.

So is the NIC :) It is lost. If it doesn't appear in the enumeration,
it seems you have a bad platform issue. the arm thing in your uname -a
hints me that you can't really talk your OEM, right?
