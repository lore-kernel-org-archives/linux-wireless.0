Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:26420 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbYL1Wc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 17:32:26 -0500
Received: by ik-out-1112.google.com with SMTP id c29so917935ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 14:32:23 -0800 (PST)
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt2500usb vs rt73usb
Date: Sun, 28 Dec 2008 23:32:20 +0100
Cc: Piter PUNK <piterpunk@unitednerds.org>,
	linux-wireless@vger.kernel.org
References: <49571E29.8060204@unitednerds.org> <200812281034.07373.IvDoorn@gmail.com> <1230502494.25726.26.camel@dv>
In-Reply-To: <1230502494.25726.26.camel@dv>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_05/VJbjQsPRBO6m"
Message-Id: <200812282332.20721.IvDoorn@gmail.com> (sfid-20081228_233231_681730_55A66BBC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_05/VJbjQsPRBO6m
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 28 December 2008, Pavel Roskin wrote:
> On Sun, 2008-12-28 at 10:34 +0100, Ivo van Doorn wrote:
> > On Sunday 28 December 2008, Piter PUNK wrote:
> 
> > > If the those 148f:2573 USB devices doesn't exists or
> > > if they exists and works fine with rt73usb, can we
> > > remove 148f:2573 from rt2500usb?
> > 
> > No we can't, you can blame manufacturers for shipping
> > USB sticks with different chipsets but the exact same USB ID.
> 
> Maybe there are some hints on the USB level that would make it possible
> to distinguish between the devices without loading the driver?
> Something like the number of endpoints?  Then we could ask USB
> developers to provide a way to specify them in the USB devece table.

Number of endpoints varies, your rt73usb device only has 2 endpoints, while
mine appears to have 5.
The only thing the driver is doing now is reading the EEPROM and double checking
the first 2 bytes to see which device has been loaded.

> I have a device that works with rt73usb, but not rt2500usb.  I'm
> attaching the output of "lsusb -v" for the device.  If we look at
> similar information for other devices, we could find out how to
> distinguish them.

Please note that some manufacturers (most notorious example Linksys) managed
to get 5 different chipsets under a single USB ID. chipsets came from Broadcom,
Ralink and Prism.

For what it is worth, I am attaching the lsusb -v output from my hardware
(both rt73usb as well as rt2500usb).

Ivo

--Boundary-00=_05/VJbjQsPRBO6m
Content-Type: text/plain;
  charset="iso-8859-15";
  name="usb.rt2500usb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usb.rt2500usb"


Bus 001 Device 006: ID 0681:3c06 Siemens Information and Communication Products 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0681 Siemens Information and Communication Products
  idProduct          0x3c06 
  bcdDevice            0.01
  iManufacturer           1 ANI 
  iProduct                2 802.11g W
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
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

Bus 001 Device 007: ID 2001:3c00 D-Link Corp. [hex] DWL-G122 802.11g rev. B1 [ralink]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2001 D-Link Corp. [hex]
  idProduct          0x3c00 DWL-G122 802.11g rev. B1 [ralink]
  bcdDevice            0.01
  iManufacturer           1 ANI 
  iProduct                2 802.11g WLAN Adapter    
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
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

--Boundary-00=_05/VJbjQsPRBO6m
Content-Type: text/plain;
  charset="iso-8859-15";
  name="usb.rt73usb"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usb.rt73usb"

Bus 001 Device 008: ID 1044:8008 Chu Yuen Enterprise Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x1044 Chu Yuen Enterprise Co., Ltd
  idProduct          0x8008 
  bcdDevice            0.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 bg WLAN
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           53
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 
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
        bEndpointAddress     0x01  EP 1 OUT
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
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
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

--Boundary-00=_05/VJbjQsPRBO6m--
