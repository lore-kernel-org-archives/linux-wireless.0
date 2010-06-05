Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43746 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab0FEAlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 20:41:09 -0400
Received: by gwb15 with SMTP id 15so263766gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 17:41:06 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Jun 2010 19:41:05 -0500
Message-ID: <AANLkTillVZPnU2MDGmMcHQ3Yxj-LfJxPLlOUzSQ8S1Bm@mail.gmail.com>
Subject: p54usb doesn't create wlan0 interface
From: Richard Tillmore <rtillmore@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a Dell usb wireless card that I am trying to use under Linux.
A search of the FCC-ID M4Y-XG705A lead me to believe it has a Z-Com
XG-705A chipset.  Another search tells me that the p54usb driver
should work.  So I added
	{USB_DEVICE(0x413c, 0x5513)},	/* Dell Wireless */
to the /usr/src/linux/drivers/net/wireless/p54/p54usb.c file in the
correct spot.  A quick recompile and the module was built.  I did a
modprobe p54usb and dmesg shows:
cfg80211: Calling CRDA to update world regulatory domain
usbcore: registered new interface driver p54usb
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

However iwconfig doesn't list a wlan0.  OK maybe I need firmware so
another search leads me to
http://wireless.kernel.org/en/users/Drivers/p54 where I download
2.13.24.0.lm87.arm (USB 2nd generation (ISL3887)), rename it to
isl3887usb and put it in /lib/firmware.  I rebooted and still no wlan0
listed in iwconfig.

What did I do wrong?

Thanks,
Greg

The lsusb -vvv for the device is:
Bus 001 Device 003: ID 413c:5513 Dell Computer Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x5513
  bcdDevice            1.00
  iManufacturer           1 Conexant
  iProduct                2 Cohiba 3887a rev1
  iSerial                 3 3887-0100
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           53
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
      bNumEndpoints           5
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
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
        bEndpointAddress     0x83  EP 3 IN
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
