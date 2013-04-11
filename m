Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from x1.w4w.guest.it ([77.95.174.1]:44982 "EHLO x1.w4w.guest.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762512Ab3DKQq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 12:46:26 -0400
Received: from [46.182.93.153] (helo=[192.168.1.37])
	by x1.w4w.guest.it with esmtpa (Exim 4.80.1)
	(envelope-from <danjde@msw.it>)
	id 1UQKde-0003Zg-G4
	for linux-wireless@vger.kernel.org; Thu, 11 Apr 2013 18:46:22 +0200
Message-ID: <5166E8CB.3040802@msw.it> (sfid-20130411_184633_252006_371CA313)
Date: Thu, 11 Apr 2013 18:46:03 +0200
From: Davide Marchi <danjde@msw.it>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: realtek usb wifi based on "rtl8192cu"
References: <516539DC.8060004@msw.it> <51657D84.2080308@lwfinger.net>
In-Reply-To: <51657D84.2080308@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger ha scritto:
> On 04/10/2013 05:07 AM, Davide Marchi wrote:
>> [..]
>
> If 3.8.6 does not fix it, then try the kernel from the 
> wireless-testing git tree. There were a number of other fixes in the 
> code that will go into kernel 3.10, and my rtl8192cu devices (3 
> different models) work fine here with that kernel. Unfortunately, 
> those changes are not yet available in a compat-drivers release.
>
> Otherwise, you need to produce more definitive logging of what is 
> failing.
>
> Larry
Hi Larry,
i've tryed with kernel "3.8.5-201.fc18" two device wireless Realtek usb:



no one of this work corretcly with kernel 3.8.5-201 Fedora or 3.8.6 
vanilla (kernel.org)
eitherdo not connect to the wifi router, but they both see the wireless 
networks

one of this, on kernel 3.2.x and 3.0. 8 vanilla (kernel.org) using the 
Realtek driver work correctly:

Bus 001 Device 003: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 
802.11n Wireless Adapter [Realtek RTL8188CUS]
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x7392 Edimax Technology Co., Ltd
   idProduct          0x7811 EW-7811Un 802.11n Wireless Adapter [Realtek 
RTL8188CUS]
   bcdDevice            2.00
   iManufacturer           1 Realtek
   iProduct                2 802.11n WLAN Adapter
   iSerial                 3 00e04c000001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)



------------------
this one: doesn't work neitherwith Realtek driver on kernel 3.0.8 or 
3.8.6 vanilla (kernel.org)

Bus 001 Device 002: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 
802.11n WLAN Adapter
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0bda Realtek Semiconductor Corp.
   idProduct          0x8178 RTL8192CU 802.11n WLAN Adapter
   bcdDevice            2.00
   iManufacturer           1 Realtek
   iProduct                2 802.11n WLAN Adapter
   iSerial                 3 00e04c000001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)



i will try the wireless-testing git tree and then I'll let you know,

for download the kernel source from the wireless-testing git tree is it 
correct this procedure?

|git clone 
|git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git


many thanks!




-- 
cosmogoniA
cosmogoniA<http://www.cosmogonia.org/>
noprovarenofareononfarenonc'èprovare
