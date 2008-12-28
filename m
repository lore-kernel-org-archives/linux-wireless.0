Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55528 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538AbYL1WO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 17:14:56 -0500
Subject: Re: rt2500usb vs rt73usb
From: Pavel Roskin <proski@gnu.org>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Piter PUNK <piterpunk@unitednerds.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200812281034.07373.IvDoorn@gmail.com>
References: <49571E29.8060204@unitednerds.org>
	 <200812281034.07373.IvDoorn@gmail.com>
Content-Type: multipart/mixed; boundary="=-MLyIz4pdIBjMQ80TKarG"
Date: Sun, 28 Dec 2008 17:14:54 -0500
Message-Id: <1230502494.25726.26.camel@dv> (sfid-20081228_231501_720223_4FC9CDB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MLyIz4pdIBjMQ80TKarG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2008-12-28 at 10:34 +0100, Ivo van Doorn wrote:
> On Sunday 28 December 2008, Piter PUNK wrote:

> > If the those 148f:2573 USB devices doesn't exists or
> > if they exists and works fine with rt73usb, can we
> > remove 148f:2573 from rt2500usb?
> 
> No we can't, you can blame manufacturers for shipping
> USB sticks with different chipsets but the exact same USB ID.

Maybe there are some hints on the USB level that would make it possible
to distinguish between the devices without loading the driver?
Something like the number of endpoints?  Then we could ask USB
developers to provide a way to specify them in the USB devece table.

I have a device that works with rt73usb, but not rt2500usb.  I'm
attaching the output of "lsusb -v" for the device.  If we look at
similar information for other devices, we could find out how to
distinguish them.

-- 
Regards,
Pavel Roskin

--=-MLyIz4pdIBjMQ80TKarG
Content-Disposition: attachment; filename="rt73"
Content-Type: text/plain; name="rt73"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Bus 001 Device 004: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x148f Ralink Technology, Corp.
  idProduct          0x2573 RT2501USB Wireless Adapter
  bcdDevice            0.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 bg WLAN
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

--=-MLyIz4pdIBjMQ80TKarG--
